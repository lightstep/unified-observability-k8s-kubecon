provider "helm" {
  kubernetes {
    host  = google_container_cluster.primary.endpoint
    client_certificate  = google_container_cluster.primary.master_auth.0.client_certificate
    token    = data.google_client_config.default.access_token
    # client_key =  base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

resource "helm_release" "otel_demo_app" {
  depends_on = [helm_release.resources]
  name             = "otel-demo-app"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-demo"
  timeout          = 120
  namespace        = var.otel_demo_namespace

  values = [
     "${file("values-ls.yaml")}"
  ]
}

# Reference: https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-962058148
resource "helm_release" "resources" {
  depends_on = [
    google_container_node_pool.primary_nodes
  ]
  name       = "external-secrets-cluster-store"
  chart      = "../itscontained/raw"
  # repository = "https://github.com/itscontained/charts/itscontained"
  # chart      = "raw"
  # version    = "0.2.5"
  values = [
    <<-EOF
    resources:
      - apiVersion: v1
        kind: Namespace
        metadata:
          name: ${var.otel_demo_namespace}

      - apiVersion: v1
        kind: Secret
        metadata:
          name: otel-collector-secret
          namespace: ${var.otel_demo_namespace}
        data:
          LS_TOKEN: ${base64encode(var.ls_access_token)}
        type: "Opaque"
    EOF
  ]
}
