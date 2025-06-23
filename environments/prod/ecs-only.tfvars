# environments/prod/ecs-only.tfvars
# VPC Configuration
vpc_id = "vpc-0f7949091fed5a2ab"

ecs_services = {

  "sns-backend" = {
    service_name                = "sns-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-sns-backend:latest"
    container_port              = 8005
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - SUPRANS LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-suprans-lb/d0de11892c1763af"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 1
    host_header                 = "api.suprans.id"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables
    environment_variables = {}
  }

  # Services using prod-suprans-lb
  "suprans" = {
    service_name                = "suprans"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-suprans:latest"
    container_port              = 3008
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    
    # Load Balancer routing configuration - SUPRANS LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-suprans-lb/d0de11892c1763af"
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
  }

  "suprans-docs" = {
    service_name                = "suprans-docs"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-suprans-docs:latest"
    container_port              = 3023
    desired_count               = 0
    cpu                         = 512
    memory                      = 2048
    log_retention_days          = 30
    
    # Load Balancer routing configuration - SUPRANS LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-suprans-lb/d0de11892c1763af"
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
  }
  # Services using prod-dexlyn-lb
  "airdrop-admin" = {
    service_name                = "airdrop-admin"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3013:3013, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-airdrop-admin:latest"
    container_port              = 3013
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 1
    host_header                 = "admin-airdrop.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - null
    environment_variables = {}
  }

  "airdrop-backend" = {
    service_name                = "airdrop-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 5050:5050, 2,048 4,096
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-airdrop-backend:latest"
    container_port              = 5050
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 2
    host_header                 = "api-airdrop.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - null
    environment_variables = {}
  }

  "airdrop-web" = {
    service_name                = "airdrop-web"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3011:3011, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-airdrop-web:latest"
    container_port              = 3011
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 3
    host_header                 = "airdrop.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - APP_TO_RUN dexlyn-web-airdrop
    environment_variables = {
      APP_TO_RUN = "dexlyn-web-airdrop"
    }
  }

  "bridgescan-backend" = {
    service_name                = "bridgescan-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 8003:8003, 2,048 4,096
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-bridgescan-backend:latest"
    container_port              = 8003
    desired_count               = 0
    cpu                         = 2048
    memory                      = 4096
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 4
    host_header                 = "api-bridgescan.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:targetgroup/ecs-prod-dexlyn-bridgesc-backend/70190103307d26ca"
    
    # Environment variables - null
    environment_variables = {}
  }

  "bridgescan-web" = {
    service_name                = "bridgescan-web"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3015:3015, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-bridgescan-web:latest"
    container_port              = 3015
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 5
    host_header                 = "bridgescan.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - APP_TO_RUN bridgescan
    environment_variables = {
      APP_TO_RUN = "bridgescan"
    }
  }

  "backend" = {
    service_name                = "backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 8000:8000, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-backend:latest"
    container_port              = 8000
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 6
    host_header                 = "api.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - null
    environment_variables = {}
  }

  "blog" = {
    service_name                = "blog"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 80:80, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-blog:latest"
    container_port              = 80
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 7
    host_header                 = "blog.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - null
    environment_variables = {}
  }

  "docs" = {
    service_name                = "docs"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3022:3022, 256 1,024
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-docs:latest"
    container_port              = 3022
    desired_count               = 0
    cpu                         = 256
    memory                      = 1024
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 8
    host_header                 = "docs.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - APP_TO_RUN docs
    environment_variables = {
      APP_TO_RUN = "docs"
    }
  }

  "indexer" = {
    service_name                = "indexer"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 8081:8081, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-indexer:latest"
    container_port              = 8081
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 9
    host_header                 = "indexer.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - null
    environment_variables = {}
  }

  "launchpad" = {
    service_name                = "launchpad"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3005:3005, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-launchpad:latest"
    container_port              = 3005
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 10
    host_header                 = "launchpad.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - APP_TO_RUN launchpad
    environment_variables = {
      APP_TO_RUN = "launchpad"
    }
  }

  "launchpad-backend" = {
    service_name                = "launchpad-backend"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 8002:8002, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-launchpad-backend:latest"
    container_port              = 8002
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 11
    host_header                 = "api-launchpad.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:targetgroup/ecs-prod-dexlyn-launchpd-backend/65993c9f59b62478"
    
    # Environment variables - null
    environment_variables = {}
  }

  "swap" = {
    service_name                = "swap"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3001:3001, 1,024 2,048
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-swap:latest"
    container_port              = 3001
    desired_count               = 0
    cpu                         = 1024
    memory                      = 2048
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 12
    host_header                 = "app.dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - APP_TO_RUN swap
    environment_variables = {
      APP_TO_RUN = "swap"
    }
  }

  "web" = {
    service_name                = "web"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 3000:3000, 1,024 3,072  
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-web:latest"
    container_port              = 3000
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 13
    host_header                 = "dexlyn.com"
    
    # Target group - auto-created
    existing_target_group_arn   = null
    
    # Environment variables - APP_TO_RUN web
    environment_variables = {
      APP_TO_RUN = "web"
    }
  }

  "reserve-size-service" = {
    service_name                = "reserve-size-service"
    existing_cluster_arn        = "arn:aws:ecs:ap-south-1:125021993355:cluster/prod-dexlyn-cluster"
    
    # Network configuration
    existing_subnet_ids = [
      "subnet-02c8989302e084118",  # ap-south-1a
      "subnet-0686d6f003c8c94e3",  # ap-south-1c
      "subnet-0704a97e66177ee01"   # ap-south-1b
    ]
    existing_security_group_id = "sg-045e4e3d83365876b"
    
    # IAM roles
    existing_execution_role_arn = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    existing_task_role_arn      = "arn:aws:iam::125021993355:role/ecsTaskExecutionRole"
    
    # Container configuration - 8090:8090, 1,024 3,072
    container_image             = "125021993355.dkr.ecr.ap-south-1.amazonaws.com/prod-dexlyn-reserve-size-service:latest"
    container_port              = 8090
    desired_count               = 0
    cpu                         = 1024
    memory                      = 3072
    log_retention_days          = 30
    
    # Load Balancer routing configuration - DEXLYN LB
    load_balancer_arn           = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:loadbalancer/app/prod-dexlyn-lb/56a0ef2f8eeadedb"
    listener_port               = 80
    listener_protocol           = "HTTP"
    listener_rule_priority      = 14
    host_header                 = "prod-reserve-service.dexlyn.com"
    
    # Target group - manually created due to long name
    existing_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:125021993355:targetgroup/ecs-prod-dexlyn-resv-size-svc/10fd4ba437e4bb3f"  # You can manually create and pass ARN here if needed
    
    # Environment variables - null
    environment_variables = {}
  }

}