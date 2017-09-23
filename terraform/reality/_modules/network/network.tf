variable "project_id"           {}

# TODO - should these be in a dedicated network?

resource "google_compute_firewall" "default_allow_http" {
    project             = "${var.project_id}"
    name                = "default-allow-http"
    network             = "default"

    allow {
        protocol        = "tcp"
        ports           = ["80"]
    }

    target_tags         = ["http-server"]
}

resource "google_compute_firewall" "default_allow_https" {
    project             = "${var.project_id}"
    name                = "default-allow-https"
    network             = "default"

    allow {
        protocol        = "tcp"
        ports           = ["443"]
    }

    target_tags         = ["https-server"]
}
