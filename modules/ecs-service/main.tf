# modules/ecs-service/main.tf

# Global variable for region
locals {
  aws_region = "ap-south-1"
  
  # Create a map of services that need new target groups (don't have existing_target_group_arn)
  services_needing_target_groups = {
    for key, service in var.services : key => service
    if service.existing_target_group_arn == null
  }
  
  # Create a map of services that need ECR repositories (now defaults to all services)
  services_needing_ecr = {
    for key, service in var.services : key => service
    if service.create_ecr_repository != false  # Only exclude if explicitly set to false
  }
}

# ECR Repositories for services that require them
resource "aws_ecr_repository" "service_repos" {
  for_each = local.services_needing_ecr

  name                 = each.value.ecr_repository_name != null ? each.value.ecr_repository_name : "${var.environment}-dexlyn-${each.value.service_name}"
  image_tag_mutability = each.value.ecr_image_tag_mutability
  force_delete         = each.value.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = each.value.ecr_scan_on_push
  }

  encryption_configuration {
    encryption_type = each.value.ecr_encryption_type
    kms_key         = each.value.ecr_encryption_type == "KMS" ? each.value.ecr_kms_key : null
  }

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-dexlyn-${each.value.service_name}-ecr"
    Service     = each.value.service_name
  })
}

# ECR Lifecycle Policies for repositories
resource "aws_ecr_lifecycle_policy" "service_lifecycle" {
  for_each = local.services_needing_ecr

  repository = aws_ecr_repository.service_repos[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${each.value.ecr_lifecycle_policy.max_image_count} tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = each.value.ecr_lifecycle_policy.tagged_prefixes
          countType     = "imageCountMoreThan"
          countNumber   = each.value.ecr_lifecycle_policy.max_image_count
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Remove untagged images older than ${each.value.ecr_lifecycle_policy.max_image_age_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = each.value.ecr_lifecycle_policy.max_image_age_days
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# CloudWatch Log Groups for each service
resource "aws_cloudwatch_log_group" "ecs_logs" {
  for_each = var.services

  name              = "/ecs/${var.environment}-dexlyn-${each.value.service_name}"
  retention_in_days = each.value.log_retention_days

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-dexlyn-${each.value.service_name}"
    Service     = each.value.service_name
  })
}

# Target Groups for services that don't have existing target groups
resource "aws_lb_target_group" "main" {
  for_each = local.services_needing_target_groups

  # Simple naming - since long names will be handled manually
  name = "ecs-${var.environment}-dexlyn-${each.value.service_name}"
    
  port        = each.value.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-dexlyn-${each.value.service_name}"
    Service     = each.value.service_name
  })
}

# Data source to get existing target groups (for manually created ones)
data "aws_lb_target_group" "existing" {
  for_each = {
    for key, service in var.services : key => service
    if service.existing_target_group_arn != null
  }

  arn = each.value.existing_target_group_arn
}

# Data source to get the Load Balancer Listener for each service
data "aws_lb_listener" "existing" {
  for_each = var.services

  load_balancer_arn = each.value.load_balancer_arn
  port              = each.value.listener_port
}

# Load Balancer Listener Rules for each service 
resource "aws_lb_listener_rule" "main" {
  for_each = var.services

  listener_arn = data.aws_lb_listener.existing[each.key].arn
  priority     = each.value.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = each.value.existing_target_group_arn != null ? each.value.existing_target_group_arn : aws_lb_target_group.main[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.host_header]
    }
  }

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-dexlyn-${each.value.service_name}"
    Service     = each.value.service_name
  })
}

# ECS Task Definitions for each service
resource "aws_ecs_task_definition" "main" {
  for_each = var.services

  family                   = "${var.environment}-dexlyn-${each.value.service_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = tostring(each.value.cpu)     # Convert to string
  memory                   = tostring(each.value.memory)  # Convert to string
  execution_role_arn       = each.value.existing_execution_role_arn
  task_role_arn           = each.value.existing_task_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "${var.environment}-dexlyn-${each.value.service_name}"
      # Use dynamically created ECR repository URL with latest tag
      image     = "${aws_ecr_repository.service_repos[each.key].repository_url}:latest"
      cpu       = each.value.cpu
      memory    = each.value.memory
      essential = true
      
      portMappings = [
        {
          containerPort = each.value.container_port
          hostPort      = each.value.container_port
          protocol      = "tcp"
        }
      ]

      # Convert environment_variables map to ECS environment array format
      environment = [
        for key, value in each.value.environment_variables : {
          name  = key
          value = value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs[each.key].name
          "awslogs-region"        = local.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      # Required empty arrays for ECS container definition
      mountPoints    = []
      volumesFrom    = []
      ulimits        = []
      systemControls = []
    }
  ])

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-dexlyn-${each.value.service_name}"
    Service     = each.value.service_name
  })
}

# ECS Services for each service
resource "aws_ecs_service" "main" {
  for_each = var.services

  name            = "${var.environment}-dexlyn-${each.value.service_name}"
  cluster         = each.value.existing_cluster_arn
  task_definition = aws_ecs_task_definition.main[each.key].arn
  desired_count   = each.value.desired_count
  launch_type     = "FARGATE"

  platform_version = "LATEST"

  network_configuration {
    subnets          = each.value.existing_subnet_ids
    security_groups  = [each.value.existing_security_group_id]
    assign_public_ip = true
  }

  # Load balancer configuration - use existing target group if provided, otherwise use created one
  load_balancer {
    target_group_arn = each.value.existing_target_group_arn != null ? each.value.existing_target_group_arn : aws_lb_target_group.main[each.key].arn
    container_name   = "${var.environment}-dexlyn-${each.value.service_name}"
    container_port   = each.value.container_port
  }

  enable_execute_command = false

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-dexlyn-${each.value.service_name}"
    Service     = each.value.service_name
  })

  # Ensure dependencies are created before services
  depends_on = [
    aws_cloudwatch_log_group.ecs_logs,
    aws_lb_target_group.main,
    aws_lb_listener_rule.main,
    aws_ecr_repository.service_repos
  ]
}