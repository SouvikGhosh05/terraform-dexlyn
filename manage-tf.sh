cd ./environments/prod
terraform plan -target=module.ecs-service  -target=module.codebuild_codepipeline_services   -var-file="codepipeline.tfvars" -var-file="ecs-only.tfvars"