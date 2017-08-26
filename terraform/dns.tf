resource "google_dns_managed_zone" "prod" {
  name              = "prod-zone"
  dns_name          = "quartic.io."
}


#-----------------------------------------------------------------------------#
# MX records for GMail
#   - see https://support.google.com/a/answer/174125?hl=en
#-----------------------------------------------------------------------------#
resource "google_dns_record_set" "gmail" {
    name            = "${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "MX"
    rrdatas         = [
        "1 aspmx.l.google.com.",
        "5 alt1.aspmx.l.google.com.",
        "5 alt2.aspmx.l.google.com.",
        "10 alt3.aspmx.l.google.com.",
        "10 alt4.aspmx.l.google.com."
    ]
}


#-----------------------------------------------------------------------------#
# CNAME records for GSuite
#   - see https://support.google.com/a/answer/53340?hl=en
#-----------------------------------------------------------------------------#
variable "gsuite_domains" {
    default = [
        "calendar.",
        "drive.",
        "groups.",
        "mail.",
        "sites."
    ]
}

resource "google_dns_record_set" "gsuite" {
    count           = 5
    name            = "${element(var.gsuite_domains, count.index)}${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "CNAME"    
    rrdatas         = ["ghs.googlehosted.com."]
}


#-----------------------------------------------------------------------------#
# SPF
#   - see http://www.openspf.org/FAQ/Common_mistakes
#   - see https://support.google.com/a/answer/178723?hl=en
# Google site verification
#   - unclear what these are actually for
#-----------------------------------------------------------------------------#
resource "google_dns_record_set" "txt_www" {
    name            = "www.${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "TXT"
    rrdatas         = ["\"v=spf1 -all\""]
}

resource "google_dns_record_set" "txt_root" {
    name            = "${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "TXT"
    rrdatas         = [
        "\"v=spf1 include:_spf.google.com ~all\"",   // SPF
        "\"google-site-verification=QPc-DPCteG5ltl3yeNCWSezM0rZagUXxDifOL8-1yo4\"",
        "\"google-site-verification=_R1PXuzP4Xh-muNylkpSmSZU7giMtNm_tbsloIo_mmY\""
    ]
}


#-----------------------------------------------------------------------------#
# DKIM
#   - see https://support.google.com/a/answer/174124?hl=en
#   - TODO - Upgrade to 2048-bit key
#-----------------------------------------------------------------------------#
resource "google_dns_record_set" "dkim" {
    name            = "google._domainkey.${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "TXT"
    rrdatas         = ["\"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDY29qg5tchKjhA0JmUUCAuQTj7CKHI3h+0d4CBh40ovRKaEeurYmpGvck5dFMIhrzEu0RR23DolxUSLcmC646YNZF48Sq9NFYpToebf68sSToEmYMg+t09mx1g3nYV9YykWpblm81ub369TKLOrojbf7hNDllNXvZsWaMCt9mYEQIDAQAB\""]
}


#-----------------------------------------------------------------------------#
# DMARC
#   - see https://support.google.com/a/answer/2466563
#-----------------------------------------------------------------------------#
resource "google_dns_record_set" "dmarc" {
    name            = "_dmarc.${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "TXT"
    rrdatas         = ["\"v=DMARC1; p=none; rua=mailto:postmaster@quartic.io\""]
}


#-----------------------------------------------------------------------------#
# WWW
#-----------------------------------------------------------------------------#
variable "www_domains" {
    default = [
        "",
        "www.",
        "www-test.",
        "tools."
    ]
}

resource "google_dns_record_set" "www" {
    count           = 3
    name            = "${element(var.www_domains, count.index)}${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "A"
    rrdatas         = ["${google_compute_address.www.address}"]
}


#-----------------------------------------------------------------------------#
# Kubernetes
#-----------------------------------------------------------------------------#
resource "google_dns_record_set" "gke" {
    name            = "*.${google_dns_managed_zone.prod.dns_name}"
    managed_zone    = "${google_dns_managed_zone.prod.name}"
    ttl             = "${var.dns_ttl}"
    type            = "A"
    rrdatas         = ["${google_compute_address.gke.address}"]
}

