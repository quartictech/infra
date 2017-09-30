variable "org_id"                           {}
variable "billing_account"                  {}
variable "region"                           {}
variable "project_id_prefix"                {}
variable "project_name"                     {}
variable "viewer_group"                     {}
variable "domain_name"                      {}
variable "dns_ttl"                          {}


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
        "container.googleapis.com",         # The CircleCI account is used to kubectl operations against other envs
        "containerregistry.googleapis.com",
        "dns.googleapis.com",
        "storage-api.googleapis.com",

        # Some noobhole stuff that the above APIs transitively enable (see https://github.com/hashicorp/terraform/issues/13004)
        "pubsub.googleapis.com",
        "compute.googleapis.com",
        "deploymentmanager.googleapis.com",
        "replicapool.googleapis.com",
        "replicapoolupdater.googleapis.com",
        "resourceviews.googleapis.com",
    ]
}

module "iam" {
    source                          = "_modules/iam"

    project_id                      = "${module.project.id}"
    viewer_member                   = "group:${var.viewer_group}"
}

module "dns" {
    source                      = "_modules/dns"

    project_id                  = "${module.project.id}"
    domain_name                 = "${var.domain_name}"
    ttl                         = "${var.dns_ttl}"
}


output "project_id"                     { value = "${module.project.id}" }
output "zone_name"                      { value = "${module.dns.zone_name}" }
output "name_servers"                   { value = "${module.dns.name_servers}" }
output "circleci_service_account_email" { value = "${module.iam.circleci_service_account_email}" }