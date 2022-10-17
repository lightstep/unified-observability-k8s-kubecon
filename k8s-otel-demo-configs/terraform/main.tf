terraform {
  required_providers {
    lightstep = {
      source = "lightstep/lightstep"
      version = ">=1.70.0"
    }
  }
  required_version = ">= v1.0.11"
}

 provider "lightstep" {
   api_key         = "<API-KEY>"
   organization    = "<ORG>"
 }

variable "lightstep_project" {
  description = "Name of Lightstep project"
  type        = string
}

variable "workloads" {
  description = "List of monitored workloads for creating dashboards"
  type = list(object({
    namespace = string
    workload  = string
  }))
}
 