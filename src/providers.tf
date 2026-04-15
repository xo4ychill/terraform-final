# ======================================================================
# providers.tf — Настройка Terraform и провайдера Yandex Cloud
# ======================================================================

terraform {
  required_version = ">= 1.12.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.120.0"
    }
  }
}

  # ===== Провайдер Yandex Cloud =====
provider "yandex" {
  # Ключ сервисного аккаунта (должен иметь права editor на каталог)
  service_account_key_file = pathexpand(var.service_account_key_file)

  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}