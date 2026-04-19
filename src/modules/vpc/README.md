# Terraform Module: vpc

---

## 📌 Описание
Модуль инфраструктуры: **vpc**

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
| [yandex_vpc_network.network](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input_environment) | Окружение (prod/staging/dev) | `string` | n/a | yes |
| <a name="input_network_name"></a> [network_name](#input_network_name) | Имя сети | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet_name](#input_subnet_name) | Имя подсети | `string` | n/a | yes |
| <a name="input_v4_cidr_blocks"></a> [v4_cidr_blocks](#input_v4_cidr_blocks) | Список CIDR-блоков подсети | `list(string)` | n/a | yes |
| <a name="input_zone"></a> [zone](#input_zone) | Зона доступности | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_id"></a> [network_id](#output_network_id) | ID созданной сети |
| <a name="output_subnet_id"></a> [subnet_id](#output_subnet_id) | ID созданной подсети |
<!-- END_TF_DOCS -->
