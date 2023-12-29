resource "kubernetes_stateful_set_v1" "controller" {
  metadata {
    name      = "csi-vultr-controller"
    namespace = local.k8s_namespace
  }

  spec {
    selector {
      match_labels = {
        app = "csi-vultr-controller"
      }
    }

    service_name = "csi-vultr"

    template {
      metadata {
        labels = {
          app  = "csi-vultr-controller"
          role = "csi-vultr"
        }
      }

      spec {
        service_account_name = kubernetes_service_account_v1.controller.metadata[0].name

        container {
          name  = "csi-provisioner"
          image = "k8s.gcr.io/sig-storage/csi-provisioner:v3.4.0"

          args = [
            "--volume-name-prefix=pvc",
            "--volume-name-uuid-length=16",
            "--csi-address=$(ADDRESS)",
            "--v=5",
            "--default-fstype=ext4"
          ]

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          volume_mount {
            name       = "socket-dir"
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
          }
        }

        container {
          name  = "csi-attacher"
          image = "k8s.gcr.io/sig-storage/csi-attacher:v4.1.0"

          args = [
            "--v=5",
            "--csi-address=$(ADDRESS)"
          ]

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          volume_mount {
            name       = "socket-dir"
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
          }
        }

        container {
          name  = "csi-resizer"
          image = "registry.k8s.io/sig-storage/csi-resizer:v1.7.0"

          args = [
            "--csi-address=$(ADDRESS)",
            "--timeout=30s",
            "--v=5",
            "--handle-volume-inuse-error=false"
          ]

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          volume_mount {
            name       = "socket-dir"
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
          }
        }

        container {
          name  = "csi-vultr-plugin"
          image = "vultr/vultr-csi:v0.10.1"

          args = [
            "--endpoint=$(CSI_ENDPOINT)",
            "--token=$(VULTR_API_KEY)"
          ]

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          env {
            name = "VULTR_API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.this.metadata[0].name
                key  = "api-key"
              }
            }
          }

          volume_mount {
            name       = "socket-dir"
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
          }
        }

        volume {
          name = "socket-dir"
          empty_dir {}
        }
      }
    }
  }
}
