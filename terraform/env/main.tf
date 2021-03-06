variable "org_id"                       {}
variable "billing_account"              {}
variable "region"                       {}
variable "project_name"                 {}
variable "project_id_prefix"            {}
variable "viewer_group"                 {}
variable "container_developer_group"    {}
variable "domain_name"                  {}
variable "dns_ttl"                      {}
variable "cluster_name"                 {}
variable "cluster_core_node_type"       {}
variable "cluster_core_node_count"      {}
variable "cluster_core_preemptible"     {}
variable "cluster_worker_node_type"     {}
variable "cluster_worker_node_count"    {}
variable "cluster_worker_preemptible"   {}
variable "cluster_full_access"          { default=false }


terraform {
    backend "gcs" {
        bucket                  = "administration.quartic.io"
    }
}

provider "google" {
    version                     = "~> 1.0.1"
    region                      = "${var.region}"
}

# TODO - get rid of this indirection
module "env" {
    source                      = "_modules/env"

    org_id                      = "${var.org_id}"
    billing_account             = "${var.billing_account}"
    region                      = "${var.region}"
    project_name                = "${var.project_name}"
    project_id_prefix           = "${var.project_id_prefix}"
    viewer_group                = "${var.viewer_group}"
    container_developer_group   = "${var.container_developer_group}"
    domain_name                 = "${var.domain_name}"
    dns_ttl                     = "${var.dns_ttl}"
    cluster_name                = "${var.cluster_name}"
    cluster_core_node_type      = "${var.cluster_core_node_type}"
    cluster_core_node_count     = "${var.cluster_core_node_count}"
    cluster_core_preemptible    = "${var.cluster_core_preemptible}"
    cluster_worker_node_type    = "${var.cluster_worker_node_type}"
    cluster_worker_node_count   = "${var.cluster_worker_node_count}"
    cluster_worker_preemptible  = "${var.cluster_worker_preemptible}"
    cluster_full_access         = "${var.cluster_full_access}"
}


output "project_id"                     { value = "${module.env.project_id}" }
output "cluster_ip"                     { value = "${module.env.cluster_ip}" }
output "cluster_zone"                   { value = "${module.env.cluster_zone}" }
output "cluster_name"                   { value = "${module.env.cluster_name}" }
output "cluster_service_account_email"  { value = "${module.env.cluster_service_account_email}" }
