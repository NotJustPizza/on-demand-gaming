variable "aws_access_key" { sensitive = true }
variable "aws_secret_key" { sensitive = true }

variable "cloudflare_email" {}
variable "cloudflare_token" { sensitive = true }

variable "vultr_token" { sensitive = true }
variable "vultr_registry_user" {}
variable "vultr_registry_key" { sensitive = true }

variable "k3s_server_token" { sensitive = true }

variable "api_app_key" { sensitive = true }
variable "api_admin_pass" { sensitive = true }

variable "public_ssh_keys" {
  type    = map(string)
  default = {}
}
