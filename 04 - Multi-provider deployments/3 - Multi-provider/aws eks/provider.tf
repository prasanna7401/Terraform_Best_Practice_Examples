terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "kubernetes" {
  host = module.my_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.my_eks.cluster_CA[0].data)
  token = data.aws_eks_cluster_auth.eks_cluster.token
}