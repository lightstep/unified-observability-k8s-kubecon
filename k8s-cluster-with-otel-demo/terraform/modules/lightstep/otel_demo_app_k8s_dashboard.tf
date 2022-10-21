module "kube-dashboards" {
  source            = "../../terraform-opentelemetry-dashboards/collector-dashboards/otel-collector-kubernetes-dashboard"
  lightstep_project = var.lightstep_project

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
      workload = "otel-demo-app-adservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-recommendationservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-cartservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-checkoutservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-currencyservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-emailservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-featureflagservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-ffpostgres"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-frontend"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-jaeger"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-loadgenerator"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-otelcol"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-paymentservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-productcatalogservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-quoteservice"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-redis"
    },
    {
      namespace = "otel-demo"
      workload = "otel-demo-app-shippingservice"
    }


  ]
}