variable "environment" {
  description = "Environment name (prod, qa, etc.)"
  type        = string
}

variable "codeconnection_arn" {
  description = "ARN of the CodeStar connection for GitHub"
  type        = string
}

variable "artifact_bucket_name" {
  description = "S3 bucket name for CodePipeline artifacts"
  type        = string
}

variable "default_ecs_cluster_arn" {
  description = "Default ECS cluster ARN for deployments"
  type        = string
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

variable "global_compute_type" {
  description = "Global compute type for all CodeBuild projects (4 vCPUs, 8 GiB memory)"
  type        = string
}

variable "global_build_image" {
  description = "Global build image for all CodeBuild projects"
  type        = string
}

variable "global_chatbot_slack_arn" {
  description = "Global AWS Chatbot Slack channel ARN for all pipeline notifications"
  type        = string
}

variable "global_organization_name" {
  description = "Global organization name for repositories"
  type        = string
}

variable "global_kms_key_arn" {
  description = "Optional KMS key ARN for CodePipeline artifact encryption (leave empty for default S3 encryption)"
  type        = string
  default     = ""
}

variable "services" {
  description = "Map of CodePipeline services configuration"
  type = map(object({
    repository_name     = string
    branch_name        = string
    pipeline_name      = string
    
    # Source Triggers - Git Triggers configuration (for future compatibility)
    # Note: Advanced Git triggers must be configured manually in AWS Console
    source_triggers = object({
      # Push triggers
      push_enabled = optional(bool, true)
      push_include_tags = optional(list(string), ["v*.*"])
      
      # Pull request triggers
      pull_request_enabled = optional(bool, false)
      pull_request_events = optional(list(string), ["CLOSED"])
      pull_request_include_branches = optional(list(string), ["production"])
      pull_request_include_file_paths = optional(list(string), [])  # Include file paths (optional)
    })
    
    build_project_name = string
    service_name      = string            # Service name for buildspec path (build-files/<service-name>/buildspec.yml)
    
    # Git Configuration
    git_clone_depth = optional(number, 1)        # Git clone depth (default: 1)
    git_submodules_enabled = optional(bool, true) # Enable Git submodules (default: true)
    
    ecs_service_name  = string
    ecs_cluster_arn   = optional(string, null)
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}