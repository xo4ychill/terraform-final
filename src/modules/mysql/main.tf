# ======================================================================
# Модуль MySQL — Yandex Managed Service for MySQL
# ======================================================================

resource "yandex_mdb_mysql_cluster" "cluster" {
  name        = "${var.environment}-mysql-cluster"
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
  labels = { environment = var.environment }
  lifecycle { prevent_destroy = false }
}

resource "yandex_mdb_mysql_database" "database" {
  cluster_id = yandex_mdb_mysql_cluster.cluster.id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "user" {
  depends_on = [yandex_mdb_mysql_database.database]

  cluster_id = yandex_mdb_mysql_cluster.cluster.id
  name       = var.db_user
  password   = var.db_password

  permission {
    database_name = var.db_name
    roles         = ["ALL"]
  }

  global_permissions = ["PROCESS", "REPLICATION_CLIENT"]

  connection_limits {
    max_questions_per_hour   = 0
    max_updates_per_hour     = 0
    max_connections_per_hour = 0
    max_user_connections     = 10
  }
}