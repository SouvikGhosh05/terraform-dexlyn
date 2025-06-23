# environments/prod/codepipeline.tfvars
# Global CodeBuild & CodePipeline Configuration
codeconnection_arn = "arn:aws:codeconnections:ap-south-1:125021993355:connection/6151fecf-efaf-4f96-bbf7-67db1aa9df02"
codepipeline_artifact_bucket = "dexlyn-codepipeline-artifact-bucket"
default_ecs_cluster_arn = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"

# Separate IAM Roles for CodeBuild and CodePipeline
codebuild_service_role_arn = "arn:aws:iam::125021993355:role/dexlyn-codepipeline-service-role"
codepipeline_service_role_arn = "arn:aws:iam::125021993355:role/service-role/dexlyn-codepipeline"

# Global CodeBuild Configuration - 4 vCPUs, 8 GiB memory
global_compute_type = "BUILD_GENERAL1_MEDIUM"
global_build_image = "aws/codebuild/standard:7.0"

# Global Notification Configuration
global_chatbot_slack_arn = "arn:aws:chatbot::125021993355:chat-configuration/slack-channel/dexlyn-codepipeline-slack-notification"

# Global Organization Configuration
global_organization_name = "DexlynLabs"

# Optional KMS Configuration (leave empty if no KMS encryption needed)
global_kms_key_arn = ""

codepipeline_services = {
  "backend" = {
    repository_name     = "dexlyn_web_frontend"
    branch_name        = "production"
    pipeline_name      = "prod-dexlyn-backend-cicd"
    
    source_triggers = {
      push_enabled = true
      push_include_tags = ["v*.*"]
      pull_request_enabled = true
      pull_request_events = ["CLOSED"]
      pull_request_include_branches = ["production"]
    }
    
    build_project_name = "prod-backend-codebuild"
    service_name      = "backend"
    
    git_clone_depth = 1
    git_submodules_enabled = true
    
    ecs_service_name = "prod-dexlyn-backend"
  }

  # "bridgescan-web" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-bridgescan-web-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-bridgescan-web-codebuild"
  #   service_name      = "bridgescan-web"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-bridgescan-web"
  # }

  # "launchpad" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-launchpad-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-launchpad-codebuild"
  #   service_name      = "launchpad"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-launchpad"
  # }

  # "swap" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-swap-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-swap-codebuild"
  #   service_name      = "swap"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-swap"
  # }

  # "web" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-web-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-web-codebuild"
  #   service_name      = "web"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-web"
  # }

  # "docs" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-docs-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-docs-codebuild"
  #   service_name      = "docs"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-docs"
  # }

  # "sns-backend" = {
  #   repository_name     = "dexlyn-sns-event-handler"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-sns-backend-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-sns-backend-codebuild"
  #   service_name      = "sns-backend"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = false  # Dedicated repo - no submodules
    
  #   ecs_service_name = "prod-dexlyn-sns-backend"
  # }

  # "suprans-docs" = {
  #   repository_name     = "suprans"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-suprans-docs-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-suprans-docs-codebuild"
  #   service_name      = "suprans-docs"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = false  # Dedicated repo - no submodules
    
  #   ecs_service_name = "prod-dexlyn-suprans-docs"
  # }

  # "airdrop-admin" = {
  #   repository_name     = "dexlyn_airdrop_admin_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-airdrop-admin-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-airdrop-admin-codebuild"
  #   service_name      = "airdrop-admin"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = false  # Dedicated repo - no submodules
    
  #   ecs_service_name = "prod-dexlyn-airdrop-admin"
  # }

  # "airdrop-backend" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-airdrop-backend-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-airdrop-backend-codebuild"
  #   service_name      = "airdrop-backend"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-airdrop-backend"
  # }

  # "airdrop-web" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-airdrop-web-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-airdrop-web-codebuild"
  #   service_name      = "airdrop-web"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-airdrop-web"
  # }

  # "launchpad-backend" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-launchpad-backend-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-launchpad-backend-codebuild"
  #   service_name      = "launchpad-backend"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-launchpad-backend"
  # }

  # "bridgescan-backend" = {
  #   repository_name     = "dexlyn_web_frontend"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-bridgescan-backend-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-bridgescan-backend-codebuild"
  #   service_name      = "bridgescan-backend"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = true
    
  #   ecs_service_name = "prod-dexlyn-bridgescan-backend"
  # }

  # "indexer" = {
  #   repository_name     = "dexlyn_indexer"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-indexer-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-indexer-codebuild"
  #   service_name      = "indexer"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = false  # Dedicated repo - no submodules
    
  #   ecs_service_name = "prod-dexlyn-indexer"
  # }

  # "reserve-size-service" = {
  #   repository_name     = "dexlyn-reserve-size-service"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-reserve-size-service-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-reserve-size-service-codebuild"
  #   service_name      = "reserve-size-service"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = false  # Dedicated repo - no submodules
    
  #   ecs_service_name = "prod-dexlyn-reserve-size-service"
  # }

  # "suprans-web" = {
  #   repository_name     = "suprans"
  #   branch_name        = "production"
  #   pipeline_name      = "prod-dexlyn-suprans-web-cicd"
    
  #   source_triggers = {
  #     push_enabled = true
  #     push_include_tags = ["v*.*"]
  #     pull_request_enabled = true
  #     pull_request_events = ["CLOSED"]
  #     pull_request_include_branches = ["production"]
  #   }
    
  #   build_project_name = "prod-suprans-web-codebuild"
  #   service_name      = "suprans-web"
    
  #   git_clone_depth = 1
  #   git_submodules_enabled = false  # Dedicated repo - no submodules
    
  #   ecs_service_name = "prod-dexlyn-suprans-web"
  # }
}