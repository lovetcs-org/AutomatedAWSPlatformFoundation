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

module "vpc" {
  source = "../../../../modules/vpc"
  env_name = "dev"
  vpc_cidr = "10.0.0.0/16"
}

data "aws_iam_role" "eks_cluster" {
  name = "dev-eks-role"
}

module "eks" {
  source = "../../../../modules/eks"
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  env_name = "dev"
  cluster_arn_role = data.aws_iam_role.eks_cluster.arn

}