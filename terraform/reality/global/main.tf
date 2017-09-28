variable "org_id"                           {}
variable "billing_account"                  {}
variable "region"                           {}
variable "project_id_prefix"                {}
variable "project_name"                     {}
variable "viewer_group"                     {}
variable "dns_name"                         {}
variable "dns_ttl"                          {}
variable "staging_service_account_email"    {}
variable "staging_name_servers"             { type = "list" }


terraform {
    backend "gcs" {
        bucket                  = "administration.quartic.io"
        path                    = "global/terraform.tfstate"
    }
}

provider "google" {
    region                      = "${var.region}"
}

module "project" {
    source                      = "../_modules/project"

    org_id                      = "${var.org_id}"
    billing_account             = "${var.billing_account}"
    name                        = "${var.project_name}"
    id_prefix                   = "${var.project_id_prefix}"
    services                    = [
        "containerregistry.googleapis.com",
        "dns.googleapis.com",
        "storage-api.googleapis.com",
    ]
}

module "iam" {
    source                          = "_modules/iam"

    project_id                      = "${module.project.id}"
    viewer_member                   = "group:${var.viewer_group}"
    storage_object_viewer_member    = "serviceAccount:${var.staging_service_account_email}"
}

module "dns" {
    source                      = "_modules/dns"

    project_id                  = "${module.project.id}"
    dns_name                    = "${var.dns_name}"
    ttl                         = "${var.dns_ttl}"
    staging_name_servers        = "${var.staging_name_servers}"
}


output "project_id"                     { value = "${module.project.id}" }
output "name_servers"                   { value = "${module.dns.name_servers}" }
output "circleci_service_account_email" { value = "${module.iam.circleci_service_account_email}" }