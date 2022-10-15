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
  # create_namespace = true

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



/* Anoter way to helm
The provider also supports multiple paths in the same way that kubectl does using the config_paths attribute or KUBE_CONFIG_PATHS environment variable.

provider "helm" {
  kubernetes {
    config_paths = [
      "/path/to/config_a.yaml",
      "/path/to/config_b.yaml"
    ]
  }
} 

You can also configure the host, basic auth credentials, and client certificate authentication explicitly or through environment variables.

provider "helm" {
  kubernetes {
    host     = "https://cluster_endpoint:port"

    client_certificate     = file("~/.kube/client-cert.pem")
    client_key             = file("~/.kube/client-key.pem")
    cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
  }
}

*/
