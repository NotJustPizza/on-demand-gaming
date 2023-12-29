resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = "external-dns"
    labels = local.k8s_labels
  }
}
