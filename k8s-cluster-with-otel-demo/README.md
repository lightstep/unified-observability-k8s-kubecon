# Create GKE Cluster with oTel Demo App and Lightstep Dashboards
- things needed 
- GKE Account needed
- gcloud cli
- terraform cli
- Lightstep account

Steps:
`cd terraform`
`terraform init`
`terraform apply` 

# K8s Stuff

Add cluster to Kube Config

```bash
gcloud container clusters get-credentials <cluster_name>
```

or

```bash
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
```