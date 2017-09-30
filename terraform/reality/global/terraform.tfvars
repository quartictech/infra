project_name                    = "Quartic - Global env"
project_id_prefix               = "quartic-global"
region                          = "europe-west1"
dns_name                        = "global.quartic.io."  # TODO - switch this back
dns_ttl                         = 60

# TODO - eliminate these by having other workspaces write to this project
staging_service_account_email   = "cluster@quartic-staging-79680f42.iam.gserviceaccount.com"
staging_name_servers            = [
    "ns-cloud-b1.googledomains.com.",
    "ns-cloud-b2.googledomains.com.",
    "ns-cloud-b3.googledomains.com.",
    "ns-cloud-b4.googledomains.com.",
]
prod_service_account_email      = "cluster@quartic-prod-5df2e1f7.iam.gserviceaccount.com"
prod_name_servers               = [
    "ns-cloud-d1.googledomains.com.",
    "ns-cloud-d2.googledomains.com.",
    "ns-cloud-d3.googledomains.com.",
    "ns-cloud-d4.googledomains.com.",
]