# modules/ecs-service/outputs.tf

output "services" {
  description = "Map of ECS services information"
  value = {
    for key, service in aws_ecs_service.main : key => {
      service_id   = service.id
      service_name = service.name
      service_arn  = service.id
    }
  }
}

output "task_definitions" {
  description = "Map of ECS task definitions information"
  value = {
    for key, task_def in aws_ecs_task_definition.main : key => {
      task_definition_arn      = task_def.arn
      task_definition_revision = task_def.revision
      family                   = task_def.family
    }
  }
}

output "target_groups" {
  description = "Map of target groups information (only created ones)"
  value = {
    for key, tg in aws_lb_target_group.main : key => {
      target_group_arn  = tg.arn
      target_group_name = tg.name
      port              = tg.port
      protocol          = tg.protocol
      vpc_id            = tg.vpc_id
    }
  }
}

output "existing_target_groups" {
  description = "Map of existing target groups information"
  value = {
    for key, tg in data.aws_lb_target_group.existing : key => {
      target_group_arn  = tg.arn
      target_group_name = tg.name
      port              = tg.port
      protocol          = tg.protocol
      vpc_id            = tg.vpc_id
    }
  }
}

output "log_groups" {
  description = "Map of CloudWatch log groups information"
  value = {
    for key, log_group in aws_cloudwatch_log_group.ecs_logs : key => {
      log_group_name = log_group.name
      log_group_arn  = log_group.arn
    }
  }
}

output "load_balancer_listeners" {
  description = "Map of load balancer listeners information"
  value = {
    for key, listener in data.aws_lb_listener.existing : key => {
      listener_arn      = listener.arn
      load_balancer_arn = listener.load_balancer_arn
      port              = listener.port
      protocol          = listener.protocol
    }
  }
}

output "load_balancer_listener_rules" {
  description = "Map of load balancer listener rules information"
  value = {
    for key, rule in aws_lb_listener_rule.main : key => {
      rule_arn          = rule.arn
      listener_arn      = rule.listener_arn
      priority          = rule.priority
      target_group_arn  = rule.action[0].target_group_arn
    }
  }
}

# ECR Outputs
output "ecr_repositories" {
  description = "Map of ECR repositories information"
  value = {
    for key, repo in aws_ecr_repository.service_repos : key => {
      repository_arn           = repo.arn
      repository_name          = repo.name
      repository_url           = repo.repository_url
      registry_id              = repo.registry_id
      image_tag_mutability     = repo.image_tag_mutability
      image_scanning_enabled   = repo.image_scanning_configuration[0].scan_on_push
      encryption_type          = repo.encryption_configuration[0].encryption_type
    }
  }
}

output "ecr_lifecycle_policies" {
  description = "Map of ECR lifecycle policies information"
  value = {
    for key, policy in aws_ecr_lifecycle_policy.service_lifecycle : key => {
      repository_name = policy.repository
      policy_text     = policy.policy
    }
  }
}

# Combined output for easy reference
output "ecr_repository_urls" {
  description = "Map of ECR repository URLs for easy reference"
  value = {
    for key, repo in aws_ecr_repository.service_repos : key => repo.repository_url
  }
}

output "all_resources_summary" {
  description = "Summary of all created resources"
  value = {
    ecs_services_count     = length(aws_ecs_service.main)
    target_groups_count    = length(aws_lb_target_group.main)
    log_groups_count       = length(aws_cloudwatch_log_group.ecs_logs)
    ecr_repositories_count = length(aws_ecr_repository.service_repos)
    listener_rules_count   = length(aws_lb_listener_rule.main)
  }
}