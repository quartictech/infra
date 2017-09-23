variable "project_id"           {}
variable "viewer_group"         {}


resource "google_project_iam_member" "viewer" {
    project             = "${var.project_id}"
    role                = "roles/viewer"
    member              = "group:${var.viewer_group}"
}
