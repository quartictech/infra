variable "project_id"           {}
variable "viewer_group"         {}
variable "instance_admin_group" {}


resource "google_project_iam_member" "viewer" {
    project             = "${var.project_id}"
    role                = "roles/viewer"
    member              = "group:${var.viewer_group}"
}

# TODO - remove this once we find a better way to provision the Ansible stuff
resource "google_project_iam_member" "instance_admin" {
    project             = "${var.project_id}"
    role                = "roles/compute.instanceAdmin.v1"
    member              = "group:${var.instance_admin_group}"
}
