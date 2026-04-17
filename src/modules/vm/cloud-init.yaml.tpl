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
  - git
  - apt-transport-https
  - ca-certificates
  - gnupg
  - lsb-release

runcmd:
  # 1. Создание рабочего каталога (первым делом)
  - mkdir -p /opt/app
  - chown yc-user:yc-user /opt/app

  # 2. Установка Docker
  - |
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker containerd

  # 3. Авторизация в Container Registry (IAM-токен)
  - |
    for i in $(seq 1 5); do
      IAM_TOKEN=$(curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token | jq -r .access_token)
      if [ -n "$IAM_TOKEN" ] && [ "$IAM_TOKEN" != "null" ]; then
        echo "$IAM_TOKEN" | docker login --username iam --password-stdin cr.yandex && break
      fi
      sleep 5
    done

  # 4. Создание .env файла
  - |
    cat > /opt/app/.env << 'ENVEOF'
    DB_HOST=${DB_HOST}
    DB_PORT=${DB_PORT}
    DB_NAME=${DB_NAME}
    DB_USER=${DB_USER}
    DB_PASSWORD=${DB_PASSWORD}
    REGISTRY_URL=${REGISTRY_URL}
    ENVEOF
    chmod 600 /opt/app/.env
    chown yc-user:yc-user /opt/app/.env

  # 5. Скрипт запуска приложения
  - |
    cat > /opt/app/start-app.sh << 'SCRIPTEOF'
    #!/bin/bash
    set -e
    cd /opt/app
    IAM_TOKEN=$(curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token | jq -r .access_token)
    if [ -n "$IAM_TOKEN" ] && [ "$IAM_TOKEN" != "null" ]; then
      echo "$IAM_TOKEN" | docker login --username iam --password-stdin cr.yandex > /dev/null 2>&1
    fi
    docker compose up -d
    SCRIPTEOF
    chmod +x /opt/app/start-app.sh
    chown yc-user:yc-user /opt/app/start-app.sh

  # 6. docker-compose.yml
  - |
    cat > /opt/app/docker-compose.yml << 'COMPOSEEOF'
    services:
      web:
        image: ${REGISTRY_URL}/app:latest
        container_name: web-app
        restart: unless-stopped
        ports:
          - "80:80"
        environment:
          - DB_HOST=${DB_HOST}
          - DB_PORT=${DB_PORT}
          - DB_NAME=${DB_NAME}
          - DB_USER=${DB_USER}
          - DB_PASSWORD=${DB_PASSWORD}
        networks:
          - app-network
        healthcheck:
          test: ["CMD", "curl", "-f", "http://localhost/"]
          interval: 30s
          timeout: 5s
          retries: 3
          start_period: 10s
    networks:
      app-network:
        driver: bridge
    COMPOSEEOF
    chown yc-user:yc-user /opt/app/docker-compose.yml

  # 7. systemd сервис
  - |
    cat > /etc/systemd/system/app.service << 'SYSTEMDEOF'
    [Unit]
    Description=App Service
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

  # 8. Запуск приложения
  - systemctl start app.service

final_message: "🎉 Cloud-init завершён."