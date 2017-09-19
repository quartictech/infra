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


resource "google_container_cluster" "cluster" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "cluster"

    node_version        = "1.7.5"
    initial_node_count  = "${var.node_count}"

    node_config {
        machine_type    = "n1-standard-4"

        oauth_scopes    = [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            # TODO - can remove datastore eventually
            "https://www.googleapis.com/auth/datastore",
        ]
    }
}

output "address" {
    value = "${google_compute_address.cluster.address}"
}