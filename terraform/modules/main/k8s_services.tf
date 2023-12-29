resource "kubernetes_service_v1" "api" {
  metadata {
    name      = "api"
    labels    = local.k8s_default_labels
    namespace = local.k8s_namespace
    annotations = {
      "external-dns.alpha.kubernetes.io/endpoints-type"     = "HostIP"
      "external-dns.alpha.kubernetes.io/hostname"           = "api.${data.cloudflare_zone.this.name}"
      "external-dns.alpha.kubernetes.io/cloudflare-proxied" = "true"
    }
  }
  spec {
    selector = local.k8s_api_labels

    # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#headless-services
    cluster_ip = "None"

    port {
      port        = 80
      target_port = 8000
    }

    type = "ClusterIP"
  }
}
