terraform {
  required_providers {
    lightstep = {
      source = "lightstep/lightstep"
      version = "~> 1.70.6"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">=2.10.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">=2.3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.5.0"
    }
  }
}

 provider "lightstep" {
   api_key         = var.ls_api_key
   organization    = var.ls_org
 }
 
 provider "digitalocean" {
  token = var.do_token
 }