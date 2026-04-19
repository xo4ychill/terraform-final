# ======================================================================
# variables.tf — Входные переменные с валидацией
# ======================================================================

variable "cloud_id" {
  description = "Идентификатор облака Yandex Cloud"
  type        = string
  validation {
    condition     = can(regex("^b1g[a-z0-9]+$", var.cloud_id))
    error_message = "cloud_id должен соответствовать формату Yandex Cloud (b1g...)."
  }
}

variable "folder_id" {
  description = "Идентификатор каталога для развёртывания"
  type        = string
  validation {
    condition     = can(regex("^b1g[a-z0-9]+$", var.folder_id))
    error_message = "folder_id должен соответствовать формату Yandex Cloud (b1g...)."
  }
}

variable "default_zone" {
  description = "Зона доступности по умолчанию"
  type        = string
  default     = "ru-central1-a"
  validation {
    condition     = contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], var.default_zone)
    error_message = "Допустимые зоны: ru-central1-a, ru-central1-b, ru-central1-d"
  }
}

variable "service_account_key_file" {
  description = "Путь к файлу ключа сервисного аккаунта (JSON) для Terraform"
  type        = string
  sensitive   = true
  validation {
    condition     = endswith(var.service_account_key_file, ".json")
    error_message = "Файл ключа должен иметь расширение .json"
  }
}

variable "environment" {
  description = "Окружение: prod / staging / dev"
  type        = string
  default     = "prod"
  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Допустимые значения: prod, staging, dev"
  }
}

# -------------------- VPC --------------------
variable "vpc_name" {
  description = "Имя сети VPC"
  type        = string
  default     = "app-network"
}

variable "subnet_name" {
  description = "Имя подсети"
  type        = string
  default     = "app-subnet"
}

variable "v4_cidr_blocks" {
  description = "CIDR-блок подсети"
  type        = list(string)
  default     = ["10.10.10.0/24"]
}

# -------------------- ВМ --------------------
variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "vm-app"
}

variable "image_family" {
  description = "Семейство образа ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Объём ОЗУ (ГБ)"
  type        = number
  default     = 4
}

variable "vm_disk_size" {
  description = "Размер диска (ГБ)"
  type        = number
  default     = 20
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR для SSH (null — запретить)"
  type        = string
  default     = null
}

variable "preemptible" {
  description = "Использовать прерываемую ВМ"
  type        = bool
  default     = false
}

# -------------------- Сервисный аккаунт для ВМ --------------------
variable "vm_service_account_id" {
  description = "ID существующего сервисного аккаунта с правами container-registry.images.puller"
  type        = string
}

# -------------------- MySQL --------------------
variable "mysql_version" {
  description = "Версия MySQL"
  type        = string
  default     = "8.0"
}

variable "mysql_db_name" {
  description = "Имя базы данных"
  type        = string
  default     = "appdb"
}

variable "mysql_user" {
  description = "Имя пользователя MySQL"
  type        = string
  default     = "appuser"
}

variable "mysql_password" {
  description = "Пароль пользователя MySQL"
  type        = string
  sensitive   = true
}

# -------------------- Container Registry --------------------
variable "registry_name" {
  description = "Имя Container Registry"
  type        = string
  default     = "app-registry"
}