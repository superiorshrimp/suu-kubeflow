resource "aws_instance" "kubeflow-controller" {
  instance_type = var.controller_instance_config.instance_type
  ami           = var.controller_instance_config.ami

  vpc_security_group_ids      = [aws_security_group.allow_access.id]
  subnet_id                   = aws_subnet.public_subnet_a.id
  iam_instance_profile        = var.controller_instance_config.iam_instance_profile
  key_name                    = var.controller_instance_config.key_name
  associate_public_ip_address = "true"

  user_data = "../scripts/init_mini_kubeflow.sh"
  metadata_options {
    http_endpoint = "enabled"
  }

  tags = {
    Name = "suu-kubeflow-project"
  }
}