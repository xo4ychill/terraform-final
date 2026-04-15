resource "yandex_mdb_mysql_cluster" "cluster" {
  name        = "${var.environment}-mysql-cluster"
  # Для ресурса MySQL environment должно быть PRODUCTION или PRESTABLE
  environment = var.environment == "prod" ? "PRODUCTION" : "PRESTABLE"
  network_id  = var.network_id
  version     = var.mysql_version

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  mysql_config = {
    innodb_buffer_pool_size = 1073741824
    max_connections         = 100
    sql_mode                = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
  }

  backup_window_start {
    hours   = 3
    minutes = 0
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone             = var.zone
    subnet_id        = var.subnet_id
    assign_public_ip = false
  }

  security_group_ids = var.security_group_ids

  # Метки должны содержать только строчные буквы, цифры и разрешённые символы
  labels = {
    environment = var.environment   # prod, staging, dev (уже строчными)
  }

  lifecycle {
    prevent_destroy = true
  }
}