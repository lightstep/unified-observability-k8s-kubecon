module "kube-dashboards" {
  source            = "./terraform-opentelemetry-dashboards/collector-dashboards/otel-collector-kubernetes-dashboard"
  lightstep_project = var.ls_project

  workloads = [
    {
      namespace = "cert-manager"
      workload  = "cert-manager"
    },
    {
      namespace = "kube-system"
      workload = "otel-demo-app-cillium"
    },
    {
      namespace = "kube-system"
      workload = "otel-demo-app-coredns"
    },
    {
      namespace = "kube-system"
      workload = "otel-demo-app-konnectivity-agent"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-adservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-recommendationservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-cartservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-checkoutservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-currencyservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-emailservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-featureflagservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-ffpostgres"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-frontend"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-jaeger"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-loadgenerator"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-otelcol"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-paymentservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-productcatalogservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-quoteservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-redis"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-demo-shippingservice"
    }


  ]
}