# modules/vpc/main.tf

# Data source for availability zones in Mumbai region
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to check if ECS cluster already exists
data "aws_ecs_cluster" "existing" {
  cluster_name = "${var.environment}-dexlyn-cluster"
}

# VPC - Production Mumbai region with 172.48.0.0/16
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-igw"
  })
}

# Public Subnets - Only public subnets as per requirements
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-public-subnet-${count.index + 1}-${data.aws_availability_zones.available.names[count.index]}"
    Type = "public"
  })
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-public-rt"
  })
}

# Associate public subnets with route table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group for ECS Tasks - ONLY allows traffic from ALB Security Group
resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.environment}-dexlyn-ecs-tasks-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for ECS tasks - only allows ALB traffic"

  # Allow ALL traffic from ALB security group (ALB will route to correct container ports)
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "All TCP traffic from ALB security group only"
  }

  # All outbound traffic (for internet access, ECR pulls, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-ecs-tasks-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group for Application Load Balancers - ALLOWS ALL inbound traffic from internet
resource "aws_security_group" "alb" {
  name_prefix = "${var.environment}-dexlyn-alb-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for Application Load Balancers - allows all inbound traffic"

  # Allow ALL inbound traffic from anywhere (ALB will handle routing)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All TCP traffic from internet"
  }

  # UDP traffic (if needed for any services)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All UDP traffic from internet"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-alb-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Application Load Balancer for Dexlyn services
resource "aws_lb" "dexlyn" {
  name               = "${var.environment}-dexlyn-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.public[*].id

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-lb"
    Service = "dexlyn"
  })
}

# Application Load Balancer for Suprans services
resource "aws_lb" "suprans" {
  name               = "${var.environment}-suprans-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.public[*].id

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = "${var.environment}-suprans-lb"
    Service = "suprans"
  })
}

# Default listeners for Dexlyn Load Balancer
resource "aws_lb_listener" "dexlyn_http" {
  load_balancer_arn = aws_lb.dexlyn.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default Dexlyn Response"
      status_code  = "200"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-http-listener"
  })
}

# Default listeners for Suprans Load Balancer  
resource "aws_lb_listener" "suprans_http" {
  load_balancer_arn = aws_lb.suprans.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default Suprans Response"
      status_code  = "200"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-suprans-http-listener"
  })
}

# ECS Cluster - only create if it doesn't exist
resource "aws_ecs_cluster" "main" {
  count = data.aws_ecs_cluster.existing.status == "ACTIVE" ? 0 : 1
  
  name = "${var.environment}-dexlyn-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-cluster"
  })
}

# ECS Cluster Capacity Provider (Fargate) - only create if cluster is created
resource "aws_ecs_cluster_capacity_providers" "main" {
  count = length(aws_ecs_cluster.main) > 0 ? 1 : 0
  
  cluster_name = aws_ecs_cluster.main[0].name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-dexlyn-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.environment}-dexlyn-ecsTaskExecutionRole"
  })
}

# Attach AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Additional policy for ECR access (if needed)
resource "aws_iam_role_policy" "ecs_task_execution_ecr_policy" {
  name = "${var.environment}-dexlyn-ecs-ecr-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })
}