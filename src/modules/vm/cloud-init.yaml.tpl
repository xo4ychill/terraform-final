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

  # Авторизация в Container Registry через IAM-токен
  - |
    IAM_TOKEN=$(curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token | jq -r .access_token)
    if [ -n "$IAM_TOKEN" ] && [ "$IAM_TOKEN" != "null" ]; then
      echo "$IAM_TOKEN" | docker login --username iam --password-stdin cr.yandex
    fi

  - mkdir -p /opt/app
  - chown yc-user:yc-user /opt/app

  # .env файл
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

  # Скрипт запуска
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

  # systemd сервис
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

final_message: "🎉 FastAPI приложение готово к работе!"