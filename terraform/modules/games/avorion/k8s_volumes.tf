resource "kubernetes_persistent_volume_v1" "this" {
  metadata {
    name   = "${var.resource_name}-galaxies"
    labels = var.k8s_default_labels
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "vultr-block-storage-hdd"
    persistent_volume_source {
      csi {
        driver        = "block.csi.vultr.com"
        volume_handle = vultr_block_storage.this.label
      }
    }

    capacity = {
      storage = "40Gi"
    }
  }
}
