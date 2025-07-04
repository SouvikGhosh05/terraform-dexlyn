# environments/prod/ecs-only.tfvars - Mumbai Production Environment
# Note: VPC configuration (172.48.0.0/16) and container images are handled dynamically
# ECS Cluster 'prod-dexlyn-cluster' will be created only if it doesn't exist

# ECS Services Configuration - All 17 services with dynamic container images
ecs_services = {
  "indexer" = {
    service_name                = "indexer"
    container_port              = 8081
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 9
    host_header                 = "indexer.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-indexer"
    ecr_image_tag_mutability    = "IMMUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "launchpad" = {
    service_name                = "launchpad"
    container_port              = 3005
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 10
    host_header                 = "launchpad.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "launchpad"
    }
    ecr_repository_name         = "prod-dexlyn-launchpad"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "launchpad-backend" = {
    service_name                = "launchpad-backend"
    container_port              = 8002
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 11
    host_header                 = "api-launchpad.dexlyn.com"
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:targetgroup/ecs-prod-dexlyn-launchpd-backend/daf0bd472c6f21b2"
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-launchpad-backend"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "swap" = {
    service_name                = "swap"
    container_port              = 3001
    desired_count               = 0
    cpu                         = 1024
    memory                      = 2048
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 12
    host_header                 = "app.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "swap"
    }
    ecr_repository_name         = "prod-dexlyn-swap"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "web" = {
    service_name                = "web"
    container_port              = 3000
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 13
    host_header                 = "dexlyn.com"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "web"
    }
    ecr_repository_name         = "prod-dexlyn-web"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "reserve-size-service" = {
    service_name                = "reserve-size-service"
    container_port              = 8090
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 14
    host_header                 = "prod-reserve-service.dexlyn.com"
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:targetgroup/ecs-prod-dexlyn-resv-size-svc/a13fe896d0efdcc6"
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-reserve-size-service"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

}
  # ===== SUPRANS LOAD BALANCER SERVICES =====
  
  "sns-backend" = {
    service_name                = "sns-backend"
    container_port              = 8005
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 1
    host_header                 = "api.suprans.id"
    existing_target_group_arn   = null
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-sns-backend"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "suprans" = {
    service_name                = "suprans"
    container_port              = 3008
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 2
    host_header                 = "www.suprans.id"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "suprans"
    }
    ecr_repository_name         = "prod-dexlyn-suprans"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "suprans-docs" = {
    service_name                = "suprans-docs"
    container_port              = 3023
    desired_count               = 0
    cpu                         = 512
    memory                      = 2048
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 3
    host_header                 = "docs.suprans.id"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "docs"
    }
    ecr_repository_name         = "prod-dexlyn-suprans-docs"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  # ===== DEXLYN LOAD BALANCER SERVICES =====

  "airdrop-admin" = {
    service_name                = "airdrop-admin"
    container_port              = 3013
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 1
    host_header                 = "admin-airdrop.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-airdrop-admin"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "airdrop-backend" = {
    service_name                = "airdrop-backend"
    container_port              = 5050
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 2
    host_header                 = "api-airdrop.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-airdrop-backend"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "airdrop-web" = {
    service_name                = "airdrop-web"
    container_port              = 3011
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 3
    host_header                 = "airdrop.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "dexlyn-web-airdrop"
    }
    ecr_repository_name         = "prod-dexlyn-airdrop-web"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "bridgescan-backend" = {
    service_name                = "bridgescan-backend"
    container_port              = 8003
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 4
    host_header                 = "api-bridgescan.dexlyn.com"
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:targetgroup/ecs-prod-dexlyn-bridgesc-backend/dbd13969e9b8cff1"
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-bridgescan-backend"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "bridgescan-web" = {
    service_name                = "bridgescan-web"
    container_port              = 3015
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 5
    host_header                 = "bridgescan.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "bridgescan"
    }
    ecr_repository_name         = "prod-dexlyn-bridgescan-web"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "backend" = {
    service_name                = "backend"
    container_port              = 8000
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 6
    host_header                 = "api.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-backend"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "blog" = {
    service_name                = "blog"
    container_port              = 80
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 7
    host_header                 = "blog.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables       = {}
    ecr_repository_name         = "prod-dexlyn-blog"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }

  "docs" = {
    service_name                = "docs"
    container_port              = 3022
    desired_count               = 0
    cpu                         = 256
    memory                      = 1024
    log_retention_days          = 30
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 8
    host_header                 = "docs.dexlyn.com"
    existing_target_group_arn   = null
    environment_variables = {
      APP_TO_RUN = "docs"
    }
    ecr_repository_name         = "prod-dexlyn-docs"
    ecr_image_tag_mutability    = "MUTABLE"
    ecr_scan_on_push            = true
    ecr_encryption_type         = "AES256"
  }