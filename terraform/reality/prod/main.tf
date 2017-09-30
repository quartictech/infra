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
variable "cluster_core_node_count"      {}
variable "cluster_worker_node_count"    {}


terraform {
    backend "gcs" {
        bucket                  = "administration.quartic.io"
        path                    = "prod/terraform.tfstate"
    }
}

provider "google" {
    region                      = "${var.region}"
}

module "env" {
    source                      = "../_modules/env"

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
    cluster_core_node_count     = "${var.cluster_core_node_count}"
    cluster_worker_node_count   = "${var.cluster_worker_node_count}"

    cluster_subdomains          = ["www.", ""]  # TODO - remove this hack
}

# TODO - remove this hack
resource "google_dns_record_set" "hack" {
    project         = "${module.env.global_project_id}"
    name            = "*.${var.domain_name}"
    managed_zone    = "${module.env.global_zone_name}"
    ttl             = "${var.dns_ttl}"
    type            = "A"
    rrdatas         = ["${module.env.cluster_ip}"]
}


output "project_id"                     { value = "${module.env.project_id}" }
output "cluster_ip"                     { value = "${module.env.cluster_ip}" }
output "cluster_zone"                   { value = "${module.env.cluster_zone}" }
output "cluster_name"                   { value = "${module.env.cluster_name}" }
output "cluster_service_account_email"  { value = "${module.env.cluster_service_account_email}" }
