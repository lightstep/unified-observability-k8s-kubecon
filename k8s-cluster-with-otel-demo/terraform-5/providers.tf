terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.40.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7.1"
    }
  }

  required_version = ">= 0.14"
}

# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
#   token = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
#   )
# }

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {
  depends_on = [
    module.k8s_cluster_create
  ]
}

data "google_container_cluster" "primary" {
  depends_on = [
    module.k8s_cluster_create
  ]
  name     = var.cluster_name
  location = var.region
}


provider "helm" {
  kubernetes {
    host  = data.google_container_cluster.primary.endpoint
    # host = module.k8s_cluster_create.kubernetes_cluster_host
    # host  = var.kubernetes_cluster_host
    client_certificate  = data.google_container_cluster.primary.master_auth.0.client_certificate
    # client_certificate = module.k8s_cluster_create.kubernetes_cluster_cert
    # client_certificate  = var.kubernetes_cluster_cert
    token    = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    # cluster_ca_certificate = module.k8s_cluster_create.kubernetes_cluster_ca_cert
    # cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_cert)
  }
}


