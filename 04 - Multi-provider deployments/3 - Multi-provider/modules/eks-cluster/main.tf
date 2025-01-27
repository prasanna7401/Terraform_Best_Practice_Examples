############ CONTROL PLANE SETUP ############

# EKS Cluster - Control Plane Setup
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = "1.32"

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }

  # Ensure IAM Role permissions are fully set up before creating EKS cluster
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

############ WORKER NODES SETUP ############

# Setup options - Managed Node group using EC2 (shown here), Self-managed ASG, Fargate

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.name}-node-group"
  node_role_arn   = aws_iam_role.ec2_node_group_role.arn

  subnet_ids     = data.aws_subnets.default.ids
  instance_types = var.instance_types
  version = "1.32"

  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_size
    max_size     = var.max_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.ec2_node_group_CNI_policy,
    aws_iam_role_policy_attachment.ec2_node_group_ContainerRegistryRead_policy,
    aws_iam_role_policy_attachment.ec2_node_group_WorkerNode_policy, 
    ]
}