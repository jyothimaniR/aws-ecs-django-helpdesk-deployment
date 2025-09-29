terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "helpdesk-terraform-state-7733"
    key            = "project-1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "helpdesk-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "django-helpdesk"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
