variable "org_id"               {}
variable "billing_account"      {}
variable "region"               {}
variable "project_name"         {}
variable "viewer_group"         {}
variable "dns_name"             {}
variable "cluster_node_count"   {}


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
    source              = "./modules/project"

    org_id              = "${var.org_id}"
    billing_account     = "${var.billing_account}"
    name                = "${var.project_name}"
}

module "iam" {
    source              = "./modules/iam"

    project_id          = "${module.project.id}"
    viewer_group        = "${var.viewer_group}"
}

data "google_compute_zones" "available" {
    region              = "${var.region}"
}

# module "compute" {
#     source              = "./modules/compute"

#     project_id          = "${module.project.id}"
#     zones               = "${data.google_compute_zones.available.names}"
# }

module "cluster" {
    source              = "./modules/cluster"

    project_id          = "${module.project.id}"
    zones               = "${data.google_compute_zones.available.names}"
    node_count          = "${var.cluster_node_count}"
}

module "dns" {
    source              = "./modules/dns"

    project_id          = "${module.project.id}"
    dns_name            = "${var.dns_name}"
    addresses           = {
        cluster         = "${module.cluster.address}"   # TODO - subdomain
    }
    addresses_count     = 1
}


output "cluster_ip"             { value = "${module.cluster.address}" }