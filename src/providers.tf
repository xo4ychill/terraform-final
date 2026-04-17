# ======================================================================
# providers.tf — Настройка провайдера Yandex Cloud и удалённого бэкенда
# ======================================================================

terraform {
  required_version = ">= 1.12.0"   # Минимальная версия Terraform

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.120.0"       # Актуальная версия провайдера Yandex Cloud
    }
  }

  # ===== УДАЛЁННЫЙ БЭКЕНД (Remote state) в Yandex Object Storage =====
  # ВНИМАНИЕ: для первого запуска закомментируйте этот блок, создайте бакет,
  # затем раскомментируйте и выполните 'terraform init -reconfigure'.
#  backend "s3" {
#    bucket = "tf.state-bucket"   # ← замените на реальное имя бакета после создания
#    key    = "${terraform.workspace}/terraform.tfstate"
#    region = "ru-central1"
#
#    # Встроенный механизм блокировок через файл в бакете (Terraform >= 1.6)
#    use_lockfile = true
#
#    # Endpoint для Yandex Cloud Object Storage (S3-совместимый)
#    endpoints = {
#      s3 = "https://storage.yandexcloud.net"
#    }
#
#    # Параметры, необходимые для работы с Yandex Cloud S3 API
#    skip_region_validation      = true
#    skip_credentials_validation = true
#    skip_requesting_account_id  = true
#    skip_s3_checksum            = true
#
#    # Ключи доступа можно передать через переменные окружения
#    # AWS_ACCESS_KEY_ID и AWS_SECRET_ACCESS_KEY, либо указать здесь:
#    # access_key = "<static_access_key>"
#    # secret_key = "<static_secret_key>"
#  }
}

# ===== Провайдер Yandex Cloud =====
provider "yandex" {
  # Аутентификация через ключ сервисного аккаунта (JSON-файл)
  service_account_key_file = pathexpand(var.service_account_key_file)

  cloud_id  = var.cloud_id      # Идентификатор облака
  folder_id = var.folder_id     # Идентификатор каталога
  zone      = var.default_zone  # Зона доступности по умолчанию
}