terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    lightstep = {
      source = "lightstep/lightstep"
      version = "~> 1.70.4"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "ls_access_token" {}
variable "ls_org" {}
variable "ls_api_key" {}
variable "ls_project" {}

provider "digitalocean" {
  token = var.do_token
}

provider "lightstep" {
  api_key      = var.ls_api_key
  organization = var.ls_org
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}