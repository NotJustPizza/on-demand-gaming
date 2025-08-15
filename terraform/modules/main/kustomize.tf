module "kustomize" {
  source    = "../kustomize"
  resources = ["../../../kustomize/overlays/${var.environment}"]

  configmaps = {
    "tf-node" = {
      literals = [
        "os_id=${data.vultr_os.flatcar.id}",
        "plan_id=${data.vultr_plan.hf2.id}",
        "region=${data.vultr_region.warsaw.id}"
      ]
    }
  }

  secrets = {
    "tf-cloudflare" = {
      literals = [
        "email=${var.cloudflare_email}",
        "token=${var.cloudflare_token}",
        "zone_id=${data.cloudflare_zone.this.id}"
      ]
    }
    "tf-vultr-csi" = {
      literals = [
        "api-key=${var.vultr_token}"
      ]
    }
    "tf-vultr" = {
      literals = [
        "api-key=${var.vultr_token}"
      ]
    }
    "tf-api" = {
      literals = [
        "app-admin-pass=${var.api_admin_pass}",
        "app-key=${var.api_app_key}"
      ]
    }
    "tf-ignite" = {
      literals = [
        "agent=${local.k8s_agent_ignite}",
        "server=${local.k8s_server_ignite}"
      ]
    }
    "docker-config" = {
      type = "kubernetes.io/dockerconfigjson"
      literals = [
        ".dockerconfigjson=${local.k8s_docker_config}"
      ]
    }
  }

  patches = [
    {
      target  = {
        kind       = "Service"
        name       = "api"
      }
      patch = <<-EOF
        - op: replace
          path: /metadata/annotations/external-dns.alpha.kubernetes.io~1hostname
          value: api.${var.cloudflare_domain}
      EOF
    }
  ]
}
