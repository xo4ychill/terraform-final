# ======================================================================
# Модуль Bucket — создание бакета в Object Storage для remote state
# ======================================================================

# Генерируем случайный суффикс, чтобы имя бакета было глобально уникальным
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "yandex_storage_bucket" "state_bucket" {
  # Имя бакета = базовое имя + случайный суффикс
  bucket = "${var.bucket_name}-${random_string.suffix.result}"

  # Версионирование позволяет хранить историю изменений state-файлов
  versioning {
    enabled = true
  }

  # Автоматическое удаление старых версий через 30 дней
  lifecycle_rule {
    id      = "cleanup-old-state-versions"
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

}