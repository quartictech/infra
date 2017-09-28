variable "project_id"           {}
variable "dns_name"             {}
variable "ttl"                  {}
variable "cluster_address"      {}


resource "google_dns_managed_zone" "zone" {
    project         = "${var.project_id}"
    name            = "primary-zone"
    dns_name        = "${var.dns_name}"
}

variable "cluster_domains" {
    default = ["*.", ""]
}

resource "google_dns_record_set" "cluster" {
    count           = "${length(var.cluster_domains)}"
    project         = "${var.project_id}"
    name            = "${element(var.cluster_domains, count.index)}${google_dns_managed_zone.zone.dns_name}"
    managed_zone    = "${google_dns_managed_zone.zone.name}"
    ttl             = "${var.ttl}"
    type            = "A"
    rrdatas         = ["${var.cluster_address}"]
}


output "name_servers"           { value = "${google_dns_managed_zone.zone.name_servers}" }
