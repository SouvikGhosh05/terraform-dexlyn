# environments/prod/main.tf

# VPC Module - Creates all networking infrastructure
module "vpc" {
  source = "../../modules/vpc"

  environment = "prod"
  # Hardcoded Mumbai production values
  vpc_cidr                  = "172.48.0.0/16"
  public_subnet_cidrs       = ["172.48.1.0/24", "172.48.2.0/24", "172.48.3.0/24"]
  enable_deletion_protection = true

  tags = {
    Environment = "prod"
    Project     = "dexlyn"
    ManagedBy   = "terraform"
  }
}

# Local transformation logic for resource mapping
locals {
  # Define which services use Suprans load balancer (all others use Dexlyn LB)
  suprans_services = ["sns-backend", "suprans", "suprans-docs"]
  
  # Base network configuration from VPC module
  base_network_config = {
    existing_cluster_arn        = module.vpc.ecs_cluster_arn
    existing_subnet_ids         = module.vpc.public_subnet_ids
    existing_security_group_id  = module.vpc.ecs_security_group_id
    existing_execution_role_arn = module.vpc.ecs_task_execution_role_arn
    existing_task_role_arn      = module.vpc.ecs_task_execution_role_arn
  }
  
  # Transform user services with VPC-provided resources
  ecs_services_with_vpc_data = {
    for service_key, service_config in var.ecs_services : service_key => merge(
      service_config,
      local.base_network_config,
      {
        # Intelligent load balancer assignment based on service name
        load_balancer_arn = contains(local.suprans_services, service_config.service_name) ? module.vpc.suprans_load_balancer_arn : module.vpc.dexlyn_load_balancer_arn
      }
    )
  }
  
  # Count services per load balancer for monitoring
  load_balancer_distribution = {
    suprans_count = length([for k, v in var.ecs_services : k if contains(local.suprans_services, v.service_name)])
    dexlyn_count = length([for k, v in var.ecs_services : k if !contains(local.suprans_services, v.service_name)])
  }
}

# ECS Services Module - Uses transformed service configurations
module "ecs_services" {
  source = "../../modules/ecs-service"

  environment = "prod"
  services    = local.ecs_services_with_vpc_data
  vpc_id      = module.vpc.vpc_id

  tags = {
    Environment = "prod"
    Project     = "dexlyn"
    ManagedBy   = "terraform"
  }

  depends_on = [module.vpc]
}

# CodeBuild & CodePipeline module - Uses VPC cluster
module "codebuild_codepipeline_services" {
  source = "../../modules/codebuild-codepipeline"

  environment                    = "prod"
  codeconnection_arn            = var.codeconnection_arn
  artifact_bucket_name          = var.codepipeline_artifact_bucket
  default_ecs_cluster_arn       = module.vpc.ecs_cluster_arn  # ← Dynamic from VPC
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
    Project     = "dexlyn"  
    ManagedBy   = "terraform"
  }

  depends_on = [module.vpc, module.ecs_services]
}