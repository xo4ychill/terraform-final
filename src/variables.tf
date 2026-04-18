# ======================================================================
# variables.tf — Описание всех входных переменных (без хардкода)
# ======================================================================

# ----- Основные параметры облака -----
variable "cloud_id" {
  description = "Идентификатор облака Yandex Cloud"
  type        = string
}

variable "folder_id" {
  description = "Идентификатор каталога для развёртывания"
  type        = string
}

variable "default_zone" {
  description = "Зона доступности по умолчанию"
  type        = string
}

variable "service_account_key_file" {
  description = "Путь к файлу ключа сервисного аккаунта (JSON)"
  type        = string
  sensitive   = true   # Не показывать в логах
}

variable "environment" {
  description = "Окружение: prod / staging / dev"
  type        = string
}

# ----- Параметры сети (VPC) -----
variable "vpc_name" {
  description = "Имя облачной сети"
  type        = string
}

variable "subnet_name" {
  description = "Имя подсети"
  type        = string
}

variable "v4_cidr_blocks" {
  description = "CIDR-блок подсети (список из одного элемента)"
  type        = list(string)
}

# ----- Параметры виртуальной машины -----
variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "image_family" {
  description = "Семейство образа ОС (например, ubuntu-2204-lts)"
  type        = string
}

variable "vm_cores" {
  description = "Количество vCPU"
  type        = number
}

variable "vm_memory" {
  description = "Объём оперативной памяти в гигабайтах"
  type        = number
}

variable "vm_disk_size" {
  description = "Размер загрузочного диска в гигабайтах"
  type        = number
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR-блок, с которого разрешён SSH (null — запретить)"
  type        = string
  default     = null
}

variable "preemptible" {
  description = "Использовать прерываемую ВМ (дешевле, но может быть остановлена)"
  type        = bool
}

# ----- Параметры MySQL -----
variable "mysql_version" {
  description = "Версия MySQL (8.0 или 8.4)"
  type        = string
}

variable "mysql_db_name" {
  description = "Имя создаваемой базы данных"
  type        = string
}

variable "mysql_user" {
  description = "Имя пользователя базы данных"
  type        = string
}

variable "mysql_password" {
  description = "Пароль пользователя базы данных"
  type        = string
  sensitive   = true
}

# ----- Container Registry -----
variable "existing_registry_id" {
  description = "ID существующего Container Registry (например, crp1nhdjvh1pkotfi5l3)"
  type        = string
}

# ----- Параметры бэкенда -----
variable "state_bucket_name" {
  description = "Имя бакета для хранения состояния Terraform"
  type        = string
}