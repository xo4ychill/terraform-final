# ======================================================================
# Модуль VM — виртуальная машина с cloud-init
# ======================================================================

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

locals {
  # Формируем cloud-init конфигурацию, подставляя переменные
  cloud_init_content = templatefile("${path.module}/cloud-init.yaml.tpl", {
    ssh_public_key = var.ssh_public_key
    DB_HOST        = var.db_host
    DB_PORT        = var.db_port
    DB_NAME        = var.db_name
    DB_USER        = var.db_user
    DB_PASSWORD    = var.db_password
    REGISTRY_URL   = var.registry_url
  })
}

resource "yandex_compute_instance" "vm" {
  name               = var.vm_name
  platform_id        = "standard-v3"
  zone               = var.zone
  service_account_id = var.service_account_id   # Привязка сервисного аккаунта

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vm_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    nat                = true   # Публичный IP
    security_group_ids = var.security_group_ids
  }

  metadata = {
    user-data          = local.cloud_init_content
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  labels = {
    project     = var.project_label
    environment = var.environment_label
    managed_by  = "terraform"
  }
}