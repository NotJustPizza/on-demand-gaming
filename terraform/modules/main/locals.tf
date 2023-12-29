locals {
  resource_prefix = "${var.environment}-${var.project}"

  k8s_namespace    = kubernetes_namespace_v1.this.metadata[0].name
  k8s_server_url   = "https://${vultr_instance.k3s_server.main_ip}:6443"
  k8s_registry_url = "sjc.vultrcr.com/${var.credentials.vultr.registry.name}"

  k8s_default_labels = {
    project     = var.project
    environment = var.environment
  }

  k8s_server_ignite = templatefile(
    "../../../butane/server.ign.tftpl",
    {
      k3s_token   = random_password.this["k3s_token"].result
      k3s_version = var.versions.k3s
    }
  )
  k8s_agent_ignite = templatefile(
    "../../../butane/agent.ign.tftpl",
    {
      k3s_token      = random_password.this["k3s_token"].result
      k3s_version    = var.versions.k3s
      k3s_server_url = local.k8s_server_url
    }
  )
}
