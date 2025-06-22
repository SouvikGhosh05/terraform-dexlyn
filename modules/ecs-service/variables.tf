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
    environment_variables       = optional(map(string), {})  # Optional
    
    # Per-service load balancer configuration
    load_balancer_arn          = string   # ARN of the load balancer for this service
    listener_port              = optional(number, 80)     # Port for the listener (default 80)
    listener_protocol          = optional(string, "HTTP") # Protocol for the listener (default HTTP)
    
    # Optional existing target group (for manual creation of long names)
    existing_target_group_arn  = optional(string, null)   # If provided, will use existing target group instead of creating new one
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}