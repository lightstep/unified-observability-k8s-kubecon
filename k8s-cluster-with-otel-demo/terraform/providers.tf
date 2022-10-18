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

data "google_client_config" "default" {}

# data "google_container_cluster" "primary" {
#   name     = var.cluster_name
#   location = var.region
# }
