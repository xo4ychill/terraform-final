# ======================================================================
# Dockerfile — Мультисборка для веб-приложения (Nginx + PHP-FPM)
# ======================================================================

# -------------------- STAGE 1: BUILDER --------------------
FROM php:8.1-fpm-alpine AS builder
RUN apk add --no-cache git curl
COPY app/ /var/www/app/
# Проверка синтаксиса всех PHP-файлов
RUN find /var/www/app -name '*.php' -exec php -l {} \; > /dev/null

# -------------------- STAGE 2: RUNTIME --------------------
FROM php:8.1-fpm-alpine AS runtime

# Установка Nginx, Supervisor и зависимостей для компиляции PHP-расширений
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    ca-certificates \
    libxml2-dev \
    curl-dev \
    oniguruma-dev \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Установка PHP-расширений
RUN docker-php-ext-install \
    mysqli \
    mbstring \
    xml \
    curl \
    opcache

# Удаление dev-пакетов для уменьшения размера образа
RUN apk del libxml2-dev curl-dev oniguruma-dev

# Настройка PHP-FPM для работы через Unix-сокет
RUN sed -i 's/^listen = .*/listen = \/run\/php\/php-fpm.sock/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^;listen.owner = .*/listen.owner = nginx/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^;listen.group = .*/listen.group = nginx/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^user = .*/user = nginx/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^group = .*/group = nginx/' /usr/local/etc/php-fpm.d/www.conf

# Копирование конфигурации Nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Конфигурация Supervisor для управления Nginx и PHP-FPM
COPY <<'EOF' /etc/supervisord.conf
[supervisord]
nodaemon=true
logfile=/dev/stdout
pidfile=/var/run/supervisord.pid

[program:nginx]
command=nginx -g "daemon off;"
autostart=true
autorestart=true
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr

[program:php-fpm]
command=php-fpm -F
autostart=true
autorestart=true
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
EOF

# Копирование кода приложения из builder-стадии
COPY --from=builder --chown=nginx:nginx /var/www/app /var/www/app
RUN ln -sf /var/www/app /var/www/html
RUN mkdir -p /run/php && chown nginx:nginx /run/php

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]