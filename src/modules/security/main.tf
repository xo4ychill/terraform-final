# ======================================================================
# Модуль Security — группа безопасности
# ======================================================================

resource "yandex_vpc_security_group" "sg" {
  name        = var.name
  description = var.description
  network_id  = var.network_id

  # SSH доступ (только если задан CIDR)
  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr != null ? [1] : []
    content {
      description    = "SSH"
      protocol       = "TCP"
      port           = 22
      v4_cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL — только из подсети приложения
  ingress {
    description    = "MySQL"
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = var.app_subnet_cidrs
  }

  # Исходящий трафик
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

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}