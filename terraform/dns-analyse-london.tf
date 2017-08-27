resource "google_dns_managed_zone" "analyse" {
  name              = "analyse-london-zone"
  dns_name          = "analyse.london."
}


#-----------------------------------------------------------------------------#
# analyse.london web
#-----------------------------------------------------------------------------#
variable "analyse_domains" {
    default = [
        "",
        "www.",
    ]
}

resource "google_dns_record_set" "analyse" {
    count           = "${length(var.analyse_domains)}"
    name            = "${element(var.analyse_domains, count.index)}${google_dns_managed_zone.analyse.dns_name}"
    managed_zone    = "${google_dns_managed_zone.analyse.name}"
    ttl             = "${var.dns_ttl}"
    type            = "A"
    rrdatas         = ["${google_compute_address.analyse.address}"]
}

