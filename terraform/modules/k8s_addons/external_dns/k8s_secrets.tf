locals {
  k8s_secrets = {
    cloudflare_email = {
      name = "cloudflare-email"
      data = {
        secret = var.cloudflare.email
      }
    }
    cloudflare_token = {
      name = "cloudflare-token"
      data = {
        secret = var.cloudflare.token
      }
    }
  }
}

resource "kubernetes_secret_v1" "this" {
  for_each = local.k8s_secrets

  metadata {
    name      = each.value.name
    namespace = local.k8s_namespace
  }

  data = each.value.data
}
