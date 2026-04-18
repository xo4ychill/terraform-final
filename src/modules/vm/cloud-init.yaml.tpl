#cloud-config
users:
  - name: yc-user
    groups: sudo, docker
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_public_key}

package_update: true
packages:
  - curl
  - jq
  - apt-transport-https
  - ca-certificates
  - gnupg
  - lsb-release

write_files:
  # Сохраняем ключ сервисного аккаунта в файл
  - path: /home/yc-user/sa-key.json
    content: ${SA_KEY_JSON}
    encoding: b64
    owner: 'yc-user:yc-user'
    permissions: '0600'

runcmd:
  # Установка Docker
  - |
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker containerd

  # Настройка Docker Credential Helper с ключом сервисного аккаунта
  - |
    # Установка YC CLI
    curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -- -n
    echo 'export PATH="$HOME/bin:$PATH"' >> /home/yc-user/.bashrc
    
    # Создание профиля с ключом сервисного аккаунта
    sudo -u yc-user /home/yc-user/bin/yc config profile create sa-profile
    sudo -u yc-user /home/yc-user/bin/yc config set service-account-key /home/yc-user/sa-key.json
    
    # Настройка Docker Credential Helper
    sudo -u yc-user /home/yc-user/bin/yc container registry configure-docker

  # Создание рабочего каталога
  - mkdir -p /opt/app
  - chown yc-user:yc-user /opt/app

  # .env файл с переменными окружения
  - |
    cat > /opt/app/.env << ENVEOF
    DB_HOST=${DB_HOST}
    DB_PORT=${DB_PORT}
    DB_NAME=${DB_NAME}
    DB_USER=${DB_USER}
    DB_PASSWORD=${DB_PASSWORD}
    REGISTRY_URL=${REGISTRY_URL}
    ENVEOF
    chmod 600 /opt/app/.env
    chown yc-user:yc-user /opt/app/.env

  # Скрипт запуска контейнера 
  - |
    cat > /opt/app/start-app.sh << 'SCRIPTEOF'
    #!/bin/bash
    set -e
    cd /opt/app
    docker compose up -d
    SCRIPTEOF
    chmod +x /opt/app/start-app.sh
    chown yc-user:yc-user /opt/app/start-app.sh

  # docker-compose.yml
  - |
    cat > /opt/app/docker-compose.yml << 'COMPOSEEOF'
    services:
      web:
        image: ${REGISTRY_URL}/app:latest
        container_name: fastapi-app
        restart: unless-stopped
        ports:
          - "80:5000"
        environment:
          - DB_HOST=${DB_HOST}
          - DB_PORT=${DB_PORT}
          - DB_NAME=${DB_NAME}
          - DB_USER=${DB_USER}
          - DB_PASSWORD=${DB_PASSWORD}
        networks:
          - app-network
        healthcheck:
          test: ["CMD", "curl", "-f", "http://localhost:5000/"]
          interval: 30s
          timeout: 5s
          retries: 3
          start_period: 10s
    networks:
      app-network:
        driver: bridge
    COMPOSEEOF
    chown yc-user:yc-user /opt/app/docker-compose.yml

  # Systemd-сервис для автоматического запуска при старте ВМ
  - |
    cat > /etc/systemd/system/app.service << 'SYSTEMDEOF'
    [Unit]
    Description=FastAPI Service
    After=docker.service network-online.target
    Requires=docker.service
    [Service]
    Type=oneshot
    RemainAfterExit=yes
    User=yc-user
    WorkingDirectory=/opt/app
    EnvironmentFile=/opt/app/.env
    ExecStart=/opt/app/start-app.sh
    ExecStop=/usr/bin/docker compose down
    [Install]
    WantedBy=multi-user.target
    SYSTEMDEOF
    systemctl daemon-reload
    systemctl enable app.service

final_message: "🎉 FastAPI приложение настроено и готово к работе!"