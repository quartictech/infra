variable "org_id"                       {}
variable "billing_account"              {}
variable "region"                       {}
variable "project_id_prefix"            {}
variable "project_name"                 {}
variable "viewer_group"                 {}
variable "instance_admin_group"         {}
variable "dns_name"                     {}


terraform {
    backend "gcs" {
        bucket              = "administration.quartic.io"
        path                = "global/terraform.tfstate"
    }
}

provider "google" {
    region                  = "${var.region}"
}

module "project" {
    source                  = "../_modules/project"

    org_id                  = "${var.org_id}"
    billing_account         = "${var.billing_account}"
    name                    = "${var.project_name}"
    id_prefix               = "${var.project_id_prefix}"
    services                = [
        "compute.googleapis.com",
        "containerregistry.googleapis.com",
        "dns.googleapis.com",
        "storage-api.googleapis.com",
    ]
}

module "circleci" {
    source                  = "../_modules/circleci"

    project_id              = "${module.project.id}"
}

module "iam" {
    source                  = "../_modules/iam"

    project_id              = "${module.project.id}"
    viewer_member           = "group:${var.viewer_group}"
    instance_admin_member   = "group:${var.instance_admin_group}"
    storage_admin_member    = "serviceAccount:${module.circleci.email}"
}

data "google_compute_zones" "available" {
    region                  = "${var.region}"
}

module "network" {
    source                  = "../_modules/network"
    
    project_id              = "${module.project.id}"
}

module "www" {
    source                  = "../_modules/www"

    project_id              = "${module.project.id}"
    zones                   = "${data.google_compute_zones.available.names}"
}

module "dns" {
    source                  = "../_modules/dns"

    project_id              = "${module.project.id}"
    dns_name                = "${var.dns_name}"
    addresses               = {
        www                 = "${module.www.address}"
    }
    addresses_count         = 1
}


output "project_id"                     { value = "${module.project.id}" }
output "name_servers"                   { value = "${module.dns.name_servers}" }
output "www_address"                    { value = "${module.www.address}" }
output "circleci_service_account_email" { value = "${module.circleci.email}" }