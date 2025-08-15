data "kustomization_overlay" "this" {
  resources = var.resources

  dynamic "secret_generator" {
    for_each = var.secrets

    content {
      name     = secret_generator.key
      type     = secret_generator.value.type
      literals = sensitive(secret_generator.value.literals)
      behavior = "replace"
    }
  }

  dynamic "config_map_generator" {
    for_each = var.configmaps

    content {
      name     = config_map_generator.key
      literals = config_map_generator.value.literals
      behavior = "replace"
    }
  }

  dynamic "patches" {
    for_each = toset(var.patches)

    content {
      target {
        kind = patches.value.target.kind
        name = patches.value.target.name
      }
      patch = patches.value.patch
    }
  }
}