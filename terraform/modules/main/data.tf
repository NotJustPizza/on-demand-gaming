#data "cloudflare_ip_ranges" "this" {}

data "cloudflare_zone" "this" {
  name = var.cloudflare_domain
}

data "remote_file" "k3s_file" {
  for_each = {
    client_key = "client-admin.key"
    client_crt = "client-admin.crt"
    cluster_ca = "server-ca.crt"
  }

  conn {
    host        = vultr_instance.k3s_server.main_ip
    user        = "core"
    private_key = tls_private_key.internal_ssh_key.private_key_openssh
    sudo        = true
  }

  path = "/var/lib/rancher/k3s/server/tls/${each.value}"
}

data "vultr_os" "flatcar" {
  filter {
    name   = "name"
    values = ["Flatcar Container Linux Stable x64"]
  }
}

data "vultr_plan" "hf1" {
  filter {
    name   = "type"
    values = ["vhf"]
  }
  filter {
    name   = "monthly_cost"
    values = [6]
  }
  filter {
    name   = "ram"
    values = [1024]
  }
  filter {
    name   = "disk"
    values = [32]
  }
}

data "vultr_plan" "hf2" {
  filter {
    name   = "type"
    values = ["vhf"]
  }
  filter {
    name   = "monthly_cost"
    values = [12]
  }
  filter {
    name   = "ram"
    values = [2048]
  }
  filter {
    name   = "disk"
    values = [64]
  }
}

data "vultr_region" "warsaw" {
  filter {
    name   = "city"
    values = ["Warsaw"]
  }
}
