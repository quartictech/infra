variable "project_id"           {}
variable "zones"                { type = "list" }
variable "node_count"           {}

# TODO - alpha/network-policy
# TODO - pre-emptible nodes
# TODO - maybe we can use smaller size?

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
    }
}

output "address" {
    value = "${google_compute_address.cluster.address}"
}