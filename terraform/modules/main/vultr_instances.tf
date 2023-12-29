locals {
  vultr_k3s_instance_label = "${local.resource_prefix}-k3s-server"
}

resource "vultr_instance" "k3s_server" {
  label    = local.vultr_k3s_instance_label
  hostname = local.vultr_k3s_instance_label

  os_id  = data.vultr_os.flatcar.id
  plan   = data.vultr_plan.hf1.id
  region = data.vultr_region.warsaw.id
  ssh_key_ids = concat(
    [vultr_ssh_key.internal_ssh_key.id],
    [for k in vultr_ssh_key.external_ssh_key : k.id]
  )

  user_data = local.k8s_server_ignite

  provisioner "remote-exec" {
    connection {
      host        = self.main_ip
      user        = "core"
      private_key = tls_private_key.internal_ssh_key.private_key_openssh
    }

    when   = create
    inline = ["sleep 5"]
  }
}
