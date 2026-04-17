# 📦 Terraform Infrastructure

---

## 📚 Автоматически сгенерированная документация

---

## 🌳 Структура проекта (без root каталога)

```
src
├── docker-compose.yml
├── Dockerfile
├── main.tf
├── modules
│   ├── mysql
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── README.md
│   │   └── variables.tf
│   ├── registry
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── README.md
│   │   └── variables.tf
│   ├── security
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── README.md
│   │   └── variables.tf
│   ├── vm
│   │   ├── cloud-init.yaml.tpl
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── README.md
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── README.md
│       └── variables.tf
├── nginx.conf
├── output.tf
├── providers.tf
├── .terraform.lock.hcl
├── terraform.tfvars
└── variables.tf
```

---

## 📘 Пояснения к структуре

| Путь | Описание |
|------|----------|
| `src/main.tf` | Точка входа: объединяет все модули |
| `src/providers.tf` | Настройка провайдеров и backend |
| `src/variables.tf` | Входные переменные |
| `src/terraform.tfvars` | Значения переменных |
| `src/output.tf` | Выходные значения |
| `src/modules/` | Каталог всех Terraform модулей |
| `src/modules/vpc` | Создание сети (VPC, подсети) |
| `src/modules/vm` | Виртуальные машины + cloud-init |
| `src/modules/mysql` | Управляемая база данных |
| `src/modules/security` | Группы безопасности |
| `src/modules/registry` | Container Registry |

---

## 📖 Документация Terraform

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.12.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement_yandex) | >= 0.120.0 |

## Providers

No providers.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ssh_cidr"></a> [allowed_ssh_cidr](#input_allowed_ssh_cidr) | CIDR-блок, с которого разрешён SSH-доступ (оставьте пустым для запрета) | `string` | `null` | no |
| <a name="input_cloud_id"></a> [cloud_id](#input_cloud_id) | Идентификатор облака Yandex Cloud | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | Зона доступности по умолчанию | `string` | `"ru-central1-a"` | no |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение: prod / staging / dev | `string` | `"prod"` | no |
| <a name="input_folder_id"></a> [folder_id](#input_folder_id) | Идентификатор каталога для развёртывания | `string` | n/a | yes |
| <a name="input_image_family"></a> [image_family](#input_image_family) | Семейство образа ОС для ВМ | `string` | `"ubuntu-2204-lts"` | no |
| <a name="input_mysql_db_name"></a> [mysql_db_name](#input_mysql_db_name) | Имя базы данных | `string` | `"appdb"` | no |
| <a name="input_mysql_password"></a> [mysql_password](#input_mysql_password) | Пароль пользователя MySQL | `string` | n/a | yes |
| <a name="input_mysql_user"></a> [mysql_user](#input_mysql_user) | Имя пользователя MySQL | `string` | `"appuser"` | no |
| <a name="input_mysql_version"></a> [mysql_version](#input_mysql_version) | Версия Managed MySQL | `string` | `"8.0"` | no |
| <a name="input_preemptible"></a> [preemptible](#input_preemptible) | Использовать прерываемую ВМ (дешевле, но может быть остановлена) | `bool` | `false` | no |
| <a name="input_registry_name"></a> [registry_name](#input_registry_name) | Имя Container Registry | `string` | `"app-registry"` | no |
| <a name="input_service_account_key_file"></a> [service_account_key_file](#input_service_account_key_file) | Путь к файлу ключа сервисного аккаунта (JSON) | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh_public_key](#input_ssh_public_key) | Публичный SSH-ключ для доступа к ВМ | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet_name](#input_subnet_name) | Имя подсети | `string` | `"app-subnet"` | no |
| <a name="input_v4_cidr_blocks"></a> [v4_cidr_blocks](#input_v4_cidr_blocks) | CIDR-блок подсети (ровно один) | `list(string)` | <pre>[<br/>  "192.168.10.0/24"<br/>]</pre> | no |
| <a name="input_vm_cores"></a> [vm_cores](#input_vm_cores) | Количество vCPU для ВМ | `number` | `2` | no |
| <a name="input_vm_disk_size"></a> [vm_disk_size](#input_vm_disk_size) | Размер загрузочного диска (ГБ) | `number` | `20` | no |
| <a name="input_vm_memory"></a> [vm_memory](#input_vm_memory) | Объём оперативной памяти ВМ (ГБ) | `number` | `4` | no |
| <a name="input_vm_name"></a> [vm_name](#input_vm_name) | Имя виртуальной машины | `string` | `"vm-app"` | no |
| <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name) | Имя сети VPC | `string` | `"app-network"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_cluster_id"></a> [mysql_cluster_id](#output_mysql_cluster_id) | ID кластера Managed MySQL |
| <a name="output_mysql_connection_string"></a> [mysql_connection_string](#output_mysql_connection_string) | Строка подключения к MySQL (без пароля) |
| <a name="output_registry_id"></a> [registry_id](#output_registry_id) | ID Container Registry |
| <a name="output_registry_url"></a> [registry_url](#output_registry_url) | URL Container Registry для docker push/pull |
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id) | ID группы безопасности |
| <a name="output_vm_external_ip"></a> [vm_external_ip](#output_vm_external_ip) | Внешний IP-адрес ВМ |
| <a name="output_vm_internal_ip"></a> [vm_internal_ip](#output_vm_internal_ip) | Внутренний IP-адрес ВМ |
| <a name="output_vpc_network_id"></a> [vpc_network_id](#output_vpc_network_id) | ID созданной сети VPC |
| <a name="output_vpc_subnet_id"></a> [vpc_subnet_id](#output_vpc_subnet_id) | ID созданной подсети |
<!-- END_TF_DOCS -->
