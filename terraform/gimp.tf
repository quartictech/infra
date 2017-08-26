provider "google" {
    project         = "quartictech"
    region          = "${var.region}"
}

resource "google_compute_address" "gimp" {
    name            = "gimp"
}

resource "google_compute_instance" "gimp" {
    name            = "gimp"
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
            nat_ip  = "${google_compute_address.gimp.address}"
        }
    }

    service_account {
        scopes = ["compute-rw"]
    }
}