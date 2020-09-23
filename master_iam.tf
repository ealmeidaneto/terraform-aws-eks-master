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
