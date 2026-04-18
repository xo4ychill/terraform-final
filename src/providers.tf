# ======================================================================
# providers.tf — Настройка провайдера Yandex Cloud и удалённого бэкенда
# ======================================================================

terraform {
  # Минимальная версия Terraform (нужна для use_lockfile)
  required_version = ">= 1.6.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.120.0"   # Актуальная версия провайдера
    }
  }

  # ----- УДАЛЁННОЕ ХРАНЕНИЕ СОСТОЯНИЯ В OBJECT STORAGE С БЛОКИРОВКОЙ -----
  backend "s3" {
    # Имя бакета, в котором будет лежать state-файл (уникальное, создаётся заранее)
    bucket = "tf.state-bucket-fltfpt"
    # Путь к файлу внутри бакета
    key    = "terraform.tfstate"
    region = "ru-central1"

    # Включаем встроенный механизм блокировки через файл блокировки в бакете (Terraform >= 1.6)
    use_lockfile = true

    # Endpoint Yandex Object Storage (S3-совместимый)
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    # Отключаем проверки, не применимые к Yandex Cloud S3 API
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    # Ключи доступа задаются через переменные окружения:
    # AWS_ACCESS_KEY_ID и AWS_SECRET_ACCESS_KEY
  }
}

# ----- Провайдер Yandex Cloud -----
provider "yandex" {
  # Аутентификация через ключ сервисного аккаунта (JSON-файл)
  service_account_key_file = pathexpand(var.service_account_key_file)

  cloud_id  = var.cloud_id      # ID облака
  folder_id = var.folder_id     # ID каталога
  zone      = var.default_zone  # Зона доступности по умолчанию
}