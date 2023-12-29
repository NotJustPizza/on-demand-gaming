locals {
  k8s_labels = merge(
    { application = var.resource_name },
    var.k8s_default_labels
  )
}

# Template deployment without replicas
resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.resource_name
    labels    = local.k8s_labels
    namespace = var.k8s_namespace
  }

  spec {
    strategy {
      type = "Recreate"
    }

    replicas = 0

    selector {
      match_labels = local.k8s_labels
    }

    template {
      metadata {
        labels = local.k8s_labels
      }

      spec {
        image_pull_secrets {
          name = var.k8s_secrets["docker_config"]
        }

        container {
          name  = var.resource_name
          image = "${var.k8s_registry_url}/avorion:latest"

          security_context {
            read_only_root_filesystem = true
          }

          port {
            container_port = 27000
            host_port      = 27000
          }

          port {
            container_port = 27003
            host_port      = 27003
          }

          port {
            container_port = 27020
            host_port      = 27020
          }

          port {
            container_port = 27021
            host_port      = 27021
          }

          volume_mount {
            name       = kubernetes_persistent_volume_v1.this.metadata[0].name
            mount_path = "/galaxies"
          }
        }

        volume {
          name = kubernetes_persistent_volume_v1.this.metadata[0].name
          empty_dir {}
        }
      }
    }
  }
}
