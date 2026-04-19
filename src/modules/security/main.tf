# ======================================================================
# Модуль Security — Создание группы безопасности
# Порты: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3306 (MySQL)
# ======================================================================

resource "yandex_vpc_security_group" "sg" {
  name        = var.name
  description = var.description
  network_id  = var.network_id

  # SSH (только если задан CIDR)
  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr != null ? [1] : []
    content {
      description    = "SSH"
      protocol       = "TCP"
      port           = 22
      v4_cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  # HTTP (публичный доступ)
  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (публичный доступ)
  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL (только из подсети приложения)
  ingress {
    description    = "MySQL"
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = var.app_subnet_cidrs
  }

  # Исходящий трафик (необходим для работы Docker и обновлений)
  egress {
    description    = "HTTPS out"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "HTTP out"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "DNS"
    protocol       = "UDP"
    port           = 53
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    description    = "MySQL out"
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = var.app_subnet_cidrs   # можно ограничить только подсетью MySQL
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}