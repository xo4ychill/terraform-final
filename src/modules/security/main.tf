# ======================================================================
# Модуль Security — создание группы безопасности
# ======================================================================

resource "yandex_vpc_security_group" "sg" {
  name        = var.name
  description = var.description
  network_id  = var.network_id

  # ----- Входящие правила (Ingress) -----
  # SSH: только с доверенных адресов (если задан)
  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr != null ? [1] : []
    content {
      description    = "SSH access"
      protocol       = "TCP"
      port           = 22
      v4_cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  # HTTP: публичный доступ
  ingress {
    description    = "HTTP access"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS: публичный доступ
  ingress {
    description    = "HTTPS access"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL: только из подсети приложения
  ingress {
    description    = "MySQL from app subnet"
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = var.app_subnet_cidrs
  }

  # ----- Исходящие правила (Egress) -----
  egress {
    description    = "HTTPS outbound"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "HTTP outbound"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "DNS outbound"
    protocol       = "UDP"
    port           = 53
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}