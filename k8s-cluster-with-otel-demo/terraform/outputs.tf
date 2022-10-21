output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = module.k8s_cluster_create.kubernetes_cluster_name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = module.k8s_cluster_create.kubernetes_cluster_host
  description = "GKE Cluster Host"
}

# output "cluster_dashboard_url" {
#   value       = module.lightstep_dashboards.cluster_dashboard_url
#   description = "OpenTelemetry Collector Kubernetes Cluster Dashboard URL"
# }


# output "workload_dashboard_url" {
#   value       = module.lightstep_dashboards.workload_dashboard_url
#   description = "OpenTelemetry Collector Kubernetes Workload Dashboard URL"
# }
