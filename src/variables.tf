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
  description = "Путь к файлу ключа сервисного аккаунта (JSON)"
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
  validation {
    condition     = length(var.vpc_name) >= 3 && length(var.vpc_name) <= 63
    error_message = "Имя сети должно быть от 3 до 63 символов"
  }
}

variable "subnet_name" {
  description = "Имя подсети"
  type        = string
  default     = "app-subnet"
  validation {
    condition     = length(var.subnet_name) >= 3 && length(var.subnet_name) <= 63
    error_message = "Имя подсети должно быть от 3 до 63 символов"
  }
}

variable "v4_cidr_blocks" {
  description = "CIDR-блок подсети"
  type        = list(string)
  default     = ["192.168.10.0/24"]
  validation {
    condition     = length(var.v4_cidr_blocks) == 1 && can(cidrhost(var.v4_cidr_blocks[0], 0))
    error_message = "Укажите ровно один валидный CIDR-блок."
  }
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
  validation {
    condition     = contains([2, 4, 8, 16, 32], var.vm_cores)
    error_message = "Допустимые значения CPU: 2, 4, 8, 16, 32"
  }
}

variable "vm_memory" {
  description = "Объём ОЗУ (ГБ)"
  type        = number
  default     = 4
  validation {
    condition     = contains([2, 4, 8, 16, 32, 64], var.vm_memory)
    error_message = "Допустимые значения памяти: 2, 4, 8, 16, 32, 64 ГБ"
  }
}

variable "vm_disk_size" {
  description = "Размер диска (ГБ)"
  type        = number
  default     = 20
  validation {
    condition     = var.vm_disk_size >= 20 && var.vm_disk_size <= 4096
    error_message = "Размер диска должен быть от 20 до 4096 ГБ"
  }
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
  validation {
    condition     = can(regex("^ssh-(rsa|ed25519) ", var.ssh_public_key))
    error_message = "Некорректный формат SSH-ключа"
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR для SSH (null — запретить)"
  type        = string
  default     = null
  validation {
    condition     = var.allowed_ssh_cidr == null ? true : can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Укажите валидный CIDR-блок"
  }
}

variable "preemptible" {
  description = "Использовать прерываемую ВМ (дешевле, но может быть остановлена)"
  type        = bool
  default     = false
}

# -------------------- MySQL --------------------
variable "mysql_version" {
  description = "Версия MySQL"
  type        = string
  default     = "8.0"
  validation {
    condition     = contains(["8.0", "8.4"], var.mysql_version)
    error_message = "Поддерживаемые версии: 8.0, 8.4"
  }
}

variable "mysql_db_name" {
  description = "Имя базы данных"
  type        = string
  default     = "appdb"
  validation {
    condition     = can(regex("^[a-z][a-z0-9_]{2,63}$", var.mysql_db_name))
    error_message = "Имя БД: от 3 до 64 символов, латиница и _"
  }
}

variable "mysql_user" {
  description = "Имя пользователя MySQL"
  type        = string
  default     = "appuser"
  validation {
    condition     = can(regex("^[a-z][a-z0-9_]{2,63}$", var.mysql_user))
    error_message = "Имя пользователя: от 3 до 64 символов"
  }
}

variable "mysql_password" {
  description = "Пароль пользователя MySQL"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.mysql_password) >= 12 && can(regex("[A-Z]", var.mysql_password)) && can(regex("[0-9]", var.mysql_password))
    error_message = "Пароль должен быть ≥12 символов, содержать заглавную букву и цифру"
  }
}

# -------------------- Container Registry --------------------
variable "registry_name" {
  description = "Имя Container Registry"
  type        = string
  default     = "app-registry"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,63}$", var.registry_name))
    error_message = "Имя реестра: от 3 до 63 символов, латиница, цифры, дефис"
  }
}

# -------------------- State Bucket --------------------
variable "state_bucket_name" {
  description = "Базовое имя бакета для хранения состояния Terraform"
  type        = string
  default     = "tf-state-bucket"
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-.]{1,61}[a-z0-9]$", var.state_bucket_name))
    error_message = "Имя бакета должно быть от 3 до 63 символов, латиница, цифры, дефис, точка."
  }
}