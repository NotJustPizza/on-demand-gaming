output "k8s_deployment_name" {
  value = kubernetes_deployment_v1.this.metadata[0].name
}

output "k8s_node_name" {
  value = local.k8s_node_name
}
