# Lightstep @ KubeCon NA 22 Demo

This describes how to run demo scenarios for Lightstep.

## k8s 1.25+ Tracing (Minikube)

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

## Unified Observability for k8s w/OpenTelemetry