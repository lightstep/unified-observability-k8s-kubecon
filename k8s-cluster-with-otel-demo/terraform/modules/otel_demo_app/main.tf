# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {} 

# # module "k8s_cluster_create" {
# #   source = "../../modules/k8s"

# #     cluster_name = var.cluster_name
# #     subnet = var.subnet
# #     project_id = var.project_id
# #     region = var.region
# #     network = var.network

# # }

# provider "kubernetes" {
#   host  = "https://${module.k8s_cluster_create.kubernetes_cluster_host}"
#   token = module.k8s_cluster_create.access_token 
#   cluster_ca_certificate = base64decode(module.k8s_cluster_create.ca_certificate) 
# }

# OTel Demo App deploy
resource "kubernetes_namespace_v1" "otel_demo_ns" {
  metadata {
    name = var.otel_demo_namespace
  }
}

resource "kubernetes_secret_v1" "ls_access_token_demo" {
  depends_on = [kubernetes_namespace_v1.otel_demo_ns]
  metadata {
    name      = "otel-collector-secret"
    namespace = var.otel_demo_namespace
  }

  data = {
    "LS_TOKEN" = var.ls_access_token
  }
}

resource "helm_release" "otel_demo_app" {
  depends_on = [helm_release.otel-kube-stack, kubernetes_namespace_v1.otel_demo_ns]
  name             = "otel-demo-app"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-demo"
  timeout          = 120
  namespace        = var.otel_demo_namespace
  # create_namespace = true
  wait             = false

  values = [
     "${file("values-ls.yaml")}"
  ]
}

# Create NS for cert manager and kubestack
resource "kubernetes_namespace_v1" "otel_kube_stack_ns" {
  metadata {
    name = var.otel_kube_stack_namespace
  }
}

# resource "kubernetes_namespace_v1" "cert_manager_ns" {
#   metadata {
#     name = var.cert_manager_namespace
#   }
# }

resource "kubernetes_namespace_v1" "opentelemetry_operator_ns" {
  metadata {
    name = var.opentelemetry_operator_namespace
  }
}

# Deploy cert manager
resource "helm_release" "cert-manager" {
    name = "cert-manager"
    namespace = var.cert_manager_namespace
    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    create_namespace = true
    version = "1.8.0"
    set {
        name = "installCRDs"
        value = "true"
    }
    wait_for_jobs = true
}

resource "helm_release" "otel-operator" {
    depends_on = [helm_release.cert-manager]
    name = "otel-operator"
    namespace = var.opentelemetry_operator_namespace
    repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
    chart = "opentelemetry-operator"
    wait_for_jobs = true
    create_namespace = true
}

# Deploy otel kube stack
resource "helm_release" "otel-kube-stack" {
    depends_on = [helm_release.otel-operator, kubernetes_namespace_v1.otel_kube_stack_ns] 
    name = "otel-kube-stack"
    chart = "./prometheus-k8s-opentelemetry-collector/kube-otel-stack"
    dependency_update = true
    values = [
        file("./prometheus-k8s-opentelemetry-collector/kube-otel-stack/values.yaml")
    ]
    namespace = var.otel_kube_stack_namespace
    wait_for_jobs = true
}

resource "kubernetes_secret_v1" "ls_access_token" {
  depends_on = [kubernetes_namespace_v1.otel_kube_stack_ns]
  metadata {
    name      = "otel-collector-secret"
    namespace = var.otel_kube_stack_namespace
  }

  data = {
    "LS_TOKEN" = var.ls_access_token
  }
}

