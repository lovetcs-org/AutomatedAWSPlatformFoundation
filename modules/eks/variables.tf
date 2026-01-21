variable "cluster_arn_role" {
  type        = string
  description = "ARN role for eks cluster"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "List of public subnet IDs"
}

variable "env_name" {
  type = string
  description = "Current Env name"
}