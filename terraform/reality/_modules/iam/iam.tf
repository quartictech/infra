variable "project_id"               {}
variable "viewer_member"            {}
variable "instance_admin_member"    {}


# TODO - remove this once we find a better way to provision the Ansible stuff
data "google_iam_policy" "www" {
    binding {
        role            = "roles/iam.serviceAccountActor"
        members         = [ "${var.instance_admin_member}" ]
    }
}

resource "google_service_account" "www" {
    project             = "${var.project_id}"
    account_id          = "www-instance"
    display_name        = "WWW instance service account"
    policy_data         = "${data.google_iam_policy.www.policy_data}"
}

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
    member              = "serviceAccount:${google_service_account.circleci.email}"
}

resource "google_project_iam_member" "storage_viewer" {
    project             = "${var.project_id}"
    role                = "roles/storage.objectViewer"
    member              = "serviceAccount:${google_service_account.www.email}"
}


output "www_service_account_email"          { value = "${google_service_account.www.email}" }
output "circleci_service_account_email"     { value = "${google_service_account.circleci.email}" }