# ======================================================================
# Модуль MySQL — Yandex Managed Service for MySQL
# ======================================================================

# Ресурс кластера MySQL (управляемый сервис Yandex Cloud)
resource "yandex_mdb_mysql_cluster" "cluster" {
  # Имя кластера формируется из префикса окружения
  name        = "${var.environment}-mysql-cluster"
  # Окружение: Yandex Cloud требует строго PRODUCTION или PRESTABLE
  # Тернарный оператор преобразует "prod" → "PRODUCTION", остальное → "PRESTABLE"
  environment = var.environment == "prod" ? "PRODUCTION" : "PRESTABLE"
  # Сеть, в которой будет развёрнут кластер
  network_id  = var.network_id
  # Версия СУБД (например, "8.0")
  version     = var.mysql_version

  # Конфигурация вычислительных ресурсов и хранилища
  resources {
    resource_preset_id = "s2.micro"      # 2 vCPU, 8 ГБ ОЗУ (стандартный пресет YC)
    disk_type_id       = "network-hdd"   # Сетевой HDD (для dev/staging). В prod рекомендуется "network-ssd"
    disk_size          = 20              # Объём диска в ГБ
  }

  # Кастомизация параметров MySQL (должны быть валидны для выбранной версии)
  mysql_config = {
    innodb_buffer_pool_size = 1073741824   # 1 ГБ — кэш InnoDB для ускорения чтения
    max_connections         = 100          # Макс. одновременных подключений
    sql_mode                = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"  # Системная переменная MySQL, определяющая правила валидации и обработки данных
                                                                                                                                    # STRICT_TRANS_TABLES:
                                                                                                                                    #                    Для транзакционных таблиц (InnoDB): при ошибке вставки/обновления вся операция откатывается.
                                                                                                                                    #                    Для нетранзакционных таблиц (MyISAM): вставляется максимально возможное корректное значение, генерируется предупреждение.
                                                                                                                                    #                    Включает строгую проверку данных: MySQL не будет автоматически исправлять некорректные значения.
                                                                                                                                    # NO_ZERO_IN_DATE:   Запрещает использование «нулевых» дат, где день или месяц равны нулю:
                                                                                                                                    #                                                       Запрещено: 2023-00-15, 2023-05-00.
                                                                                                                                    #                                                       Разрешено: 0000-00-00 (если не включён NO_ZERO_DATE).
                                                                                                                                    # NO_ZERO_DATE:      Запрещает использование полной нулевой даты 0000-00-00. При попытке вставить такое значение:
                                                                                                                                    #                                                       В строгом режиме (STRICT_TRANS_TABLES) — ошибка.
                                                                                                                                    #                                                       Без строгого режима — вставляется текущая дата или генерируется предупреждение.
                                                                                                                                    # ERROR_FOR_DIVISION_BY_ZERO:
                                                                                                                                    #                    При делении на ноль:
                                                                                                                                    #                                       Без этого флага: возвращается NULL.
                                                                                                                                    #                                       С флагом: генерируется ошибка (если включён строгий режим) или предупреждение (если нет).
                                                                                                                                    # NO_ENGINE_SUBSTITUTION:
                                                                                                                                    #                    Если при создании таблицы указан неподдерживаемый или несуществующий движок (например, ENGINE=NonExistentEngine):
                                                                                                                                    #                                       Без этого флага: MySQL подставляет движок по умолчанию (обычно InnoDB) и выдаёт предупреждение.
                                                                                                                                    #                                       C флагом: операция завершается ошибкой, таблица не создаётся.

  }

  # Расписание ежедневного резервного копирования
  backup_window_start {
    hours   = 3
    minutes = 0
  }
  
  # Окно технических обновлений кластера
  maintenance_window {
    type = "ANYTIME"                     # YC может применять обновления в любое время без простоя
  }

  # Параметры для хост БД (нода кластера)
  host {
    zone             = var.zone          # Зона доступности (например, ru-central1-a)
    subnet_id        = var.subnet_id     # Подсеть для приватного размещения
    assign_public_ip = false             # Публичный IP отключён — доступ только из приватной сети YC
  }

  # Группы безопасности, управляющие сетевым доступом к кластеру
  security_group_ids = var.security_group_ids

  # Метки для тегирования и фильтрации ресурсов в YC
  labels = {
    environment = var.environment
  }

  # Защита от случайного удаления через terraform destroy
  lifecycle {
    prevent_destroy = false               # true для prod, false  для dev/staging
  }
}

# Создание логической базы данных внутри кластера
resource "yandex_mdb_mysql_database" "database" {
  cluster_id = yandex_mdb_mysql_cluster.cluster.id
  name       = var.db_name
}

# Создание пользователя и назначение прав
resource "yandex_mdb_mysql_user" "user" {
  cluster_id = yandex_mdb_mysql_cluster.cluster.id
  name       = var.db_user
  password   = var.db_password            # Пароль будет скрыт в логах благодаря sensitive = true в variables.tf    

  # Права на конкретную БД
  permission {
    database_name = var.db_name
    roles         = ["ALL"]               # Полный доступ к указанной базе
  }

  # Глобальные права пользователя (управление процессами, репликацией)
  global_permissions = ["PROCESS", "REPLICATION_CLIENT"]

  # Ограничения подключений для защиты от перегрузки
  connection_limits {
    max_questions_per_hour   = 0           # 0 = без ограничений (ограничивает количество запросов (SQL‑операторов), которые пользователь может выполнить за один час.)
    max_updates_per_hour     = 0           # Лимит на количество команд, изменяющих данные в таблицах или структуру БД, которые пользователь может выполнить за час.
    max_connections_per_hour = 0           # Лимит на количество новых соединений, которые пользователь может установить к серверу MySQL в течение одного часа
    max_user_connections     = 10          # Лимит на максимальное количество одновременных подключений для конкретной учётной записи пользователя MySQL
  }

  # Явная зависимость: пользователь создаётся только после создания базы данных
  depends_on = [yandex_mdb_mysql_database.database]
  
}