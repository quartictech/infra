variable "org_id"                       {}
variable "billing_account"              {}
variable "region"                       {}
variable "project_name"                 {}
variable "project_id_prefix"            {}
variable "viewer_group"                 {}
variable "container_developer_group"    {}
variable "dns_name"                     {}
variable "dns_ttl"                      {}
variable "cluster_name"                 {}
variable "cluster_core_node_count"      {}
variable "cluster_worker_node_count"    {}
variable "cluster_domains"              { default = ["*.", ""] }    # TODO - remove this hack


data "terraform_remote_state" "global" {
    backend                     = "gcs"
    config {
        bucket                  = "administration.quartic.io"
        path                    = "global/terraform.tfstate"
    }
}

module "project" {
    source                      = "../project"

    org_id                      = "${var.org_id}"
    billing_account             = "${var.billing_account}"
    name                        = "${var.project_name}"
    id_prefix                   = "${var.project_id_prefix}"
    services                    = [
        "compute.googleapis.com",
        "container.googleapis.com",
        "dns.googleapis.com",
        "storage-api.googleapis.com",

        # Some noobhole stuff that the above APIs transitively enable (see https://github.com/hashicorp/terraform/issues/13004)
        "pubsub.googleapis.com",
        "containerregistry.googleapis.com",
        "deploymentmanager.googleapis.com",
        "replicapool.googleapis.com",
        "replicapoolupdater.googleapis.com",
        "resourceviews.googleapis.com",
    ]
}

module "iam" {
    source                      = "../iam"

    project_id                  = "${module.project.id}"
    viewer_member               = "group:${var.viewer_group}"
    container_developer_members = [
        "group:${var.container_developer_group}",
        "serviceAccount:${data.terraform_remote_state.global.circleci_service_account_email}",  // In order to deploy website
    ]
}

data "google_compute_zones" "available" {
    region                      = "${var.region}"
}

module "cluster" {
    source                      = "../cluster"

    project_id                  = "${module.project.id}"
    region                      = "${var.region}"
    zones                       = "${data.google_compute_zones.available.names}"
    name                        = "${var.cluster_name}"
    service_account_email       = "${module.iam.cluster_service_account_email}"
    core_node_count             = "${var.cluster_core_node_count}"
    worker_node_count           = "${var.cluster_worker_node_count}"
}

# TODO - Need something that adds an NS record to the global project
module "dns" {
    source                      = "../dns"

    project_id                  = "${module.project.id}"
    dns_name                    = "${var.dns_name}"
    ttl                         = "${var.dns_ttl}"
    cluster_address             = "${module.cluster.address}"
    cluster_domains             = "${var.cluster_domains}"  # TODO - remove this hack
}


output "project_id"                     { value = "${module.project.id}" }
output "name_servers"                   { value = "${module.dns.name_servers}" }
output "cluster_ip"                     { value = "${module.cluster.address}" }
output "cluster_zone"                   { value = "${module.cluster.zone}" }
output "cluster_name"                   { value = "${var.cluster_name}" }
output "cluster_service_account_email"  { value = "${module.iam.cluster_service_account_email}" }
output "zone_name"                      { value = "${module.dns.zone_name}" }       # TODO - remove this hack