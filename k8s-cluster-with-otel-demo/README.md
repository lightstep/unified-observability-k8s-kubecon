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

## FAQ

### What is `itscontained`?

Great question! Well, it turns out that you run into a bit of a chicken-and-egg scenario when you try to create k8s resources after you create a k8s cluster. You can read all about everyone's frustrations [here](https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-962058148).

The solution to this problem is presented [here](https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a). Unfortunately, the Helm repo [https://charts.itscontained.io](https://charts.itscontained.io) gives you a nice 404 error. See for yourself. Fortunately, the [GitHub repo with the Helm chart](https://github.com/itscontained/charts/tree/master/itscontained) still exists. I wasn't able to run the chart from the repo, so I did the next best thing - made a local copy of it and put it in this repo, which resides in the `itscontained` folder.