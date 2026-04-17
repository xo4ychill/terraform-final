# ======================================================================
# outputs.tf — Вывод результатов после terraform apply
# ======================================================================

output "state_bucket_name" {
  description = "Фактическое имя созданного бакета для remote state"
  value       = module.state_bucket.bucket_name
}

output "vm_external_ip" {
  description = "Внешний IP-адрес виртуальной машины"
  value       = module.vm.external_ip
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес виртуальной машины"
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

output "vm_service_account_id" {
  description = "ID сервисного аккаунта, привязанного к ВМ"
  value       = module.iam.service_account_id
}