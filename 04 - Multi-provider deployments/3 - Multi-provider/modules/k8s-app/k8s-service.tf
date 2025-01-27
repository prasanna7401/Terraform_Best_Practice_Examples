resource "kubernetes_service" "my-app" {
  metadata {
    name = "${var.name}-service"
  }

  spec {
    selector = local.pod_labels # K8s service will forward traffic to pods with these labels
    type = "LoadBalancer"
    port {
      port        = var.local_port
      target_port = var.container_port
      protocol = "TCP"
    }
  }
}