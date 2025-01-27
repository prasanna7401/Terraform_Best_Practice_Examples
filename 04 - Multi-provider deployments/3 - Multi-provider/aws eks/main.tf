# EKS Setup
module "my_eks" {
  source = "../modules/eks-cluster"
  name = "my-eks-cluster"
  min_size = 1
  max_size = 2
  desired_capacity = 1
  instance_types = ["t3.small"] # Minimum supported for EKS
}

# Container Setup 
module "my_app" {
  source = "../modules/k8s-app"
  name = "my-app"
  image = "training/webapp"
  container_port = 80
  local_port = 80
  replicas = 2

  env_vars = {
    "PROVIDER" = "Prasanna"
  }

  # Deploy the app after the EKS cluster is created
  depends_on = [ module.my_eks ]
}