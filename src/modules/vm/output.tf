output "external_ip" {
  description = "Внешний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.vm.id
}