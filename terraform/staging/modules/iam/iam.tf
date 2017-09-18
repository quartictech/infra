variable "project_id"           {}
variable "viewer_group"         {}


resource "google_project_iam_member" "editor" {
    project             = "${var.project_id}"
    role                = "roles/editor"
    member              = "group:${var.viewer_group}"
}
