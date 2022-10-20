
variable "ls_access_token" {
  description = "Lightstep access token"
}

variable "ls_org" {
    description = "Lightstep organization (case sensitive)"
}

variable "ls_api_key" {
    description = "Lightstep API key"
}

variable "ls_project" {
  description = "project name"
}

variable "do_token" {
  default = ""
  description = "digitalocean pat"
}

variable "do_region" {
    default = "nyc3"
    description = "digitalocean region"
}

variable "k8s_node_count" {
    default = 3
    description = "number of k8s nodes"
}

variable "k8s_cluster_name" {
  description = "cluster name"
}

variable "otel_demo_namespace" {
  default = "otel-demo"
  description = "OTel Demo app namespace"
}

variable "write_kubeconfig" {
  default = true
  description = "write kubeconfig to disk"
}