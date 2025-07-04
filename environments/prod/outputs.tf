# environments/prod/outputs.tf

# ========================================
# VPC INFRASTRUCTURE OUTPUTS
# ========================================

# VPC Infrastructure Outputs
output "vpc_infrastructure" {
  description = "Complete VPC infrastructure information"
  value = {
    # Network Resources
    vpc_id                     = module.vpc.vpc_id
    vpc_cidr                   = module.vpc.vpc_cidr_block
    public_subnet_ids          = module.vpc.public_subnet_ids
    
    # Security Groups
    ecs_security_group_id      = module.vpc.ecs_security_group_id
    alb_security_group_id      = module.vpc.alb_security_group_id
    
    # Load Balancers
    dexlyn_load_balancer = {
      arn      = module.vpc.dexlyn_load_balancer_arn
      dns_name = module.vpc.dexlyn_load_balancer_dns_name
      zone_id  = module.vpc.dexlyn_load_balancer_zone_id
    }
    suprans_load_balancer = {
      arn      = module.vpc.suprans_load_balancer_arn
      dns_name = module.vpc.suprans_load_balancer_dns_name
      zone_id  = module.vpc.suprans_load_balancer_zone_id
    }
    
    # ECS Infrastructure
    ecs_cluster_arn            = module.vpc.ecs_cluster_arn
    ecs_cluster_name           = module.vpc.ecs_cluster_name
    ecs_task_execution_role_arn = module.vpc.ecs_task_execution_role_arn
  }
}

# Service Distribution Analysis
output "service_distribution" {
  description = "Analysis of service distribution across load balancers"
  value = {
    total_services = length(var.ecs_services)
    distribution = local.load_balancer_distribution
    suprans_services = [
      for k, v in var.ecs_services : v.service_name 
      if contains(local.suprans_services, v.service_name)
    ]
    dexlyn_services = [
      for k, v in var.ecs_services : v.service_name 
      if !contains(local.suprans_services, v.service_name)
    ]
  }
}

# ========================================
# ECS SERVICES OUTPUTS
# ========================================

# ECS Services Outputs
output "ecs_services" {
  description = "Information about created ECS services"
  value       = module.ecs_services.services
}

output "task_definitions" {
  description = "Information about created task definitions"
  value       = module.ecs_services.task_definitions
}

output "target_groups" {
  description = "Information about created target groups"
  value       = module.ecs_services.target_groups
}

output "existing_target_groups" {
  description = "Information about existing target groups"
  value       = module.ecs_services.existing_target_groups
}

output "log_groups" {
  description = "Information about created log groups"
  value       = module.ecs_services.log_groups
}

output "load_balancer_listeners" {
  description = "Information about the load balancer listeners"
  value       = module.ecs_services.load_balancer_listeners
}

output "load_balancer_listener_rules" {
  description = "Information about created load balancer listener rules"
  value       = module.ecs_services.load_balancer_listener_rules
}

# ========================================
# ECR OUTPUTS
# ========================================

output "ecr_repositories" {
  description = "Information about created ECR repositories"
  value       = module.ecs_services.ecr_repositories
}

output "ecr_lifecycle_policies" {
  description = "Information about ECR lifecycle policies"
  value       = module.ecs_services.ecr_lifecycle_policies
}

output "ecr_repository_urls" {
  description = "ECR repository URLs for easy reference"
  value       = module.ecs_services.ecr_repository_urls
}

# ========================================
# RESOURCE SUMMARY OUTPUTS
# ========================================

output "all_resources_summary" {
  description = "Summary of all created resources"
  value = merge(
    module.ecs_services.all_resources_summary,
    {
      vpc_resources = {
        vpc_created = module.vpc.vpc_id != null
        subnets_created = length(module.vpc.public_subnet_ids)
        load_balancers_created = 2
        security_groups_created = 2
        ecs_cluster_created = module.vpc.ecs_cluster_arn != null
      }
    }
  )
}

# ========================================
# CODEBUILD & CODEPIPELINE OUTPUTS
# ========================================

output "codepipeline_services" {
  description = "Information about created CodePipeline services"
  value       = module.codebuild_codepipeline_services.pipelines
}

output "codebuild_projects" {
  description = "Information about created CodeBuild projects"
  value       = module.codebuild_codepipeline_services.codebuild_projects
}

output "codepipeline_artifact_bucket" {
  description = "S3 bucket for CodePipeline artifacts"
  value       = module.codebuild_codepipeline_services.s3_artifact_bucket
}

output "notification_rules" {
  description = "CodePipeline notification rules for Slack"
  value       = module.codebuild_codepipeline_services.notification_rules
}