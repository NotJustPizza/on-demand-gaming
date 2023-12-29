locals {
  k8s_namespace = kubernetes_namespace_v1.this.metadata[0].name
  k8s_labels = {
    application = "external-dns"
  }
}
