variable "network_id" {
  description = "ID сети, в которой создаётся кластер"
  type        = string
}

variable "subnet_id" {
  description = "ID подсети для размещения хоста"
  type        = string
}

variable "zone" {
  description = "Зона доступности для хоста"
  type        = string
}

variable "environment" {
  description = "Окружение (PRODUCTION/PRESTABLE)"
  type        = string
}

variable "mysql_version" {
  description = "Версия MySQL"
  type        = string
}

variable "db_name" {
  description = "Имя создаваемой базы данных"
  type        = string
}

variable "db_user" {
  description = "Имя пользователя БД"
  type        = string
}

variable "db_password" {
  description = "Пароль пользователя БД"
  type        = string
  sensitive   = true           # Скрывает значение в выводе terraform plan/apply
}

variable "security_group_ids" {
  description = "Список ID групп безопасности"
  type        = list(string)
}