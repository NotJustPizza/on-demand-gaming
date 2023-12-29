/*module "k8s_vultr_csi" {
  source = "../k8s_addons/vutr_csi"

  vultr_api_key = var.credentials.vultr.token
  stack_version = var.versions.vultr_csi
}

module "k8s_external_dns" {
  source = "../k8s_addons/external_dns"

  cloudflare    = var.credentials.cloudflare
  image_version = var.versions.external_dns
}*/
