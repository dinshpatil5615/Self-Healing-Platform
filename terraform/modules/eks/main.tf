resource "aws_eks_cluster" "eks_cluster" {
    name = var.cluster_name
    role_arn = var.cluster_role_arn

    vpc_config {
      subnet_ids = var.subnet_ids
      security_group_ids = [var.cluster_sg_id]
    }
}

resource "aws_eks_node_group" "node-group" {
  cluster_name = var.cluster_name
  node_role_arn = var.node_role_arn
  node_group_name = "self-healing-nodes"
  subnet_ids = var.subnet_ids
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 3
    min_size = 2
    max_size = 4
  }
}