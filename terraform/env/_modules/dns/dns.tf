variable "global_project_id"    {}
variable "global_zone_name"     {}
variable "domain_name"          {}
variable "ttl"                  {}
variable "cluster_address"      {}
variable "cluster_subdomains"   { default = ["*.", ""] }


# NOTE: We set these in global DNS
resource "google_dns_record_set" "cluster" {
    count           = "${length(var.cluster_subdomains)}"
    project         = "${var.global_project_id}"
    name            = "${element(var.cluster_subdomains, count.index)}${var.domain_name}"
    managed_zone    = "${var.global_zone_name}"
    ttl             = "${var.ttl}"
    type            = "A"
    rrdatas         = ["${var.cluster_address}"]
}

# NOTE: this is a hack so that we're using GitHub pages to serve up the website
resource "google_dns_record_set" "www" {
    project         = "${var.global_project_id}"
    name            = "www.${var.domain_name}"
    managed_zone    = "${var.global_zone_name}"
    ttl             = "${var.ttl}"
    type            = "CNAME"
    rrdatas         = ["quartictech.github.io"]
}