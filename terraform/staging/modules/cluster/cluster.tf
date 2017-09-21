variable "project_id"           {}
variable "zones"                { type = "list" }
variable "node_count"           {}

# TODO - alpha/network-policy
# TODO - pre-emptible nodes
# TODO - maybe we can use smaller size?
# TODO - remove external IPs / SSH access
# TODO - disable http_load_balancing?  (We're using TCP protocol forwarding, I think)
# TODO - disable horizontal_pod_autoscaling

# Note that this isn't actually hooked up to the cluster here - it has to be done in k8s config
resource "google_compute_address" "cluster" {
    project             = "${var.project_id}"
    name                = "cluster"
}


# See https://www.terraform.io/docs/providers/google/r/container_node_pool.html#oauth_scopes
variable "basic_gke_oauth_scopes" {
    default = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
    ]
}


variable "extra_gke_oauth_scopes" {
    default = [
        "https://www.googleapis.com/auth/datastore",        # TODO - get rid of datastore
    ]
}


resource "google_container_cluster" "cluster" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "cluster"

    node_version        = "1.7.5"
    initial_node_count  = "${var.node_count}"

    node_config {
        machine_type    = "n1-standard-4"

        oauth_scopes    = "${concat(var.basic_gke_oauth_scopes, var.extra_gke_oauth_scopes)}"
    }
}


resource "google_container_node_pool" "worker" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "worker"
    cluster             = "${google_container_cluster.cluster.name}"

    initial_node_count  = 1

    node_config {
        machine_type    = "n1-standard-2"

        oauth_scopes    = "${var.basic_gke_oauth_scopes}"
    }
}


output "address" {
    value = "${google_compute_address.cluster.address}"
}