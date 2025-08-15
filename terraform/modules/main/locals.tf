locals {
  resource_prefix = "${var.environment}-${var.project}"

  k3s_server_subdomain = "k3s"
  k3s_server_hostname  = "${local.k3s_server_subdomain}.${var.cloudflare_domain}"

  k8s_server_url = "https://${local.k3s_server_hostname}:6443"
  k8s_docker_config = jsonencode({
    auths = {
      "sjc.vultrcr.com" = {
        auth = base64encode("${var.vultr_registry_user}:${var.vultr_registry_key}")
      }
    }
  })
  k8s_server_ignite = templatefile(
    "../../../butane/server.ign.tftpl",
    {
      k3s_token   = var.k3s_server_token
      k3s_version = var.k3s_server_version
    }
  )
  k8s_agent_ignite = templatefile(
    "../../../butane/agent.ign.tftpl",
    {
      k3s_token      = var.k3s_server_token
      k3s_version    = var.k3s_server_version
      k3s_server_url = local.k8s_server_url
    }
  )
}
