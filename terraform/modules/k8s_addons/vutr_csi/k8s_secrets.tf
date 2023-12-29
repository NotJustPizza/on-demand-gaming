resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "vultr-csi"
    namespace = local.k8s_namespace
  }

  data = {
    "api-key" = var.vultr_api_key
  }
}
