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

    otel_demo_namespace = var.otel_demo_namespace
    ls_access_token = var.ls_access_token
    cluster_name = var.cluster_name
    project_id = var.project_id
    region = var.region
    network = var.network
    subnet = var.subnet
}

module "lightstep_dashboards" {
    source = "./modules/lightstep"
    depends_on = [module.k8s_cluster_create]

    lightstep_project = var.ls_project
    workloads = var.workloads
}