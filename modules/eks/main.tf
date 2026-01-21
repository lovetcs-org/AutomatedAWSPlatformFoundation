resource "aws_eks_cluster" "main" {
  name = "${var.env_name}-cluster"
  role_arn = var.cluster_arn_role
  vpc_config {
    subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access =  true 
    endpoint_public_access = true
    }
}