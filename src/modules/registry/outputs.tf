output "registry_id" {
  description = "ID Container Registry"
  value       = yandex_container_registry.registry.id
}

output "registry_url" {
  description = "URL Container Registry для работы с Docker"
  value       = "cr.yandex/${yandex_container_registry.registry.id}"
}