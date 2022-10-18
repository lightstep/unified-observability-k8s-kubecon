output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_cert" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
  description = "GKE Cluster Certificate"
}

output "kubernetes_cluster_ca_cert" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  description = "GKE Cluster CA Certificate"
}