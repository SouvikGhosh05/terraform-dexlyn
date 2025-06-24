# environments/prod/variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "VPC ID for resources"
  type        = string
}

# ECS Variables with per-service load balancer configuration
variable "ecs_services" {
  description = "Map of ECS services configuration"
  type = map(object({
    service_name                = string
    existing_cluster_arn        = string
    existing_subnet_ids         = list(string)
    existing_security_group_id  = string
    existing_execution_role_arn = string  # ecsTaskExecutionRole
    existing_task_role_arn      = string  # ecsTaskExecutionRole (same as execution)
    container_image             = string
    container_port              = number
    desired_count               = number
    cpu                         = number
    memory                      = number
    log_retention_days          = number
    listener_rule_priority      = number   # Priority for listener rule (1-50000) - must be unique per service
    host_header                 = string   # Host header for routing (e.g., "prod-docs.dexlyn.com")
    environment_variables       = optional(map(string), {})  # Optional - can contain APP_TO_RUN and others
    
    # Per-service load balancer configuration
    load_balancer_arn          = string   # ARN of the load balancer for this service
    listener_port              = optional(number, 80)     # Port for the listener (default 80)
    listener_protocol          = optional(string, "HTTP") # Protocol for the listener (default HTTP)
    
    # Optional existing target group (for manual creation of long names)
    existing_target_group_arn  = optional(string, null)   # If provided, will use existing target group instead of creating new one
    
    # ECR Configuration (always creates ECR repo by default)
    create_ecr_repository      = optional(bool, true)     # Whether to create ECR repository for this service
    ecr_repository_name        = optional(string, null)   # Custom ECR repo name (defaults to service name if not specified)
    ecr_force_delete           = optional(bool, false)    # Force delete ECR repo even if it contains images
    ecr_image_tag_mutability   = optional(string, "MUTABLE") # MUTABLE or IMMUTABLE
    ecr_scan_on_push           = optional(bool, true)     # Enable vulnerability scanning on push
    ecr_encryption_type        = optional(string, "AES256") # AES256 or KMS
    ecr_kms_key                = optional(string, null)   # KMS key ARN for encryption (if encryption_type is KMS)
    ecr_lifecycle_policy       = optional(object({
      max_image_count          = optional(number, 100)    # Maximum number of images to keep
      max_image_age_days       = optional(number, 30)     # Maximum age of untagged images in days
      tagged_prefixes          = optional(list(string), ["v", "release"]) # Keep images with these tag prefixes
    }), {})
  }))
}

# CodeBuild & CodePipeline Global Configuration
variable "codeconnection_arn" {
  description = "ARN of the CodeStar connection for GitHub"
  type        = string
}

variable "codepipeline_artifact_bucket" {
  description = "S3 bucket name for CodePipeline artifacts"
  type        = string
}

variable "default_ecs_cluster_arn" {
  description = "Default ECS cluster ARN for deployments"
  type        = string
  default     = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
}

# Separate IAM Roles for CodeBuild and CodePipeline
variable "codebuild_service_role_arn" {
  description = "IAM role ARN for CodeBuild service"
  type        = string
}

variable "codepipeline_service_role_arn" {
  description = "IAM role ARN for CodePipeline service"
  type        = string
}

# Global CodeBuild Configuration - 4 vCPUs, 8 GiB memory
variable "global_compute_type" {
  description = "Global compute type for all CodeBuild projects (4 vCPUs, 8 GiB memory)"
  type        = string
  default     = "BUILD_GENERAL1_MEDIUM"
}

variable "global_build_image" {
  description = "Global build image for all CodeBuild projects"
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

# Global Notification Configuration
variable "global_chatbot_slack_arn" {
  description = "Global AWS Chatbot Slack channel ARN for all pipeline notifications"
  type        = string
}

# Global Organization Configuration
variable "global_organization_name" {
  description = "Global organization name for repositories"
  type        = string
  default     = "DexlynLabs"
}

# Optional Global KMS Configuration
variable "global_kms_key_arn" {
  description = "Optional KMS key ARN for CodePipeline artifact encryption (leave empty for default S3 encryption)"
  type        = string
  default     = ""
}

# CodePipeline Services Configuration
variable "codepipeline_services" {
  description = "Map of CodePipeline services configuration"
  type = map(object({
    # Repository Configuration
    repository_name     = string           # GitHub repo name only (org will be prepended automatically)
    branch_name        = string           # Branch to monitor
    
    # Pipeline Configuration
    pipeline_name      = string           # Name of the pipeline
    
    # Source Triggers - Git Triggers configuration (for future compatibility)
    # Note: Advanced Git triggers must be configured manually in AWS Console
    source_triggers = object({
      # Push triggers
      push_enabled = optional(bool, true)
      push_include_tags = optional(list(string), ["v*.*"])  # Include tags like v*.*
      
      # Pull request triggers  
      pull_request_enabled = optional(bool, false)
      pull_request_events = optional(list(string), ["CLOSED"])  # PR events: OPEN, UPDATED, CLOSED
      pull_request_include_branches = optional(list(string), ["production"])  # Include branches
      pull_request_include_file_paths = optional(list(string), [])  # Include file paths (optional)
    })
    
    # Build Configuration
    build_project_name = string           # CodeBuild project name
    service_name      = string            # Service name for buildspec path (build-files/<service-name>/buildspec.yml)
    
    # Git Configuration
    git_clone_depth = optional(number, 1)        # Git clone depth (default: 1)
    git_submodules_enabled = optional(bool, true) # Enable Git submodules (default: true)
    
    # Deploy Configuration
    ecs_service_name  = string           # ECS service name to deploy to
    ecs_cluster_arn   = optional(string, null)  # Override default cluster if needed
  }))
  default = {}
}