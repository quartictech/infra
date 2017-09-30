variable "project_id"                       {}
variable "viewer_member"                    {}
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
    role                = "roles/container.developer"
    member              = "${element(var.container_developer_members, count.index)}"
}


output "cluster_service_account_email"      { value = "${google_service_account.cluster.email}" }