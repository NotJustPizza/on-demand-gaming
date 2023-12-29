module "main" {
  source = "../../modules/main"

  environment     = var.environment
  credentials     = var.credentials
  public_ssh_keys = var.public_ssh_keys
}
