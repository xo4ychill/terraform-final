# Terraform Module: vm

---

## 📌 Описание
Модуль инфраструктуры: **vm**

---

## 📚 Документация
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.12.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement_yandex) | >= 0.120 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider_yandex) | >= 0.120 |

## Resources

| Name | Type |
|------|------|
| [yandex_compute_instance.vm](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_host"></a> [db_host](#input_db_host) | Хост базы данных MySQL | `string` | n/a | yes |
| <a name="input_db_name"></a> [db_name](#input_db_name) | Имя базы данных | `string` | n/a | yes |
| <a name="input_db_password"></a> [db_password](#input_db_password) | Пароль пользователя БД | `string` | n/a | yes |
| <a name="input_db_port"></a> [db_port](#input_db_port) | Порт базы данных MySQL | `number` | n/a | yes |
| <a name="input_db_user"></a> [db_user](#input_db_user) | Имя пользователя БД | `string` | n/a | yes |
| <a name="input_environment_label"></a> [environment_label](#input_environment_label) | Метка окружения | `string` | n/a | yes |
| <a name="input_image_family"></a> [image_family](#input_image_family) | Семейство образа ОС | `string` | n/a | yes |
| <a name="input_preemptible"></a> [preemptible](#input_preemptible) | Использовать прерываемую ВМ | `bool` | n/a | yes |
| <a name="input_project_label"></a> [project_label](#input_project_label) | Метка проекта | `string` | n/a | yes |
| <a name="input_registry_url"></a> [registry_url](#input_registry_url) | URL Container Registry | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids) | Список ID групп безопасности | `list(string)` | n/a | yes |
| <a name="input_service_account_id"></a> [service_account_id](#input_service_account_id) | ID сервисного аккаунта для доступа к Container Registry | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh_public_key](#input_ssh_public_key) | Публичный SSH-ключ | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | ID подсети для подключения ВМ | `string` | n/a | yes |
| <a name="input_vm_cores"></a> [vm_cores](#input_vm_cores) | Количество vCPU | `number` | n/a | yes |
| <a name="input_vm_disk_size"></a> [vm_disk_size](#input_vm_disk_size) | Размер загрузочного диска (ГБ) | `number` | n/a | yes |
| <a name="input_vm_memory"></a> [vm_memory](#input_vm_memory) | Объём оперативной памяти (ГБ) | `number` | n/a | yes |
| <a name="input_vm_name"></a> [vm_name](#input_vm_name) | Имя виртуальной машины | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input_zone) | Зона доступности | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ip"></a> [external_ip](#output_external_ip) | Внешний IP-адрес ВМ |
| <a name="output_id"></a> [id](#output_id) | ID виртуальной машины |
| <a name="output_internal_ip"></a> [internal_ip](#output_internal_ip) | Внутренний IP-адрес ВМ |
<!-- END_TF_DOCS -->
