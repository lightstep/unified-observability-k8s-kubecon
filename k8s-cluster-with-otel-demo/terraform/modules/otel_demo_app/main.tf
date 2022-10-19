# Create namespace and k8s secret for LS access token
resource "kubernetes_namespace_v1" "otel_demo_ns" {
  metadata {
    name = var.otel_demo_namespace
  }
}

resource "kubernetes_secret_v1" "ls_access_token" {
  depends_on = [kubernetes_namespace_v1.otel_demo_ns]
  metadata {
    name = "otel-collector-secret"
    namespace = var.otel_demo_namespace
  }
  data = {
    LS_TOKEN = var.ls_access_token
  }

  type = "Opaque"
}

# Deploy demo app
resource "helm_release" "otel_demo_app" {
  depends_on = [kubernetes_secret_v1.ls_access_token]
  name             = "otel-demo-app"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-demo"
  timeout          = 120
  namespace        = var.otel_demo_namespace

  values = [
     "${file("values-ls.yaml")}"
  ]
}
