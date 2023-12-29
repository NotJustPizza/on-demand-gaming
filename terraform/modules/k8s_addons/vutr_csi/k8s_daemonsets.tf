resource "kubernetes_daemon_set_v1" "node" {
  metadata {
    name      = "csi-vultr-node"
    namespace = local.k8s_namespace
  }

  spec {
    selector {
      match_labels = {
        app = "csi-vultr-node"
      }
    }

    template {
      metadata {
        labels = {
          app  = "csi-vultr-node"
          role = "csi-vultr"
        }
      }

      spec {
        service_account_name = kubernetes_service_account_v1.node.metadata[0].name
        host_network         = true

        container {
          name  = "driver-registrar"
          image = "registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.7.0"

          args = [
            "--v=5",
            "--csi-address=$(ADDRESS)",
            "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)"
          ]

          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }

          env {
            name  = "DRIVER_REG_SOCK_PATH"
            value = "/var/lib/kubelet/plugins/block.csi.vultr.com/csi.sock"
          }

          env {
            name = "KUBE_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi/"
          }

          volume_mount {
            name       = "registration-dir"
            mount_path = "/registration/"
          }
        }

        container {
          name  = "csi-vultr-plugin"
          image = "vultr/vultr-csi:v0.10.1"

          args = [
            "--endpoint=$(CSI_ENDPOINT)"
          ]

          security_context {
            privileged = true
            capabilities {
              add = ["SYS_ADMIN"]
            }
          }

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///csi/csi.sock"
          }

          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }

          volume_mount {
            name              = "pods-mount-dir"
            mount_path        = " /var/lib/kubelet"
            mount_propagation = "Bidirectional"
          }

          volume_mount {
            name       = "device-dir"
            mount_path = "/dev"
          }
        }

        volume {
          name = "registration-dir"
          host_path {
            path = "/var/lib/kubelet/plugins_registry/"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "kubelet-dir"
          host_path {
            path = "/var/lib/kubelet"
            type = "Directory"
          }
        }

        volume {
          name = "plugin-dir"
          host_path {
            path = "/var/lib/kubelet/plugins/block.csi.vultr.com"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "pods-mount-dir"
          host_path {
            path = "/var/lib/kubelet"
            type = "Directory"
          }
        }

        volume {
          name = "device-dir"
          host_path {
            path = "/dev"
          }
        }

        volume {
          name = "udev-rules-etc"
          host_path {
            path = "/etc/udev"
            type = "Directory"
          }
        }

        volume {
          name = "udev-rules-lib"
          host_path {
            path = "/lib/udev"
            type = "Directory"
          }
        }

        volume {
          name = "udev-socket"
          host_path {
            path = "/run/udev"
            type = "Directory"
          }
        }

        volume {
          name = "sys"
          host_path {
            path = "/sys"
            type = "Directory"
          }
        }
      }
    }
  }
}
