variable "region" {
   default = "europe-west1"
}

variable "zone" {
    default = "europe-west1-b"
}

# Can be discovered via: gcloud beta organizations list
variable "org_id" {
    default = 2425379824
}

# Can be discovered via: gcloud alpha billing accounts list
variable "billing_account" {
    default = "00798C-5FD4EC-188617"
}

variable "project_name" {
    default = "quartic-gibberish"
}

variable "dns_ttl" {
    default = 60
}