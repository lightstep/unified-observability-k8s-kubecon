variable "otel_demo_namespace" {
  default = "otel-demo"
  description = "OTel Demo app namespace"
}

variable "otel_kube_stack_namespace" {
  default = "otel-kube-stack"
  description = "otel-kube-stack namespace"
}

variable "cert_manager_namespace" {
  default = "cert-manager"
  description = "cert-manager namespace"
}

variable "opentelemetry_operator_namespace" {
  default = "opentelemetry-operator"
  description = "opentelemetry-operator namespace"
}

variable "ls_access_token" {
  description = "Lightstep access token"
}
