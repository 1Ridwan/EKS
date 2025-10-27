terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.12.0"
    }
  }
}

provider "aws" {
  region = var.vpc_region

  default_tags {
    tags = {
      Project = "EKS"
      Environment = "Dev"
      ManagedBy = "terraform"
    }
  }
}