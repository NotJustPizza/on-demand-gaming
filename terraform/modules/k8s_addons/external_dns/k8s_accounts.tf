resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = "external-dns"
    namespace = local.k8s_namespace
    labels    = local.k8s_labels
  }
}

resource "kubernetes_cluster_role_v1" "this" {
  metadata {
    name   = "external-dns"
    labels = local.k8s_labels
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "this" {
  metadata {
    name   = "external-dns"
    labels = local.k8s_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.this.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = local.k8s_namespace
  }
}
