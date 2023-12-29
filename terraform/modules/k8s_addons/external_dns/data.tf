data "cloudflare_zone" "this" {
  name = var.cloudflare.domain
}
