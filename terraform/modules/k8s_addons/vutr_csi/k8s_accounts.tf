resource "kubernetes_service_account_v1" "controller" {
  metadata {
    name      = "csi-vultr-controller-sa"
    namespace = local.k8s_namespace
  }
}

resource "kubernetes_cluster_role_v1" "attacher" {
  metadata {
    name = "csi-vultr-attacher-role"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["csinodes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["volumeattachments"]
    verbs      = ["get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["volumeattachments/status"]
    verbs      = ["patch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "attacher" {
  metadata {
    name = "csi-controller-attacher-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.attacher.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.controller.metadata[0].name
    namespace = local.k8s_namespace
  }
}

resource "kubernetes_cluster_role_v1" "provisioner" {
  metadata {
    name = "csi-vultr-provisioner-role"
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["csinodes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["volumeattachments"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "provisioner" {
  metadata {
    name = "csi-controller-provisioner-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.provisioner.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.controller.metadata[0].name
    namespace = local.k8s_namespace
  }
}

resource "kubernetes_service_account_v1" "node" {
  metadata {
    name      = "csi-vultr-node-sa"
    namespace = local.k8s_namespace
  }
}

resource "kubernetes_cluster_role_v1" "registrar" {
  metadata {
    name = "csi-vultr-node-driver-registrar-role"
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "registrar" {
  metadata {
    name = "driver-registrar-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.registrar.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.node.metadata[0].name
    namespace = local.k8s_namespace
  }
}

resource "kubernetes_cluster_role_v1" "resizer" {
  metadata {
    name = "csi-vultr-resizer-role"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims/status"]
    verbs      = ["update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["list", "watch", "create", "update", "patch"]
  }

}

resource "kubernetes_cluster_role_binding_v1" "resizer" {
  metadata {
    name = "csi-vultr-resizer-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.resizer.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.node.metadata[0].name
    namespace = local.k8s_namespace
  }
}
