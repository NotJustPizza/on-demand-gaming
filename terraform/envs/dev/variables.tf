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
variable "public_ssh_keys" {
  type    = map(string)
  default = {}
}
