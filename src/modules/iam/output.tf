output "service_account_id" {
  description = "ID созданного сервисного аккаунта"
  value       = yandex_iam_service_account.vm_sa.id
}