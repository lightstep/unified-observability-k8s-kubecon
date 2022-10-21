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

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "ls_api_key" {
  description = "Lightstep API key"
  type        = string
}

variable "ls_org" {
  description = "Lightstep organization"
  type        = string
}

variable "ls_project" {
  description = "Name of Lightstep project"
  type        = string
}
