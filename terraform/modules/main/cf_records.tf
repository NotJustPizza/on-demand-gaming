resource "cloudflare_record" "k3s" {
  zone_id = data.cloudflare_zone.this.id
  name    = local.k3s_server_subdomain
  value   = vultr_instance.k3s_server.main_ip
  type    = "A"
  ttl     = 300
}
