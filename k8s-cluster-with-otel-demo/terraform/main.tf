# Confg 
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


# GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network = "projects/${var.project_id}/global/networks/${var.network}"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnet}"

  # network    = google_compute_network.vpc.name
  # subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", var.cluster_name]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  location = var.region
}


provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}


provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
# resource "google_compute_network" "vpc" {
#   name                    = "${var.project_id}--vpc"
#   auto_create_subnetworks = "false"
# }

# # Subnet
# resource "google_compute_subnetwork" "subnet" {
#   name          = "${var.project_id}-subnet"
#   region        = var.region
#   network       = google_compute_network.vpc.name
#   ip_cidr_range = "10.10.0.0/24"
# }

