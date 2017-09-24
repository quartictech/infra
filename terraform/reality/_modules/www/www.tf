variable "project_id"               {}
variable "zones"                    { type = "list" }
variable "service_account_email"    {}


resource "google_compute_address" "www" {
    project             = "${var.project_id}"
    name                = "www"
}

resource "google_compute_instance" "www" {
    project             = "${var.project_id}"
    zone                = "${var.zones[0]}"
    name                = "www"
    machine_type        = "g1-small"

    tags                = ["http-server", "https-server"]

    boot_disk {
        initialize_params {
            image       = "debian-cloud/debian-8"
        }
    }

    network_interface {
        network         = "default"
        access_config {
            nat_ip      = "${google_compute_address.www.address}"
        }
    }

    # We control access through service-account IAM
    # (see https://cloud.google.com/compute/docs/access/service-accounts#service_account_permissions)
    service_account {
        email           = "${var.service_account_email}"
        scopes          = [ "https://www.googleapis.com/auth/cloud-platform" ]
    }
}


output "address"                    { value = "${google_compute_address.www.address}" }
