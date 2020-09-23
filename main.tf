resource "aws_eks_cluster" "eks" {
  count                     = var.create_cluster ? 1 : 0
  name                      = "${var.cluster_name}-${var.environment}"
  role_arn                  = var.create_cluster_iam ?  aws_iam_role.eks_role[0].arn : var.role_arn
  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    security_group_ids      = var.create_master_sg ?  [aws_security_group.eks-master[0].id] : var.master_sg
    subnet_ids              = var.master_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  dynamic encryption_config {
    for_each = var.encryption_config

    content {
      provider {
        key_arn = lookup(var.encryption_config, "key_arn", null)
      }
      resources = lookup(var.encryption_config, "resources", null)
    }
  }
  
  version = var.eks_version

  tags = merge(var.tags)

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.eks_master_cw_log_group
  ]

}

resource "aws_cloudwatch_log_group" "eks_master_cw_log_group" {
  # count             = length(var.cluster_log_types) > 0 ? 1 : 0
  count             = var.create_cw_log_group ? 1 : 0 
  name              = "/aws/eks/${var.cluster_name}-${var.environment}-${random_pet.cw.id}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
  kms_key_id        = var.eks_log_kms_key
  tags              = var.tags
}

resource "random_pet" "cw" {

}

# EKS master IAM role

resource "aws_iam_role" "eks_role" {
  count = var.create_cluster_iam ? 1 : 0
  name  = "${var.cluster_name}-${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  count      = var.create_cluster_iam ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
  count      = var.create_cluster_iam ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role[0].name
}

# EKS Master SG
resource "aws_security_group" "eks-master" {
  count       = var.create_master_sg ? 1 : 0
  name        = "${var.cluster_name}-${var.environment}" 
  description = "${var.cluster_name}-${var.environment} Security Group"
  vpc_id      = var.vpc_id

  # TODO: Make rules creation dynamic

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
