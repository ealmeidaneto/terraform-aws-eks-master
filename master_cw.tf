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