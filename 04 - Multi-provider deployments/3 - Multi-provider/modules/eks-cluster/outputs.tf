output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_CA" {
  value = aws_eks_cluster.eks_cluster.certificate_authority # used for authenticating with the cluster in root module
}