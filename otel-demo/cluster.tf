resource "digitalocean_kubernetes_cluster" "otel-demo-cluster" {
    name = var.k8s_cluster_name
    region = var.do_region
    version = "1.24.4-do.0"

    node_pool {
        name = "default"
        size = "gd-2vcpu-8gb"
        node_count = var.k8s_node_count
    }
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.otel-demo-cluster.endpoint
    token = digitalocean_kubernetes_cluster.otel-demo-cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.otel-demo-cluster.kube_config[0].cluster_ca_certificate
    )
  }
}
provider "kubernetes" {
  host             = digitalocean_kubernetes_cluster.otel-demo-cluster.endpoint
  token            = digitalocean_kubernetes_cluster.otel-demo-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.otel-demo-cluster.kube_config[0].cluster_ca_certificate
  )
}

resource "kubernetes_namespace" "otel-kube-stack" {
  metadata {
    name = "otel-kube-stack"
  }
}

resource "kubernetes_namespace" "otel-demo" {
  metadata {
    name = "otel-demo"
  }
}

resource "kubernetes_secret" "ls_access_token" {
  metadata {
    name      = "otel-collector-secret"
    namespace = "otel-kube-stack"
  }

  data = {
    "LS_TOKEN" = var.ls_access_token
  }
}

resource "kubernetes_secret" "ls_access_token_demo" {
  metadata {
    name      = "otel-collector-secret"
    namespace = "otel-demo"
  }

  data = {
    "LS_TOKEN" = var.ls_access_token
  }
}

resource "helm_release" "cert-manager" {
    name = "cert-manager"
    namespace = "cert-manager"
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
    namespace = "opentelemetry-operator"
    repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
    chart = "opentelemetry-operator"
    create_namespace = true
    wait_for_jobs = true
}

resource "helm_release" "otel-kube-stack" {
    depends_on = [helm_release.otel-operator]
    name = "otel-kube-stack"
    chart = "./prometheus-k8s-opentelemetry-collector/kube-otel-stack"
    values = [
        file("./prometheus-k8s-opentelemetry-collector/kube-otel-stack/values.yaml")
    ]
    namespace = "otel-kube-stack"
    wait_for_jobs = true
}

resource "helm_release" "otel-demo" {
    name = "demo"
    repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
    chart = "opentelemetry-demo"
    version = "0.9.6"
    namespace = "otel-demo"
    values = [
        "${file("demo-values.yaml")}"
    ]
    create_namespace = true
}