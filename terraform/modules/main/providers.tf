terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.20.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.1.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    vultr = {
      source  = "vultr/vultr"
      version = "2.18.0"
    }
  }

  required_version = "1.7.5"
}

provider "vultr" {
  api_key = var.vultr_token
}

provider "cloudflare" {
  api_key = var.cloudflare_token
  email   = var.cloudflare_email
}

provider "kustomization" {
  kubeconfig_raw = templatefile(
    "../../../kustomize/kubeconfig.yaml.tftpl",
    {
      server                     = local.k8s_server_url
      client_key_data            = base64encode(data.remote_file.k3s_file["client_key"].content)
      client_certificate_data    = base64encode(data.remote_file.k3s_file["client_crt"].content)
      certificate_authority_data = base64encode(data.remote_file.k3s_file["cluster_ca"].content)
    }
  )
}
