# Kubernetes OTel Demo Configs

Follow these instructions to run the OpenTelemetry Demo on Kubernetes, using Lightstep as your Observability back-end.

## Pre-Requisites

Before you begin, you will need:

* A Lightstep Observability account: [create a free account here](https://app.lightstep.com/signup/developer?signup_source=docs).
* A [Lightstep Access Token](https://docs.lightstep.com/docs/create-and-manage-access-tokens#create-an-access-token) for the Lightstep Observability project you would like to use.
* A Kubernetes cluster

## Steps

1. Initialize Helm

    ```console
    helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
    ```

2. Deploy the app

    ```console
    export LS_TOKEN="<YOUR_LS_TOKEN>"
    kubectl create ns otel-demo
    kubectl create secret generic otel-collector-secret -n otel-demo --from-literal=LS_TOKEN=$LS_TOKEN
    helm upgrade my-otel-demo open-telemetry/opentelemetry-demo -f ./k8s-otel-demo-configs/values-ls.yaml -n otel-demo --install
    ```

    Be sure to replace `<YOUR_LS_TOKEN>` with your own [Lightstep Access Token](https://docs.lightstep.com/docs/create-and-manage-access-tokens#create-an-access-token)

3. See traces in Lightstep!