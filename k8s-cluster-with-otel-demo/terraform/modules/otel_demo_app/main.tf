# Create namespace and k8s secret for LS access token
resource "kubernetes_namespace_v1" "otel_demo_ns" {
  metadata {
    name = var.otel_demo_namespace
  }
}

resource "kubernetes_namespace_v1" "otel_kube_stack_ns" {
  metadata {
    name = var.otel_kube_stack_namespace
  }
}

resource "kubernetes_namespace_v1" "cert_manager_ns" {
  metadata {
    name = var.cert_manager_namespace
  }
}

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
}

# Deploy otel kube stack
resource "helm_release" "otel-kube-stack" {
     depends_on = [helm_release.otel-operator] 
    name = "otel-kube-stack"
    chart = "./prometheus-k8s-opentelemetry-collector/kube-otel-stack"
    values = [
        file("./prometheus-k8s-opentelemetry-collector/kube-otel-stack/values.yaml")
    ]
    namespace = var.otel_kube_stack_namespace
    wait_for_jobs = true
}

resource "helm_release" "otel_demo_app" {
  depends_on = [helm_release.otel-kube-stack]
  name             = "otel-demo-app"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-demo"
  timeout          = 120
  namespace        = var.otel_demo_namespace

  values = [
     "${file("values-ls.yaml")}"
  ]
}



resource "kubernetes_secret_v1" "ls_access_token" {
  depends_on = [helm_release.otel_demo_app]
  metadata {
    name = "otel-collector-secret"
    namespace = var.otel_demo_namespace
  }
  data = {
    LS_TOKEN = var.ls_access_token
  }

  type = "Opaque"
}

