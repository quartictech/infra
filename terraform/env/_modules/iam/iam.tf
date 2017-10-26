variable "project_id"                       {}
variable "global_project_id"                {}
variable "viewer_member"                    {}
variable "container_full_access"            {}
variable "container_developer_members"      { type = "list" }


resource "google_service_account" "cluster" {
    project             = "${var.project_id}"
    account_id          = "cluster"
    display_name        = "Cluster service account"
}

resource "google_project_iam_member" "viewer" {
    project             = "${var.project_id}"
    role                = "roles/viewer"
    member              = "${var.viewer_member}"
}

resource "google_project_iam_member" "container_developer" {
    count               = "${length(var.container_developer_members)}"
    project             = "${var.project_id}"
    role                = "roles/${var.container_full_access ? "container.clusterAdmin" : "container.developer"}"
    member              = "${element(var.container_developer_members, count.index)}"
}

# NOTE - this is a modification to global env
# TODO - can we lock this down to the specific bucket?
resource "google_project_iam_member" "storage_object_viewer" {
    project             = "${var.global_project_id}"
    role                = "roles/storage.objectViewer"
    member              = "serviceAccount:${google_service_account.cluster.email}"
}


output "cluster_service_account_email"      { value = "${google_service_account.cluster.email}" }
