resource "kubernetes_service_account_v1" "autoscaler" {
  metadata {
    name      = "autoscaler"
    namespace = local.k8s_namespace
    labels    = local.k8s_default_labels
  }
}

resource "kubernetes_cluster_role_v1" "autoscaler" {
  metadata {
    name   = "autoscaler"
    labels = local.k8s_default_labels
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "autoscaler" {
  metadata {
    name   = "autoscaler"
    labels = local.k8s_default_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.autoscaler.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.autoscaler.metadata[0].name
    namespace = local.k8s_namespace
  }
}
