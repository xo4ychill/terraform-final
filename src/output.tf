# ======================================================================
# outputs.tf — Вывод полезной информации после развёртывания
# ======================================================================

output "vm_external_ip" {
  description = "Внешний IP-адрес виртуальной машины (для доступа по HTTP/SSH)"
  value       = module.vm.external_ip
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес виртуальной машины"
  value       = module.vm.internal_ip
}

output "mysql_cluster_id" {
  description = "ID кластера MySQL"
  value       = module.mysql.cluster_id
}

output "mysql_connection_string" {
  description = "Строка подключения к MySQL (без пароля)"
  value       = "mysql://${var.mysql_user}@${module.mysql.db_host}:${module.mysql.db_port}/${var.mysql_db_name}"
  sensitive   = true
}

output "registry_url" {
  description = "URL Container Registry для загрузки образов"
  value       = local.registry_url
}

output "vm_service_account_id" {
  description = "ID сервисного аккаунта, привязанного к ВМ"
  value       = yandex_iam_service_account.vm_sa.id
}