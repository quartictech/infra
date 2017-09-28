variable "project_id"                   {}
variable "viewer_member"                {}
variable "storage_object_viewer_member" {}


resource "google_service_account" "circleci" {
    project             = "${var.project_id}"
    account_id          = "circleci"
    display_name        = "CircleCI service account"
}

resource "google_project_iam_member" "viewer" {
    project             = "${var.project_id}"
    role                = "roles/viewer"
    member              = "${var.viewer_member}"
}

# TODO - can we lock this down to the specific bucket?
resource "google_project_iam_member" "storage_admin" {
    project             = "${var.project_id}"
    role                = "roles/storage.admin"
    member              = "serviceAccount:${google_service_account.circleci.email}"
}

# TODO - can we lock this down to the specific bucket?
resource "google_project_iam_member" "storage_object_viewer" {
    project             = "${var.project_id}"
    role                = "roles/storage.objectViewer"
    member              = "${var.storage_object_viewer_member}"
}


output "circleci_service_account_email"     { value = "${google_service_account.circleci.email}" }
