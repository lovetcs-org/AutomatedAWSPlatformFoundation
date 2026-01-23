resource "aws_eks_cluster" "main" {
  name = "${var.env_name}-cluster"
  role_arn = var.cluster_arn_role
  vpc_config {
    subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access =  true 
    endpoint_public_access = true
    }
}

resource "aws_eks_node_group" "main" {
  node_group_name = "${var.env_name}-node-group"
  cluster_name = aws_eks_cluster.main.name
  node_role_arn = var.cluster_node_arn_role
  subnet_ids = var.private_subnet_ids
  instance_types = ["t2.small"]
  scaling_config {
    desired_size = 3
    min_size = 1
    max_size = 5
  } 
}
