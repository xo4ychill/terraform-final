# Итоговый проект модуля «Облачная инфраструктура. Terraform»

#### Структура проекта.
src/
├── providers.tf
├── variables.tf
├── terraform.tfvars.example
├── main.tf
├── outputs.tf
├── Dockerfile
├── nginx.conf
├── app/
│   ├── index.html
│   ├── style.css
│   └── info.php
├── modules/
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── cloud-init.yaml.tpl
│   ├── mysql/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── registry/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── bucket/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── scripts/
│   └── docker-push.sh

#### Задание 1. Развертывание инфраструктуры в Yandex Cloud.

-  Создание Virtual Private Cloud (VPC)

-  Создание подсети

-  Создание виртуальные машины (VM):

        - Настройка группы безопасности (порты 22, 80, 443)

        - Привязываем группу безопасности к VM

- Описание создания БД MySQL в Yandex Cloud

- Описание создания Container Registry

#### Задание 2. Используя user-data (cloud-init), установливаем Docker и Docker Compose.

#### Задание 3. Описание Docker файла  c web-приложением и сохранние контейнера в Container Registry.

#### Задание 4. Завязываем работу приложения в контейнере на БД в Yandex Cloud.