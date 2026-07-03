output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  value = aws_security_group.eks_nodes.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}
