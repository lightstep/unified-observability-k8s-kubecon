resource "lightstep_dashboard" "k8s_tracing_dashboard" {
  project_name   = var.ls_project
  dashboard_name = "Kubernetes Tracing Dashboard"

  chart {
    name = "API Rate by HTTP Method"
    rank = "1"
    type = "timeseries"

    query {
      hidden         = false
      query_name     = "a"
      display        = "line"
      query_string   = "spans count | rate | filter (operation == \"KubernetesAPI\") | group_by [\"http.method\"], sum"
    }
  }

  chart {
    name = "etcd Rate by Operation"
    rank = "2"
    type = "timeseries"

    query {
      query_name     = "a"
      display        = "line"
      hidden         = false
      query_string   = "spans count | rate | filter (service == \"etcd\") | group_by [\"operation\"], sum"
    }
  }

  chart {
    name = "Kubelet Latency"
    rank = "3"
    type = "timeseries"

    query {
        query_name = "a"
        display = "heatmap"
        hidden = false
        query_string = "spans latency | delta | filter (service == \"kubelet\") | group_by [], sum"
    }
  }

  chart {
    name = "API Server Node Request Duration (s)"
    rank = "4"
    type = "timeseries"

    query {
        query_name = "a"
        display = "line"
        hidden = false
        query_string = "metric apiserver_request_duration_seconds | filter (resource == \"namespaces\") | delta | group_by [], sum | point percentile(value, 50.0), percentile(value, 95.0), percentile(value, 99.0), percentile(value, 99.9)"
    }
  }

  chart {
    name = "API Server Request Total (namespaces)"
    rank = "5"
    type = "timeseries"

    query {
        query_name = "a"
        display = "line"
        hidden = false
        query_string = "metric apiserver_request_total | filter (resource == \"namespaces\") | delta | group_by [], sum"
    }
  }

  chart {
    name = "API Server Namespace Spans"
    rank = "6"
    type = "timeseries"

    query {
        query_name = "a"
        display = "line"
        hidden = false
        query_string = "spans latency | delta | filter (((service == \"apiserver\") && (operation == \"KubernetesAPI\")) && (http.target =~ \".*namespaces.*\")) | group_by [], sum | point percentile(value, 99.0), percentile(value, 50.0), percentile(value, 95.0), percentile(value, 99.9)"
    }
  }

  chart {
    name = "Kubelet Container Starts"
    rank = "7"
    type = "timeseries"

    query {
        query_name = "a"
        display = "line"
        hidden = false
        query_string = "spans latency | delta | filter ((service == \"kubelet\") && (operation == \"runtime.RuntimeService/StartContainer\")) | group_by [], sum | point percentile(value, 50.0), percentile(value, 95.0), percentile(value, 99.0), percentile(value, 99.9)"
    }
  }
}