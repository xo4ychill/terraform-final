variable "name" {
  description = "Имя Container Registry"
  type        = string
}

variable "folder_id" {
  description = "ID каталога, в котором создаётся реестр"
  type        = string
}

variable "environment" {
  description = "Окружение (prod/staging/dev)"
  type        = string
}