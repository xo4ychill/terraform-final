# Terraform Module: registry

---

## 📌 Описание
Модуль инфраструктуры: **registry**

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
| [yandex_container_registry.registry](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry) | Создаёт приватный реестр для хранения Docker-образов |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input_environment) | Окружение (prod/staging/dev) | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder_id](#input_folder_id) | ID каталога, в котором создаётся реестр | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Имя Container Registry | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_id"></a> [registry_id](#output_registry_id) | ID Container Registry |
| <a name="output_registry_url"></a> [registry_url](#output_registry_url) | URL Container Registry для работы с Docker |
<!-- END_TF_DOCS -->
