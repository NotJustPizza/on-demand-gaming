locals {
  passwords = {
    app_admin_pass = {
      length = 32
    }
    app_key = {
      length = 32
    }
    k3s_token = {
      length  = 32
      special = false
    }
  }
}

resource "random_password" "this" {
  for_each = local.passwords

  length  = each.value.length
  special = try(each.value.special, null)
}
