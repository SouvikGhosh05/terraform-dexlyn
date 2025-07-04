# modules/vpc/outputs.tf

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

# Security Group Outputs
output "ecs_security_group_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks.id
}

output "alb_security_group_id" {
  description = "ID of the Application Load Balancer security group"
  value       = aws_security_group.alb.id
}

# Load Balancer Outputs
output "dexlyn_load_balancer_arn" {
  description = "ARN of the Dexlyn load balancer"
  value       = aws_lb.dexlyn.arn
}

output "dexlyn_load_balancer_dns_name" {
  description = "DNS name of the Dexlyn load balancer"
  value       = aws_lb.dexlyn.dns_name
}

output "dexlyn_load_balancer_zone_id" {
  description = "Zone ID of the Dexlyn load balancer"
  value       = aws_lb.dexlyn.zone_id
}

output "suprans_load_balancer_arn" {
  description = "ARN of the Suprans load balancer"
  value       = aws_lb.suprans.arn
}

output "suprans_load_balancer_dns_name" {
  description = "DNS name of the Suprans load balancer"
  value       = aws_lb.suprans.dns_name
}

output "suprans_load_balancer_zone_id" {
  description = "Zone ID of the Suprans load balancer"
  value       = aws_lb.suprans.zone_id
}

# ECS Cluster Outputs
output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = length(aws_ecs_cluster.main) > 0 ? aws_ecs_cluster.main[0].arn : data.aws_ecs_cluster.existing.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = length(aws_ecs_cluster.main) > 0 ? aws_ecs_cluster.main[0].name : data.aws_ecs_cluster.existing.cluster_name
}

# IAM Role Outputs
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.name
}

# Combined outputs for easy reference in ECS module
output "ecs_network_configuration" {
  description = "Network configuration for ECS services"
  value = {
    vpc_id              = aws_vpc.main.id
    subnet_ids          = aws_subnet.public[*].id
    security_group_id   = aws_security_group.ecs_tasks.id
    cluster_arn         = length(aws_ecs_cluster.main) > 0 ? aws_ecs_cluster.main[0].arn : data.aws_ecs_cluster.existing.arn
    execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  }
}

output "load_balancer_configuration" {
  description = "Load balancer configuration"
  value = {
    dexlyn_lb_arn   = aws_lb.dexlyn.arn
    suprans_lb_arn  = aws_lb.suprans.arn
  }
}