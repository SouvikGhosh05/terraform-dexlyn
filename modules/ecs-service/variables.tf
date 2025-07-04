# modules/ecs-service/variables.tf

variable "environment" {
  description = "Environment name (prod, qa, etc.)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for resources"
  type        = string
}

variable "services" {
  description = "Map of ECS services configuration"
  type = map(object({
    service_name                = string
    container_port              = number
    desired_count               = number
    cpu                         = number
    memory                      = number
    log_retention_days          = number
    listener_rule_priority      = number   # Priority for listener rule (1-50000) - must be unique per service
    host_header                 = string   # Host header for routing (e.g., "prod-docs.dexlyn.com")
    environment_variables       = optional(map(string), {})  # Optional
    
    # Per-service load balancer configuration (will be set dynamically by main.tf)
    existing_cluster_arn        = string
    existing_subnet_ids         = list(string)
    existing_security_group_id  = string
    existing_execution_role_arn = string  # ecsTaskExecutionRole
    existing_task_role_arn      = string  # ecsTaskExecutionRole (same as execution)
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}