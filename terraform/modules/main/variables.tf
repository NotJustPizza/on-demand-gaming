variable "environment" {
  type = string
}
variable "credentials" {
  sensitive = true
  type = object({
    aws = object({
      access_key = string
      secret_key = string
    })
    cloudflare = object({
      email  = string
      token  = string
      domain = string
    })
    vultr = object({
      token = string
      registry = object({
        name     = string
        username = string
        api_key  = string
      })
    })
  })
}
variable "versions" {
  type = object({
    external_dns = string
    k3s          = string
    key_db       = string
    vultr_csi    = string
  })
  default = {
    external_dns = "v0.14.0"
    k3s          = "v1.29.0+k3s1"
    key_db       = "v6.3.4"
    vultr_csi    = "v0.11.0"
  }
}
variable "project" {
  type    = string
  default = "odg"
}
variable "public_ssh_keys" {
  type    = map(string)
  default = {}
}
