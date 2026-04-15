variable "name" {
  description = "Имя группы безопасности"
  type        = string
}

variable "description" {
  description = "Описание группы безопасности"
  type        = string
}

variable "network_id" {
  description = "ID сети, к которой привязывается группа"
  type        = string
}

variable "environment" {
  description = "Окружение (prod/staging/dev)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR-блок, с которого разрешён SSH (null — запретить)"
  type        = string
  default     = null
}

variable "app_subnet_cidrs" {
  description = "CIDR-блоки подсети приложения (для доступа к MySQL)"
  type        = list(string)
}