# Local variables
locals {
  aws_region = "ap-south-1"
  account_id = data.aws_caller_identity.current.account_id
}

# Data sources
data "aws_caller_identity" "current" {}

# Data source for existing S3 bucket
data "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = var.artifact_bucket_name
}

# CloudWatch Log Groups for CodeBuild projects
resource "aws_cloudwatch_log_group" "codebuild_logs" {
  for_each = var.services

  name              = "/aws/codebuild/${each.value.build_project_name}"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name        = "/aws/codebuild/${each.value.build_project_name}"
    Environment = var.environment
  })
}

# CodeBuild projects
resource "aws_codebuild_project" "main" {
  for_each = var.services

  name          = each.value.build_project_name
  service_role  = var.codebuild_service_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.global_compute_type
    image                      = var.global_build_image
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode            = true  # Required for Docker builds
  }

  source {
    type = "GITHUB"
    location = "https://github.com/${var.global_organization_name}/${each.value.repository_name}.git"
    # Set a predictable buildspec path that teams can reference
    # Teams can switch to inline commands in AWS Console after creation
    buildspec = "build-files/${each.value.service_name}/buildspec.yml"
    git_clone_depth = each.value.git_clone_depth
    git_submodules_config {
      fetch_submodules = each.value.git_submodules_enabled
    }
    
    # GitHub App authentication will be used automatically
    auth {
      type = "CODECONNECTIONS"
      resource = var.codeconnection_arn
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild_logs[each.key].name
    }
  }

  tags = merge(var.tags, {
    Name        = each.value.build_project_name
    Environment = var.environment
  })

  # Ignore changes to buildspec after creation - allows manual management including inline buildspec
  lifecycle {
    ignore_changes = [
      source[0].buildspec,
      source[0].git_clone_depth,
      source[0].git_submodules_config,
      source
    ]
  }
}

# CodePipeline
resource "aws_codepipeline" "main" {
  for_each = var.services

  name          = each.value.pipeline_name
  role_arn      = var.codepipeline_service_role_arn
  pipeline_type = "V2"

  execution_mode = "QUEUED"  # Pipeline executions will be processed one by one

  artifact_store {
    location = data.aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
    
    # Optional KMS encryption - only add if KMS key is provided
    dynamic "encryption_key" {
      for_each = var.global_kms_key_arn != "" ? [1] : []
      content {
        id   = var.global_kms_key_arn
        type = "KMS"
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = var.codeconnection_arn
        FullRepositoryId = "${var.global_organization_name}/${each.value.repository_name}"
        BranchName       = each.value.branch_name
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges = false  # Disable automatic detection to lock pipeline
      }
    }

    # Source-PR action for Pull Request triggers (will be configured manually if needed)
    dynamic "action" {
      for_each = each.value.source_triggers.pull_request_enabled ? [1] : []
      content {
        name             = "Source-PR"
        category         = "Source"
        owner            = "AWS"
        provider         = "CodeStarSourceConnection"
        version          = "1"
        output_artifacts = ["SourceArtifact-PR"]
        run_order        = 1

        configuration = {
          ConnectionArn    = var.codeconnection_arn
          FullRepositoryId = "${var.global_organization_name}/${each.value.repository_name}"
          BranchName       = each.value.branch_name
          OutputArtifactFormat = "CODEBUILD_CLONE_REF"
          DetectChanges = false  # Will be configured manually for PR triggers
        }
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.main[each.key].name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = each.value.ecs_cluster_arn != null ? split("/", each.value.ecs_cluster_arn)[1] : split("/", var.default_ecs_cluster_arn)[1]
        ServiceName = each.value.ecs_service_name
        FileName    = "imagedefinitions.json"
      }
    }
  }

  tags = merge(var.tags, {
    Name        = each.value.pipeline_name
    Environment = var.environment
  })

  # Ignore changes to trigger configurations that will be set manually in AWS Console
  lifecycle {
    ignore_changes = [
      stage[0].action[0].configuration,
      stage[0].action[1].configuration,  # Ignore Source-PR configuration changes
      stage[0].action
    ]
  }

  depends_on = [
    data.aws_s3_bucket.codepipeline_artifacts,
    aws_codebuild_project.main
  ]
}

# Stop any pipeline executions that may have started automatically
resource "null_resource" "stop_pipeline_executions" {
  for_each = var.services

  provisioner "local-exec" {
    command = <<-EOT
      # Wait a few seconds for pipeline to be created
      sleep 5
      
      # Stop any running executions
      aws codepipeline stop-pipeline-execution \
        --pipeline-name ${each.value.pipeline_name} \
        --pipeline-execution-id $(aws codepipeline list-pipeline-executions \
          --pipeline-name ${each.value.pipeline_name} \
          --max-items 1 \
          --query 'pipelineExecutionSummaries[0].pipelineExecutionId' \
          --output text 2>/dev/null || echo "no-execution") \
        --abandon --region ${local.aws_region} 2>/dev/null || true
      
      echo "Pipeline ${each.value.pipeline_name} locked - manual execution required"
    EOT
  }

  depends_on = [aws_codepipeline.main]

  triggers = {
    pipeline_name = each.value.pipeline_name
  }
}

# CodePipeline Notification Rules
resource "aws_codestarnotifications_notification_rule" "pipeline_notifications" {
  for_each = var.services

  name        = "${var.environment}-dexlyn-${each.value.service_name}-slack"
  detail_type = "FULL"
  resource    = aws_codepipeline.main[each.key].arn

  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-succeeded"
  ]

  target {
    address = var.global_chatbot_slack_arn
    type    = "AWSChatbotSlack"
  }

  tags = merge(var.tags, {
    Name        = "${var.environment}-dexlyn-${each.value.service_name}-slack"
    Environment = var.environment
  })
}