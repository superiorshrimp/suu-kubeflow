resource "aws_eks_cluster" "eks_infrastructure" {
  name     = var.eks_config.eks_cluster_name
  role_arn = local.eks_cluster_arn

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
    security_group_ids = [aws_security_group.allow_access.id]
  }
}

resource "aws_eks_node_group" "eks_training_nodes" {
  cluster_name    = aws_eks_cluster.eks_infrastructure.id
  node_group_name = var.eks_config.node_group_name
  node_role_arn   = local.node_group_arn
  subnet_ids      = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}