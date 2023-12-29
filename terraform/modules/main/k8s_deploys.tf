locals {
  k8s_autoscaler_labels = merge(
    { application = "autoscaler" },
    local.k8s_default_labels
  )
  k8s_api_labels = merge(
    { application = "api" },
    local.k8s_default_labels
  )
}

resource "kubernetes_deployment_v1" "autoscaler" {
  metadata {
    name      = "autoscaler"
    labels    = local.k8s_autoscaler_labels
    namespace = local.k8s_namespace
  }

  spec {
    strategy {
      type = "Recreate"
    }

    replicas = 0

    selector {
      match_labels = local.k8s_autoscaler_labels
    }

    template {
      metadata {
        labels = local.k8s_autoscaler_labels
      }

      spec {
        image_pull_secrets {
          name = kubernetes_secret_v1.this["docker_config"].metadata[0].name
        }

        container {
          name = "autoscaler"
          #image = "${local.k8s_registry_url}/autoscaler:latest"
          image = "${local.k8s_registry_url}/api:latest"

          security_context {
            read_only_root_filesystem = true
          }

          dynamic "env" {
            for_each = {}

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = {
              VULTR_TOKEN = kubernetes_secret_v1.this["vultr_token"].metadata[0].name
            }

            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value
                  key  = "secret"
                }
              }
            }
          }

          volume_mount {
            mount_path = "/etc/ignite/"
            name       = kubernetes_config_map_v1.ignite.metadata[0].name
          }
        }

        volume {
          name = kubernetes_config_map_v1.ignite.metadata[0].name
          config_map {
            name = kubernetes_config_map_v1.ignite.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "api" {
  metadata {
    name      = "api"
    labels    = local.k8s_api_labels
    namespace = local.k8s_namespace
  }

  spec {
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = local.k8s_api_labels
    }

    template {
      metadata {
        labels = local.k8s_api_labels
      }

      spec {
        image_pull_secrets {
          name = kubernetes_secret_v1.this["docker_config"].metadata[0].name
        }

        container {
          name  = "api"
          image = "${local.k8s_registry_url}/api:latest"

          security_context {
            read_only_root_filesystem = true
          }

          port {
            container_port = 8000
            host_port      = 80
          }

          dynamic "env" {
            for_each = {}

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = {
              APP_KEY         = kubernetes_secret_v1.this["app_key"].metadata[0].name
              ADMIN_PASS_HASH = kubernetes_secret_v1.this["app_admin_pass"].metadata[0].name
            }

            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value
                  key  = "secret"
                }
              }
            }
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = 8000
            }
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = 8000
            }
          }
        }
      }
    }
  }
}
