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
      workload = "cillium"
    },
    {
      namespace = "kube-system"
      workload = "coredns"
    },
    {
      namespace = "kube-system"
      workload = "konnectivity-agent"
    },
    {
      namespace = "otel-demo"
      workload = "demo-adservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-recommendationservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-cartservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-checkoutservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-currencyservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-emailservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-featureflagservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-ffpostgres"
    },
    {
      namespace = "otel-demo"
      workload = "demo-frontend"
    },
    {
      namespace = "otel-demo"
      workload = "demo-jaeger"
    },
    {
      namespace = "otel-demo"
      workload = "demo-loadgenerator"
    },
    {
      namespace = "otel-demo"
      workload = "demo-otelcol"
    },
    {
      namespace = "otel-demo"
      workload = "demo-paymentservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-productcatalogservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-quoteservice"
    },
    {
      namespace = "otel-demo"
      workload = "demo-redis"
    },
    {
      namespace = "otel-demo"
      workload = "demo-shippingservice"
    }


  ]
}