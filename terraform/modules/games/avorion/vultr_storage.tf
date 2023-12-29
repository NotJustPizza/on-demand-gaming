resource "vultr_block_storage" "this" {
  label      = "${var.resource_prefix}-${var.resource_name}-galaxies"
  region     = var.vultr_region_id
  block_type = "storage_opt"

  size_gb = 40
}
