/*module "avorion" {
  source = "../games/avorion"

  image_version   = "test"
  resource_name   = "avorion"
  resource_prefix = local.resource_prefix

  vultr_region_id = data.vultr_region.warsaw.id

  k8s_default_labels = local.k8s_default_labels
  k8s_namespace      = local.k8s_namespace
  k8s_registry_url   = local.k8s_registry_url
  k8s_secrets = {
    docker_config = kubernetes_secret_v1.this["docker_config"].metadata[0].name
  }
}*/
