module "main" {
  source = "../../modules/main"

  environment = "prod"

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key

  cloudflare_email  = var.cloudflare_email
  cloudflare_token  = var.cloudflare_token
  cloudflare_domain = "avorion.org"

  vultr_token         = var.vultr_token
  vultr_registry_user = var.vultr_registry_user
  vultr_registry_key  = var.vultr_registry_key

  k3s_server_token = var.k3s_server_token

  api_app_key    = var.api_app_key
  api_admin_pass = var.api_admin_pass

  public_ssh_keys = var.public_ssh_keys
}

