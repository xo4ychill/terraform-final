# ======================================================================
# Модуль IAM — сервисный аккаунт и права доступа
# ======================================================================

resource "yandex_iam_service_account" "vm_sa" {
  name        = var.sa_name
  description = var.sa_description
}

# Права на скачивание образов из Container Registry
resource "yandex_resourcemanager_folder_iam_member" "registry_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}