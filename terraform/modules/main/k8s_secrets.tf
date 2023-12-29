locals {
  k8s_secrets = {
    app_admin_pass = {
      name = "app-admin-pass"
      data = {
        secret = random_password.this["app_admin_pass"].result
      }
    }
    app_key = {
      name = "app-key"
      data = {
        secret = random_password.this["app_key"].result
      }
    }
    docker_config = {
      name = "docker-config"
      data = {
        ".dockerconfigjson" = jsonencode({
          auths = {
            "sjc.vultrcr.com" = {
              auth = base64encode("${var.credentials.vultr.registry.username}:${var.credentials.vultr.registry.api_key}")
            }
          }
        })
      }
      type = "kubernetes.io/dockerconfigjson"
    }
    vultr_token = {
      name = "vultr-token"
      data = {
        secret = var.credentials.vultr.token
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
  type = try(each.value.type, null)
}
