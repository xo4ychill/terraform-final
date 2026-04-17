# ======================================================================
# Модуль Registry — Yandex Container Registry
# ======================================================================

resource "yandex_container_registry" "registry" {
  name      = var.name
  folder_id = var.folder_id
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}