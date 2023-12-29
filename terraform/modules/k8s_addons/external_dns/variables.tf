variable "image_version" {
  type = string
}

variable "cloudflare" {
  sensitive = true
  type = object({
    email  = string
    token  = string
    domain = string
  })
}
