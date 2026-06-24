output "deployment_name" {
  value = kubernetes_deployment_v1.mi_app.metadata[0].name
}

output "service_name" {
  value = kubernetes_service_v1.mi_app.metadata[0].name
}

output "load_balancer_hostname" {
  value = try(
    kubernetes_service_v1.mi_app.status[0].load_balancer[0].ingress[0].hostname,
    "Load balancer provisioning"
  )
}
