# ======================================================================
# main.tf — ОСНОВНАЯ КОНФИГУРАЦИЯ ИНФРАСТРУКТУРЫ
# ======================================================================

# ==================== VPC: СЕТЬ И ПОДСЕТЬ ====================
module "vpc" {
  source = "./modules/vpc"

  network_name   = var.vpc_name
  subnet_name    = var.subnet_name
  zone           = var.default_zone
  v4_cidr_blocks = var.v4_cidr_blocks
  environment    = var.environment
}

# ==================== SECURITY GROUP ====================
module "security" {
  source = "./modules/security"

  name             = "${var.vpc_name}-sg"
  description      = "Security group для приложения"
  network_id       = module.vpc.network_id
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
  app_subnet_cidrs = var.v4_cidr_blocks
}

# ==================== MANAGED MYSQL ====================
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

# ==================== CONTAINER REGISTRY ====================
module "registry" {
  source = "./modules/registry"

  name        = var.registry_name
  folder_id   = var.folder_id
  environment = var.environment
}

# ==================== ВИРТУАЛЬНАЯ МАШИНА ====================
module "vm" {
  source = "./modules/vm"

  vm_name            = var.vm_name
  project_label      = "app"
  environment_label  = var.environment

  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security.security_group_id]
  service_account_id = var.vm_service_account_id   # используем существующий SA

  zone               = var.default_zone
  image_family       = var.image_family
  ssh_public_key     = var.ssh_public_key

  vm_cores           = var.vm_cores
  vm_memory          = var.vm_memory
  vm_disk_size       = var.vm_disk_size
  preemptible        = var.preemptible

  # Параметры подключения к БД и реестру
  db_host            = module.mysql.db_host
  db_port            = module.mysql.db_port
  db_name            = var.mysql_db_name
  db_user            = var.mysql_user
  db_password        = var.mysql_password
  registry_url       = module.registry.registry_url
}