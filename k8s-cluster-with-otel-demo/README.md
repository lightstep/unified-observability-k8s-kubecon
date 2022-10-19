# Create GKE Cluster with oTel Demo App and Lightstep Dashboards

## Pre-Requisites

Before you begin, you will need:

* A Google Cloud project with the ability to create a GKE cluster
* A Lightstep Observability account: [create a free account here](https://app.lightstep.com/signup/developer?signup_source=docs).
* A [Lightstep Access Token](https://docs.lightstep.com/docs/create-and-manage-access-tokens#create-an-access-token) for the Lightstep Observability project you would like to use.
* A Kubernetes cluster

Steps:

1. Create `terraform.tfvars`

    ```bash
    cd k8s-cluster-with-otel-demo/terraform
    touch terraform.tfvars
    ```

2. Populate `terraform.tfvars`

    Don't worry - this file is `.gitignored` and won't be put into version control.

    ```t
    cluster_name = "<YOUR_CLUSTER_NAME>"
    demo_namespace = "otel-demo"
    ls_access_token = "<YOUR_LS_TOKEN>"
    project_id = "<YOUR_GCLOUD_PROJECT>"
    region     = "us-central1"
    zone       = "us-central1-a"
    network    = "default"
    subnet     = "default"
    initial_node_count = 2
    ```

    * Replace `<YOUR_CLUSTER_NAME>` with your own cluster name
    * Replace `<YOUR_GCLOUD_PROJECT>` with your own Google Cloud project name
    * Replace `<YOUR_LS_TOKEN>` with your own [Lightstep Access Token](https://docs.lightstep.com/docs/create-and-manage-access-tokens#create-an-access-token)

3. Run Terraform

    ```bash
    terraform init
    terraform apply -auto-approve
    ```

4. Update your kubeconfig

    You can do this in one of two ways:

    ```bash
    # Option 1: Add by cluster name. Replace <YOUR_CLUSTER_NAME> with your own cluster name
    gcloud container clusters get-credentials <YOUR_CLUSTER_NAME>

    # Option 2: Use Terraform output variables to update kubeconfig
    gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
    ```
