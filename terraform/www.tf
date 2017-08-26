resource "google_compute_address" "www" {
    name            = "www-dummy"   # TODO - replace once happy
}

resource "google_compute_instance" "www" {
    name            = "www-dummy"   # TODO - replace once happy
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
            nat_ip  = "${google_compute_address.www.address}"
        }
    }

    service_account {
        scopes = ["compute-rw"]
    }
}