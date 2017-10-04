project_name                = "Quartic - Production env"
project_id_prefix           = "quartic-prod"
region                      = "europe-west1"
domain_name                 = "quartic.io."
dns_ttl                     = 3600

cluster_name                = "prod"
cluster_core_node_type      = "n1-standard-4"
cluster_core_node_count     = 1
cluster_worker_node_type    = "n1-standard-2"
cluster_worker_node_count   = 1

container_developer_group   = "core@quartic.io"             # TODO - this can't be true long-term