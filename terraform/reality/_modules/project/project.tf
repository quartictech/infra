variable "org_id"               {}
variable "billing_account"      {}
variable "id_prefix"            { default = "quartic" }
variable "name"                 {}
variable "services"             { type = "list" }


resource "random_id" "id" {
    byte_length         = 4
}

resource "google_project" "project" {
    name                = "${var.name}"
    project_id          = "${var.id_prefix}-${random_id.id.hex}"
    billing_account     = "${var.billing_account}"
    org_id              = "${var.org_id}"
}

resource "google_project_services" "project" {
    project             = "${google_project.project.project_id}"

    # Note - ensure these are all reflected in the list in bootstrapping.tf
    services            = "${var.services}"
}

output "id" {
    value = "${google_project_services.project.project}"
}
