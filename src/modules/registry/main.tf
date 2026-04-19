# ======================================================================
# Модуль Registry — Yandex Container Registry
# ======================================================================

# Создание управляемого реестра Docker-образов в Yandex Cloud
resource "yandex_container_registry" "registry" {
  # Уникальное имя реестра в пределах указанной папки (folder)
  # Может содержать строчные буквы, цифры и дефисы
  name      = var.name
  # ID папки Yandex Cloud, в которой будет размещён реестр
  # Все ресурсы и IAM-политики наследуются от этой папки
  folder_id = var.folder_id

  # Метки (labels) для категоризации, фильтрации ресурсов и учёта затрат
  labels = {
    environment = var.environment     # Окружение: prod / dev / staging
    managed_by  = "terraform"         # Подчёркивает, что инфраструктура управляется кодом
  }

  # Защита от случайного удаления через terraform destroy
  lifecycle {
    prevent_destroy = false           # Рекомендуется true для production-окружений
  }
}