variable "project_id"               {}
variable "viewer_member"            {}
variable "instance_admin_member"    {}
variable "storage_admin_member"     {}


resource "google_project_iam_member" "viewer" {
    project             = "${var.project_id}"
    role                = "roles/viewer"
    member              = "${var.viewer_member}"
}

# TODO - remove this once we find a better way to provision the Ansible stuff
resource "google_project_iam_member" "instance_admin" {
    project             = "${var.project_id}"
    role                = "roles/compute.instanceAdmin.v1"
    member              = "${var.instance_admin_member}"
}

# TODO - can we lock this down to the specific bucket?
resource "google_project_iam_member" "storage_admin" {
    project             = "${var.project_id}"
    role                = "roles/storage.admin"
    member              = "${var.storage_admin_member}"
}
