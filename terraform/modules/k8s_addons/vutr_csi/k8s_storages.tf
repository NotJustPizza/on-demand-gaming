locals {
  k8s_storages = {
    hdd = {
      block_type = "storage_opt"
      name       = "vultr-block-storage-hdd"
    }
    hdd_retain = {
      block_type     = "storage_opt"
      name           = "vultr-block-storage-hdd-retain"
      reclaim_policy = "Retain"
    }
    ssd = {
      block_type = "high_perf"
      name       = "vultr-block-storage"
    }
    ssd_retain = {
      block_type     = "high_perf"
      name           = "vultr-block-storage-retain"
      reclaim_policy = "Retain"
    }
  }
}


resource "kubernetes_storage_class_v1" "this" {
  for_each = local.k8s_storages

  metadata {
    name = each.value.name
  }

  storage_provisioner    = kubernetes_csi_driver_v1.this.metadata[0].name
  allow_volume_expansion = true
  reclaim_policy         = try(each.value.reclaim_policy, null)

  parameters = {
    block_type = each.value.block_type
  }
}
