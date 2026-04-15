# ======================================================================
# outputs.tf — Вывод результатов после terraform apply
# ======================================================================

output "vpc_network_id" {
  description = "ID созданной сети VPC"
  value       = module.vpc.network_id
}

output "vpc_subnet_id" {
  description = "ID созданной подсети"
  value       = module.vpc.subnet_id
}

output "security_group_id" {
  description = "ID группы безопасности"
  value       = module.security.security_group_id
}

output "vm_external_ip" {
  description = "Внешний IP-адрес ВМ"
  value       = module.vm.external_ip
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = module.vm.internal_ip
}

output "mysql_cluster_id" {
  description = "ID кластера Managed MySQL"
  value       = module.mysql.cluster_id
}

output "mysql_connection_string" {
  description = "Строка подключения к MySQL (без пароля)"
  value       = "mysql://${var.mysql_user}@${module.mysql.db_host}:${module.mysql.db_port}/${var.mysql_db_name}"
  sensitive   = true
}

output "registry_url" {
  description = "URL Container Registry для docker push/pull"
  value       = module.registry.registry_url
}

output "registry_id" {
  description = "ID Container Registry"
  value       = module.registry.registry_id
}