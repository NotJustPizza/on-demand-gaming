resource "tls_private_key" "internal_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "vultr_ssh_key" "internal_ssh_key" {
  name    = "${local.resource_prefix}-internal"
  ssh_key = trimspace(tls_private_key.internal_ssh_key.public_key_openssh)
}

resource "vultr_ssh_key" "external_ssh_key" {
  for_each = var.public_ssh_keys

  name    = "${local.resource_prefix}-external-${each.key}"
  ssh_key = trimspace(each.value)
}
