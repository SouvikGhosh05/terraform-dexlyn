# environments/prod/ecs-only.tfvars - PART 1 of 3
# VPC Configuration
vpc_id = "vpc-07bb36cd55e344c48"

ecs_services = {
  
  "sns-backend" = {
    service_name                = "sns-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-sns-backend:latest"
    container_port              = 8005
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - SUPRANS LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-suprans-lb/d63a4606e3ec60bf"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 1
    host_header                 = "api.suprans.id"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-sns-backend"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 7
    #   tagged_prefixes    = ["v", "release", "stable"]
    # }
  }

  "suprans" = {
    service_name                = "suprans"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-suprans:latest"
    container_port              = 3008
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    
    # Load Balancer routing configuration - SUPRANS LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-suprans-lb/d63a4606e3ec60bf"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 2
    host_header                 = "www.suprans.id"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "suprans"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-suprans"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 100
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "suprans-docs" = {
    service_name                = "suprans-docs"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-suprans-docs:latest"
    container_port              = 3023
    desired_count               = 0
    cpu                         = 512
    memory                      = 2048
    log_retention_days          = 30
    
    # Load Balancer routing configuration - SUPRANS LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-suprans-lb/d63a4606e3ec60bf"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 3
    host_header                 = "docs.suprans.id"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "docs"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-suprans-docs"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 30
    #   max_image_age_days = 10
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "airdrop-admin" = {
    service_name                = "airdrop-admin"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3013:3013, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-airdrop-admin:latest"
    container_port              = 3013
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 1
    host_header                 = "admin-airdrop.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-airdrop-admin"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "airdrop-backend" = {
    service_name                = "airdrop-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 5050:5050, 2,048 4,096
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-airdrop-backend:latest"
    container_port              = 5050
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 2
    host_header                 = "api-airdrop.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-airdrop-backend"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 75
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release", "hotfix"]
    # }
  }

  "airdrop-web" = {
    service_name                = "airdrop-web"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3011:3011, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-airdrop-web:latest"
    container_port              = 3011
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 3
    host_header                 = "airdrop.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "dexlyn-web-airdrop"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-airdrop-web"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "bridgescan-backend" = {
    service_name                = "bridgescan-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 8003:8003, 2,048 4,096
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-bridgescan-backend:latest"
    container_port              = 8003
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 4
    host_header                 = "api-bridgescan.dexlyn.com"
    
    # Target group - existing
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:targetgroup/ecs-prod-dexlyn-bridgesc-backend/dbd13969e9b8cff1"
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-bridgescan-backend"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 75
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release", "hotfix"]
    # }
  }

  "bridgescan-web" = {
    service_name                = "bridgescan-web"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3015:3015, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-bridgescan-web:latest"
    container_port              = 3015
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 5
    host_header                 = "bridgescan.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "bridgescan"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-bridgescan-web"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "backend" = {
    service_name                = "backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 8000:8000, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-backend:latest"
    container_port              = 8000
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 6
    host_header                 = "api.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-backend"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 100
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release", "hotfix"]
    # }
  }

  "blog" = {
    service_name                = "blog"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 80:80, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-blog:latest"
    container_port              = 80
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 7
    host_header                 = "blog.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-blog"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 30
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "docs" = {
    service_name                = "docs"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3022:3022, 256 1,024
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-docs:latest"
    container_port              = 3022
    desired_count               = 0
    cpu                         = 256
    memory                      = 1024
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 8
    host_header                 = "docs.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "docs"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-docs"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 30
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "indexer" = {
    service_name                = "indexer"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 8081:8081, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-indexer:latest"
    container_port              = 8081
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 9
    host_header                 = "indexer.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-indexer"
    ecr_image_tag_mutability   = "IMMUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "launchpad" = {
    service_name                = "launchpad"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3005:3005, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-launchpad:latest"
    container_port              = 3005
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 10
    host_header                 = "launchpad.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "launchpad"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-launchpad"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "launchpad-backend" = {
    service_name                = "launchpad-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 8002:8002, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-launchpad-backend:latest"
    container_port              = 8002
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 11
    host_header                 = "api-launchpad.dexlyn.com"
    
    # Target group - existing
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:targetgroup/ecs-prod-dexlyn-launchpd-backend/daf0bd472c6f21b2"
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-launchpad-backend"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 75
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release", "hotfix"]
    # }
  }

  "swap" = {
    service_name                = "swap"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3001:3001, 1,024 2,048
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-swap:latest"
    container_port              = 3001
    desired_count               = 0
    cpu                         = 1024
    memory                      = 2048
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 12
    host_header                 = "app.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "swap"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-swap"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "web" = {
    service_name                = "web"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 3000:3000, 1,024 3,072  
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-web:latest"
    container_port              = 3000
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 13
    host_header                 = "dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {
      APP_TO_RUN = "web"
    }
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-web"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

  "reserve-size-service" = {
    service_name                = "reserve-size-service"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:654654234818:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-0515736f6100e35bb",  # ap-south-1a
      "subnet-05de2d5acc2ec95cd",  # ap-south-1c
      "subnet-06e4ea6fe3497d8c7"   # ap-south-1b
    ]
    existing_security_group_id = "sg-017585087b499d69b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::654654234818:role/ecsTaskExecutionRole"
    
    # Container configuration - 8090:8090, 1,024 3,072
    container_image             = "654654234818.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-reserve-size-service:latest"
    container_port              = 8090
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:loadbalancer/app/prod-dexlyn-lb/c599bff662dd0df9"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 14
    host_header                 = "prod-reserve-service.dexlyn.com"
    
    # Target group - existing
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:654654234818:targetgroup/ecs-prod-dexlyn-resv-size-svc/a13fe896d0efdcc6"
    
    # Environment variables
    environment_variables = {}
    
    # ECR Configuration - Will be created by default
    ecr_repository_name        = "prod-dexlyn-reserve-size-service"
    ecr_image_tag_mutability   = "MUTABLE"
    ecr_scan_on_push           = true
    ecr_encryption_type        = "AES256"
    # ecr_lifecycle_policy = {
    #   max_image_count    = 50
    #   max_image_age_days = 14
    #   tagged_prefixes    = ["v", "release"]
    # }
  }

}