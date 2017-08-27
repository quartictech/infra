resource "google_compute_address" "analyse" {
    name            = "analyse"
}

resource "google_compute_instance" "analyse" {
    name            = "analyse"
    machine_type    = "g1-small"
    zone            = "${var.zone}"

    tags            = ["http-server", "https-server"]

    boot_disk {
        initialize_params {
            image   = "debian-cloud/debian-9"
        }
    }

    network_interface {
        network     = "default"

        access_config {
            nat_ip  = "${google_compute_address.analyse.address}"
        }
    }

    service_account {
        scopes = ["compute-rw"]
    }
}