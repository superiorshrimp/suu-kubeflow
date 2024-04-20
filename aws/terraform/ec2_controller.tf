resource "aws_instance" "controller_instance" {
  instance_type = var.controller_instance_config.instance_type
  ami           = var.controller_instance_config.ami

  vpc_security_group_ids      = [aws_security_group.allow_access.id]
  subnet_id                   = aws_subnet.public_subnet_a.id
  iam_instance_profile        = var.controller_instance_config.iam_instance_profile
  key_name                    = var.controller_instance_config.key_name
  associate_public_ip_address = "true"

  user_data = templatefile("../scripts/init_kubeflow_controller.sh", {
    cluster_name  = "${var.eks_config.eks_cluster_name}"
    region        = "${var.region}"
  })

  metadata_options {
    http_endpoint = "enabled"
  }

  tags = {
    Name = "suu-kubeflow-project"
  }
}