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

    lightstep = {
      source = "lightstep/lightstep"
      version = ">=1.70.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

  }

  required_version = ">= v1.0.11"
}

provider "google" {
  project = var.project_id
  region  = var.region
}


data "google_client_config" "default" {
  depends_on = [module.k8s_cluster_create]
}

data "google_container_cluster" "primary" {
  depends_on = [module.k8s_cluster_create]
  name     = var.cluster_name
  location = var.region
}


provider "kubernetes" {
  host  = "https://${data.google_container_cluster.primary.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.google_container_cluster.primary.endpoint
    client_certificate  = data.google_container_cluster.primary.master_auth.0.client_certificate
    token    = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

provider "lightstep" {
  api_key         = var.ls_api_key
  organization    = var.ls_org
}
