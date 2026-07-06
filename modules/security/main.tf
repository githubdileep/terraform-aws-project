resource "aws_security_group" "alb" {
  name_prefix = "${var.environment}-alb-sg-"
  vpc_id      = var.vpc_id
  description = "Allow HTTP/HTTPS inbound to ALB"

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
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

  tags = {
    Name = "${var.environment}-alb-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "eks_cluster" {
  name_prefix = "${var.environment}-eks-cluster-sg-"
  vpc_id      = var.vpc_id
  description = "EKS control plane security group"

  tags = {
    Name = "${var.environment}-eks-cluster-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "eks_cluster_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group" "eks_nodes" {
  name_prefix = "${var.environment}-eks-nodes-sg-"
  vpc_id      = var.vpc_id
  description = "EKS worker node security group"

  tags = {
    Name                                          = "${var.environment}-eks-nodes-sg"
    "kubernetes.io/cluster/${var.environment}-eks" = "owned"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "eks_nodes_ingress_alb_nodeport" {
  type                     = "ingress"
  description              = "NodePort range from ALB"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "eks_nodes_ingress_self" {
  type              = "ingress"
  description       = "Node to node communication"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "eks_nodes_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "cluster_to_nodes" {
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "nodes_from_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group_rule" "nodes_from_cluster_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group" "ec2" {
  name_prefix = "${var.environment}-ec2-sg-"
  vpc_id      = var.vpc_id
  description = "Security group for standalone EC2 instances"

  ingress {
    description = "SSH from within VPC only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}
