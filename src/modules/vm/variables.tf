variable "service_account_id" { 
  description = "ID сервисного аккаунта для доступа к "
  type = string 
}
variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "project_label" {
  description = "Метка проекта"
  type        = string
}

variable "environment_label" {
  description = "Метка окружения"
  type        = string
}

variable "subnet_id" {
  description = "ID подсети для подключения ВМ"
  type        = string
}

variable "security_group_ids" {
  description = "Список ID групп безопасности"
  type        = list(string)
}

variable "zone" {
  description = "Зона доступности"
  type        = string
}

variable "image_family" {
  description = "Семейство образа ОС"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "vm_cores" {
  description = "Количество vCPU"
  type        = number
}

variable "vm_memory" {
  description = "Объём оперативной памяти (ГБ)"
  type        = number
}

variable "vm_disk_size" {
  description = "Размер загрузочного диска (ГБ)"
  type        = number
}

variable "preemptible" {
  description = "Использовать прерываемую ВМ"
  type        = bool
}

# Переменные для настройки подключения к БД и реестру (передаются в cloud-init)
variable "db_host" {
  description = "Хост базы данных MySQL"
  type        = string
}

variable "db_port" {
  description = "Порт базы данных MySQL"
  type        = number
}

variable "db_name" {
  description = "Имя базы данных"
  type        = string
}

variable "db_user" {
  description = "Имя пользователя БД"
  type        = string
}

variable "db_password" {
  description = "Пароль пользователя БД"
  type        = string
  sensitive   = true
}

variable "registry_url" {
  description = "URL Container Registry"
  type        = string
}

variable "sa_key_json"  {
  description = "Токен сервисного аккаунта для скачивание из registry "
  type = string
  sensitive = true 
}