variable "project_id"           {}


resource "google_service_account" "circleci" {
    project             = "${var.project_id}"
    account_id          = "circleci"
    display_name        = "CircleCI service account"
}


output "email"                      { value = "${google_service_account.circleci.email}" }