############ CONTROL PLANE SETUP STARTS ############

# Create IAM role for the control plane
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
  # Here, we have set up only the trust relationship policy, but not the permissions policy yet. - Next step
}


# Attach the required policies to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" # Managed policy for EKS cluster
}

############ CONTROL PLANE SETUP ENDS ############

############ WORKER NODES SETUP STARTS ############

resource "aws_iam_role" "ec2_node_group_role" {
  name               = "${var.name}-ec2-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role.json
}

# Attach permissions to the Node group role

resource "aws_iam_role_policy_attachment" "ec2_node_group_WorkerNode_policy" {
  role       = aws_iam_role.ec2_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" # Managed policy for EKS worker nodes
}

resource "aws_iam_role_policy_attachment" "ec2_node_group_CNI_policy" {
  role       = aws_iam_role.ec2_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Managed policy for EKS CNI
}

resource "aws_iam_role_policy_attachment" "ec2_node_group_ContainerRegistryRead_policy" {
  role       = aws_iam_role.ec2_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # Managed policy for ECR read access
}

############ WORKER NODES SETUP ENDS ############