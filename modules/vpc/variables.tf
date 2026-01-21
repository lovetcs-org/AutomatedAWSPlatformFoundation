variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "env_name" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet ids"
}