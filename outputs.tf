output "cluster_fqdns_list" {
  description = "The list of fully qualified domain names (FQDN) for the ClickHouse cluster nodes."
  value       = module.clickhouse.cluster_fqdns_list
}

output "cluster_users" {
  description = "The list of users created in the ClickHouse cluster, including their passwords."
  value       = module.clickhouse.cluster_users
  sensitive   = true
}

output "databases" {
  description = "The list of databases created in the ClickHouse cluster."
  value       = module.clickhouse.databases
}

output "connection" {
  description = "The connection in which the ClickHouse cluster is deployed."
  value       = module.clickhouse.connection
  sensitive   = true
}
