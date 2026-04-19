# Terraform Module: security

---

## 📌 Описание
Модуль инфраструктуры: **security**

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
| [yandex_vpc_security_group.sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ssh_cidr"></a> [allowed_ssh_cidr](#input_allowed_ssh_cidr) | CIDR-блок, с которого разрешён SSH (null — запретить) | `string` | `null` | no |
| <a name="input_app_subnet_cidrs"></a> [app_subnet_cidrs](#input_app_subnet_cidrs) | CIDR-блоки подсети приложения (для доступа к MySQL) | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input_description) | Описание группы безопасности | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение (prod/staging/dev) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Имя группы безопасности | `string` | n/a | yes |
| <a name="input_network_id"></a> [network_id](#input_network_id) | ID сети, к которой привязывается группа | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id) | ID созданной группы безопасности |
<!-- END_TF_DOCS -->
