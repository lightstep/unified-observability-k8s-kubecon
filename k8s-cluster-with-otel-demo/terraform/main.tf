module "k8s_cluster_create" {
    source = "./modules/k8s"

    cluster_name = var.cluster_name
    project_id = var.project_id
    region = var.region
    network = var.network
    subnet = var.subnet
}

module "deploy_otel_demo_app" {
    source = "./modules/otel_demo_app"
    # depends_on = [module.k8s_cluster_create]

    kubernetes_cluster_host = module.k8s_cluster_create.kubernetes_cluster_host
    kubernetes_cluster_cert = module.k8s_cluster_create.kubernetes_cluster_cert
    kubernetes_cluster_ca_cert = module.k8s_cluster_create.kubernetes_cluster_ca_cert
    otel_demo_namespace = var.otel_demo_namespace
    ls_access_token = var.ls_access_token
}