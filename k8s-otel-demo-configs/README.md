# Kubernetes OTel Demo Configs

Follow these instructions to run the OpenTelemetry Demo on Kubernetes, using Lightstep as your Observability back-end.

## Pre-Requisites

Before you begin, you will need:

* A Lightstep Observability account: [create a free account here](https://app.lightstep.com/signup/developer?signup_source=docs).
* A [Lightstep Access Token](https://docs.lightstep.com/docs/create-and-manage-access-tokens#create-an-access-token) for the Lightstep Observability project you would like to use.
* A Kubernetes cluster

## Steps

1. Clone the repo

Open up a terminal window

```console
git clone git@github.com:open-telemetry/opentelemetry-helm-charts.git
```

2. Copy [`values-ls.yaml`](values-ls.yaml) to `opentelemetry-helm-charts/charts/opentelemetry-demo`

3. Initialize Helm

```console
cd opentelemetry-helm-charts/charts/opentelemetry-demo
helm dependency build
cd ..
```

4. Deploy the app

```console
export LS_TOKEN="<YOUR_LS_TOKEN>"
kubectl create ns otel-demo
kubectl create secret generic otel-collector-secret -n otel-demo --from-literal=LS_TOKEN=$LS_TOKEN
helm upgrade opentelemetry-demo opentelemetry-demo -f ./opentelemetry-demo/values-ls.yaml -n otel-demo --install
```

Be sure to replace `<YOUR_LS_TOKEN>` with your own [Lightstep Access Token](https://docs.lightstep.com/docs/create-and-manage-access-tokens#create-an-access-token)

5. See traces in Lightstep!