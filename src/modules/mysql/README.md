# Terraform Module: mysql

---

## 📌 Описание
Модуль инфраструктуры: **mysql**

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
| [yandex_mdb_mysql_cluster.cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster) | resource |
| [yandex_mdb_mysql_database.database](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_database) | resource |
| [yandex_mdb_mysql_user.user](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_name"></a> [db_name](#input_db_name) | Имя создаваемой базы данных | `string` | n/a | yes |
| <a name="input_db_password"></a> [db_password](#input_db_password) | Пароль пользователя БД | `string` | n/a | yes |
| <a name="input_db_user"></a> [db_user](#input_db_user) | Имя пользователя БД | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение (PRODUCTION/PRESTABLE) | `string` | n/a | yes |
| <a name="input_mysql_version"></a> [mysql_version](#input_mysql_version) | Версия MySQL | `string` | n/a | yes |
| <a name="input_network_id"></a> [network_id](#input_network_id) | ID сети, в которой создаётся кластер | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids) | Список ID групп безопасности | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | ID подсети для размещения хоста | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input_zone) | Зона доступности для хоста | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id) | ID кластера MySQL |
| <a name="output_db_host"></a> [db_host](#output_db_host) | FQDN хоста MySQL |
| <a name="output_db_port"></a> [db_port](#output_db_port) | Порт для подключения к MySQL |
<!-- END_TF_DOCS -->
