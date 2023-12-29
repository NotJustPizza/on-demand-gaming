resource "kubernetes_config_map_v1" "ignite" {
  metadata {
    name      = "ignite"
    namespace = local.k8s_namespace
  }

  data = {
    AGENT = local.k8s_agent_ignite
  }
}

resource "kubernetes_config_map_v1" "games" {
  metadata {
    name      = "games"
    namespace = local.k8s_namespace
  }

  // Keep format in sync with Golang
  data = {
    avorion = jsonencode({
      node = {
        name    = module.avorion.k8s_node_name
        os_id   = data.vultr_os.flatcar.id
        plan_id = data.vultr_plan.hf2.id
        region  = data.vultr_region.warsaw.id
      }
      deployment = {
        name = module.avorion.k8s_deployment_name
      }
      status = {
        current  = false
        expected = false
      }
    })
  }
}
