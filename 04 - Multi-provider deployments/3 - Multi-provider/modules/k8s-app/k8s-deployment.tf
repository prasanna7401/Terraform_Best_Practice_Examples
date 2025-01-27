# Pod labels - used by K8s service to identify the pods
locals {
  pod_labels = {
    app = var.name
  }
}

resource "kubernetes_deployment" "my-app" {
  metadata {
    name = var.name #
  }

  spec {
    replicas = var.replicas

    # Pod Template - POD specific configurations
    template {
      metadata {
        labels = local.pod_labels
      }

      spec { # can define one or more container blocks
        container {
          name  = var.name
          image = var.image

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }
    }

    selector {
      match_labels = local.pod_labels # Selects the pods to manage
    }
  }



}

