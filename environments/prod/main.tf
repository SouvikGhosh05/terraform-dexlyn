module "ecs_services" {
  source = "../../modules/ecs-service"

  environment = "prod"
  services    = var.ecs_services
  vpc_id      = var.vpc_id

  tags = {
    Environment = "prod"
    Project     = "dexlyn"
    ManagedBy   = "terraform"
  }
}

# CodeBuild & CodePipeline module
module "codebuild_codepipeline_services" {
  source = "../../modules/codebuild-codepipeline"

  environment                    = "prod"
  codeconnection_arn            = var.codeconnection_arn
  artifact_bucket_name          = var.codepipeline_artifact_bucket
  default_ecs_cluster_arn       = var.default_ecs_cluster_arn
  codebuild_service_role_arn    = var.codebuild_service_role_arn
  codepipeline_service_role_arn = var.codepipeline_service_role_arn
  global_compute_type           = var.global_compute_type
  global_build_image            = var.global_build_image
  global_chatbot_slack_arn      = var.global_chatbot_slack_arn
  global_organization_name      = var.global_organization_name
  global_kms_key_arn           = var.global_kms_key_arn
  services                      = var.codepipeline_services

  tags = {
    Environment = "prod"
  }
}

# ECS Output
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

# ECR Outputs
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

output "all_resources_summary" {
  description = "Summary of all created resources"
  value       = module.ecs_services.all_resources_summary
}

# CodeBuild & CodePipeline Outputs
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