variable "org_id"                       {}
variable "billing_account"              {}
variable "region"                       {}
variable "project_name"                 {}
variable "project_id_prefix"            {}
variable "viewer_group"                 {}
variable "dns_name"                     {}
variable "cluster_name"                 {}
variable "cluster_core_node_count"      {}
variable "cluster_worker_node_count"    {}


terraform {
    backend "gcs" {
        bucket          = "administration.quartic.io"
        path            = "staging/terraform.tfstate"
    }
}

provider "google" {
    region              = "${var.region}"
}

module "project" {
    source              = "../_modules/project"

    org_id              = "${var.org_id}"
    billing_account     = "${var.billing_account}"
    name                = "${var.project_name}"
    id_prefix           = "${var.project_id_prefix}"
}

module "iam" {
    source              = "../_modules/iam"

    project_id          = "${module.project.id}"
    viewer_group        = "${var.viewer_group}"
}

data "google_compute_zones" "available" {
    region              = "${var.region}"
}

module "cluster" {
    source              = "../_modules/cluster"

    project_id          = "${module.project.id}"
    zones               = "${data.google_compute_zones.available.names}"
    name                = "${var.cluster_name}"
    core_node_count     = "${var.cluster_core_node_count}"
    worker_node_count   = "${var.cluster_worker_node_count}"
}

module "dns" {
    source              = "../_modules/dns"

    project_id          = "${module.project.id}"
    dns_name            = "${var.dns_name}"
    addresses           = {
        cluster         = "${module.cluster.address}"   # TODO - subdomain
    }
    addresses_count     = 1
}


output "cluster_ip"             { value = "${module.cluster.address}" }