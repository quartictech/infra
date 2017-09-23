variable "org_id"                       {}
variable "billing_account"              {}
variable "region"                       {}
variable "project_id_prefix"            {}
variable "project_name"                 {}
variable "viewer_group"                 {}
variable "dns_name"                     {}


terraform {
    backend "gcs" {
        bucket          = "administration.quartic.io"
        path            = "global/terraform.tfstate"
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

module "dns" {
    source              = "../_modules/dns"

    project_id          = "${module.project.id}"
    dns_name            = "${var.dns_name}"
    addresses           = {}
    addresses_count     = 0
}


output "name_servers"       { value = "${module.dns.name_servers}" }