<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.120.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mysql"></a> [mysql](#module\_mysql) | ./modules/mysql | n/a |
| <a name="module_registry"></a> [registry](#module\_registry) | ./modules/registry | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vm"></a> [vm](#module\_vm) | ./modules/vm | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | Идентификатор облака Yandex Cloud | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Идентификатор каталога для развёртывания | `string` | n/a | yes |
| <a name="input_mysql_password"></a> [mysql\_password](#input\_mysql\_password) | Пароль пользователя MySQL | `string` | n/a | yes |
| <a name="input_service_account_key_file"></a> [service\_account\_key\_file](#input\_service\_account\_key\_file) | Путь к файлу ключа сервисного аккаунта (JSON) для Terraform | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Публичный SSH-ключ | `string` | n/a | yes |
| <a name="input_vm_service_account_id"></a> [vm\_service\_account\_id](#input\_vm\_service\_account\_id) | ID существующего сервисного аккаунта с правами container-registry.images.puller | `string` | n/a | yes |
| <a name="input_allowed_ssh_cidr"></a> [allowed\_ssh\_cidr](#input\_allowed\_ssh\_cidr) | CIDR для SSH (null — запретить) | `string` | `null` | no |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Зона доступности по умолчанию | `string` | `"ru-central1-a"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Окружение: prod / staging / dev | `string` | `"prod"` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Семейство образа ОС | `string` | `"ubuntu-2204-lts"` | no |
| <a name="input_mysql_db_name"></a> [mysql\_db\_name](#input\_mysql\_db\_name) | Имя базы данных | `string` | `"appdb"` | no |
| <a name="input_mysql_user"></a> [mysql\_user](#input\_mysql\_user) | Имя пользователя MySQL | `string` | `"appuser"` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | Версия MySQL | `string` | `"8.0"` | no |
| <a name="input_preemptible"></a> [preemptible](#input\_preemptible) | Использовать прерываемую ВМ | `bool` | `false` | no |
| <a name="input_registry_name"></a> [registry\_name](#input\_registry\_name) | Имя Container Registry | `string` | `"app-registry"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Имя подсети | `string` | `"app-subnet"` | no |
| <a name="input_v4_cidr_blocks"></a> [v4\_cidr\_blocks](#input\_v4\_cidr\_blocks) | CIDR-блок подсети | `list(string)` | <pre>[<br/>  "192.168.10.0/24"<br/>]</pre> | no |
| <a name="input_vm_cores"></a> [vm\_cores](#input\_vm\_cores) | Количество vCPU | `number` | `2` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Размер диска (ГБ) | `number` | `20` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Объём ОЗУ (ГБ) | `number` | `4` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Имя виртуальной машины | `string` | `"vm-app"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Имя сети VPC | `string` | `"app-network"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_cluster_id"></a> [mysql\_cluster\_id](#output\_mysql\_cluster\_id) | ID кластера Managed MySQL |
| <a name="output_mysql_connection_string"></a> [mysql\_connection\_string](#output\_mysql\_connection\_string) | Строка подключения к MySQL (без пароля) |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | ID Container Registry |
| <a name="output_registry_url"></a> [registry\_url](#output\_registry\_url) | URL Container Registry для docker push/pull |
| <a name="output_vm_external_ip"></a> [vm\_external\_ip](#output\_vm\_external\_ip) | Внешний IP-адрес виртуальной машины |
| <a name="output_vm_internal_ip"></a> [vm\_internal\_ip](#output\_vm\_internal\_ip) | Внутренний IP-адрес виртуальной машины |
<!-- END_TF_DOCS -->