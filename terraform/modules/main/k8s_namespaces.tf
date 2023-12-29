resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = var.environment
    labels = local.k8s_default_labels
  }
}
