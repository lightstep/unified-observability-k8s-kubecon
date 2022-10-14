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
  name       = "otel-demo-app"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-demo"

  values = [
     "${file("values-ls.yaml")}"
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
