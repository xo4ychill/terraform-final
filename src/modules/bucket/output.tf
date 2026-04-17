output "bucket_name" {
  description = "Фактическое имя созданного бакета"
  value       = yandex_storage_bucket.state_bucket.bucket
}

output "bucket_id" {
  description = "ID бакета"
  value       = yandex_storage_bucket.state_bucket.id
}