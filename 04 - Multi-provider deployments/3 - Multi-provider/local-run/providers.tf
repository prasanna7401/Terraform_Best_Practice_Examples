terraform {
    required_providers {
        kubernetes = {
        source  = "hashicorp/kubernetes"
        version = "2.22.0"
        }
    }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context = "docker-desktop"
}