terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  type = string
}

provider "aws" {
  region = var.aws_region
}

terraform {
    backend "s3" {
        bucket = "lovetcs-dev-lock-bucket"
        key = "terraform.tfstate"
        encrypt = true
        use_lockfile = true
    }
}