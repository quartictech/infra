variable "project_id"           {}
variable "zones"                { type = "list" }


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
}

output "address" {
    value = "${google_compute_address.www.address}"
}