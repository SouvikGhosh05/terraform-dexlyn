output "pipelines" {
  description = "Information about created CodePipelines"
  value = {
    for key, pipeline in aws_codepipeline.main : key => {
      pipeline_name = pipeline.name
      pipeline_arn  = pipeline.arn
      pipeline_id   = pipeline.id
      execution_mode = pipeline.execution_mode
    }
  }
}

output "codebuild_projects" {
  description = "Information about created CodeBuild projects"
  value = {
    for key, project in aws_codebuild_project.main : key => {
      project_name = project.name
      project_arn  = project.arn
      project_id   = project.id
      service_role = project.service_role
    }
  }
}

output "s3_artifact_bucket" {
  description = "S3 bucket for CodePipeline artifacts"
  value = {
    bucket_name = data.aws_s3_bucket.codepipeline_artifacts.id
    bucket_arn  = data.aws_s3_bucket.codepipeline_artifacts.arn
    bucket_domain_name = data.aws_s3_bucket.codepipeline_artifacts.bucket_domain_name
  }
}

output "cloudwatch_log_groups" {
  description = "CloudWatch log groups for CodeBuild projects"
  value = {
    for key, log_group in aws_cloudwatch_log_group.codebuild_logs : key => {
      log_group_name = log_group.name
      log_group_arn  = log_group.arn
      retention_days = log_group.retention_in_days
    }
  }
}

output "notification_rules" {
  description = "CodePipeline notification rules for Slack"
  value = {
    for key, rule in aws_codestarnotifications_notification_rule.pipeline_notifications : key => {
      rule_name = rule.name
      rule_arn  = rule.arn
      detail_type = rule.detail_type
    }
  }
}