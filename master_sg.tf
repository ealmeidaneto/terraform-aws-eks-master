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
