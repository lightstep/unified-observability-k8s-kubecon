# Lightstep @ KubeCon NA 22 Demo

This describes how to run demo scenarios for Lightstep.

## k8s 1.25+ Tracing (k3s)

Requirements
- DigitalOcean Account w/PAT
- Terraform
- Lightstep Observability Account

1. Create a DigitalOcean account and generate a Personal Access Token (PAT) with
   read/write access to the API.  This will be used to create necessary
   resources for the demo. You will also need to upload your public SSH key to
   DigitalOcean with the name `terraform`.
2. Create a Lightstep Observability account. You will need your project access
   token, as well as an API key with member or admin access.
3. In `k8s-tracing`, create `terraform.tfvars` and populate the following variables:
   - `do_token` - DigitalOcean PAT
   - `pvt_key` - Path to the `terraform` private key, locally.
   - `ls_access_token` - Lightstep project access token
   - `ls_project` - Lightstep project name
   - `ls_org` - Lightstep organization name (case-sensitive)
   - `ls_api_key` - Lightstep API key (member or admin)
4. In `k8s-tracing`, run `terraform init` to initialize the Terraform
   environment.
5. In `k8s-tracing`, run `terraform apply` to create the necessary resources.

This will create a k3s cluster with API Server, containerd, etcd, and kubelet
tracing enabled. You can view these traces in Lightstep.

## Unified Observability for k8s w/OpenTelemetry

Requirements
- DigitalOcean Account w/PAT and `doctl` installed
- `kubectl` to access the k8s cluster if desired
- Helm
- Terraform
- Lightstep Observability Account

1. Create a DigitalOcean account and generate a Personal Access Token (PAT) with
   read/write access to the API. 
2. Create a Lightstep Observability account. You will need your project access
   token, as well as an API key with member or admin access.
3. In `otel-demo`, create a `terraform.tfvars` file and populate the following
   variables:
   - `do_token` - DigitalOcean PAT
   - `ls_access_token` - Lightstep project access token
   - `ls_org` - Lightstep organization name (case-sensitive)
   - `ls_api_key` - Lightstep API key (member or admin)
   - `ls_project` - Lightstep project name
   - `k8s_cluster_name` - Name of the k8s cluster to create
4. In `otel-demo`, run `terraform init` to initialize the Terraform environment.
5. In `otel-demo`, run `terraform apply` to create the necessary resources.

To enable interesting failure scenarios, connect to the Feature Flag service pod
with `kubectl port-forward` on port 8081 and enable one or both flags.
