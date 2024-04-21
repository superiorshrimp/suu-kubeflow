data "aws_caller_identity" "current" {}

locals {
  node_group_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  eks_cluster_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable  "eks_config" {
  type = object({
    node_group_name  = string
    eks_cluster_name = string
  })

  default = {
    node_group_name  = "suu-kubeflow-training"
    eks_cluster_name = "suu-kubeflow-project"
  }
}

variable "controller_instance_config" {
  type = object({
    instance_type         = string
    ami                   = string
    iam_instance_profile  = string
    key_name              = string
  })

  default = {
    instance_type         = "t2.medium"
    ami                   = "ami-080e1f13689e07408"
    iam_instance_profile  = "LabInstanceProfile"
    key_name              = "vockey"
  }
}

