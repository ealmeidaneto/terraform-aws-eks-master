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
