# ======================================================================
# main.tf — ОСНОВНАЯ СБОРКА ИНФРАСТРУКТУРЫ
# ======================================================================

# ----- ПОЛУЧЕНИЕ ДАННЫХ О СУЩЕСТВУЮЩЕМ РЕЕСТРЕ -----
data "yandex_container_registry" "existing" {
  registry_id = var.existing_registry_id
}

# Формируем полный URL реестра для Docker
locals {
  registry_url = "cr.yandex/${data.yandex_container_registry.existing.id}"
}

# ----- СЕРВИСНЫЙ АККАУНТ ДЛЯ ВИРТУАЛЬНОЙ МАШИНЫ -----
resource "yandex_iam_service_account" "vm_sa" {
  name        = "vm-sa-${var.environment}"
  description = "Сервисный аккаунт для доступа к Container Registry"
}

# Выдаём роль container-registry.images.puller на существующий реестр
resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = var.existing_registry_id
  role        = "container-registry.images.puller"
  members     = ["serviceAccount:${yandex_iam_service_account.vm_sa.id}"]
}

# Создаём авторизованный ключ для сервисного аккаунта.
# Он будет передан в cloud-init и использован для настройки Docker Credential Helper.
resource "yandex_iam_service_account_key" "vm_sa_key" {
  service_account_id = yandex_iam_service_account.vm_sa.id
  description        = "Ключ для Docker Credential Helper на ВМ"
}

# ----- VPC И ПОДСЕТЬ -----
module "vpc" {
  source = "./modules/vpc"

  network_name   = var.vpc_name
  subnet_name    = var.subnet_name
  zone           = var.default_zone
  v4_cidr_blocks = var.v4_cidr_blocks
  environment    = var.environment
}

# ----- ГРУППА БЕЗОПАСНОСТИ -----
module "security" {
  source = "./modules/security"

  name             = "${var.vpc_name}-sg"
  description      = "Security group для приложения"
  network_id       = module.vpc.network_id
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
  app_subnet_cidrs = var.v4_cidr_blocks   # для доступа к MySQL
}

# ----- УПРАВЛЯЕМЫЙ MYSQL -----
module "mysql" {
  source = "./modules/mysql"

  network_id         = module.vpc.network_id
  subnet_id          = module.vpc.subnet_id
  zone               = var.default_zone
  environment        = var.environment
  mysql_version      = var.mysql_version
  db_name            = var.mysql_db_name
  db_user            = var.mysql_user
  db_password        = var.mysql_password
  security_group_ids = [module.security.security_group_id]
}

# ----- ВИРТУАЛЬНАЯ МАШИНА -----
module "vm" {
  source = "./modules/vm"

  vm_name            = var.vm_name
  project_label      = "app"
  environment_label  = var.environment

  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security.security_group_id]
  service_account_id = yandex_iam_service_account.vm_sa.id   # Привязываем сервисный аккаунт к ВМ

  zone               = var.default_zone
  image_family       = var.image_family
  ssh_public_key     = var.ssh_public_key

  vm_cores           = var.vm_cores
  vm_memory          = var.vm_memory
  vm_disk_size       = var.vm_disk_size
  preemptible        = var.preemptible

  # Параметры подключения к БД (будут переданы в контейнер)
  db_host            = module.mysql.db_host
  db_port            = module.mysql.db_port
  db_name            = var.mysql_db_name
  db_user            = var.mysql_user
  db_password        = var.mysql_password

  # URL реестра и ключ сервисного аккаунта (в формате JSON) для cloud-init
  registry_url       = local.registry_url
  sa_key_json        = yandex_iam_service_account_key.vm_sa_key.private_key
}