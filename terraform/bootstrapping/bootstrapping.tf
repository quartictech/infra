variable "org_id"                           {}
variable "billing_account"                  {}
variable "region"                           {}
variable "project_id_prefix"                {}
variable "project_name"                     {}
variable "viewer_group"                     {}
variable "service_account_name"             {}
variable "bucket_name"                      {}


terraform {
    backend "gcs" {
        bucket          = "bottom-turtle.quartic.io"
        path            = "terraform.tfstate"
    }
}

provider "google" {
    version             = "~> 1.0.1"
    region              = "${var.region}"
}

resource "random_id" "id" {
    byte_length         = 4
}

resource "google_project" "admin" {
    name                = "Quartic - Admin"
    project_id          = "${var.project_id_prefix}-${random_id.id.hex}"
    billing_account     = "${var.billing_account}"
    org_id              = "${var.org_id}"
}

resource "google_project_services" "admin" {
    project             = "${google_project.admin.project_id}"
    services            = [
        "compute.googleapis.com",               # So we can list available zones
        "cloudresourcemanager.googleapis.com",  # So we can create a project
        "cloudbilling.googleapis.com",          # So we can attach project to billing account
        "storage-api.googleapis.com",           # So we can interact with our state bucket
        "servicemanagement.googleapis.com",     # So we can manage APIs/services on the project
        # Whilst services will be enabled on the target project, we still need the corresponding APIs to be enabled
        # on *this* project, as we'll be performing the actions via this project.
        "container.googleapis.com",
        "dns.googleapis.com",
        "iam.googleapis.com",
    ]
}

resource "google_service_account" "terraform" {
    project             = "${google_project.admin.project_id}"
    account_id          = "${var.service_account_name}"
    display_name        = "Terraform service account"
}

# So everyone can view
resource "google_project_iam_member" "viewer" {
    project             = "${google_project.admin.project_id}"
    role                = "roles/viewer"
    member              = "group:${var.viewer_group}"
}

variable "service_account_roles" {
    default = [
        "compute.networkViewer",    # To list available zones
        "storage.objectAdmin",      # To read/write state in bucket
    ]
}

resource "google_project_iam_member" "service_account" {
    count               = "${length(var.service_account_roles)}"
    project             = "${google_project.admin.project_id}"
    role                = "roles/${element(var.service_account_roles, count.index)}"
    member              = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_storage_bucket" "admin" {
    project             = "${google_project.admin.project_id}"
    name                = "${var.bucket_name}"
    location            = "${var.region}"
    storage_class       = "REGIONAL"
    versioning {
        enabled         = true
    }
}


# Used by finaliser script
output "org_id"                     { value = "${var.org_id}" }
output "project_id"                 { value = "${google_project.admin.project_id}" }
output "service_account_email"      { value = "${google_service_account.terraform.email}" }


