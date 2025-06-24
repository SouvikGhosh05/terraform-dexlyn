terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "dexlyn-terraform-tfstate-s3"
    key     = "terraform_state_files/dexlyn-prod/prod-souvik-terraform.tfstate"
    region  = "ap-south-1"
    profile = "souvik-admin-dexlyn"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "souvik-admin-dexlyn"
}