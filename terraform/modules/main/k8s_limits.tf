resource "kubernetes_limit_range" "this" {
  metadata {
    name      = "default-limits"
    namespace = local.k8s_namespace
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "100m"
        memory = "100Mi"
      }
      default_request = {
        cpu    = "20m"
        memory = "20Mi"
      }
    }
  }
}
