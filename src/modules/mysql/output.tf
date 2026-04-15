output "cluster_id" {
  description = "ID кластера MySQL"
  value       = yandex_mdb_mysql_cluster.cluster.id
}

output "db_host" {
  description = "FQDN хоста MySQL"
  value       = yandex_mdb_mysql_cluster.cluster.host[0].fqdn
}

output "db_port" {
  description = "Порт для подключения к MySQL"
  value       = 3306
}