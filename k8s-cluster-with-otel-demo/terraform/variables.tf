variable "cluster_name" {
  description = "cluster name"
}

variable "otel_demo_namespace" {
  default = "otel-demo"
  description = "OTel Demo app namespace"
}

variable "ls_access_token" {
  description = "Lightstep access token"
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "network" {
  description = "network name"
}

variable "subnet" {
  description = "subnet name"
}


variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

