provider "helm" {

  # kubernetes {
  #   host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  #   token = data.google_client_config.default.access_token
  #   cluster_ca_certificate = base64decode(
  #     data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  #   )
  # }

  kubernetes {
    host  = google_container_cluster.primary.endpoint
    client_certificate  = google_container_cluster.primary.master_auth.0.client_certificate
    token    = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

resource "helm_release" "otel_demo_app" {
  depends_on = [kubectl_manifest.namespace, kubectl_manifest.secrets]
  name       = "otel-demo-app"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-demo"
  timeout    = 90
  namespace           = "otel-demo"
  # create_namespace = true

  values = [
     "${file("values-ls.yaml")}"
  ]
}

# Reference: https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-967022975
resource "kubectl_manifest" "namespace" {
  yaml_body  = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: ${var.otel_demo_namespace}
YAML
}

resource "kubectl_manifest" "secrets" {
  depends_on = [kubectl_manifest.namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: otel-collector-secret
  namespace: ${var.otel_demo_namespace}
data:
  LS_TOKEN: ${var.ls_access_token}
type: "Opaque"
YAML
}

# # Reference: https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-962058148
# resource "helm_release" "secrets" {
#   depends_on = [helm_release.otel_demo_app]
#   name       = "external-secrets-cluster-store"
#   repository = "https://github.com/itscontained/charts/tree/master/itscontained"
#   chart      = "raw"
#   version    = "0.2.5"
#   values = [
#     <<-EOF
#     resources:
#       - apiVersion: v1
#         kind: Secret
#         metadata:
#           name: otel-collector-secret
#           namespace: ${var.otel_demo_namespace}
#         data:
#           LS_TOKEN: ${var.ls_access_token}
#     EOF
#   ]
# }

