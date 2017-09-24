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

module "iam" {
    source                  = "../_modules/iam"

    project_id              = "${module.project.id}"
    viewer_member           = "group:${var.viewer_group}"
    instance_admin_member   = "group:${var.instance_admin_group}"
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
    service_account_email   = "${module.iam.www_service_account_email}"
}

module "dns" {
    source                  = "../_modules/dns"

    project_id              = "${module.project.id}"
    dns_name                = "${var.dns_name}"
    www_address             = "${module.www.address}"
}


output "project_id"                     { value = "${module.project.id}" }
output "name_servers"                   { value = "${module.dns.name_servers}" }
output "www_address"                    { value = "${module.www.address}" }
output "circleci_service_account_email" { value = "${module.iam.circleci_service_account_email}" }