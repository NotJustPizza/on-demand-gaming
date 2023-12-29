resource "kubernetes_csi_driver_v1" "this" {
  metadata {
    name = "block.csi.vultr.com"
  }

  spec {
    attach_required        = true
    pod_info_on_mount      = true
    volume_lifecycle_modes = ["Persistent"]
  }
}
