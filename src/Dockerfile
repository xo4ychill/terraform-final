# ======================================================================
# Мультисборка для FastAPI приложения
# Stage 1: builder — установка зависимостей
# Stage 2: runtime — минимальный образ с приложением
# ======================================================================

FROM python:3.12-alpine AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-alpine
WORKDIR /app
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY app/ /app/
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]