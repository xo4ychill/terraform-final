output "security_group_id" {
  description = "ID созданной группы безопасности"
  value       = yandex_vpc_security_group.sg.id
}