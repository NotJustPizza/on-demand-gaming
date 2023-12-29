resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = "external-dns"
    labels    = local.k8s_labels
    namespace = local.k8s_namespace
  }

  spec {
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = local.k8s_labels
    }

    template {
      metadata {
        labels = local.k8s_labels
      }

      spec {
        service_account_name = kubernetes_service_account_v1.this.metadata[0].name

        container {
          name  = "external-dns"
          image = "registry.k8s.io/external-dns/external-dns:${var.image_version}"

          args = [
            "--source=service",
            "--zone-id-filter=${data.cloudflare_zone.this.id}",
            "--provider=cloudflare"
          ]

          dynamic "env" {
            for_each = {
              CF_API_EMAIL = kubernetes_secret_v1.this["cloudflare_email"].metadata[0].name
              CF_API_KEY   = kubernetes_secret_v1.this["cloudflare_token"].metadata[0].name
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
        }
      }
    }
  }
}
