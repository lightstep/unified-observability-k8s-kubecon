
resource "lightstep_dashboard" "exported_dashboard" {
  project_name   = var.lightstep_project
  dashboard_name = "OTel Demo App - Application Metrics"

  chart {
    name = "Latency per Service"
    rank = "0"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans latency 
| delta 
| filter ((((((((((((service == "adservice") 
|| (service == "cartservice")) 
|| (service == "checkoutservice")) 
|| (service == "currencyservice")) 
|| (service == "emailservice")) 
|| (service == "featureflagservice")) 
|| (service == "frontend")) 
|| (service == "paymentservice")) 
|| (service == "productcatalogservice")) 
|| (service == "quoteservice")) 
|| (service == "recommendationservice")) 
|| (service == "shippingservice")) 
| group_by ["service"], sum 
| point percentile(value, 50.0), percentile(value, 95.0), percentile(value, 99.0), percentile(value, 99.9)
EOT
    }

  }

  chart {
    name = "Orders Placed"
    rank = "1"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans count 
| delta 
| filter (operation == "grpc.hipstershop.CheckoutService/PlaceOrder") 
| group_by [], 
sum
EOT
    }
  }
  chart {
    name = "/GetCart latency"
    rank = "2"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
 spans latency 
 | delta 
 | filter ((service == "cartservice") 
 && (operation == "hipstershop.CartService/GetCart")) 
 | group_by ["operation"], 
 sum 
 | point percentile(value, 50.0), percentile(value, 95.0), percentile(value, 99.0), percentile(value, 99.9)     
EOT
    }
  }

  chart {
    name = "/GetProduct latency"
    rank = "3"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans latency 
| delta 
| filter ((service == "productcatalogservice") 
&& (operation == "hipstershop.ProductCatalogService/GetProduct")) 
| group_by ["operation"], 
sum 
| point percentile(value, 50.0), percentile(value, 95.0), percentile(value, 99.0), percentile(value, 99.9)
EOT
    }
  }

  chart {
    name = "Rate per Service"
    rank = "4"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans count 
| rate 10m 
| filter (((((((((((((service == "adservice") 
|| (service == "cartservice")) 
|| (service == "checkoutservice")) 
|| (service == "currencyservice")) 
|| (service == "emailservice")) 
|| (service == "featureflagservice")) 
|| (service == "frontend")) 
|| (service == "loadgenerator")) 
|| (service == "paymentservice")) 
|| (service == "productcatalogservice")) 
|| (service == "quoteservice")) 
|| (service == "recommendationservice")) 
|| (service == "shippingservice")) 
| group_by ["service"], 
sum      
EOT
    }

  }
  chart {
    name = "Order Confirmations Sent"
    rank = "5"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans count 
| delta 
| filter (operation == "POST /send_order_confirmation") 
| group_by [], 
sum      
EOT
    }
  }

  chart {
    name = "recommendationservice app_recommendations_counter"
    rank = "6"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "bar"
      hidden       = false
      query_string = <<EOT
metric app_recommendations_counter 
| filter (service.name == "recommendationservice") 
| rate 
| group_by [], 
sum      
EOT
    }
  }
  chart {
    name = "Ads count"
    rank = "7"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans count 
| delta 
| filter ((service == "adservice") 
&& (app.ads.count == 0)) 
| group_by [], 
sum
EOT
    }
  }
  chart {
    name = "CartService/GetCart [Count]"
    rank = "8"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
spans count 
| delta 
| filter ((service == "frontend") 
&& (((operation == "grpc.hipstershop.CartService/GetCart") 
|| (operation == "HTTP GET")) 
|| (operation == "HTTP POST"))) 
| group_by [], 
sum      
EOT
    }

  }

  chart {
    name = "otlp.exporter.seen"
    rank = "9"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "bar"
      hidden       = false
      query_string = "metric otlp.exporter.seen | delta | group_by [], sum"
    }

  }

  chart {
    name = "runtime.cpython.cpu_time"
    rank = "10"
    type = "timeseries"

    query {
      query_name   = "(a * 100)"
      display      = "area"
      hidden       = false
      query_string = <<EOT
metric runtime.cpython.cpu_time 
| rate 
| group_by [], 
sum 
| point (value * 100)
  EOT
    }
  }

  chart {
    name = "runtime.cpython.gc_count"
    rank = "11"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
metric runtime.cpython.gc_count 
| rate 
| group_by [], 
sum
EOT
    }
  }

  chart {
    name = "runtime.cpython.memory"
    rank = "12"
    type = "timeseries"

    query {
      query_name   = "a"
      display      = "line"
      hidden       = false
      query_string = <<EOT
metric runtime.cpython.memory 
| rate 
| group_by [],
sum     
EOT
    }

  }

}