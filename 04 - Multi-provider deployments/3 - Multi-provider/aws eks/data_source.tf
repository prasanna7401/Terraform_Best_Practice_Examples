data "aws_eks_cluster_auth" "eks_cluster" {
  name = module.my_eks.cluster_name
}