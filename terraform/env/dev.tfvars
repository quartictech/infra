project_name                = "Quartic - Dev"
project_id_prefix           = "quartic-dev"
region                      = "europe-west1"
domain_name                 = "dev.quartic.io."
dns_ttl                     = 3600

cluster_name                = "dev"
cluster_core_node_type      = "n1-standard-2"
cluster_core_node_count     = 1
cluster_core_preemptible    = true
cluster_worker_node_type    = "n1-standard-1"
cluster_worker_node_count   = 1
cluster_worker_preemptible  = true
cluster_full_access         = true

container_developer_group   = "core@quartic.io"
