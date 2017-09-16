variable "org_id"               {}
variable "billing_account"      {}
variable "id_prefix"            { default = "quartic" }
variable "name"                 {}


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

    services            = [
        "compute.googleapis.com",
        "dns.googleapis.com",
    ]
}

output "id" {
    value = "${google_project_services.project.project}"
}
