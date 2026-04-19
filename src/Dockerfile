# ======================================================================
# Мультисборка для FastAPI приложения
# ======================================================================

# ======================================================================
# Stage 1: Builder — установка зависимостей
# ======================================================================
FROM python:3.12-alpine AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ======================================================================
# Stage 2: Runtime — минимальный образ с приложением
# ======================================================================
FROM python:3.12-alpine
WORKDIR /app

# Копируем установленные зависимости из builder-стадии
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Копируем исходный код приложения
COPY app/ /app/

# Открываем порт для FastAPI (Uvicorn)
EXPOSE 5000

# Healthcheck для мониторинга состояния контейнера
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

# Запуск приложения через Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]