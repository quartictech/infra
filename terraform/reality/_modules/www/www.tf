variable "project_id"               {}
variable "zones"                    { type = "list" }
variable "service_account_email"    {}


# Note that this isn't actually hooked up to the cluster here - it has to be done in k8s config
resource "google_compute_address" "www" {
    project             = "${var.project_id}"
    name                = "www"
}


# See https://www.terraform.io/docs/providers/google/r/container_node_pool.html#oauth_scopes
# TODO - should do this via IAM
variable "basic_gke_oauth_scopes" {
    default = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
    ]
}


resource "google_container_cluster" "www" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "${var.name}"

    node_version        = "1.7.5"

    initial_node_count  = "1"
    node_config {
        machine_type    = "g1-small"

        # We control access through service-account IAM
        # (see https://cloud.google.com/compute/docs/access/service-accounts#service_account_permissions)

        # TODO - hook up to service account email
        oauth_scopes    = [ "https://www.googleapis.com/auth/cloud-platform" ]
    }
}


output "address"                    { value = "${google_compute_address.www.address}" }
