variable "project_id"               {}
variable "zones"                    { type = "list" }
variable "name"                     {}
variable "service_account_email"    {}
variable "core_node_count"          {}
variable "worker_node_count"        {}

# TODO - alpha/network-policy
# TODO - pre-emptible nodes
# TODO - remove SSH access with ingress firewall
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


# We need this for Howl to be able to write to GCS buckets
variable "core_node_pool_extra_scopes" {
    default = [
        "https://www.googleapis.com/auth/devstorage.read_write",
    ]
}


# Management of node pools is somewhat raging right now, see:
#
#  - https://github.com/terraform-providers/terraform-provider-google/issues/285
#  - https://github.com/terraform-providers/terraform-provider-google/issues/408
#
# Basically, if we embed the node-pool definitions in the google_container_cluster resource, then any change to any
# pool causes the entire cluster to be rebuilt.  But if we define the node pools as separate resources, we can use
# ignore_changes to prevent entire rebuilds.  However, we then need to define a noob little node as part of the
# cluster itself.
resource "google_container_cluster" "cluster" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "${var.name}"

    node_version        = "1.7.6"

    lifecycle {
        ignore_changes  = ["node_pools"]
    }

    # We don't actually want this, but forced to have it.  So make as small as possible.
    initial_node_count  = "1"
    node_config {
        machine_type    = "g1-small"
        service_account = "${var.service_account_email}"
        oauth_scopes    = "${var.basic_gke_oauth_scopes}"
    }
}

# TODO - we need to add write access to GCS for Jupyter to work
resource "google_container_node_pool" "core" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "core"
    cluster             = "${google_container_cluster.cluster.name}"

    initial_node_count  = "${var.core_node_count}"
    node_config {
        machine_type    = "n1-standard-2"
        service_account = "${var.service_account_email}"
        oauth_scopes    = "${concat(var.basic_gke_oauth_scopes, var.core_node_pool_extra_scopes)}"
    }

    lifecycle {
        create_before_destroy = true
    }
}


resource "google_container_node_pool" "worker" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "worker"
    cluster             = "${google_container_cluster.cluster.name}"

    initial_node_count  = "${var.worker_node_count}"
    node_config {
        machine_type    = "n1-standard-2"
        service_account = "${var.service_account_email}"
        oauth_scopes    = "${var.basic_gke_oauth_scopes}"
    }

    lifecycle {
        create_before_destroy = true
    }
}


output "address" {
    value = "${google_compute_address.cluster.address}"
}