output "eks-master-security-group" {
  value = aws_eks_cluster.eks[*].vpc_config[0].cluster_security_group_id
  sensitive   = true
  description = "The cluster security group that was created by Amazon EKS for the cluster."
}


output "cluster_name" {
  value       = aws_eks_cluster.eks[*].id
  description = "The name of the cluster"
}

output "cluster_status" {
  value       = aws_eks_cluster.eks[*].status
  description = "Cluster Status"
}
