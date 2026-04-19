# ======================================================================
# FastAPI приложение с подключением к MySQL
# ======================================================================

from datetime import datetime
import os
from contextlib import contextmanager, asynccontextmanager

import mysql.connector
from fastapi import FastAPI, Request, Depends, Header
from typing import Optional

# --- Конфигурация из переменных окружения ---
db_host = os.environ.get('DB_HOST', '127.0.0.1')
db_port = int(os.environ.get('DB_PORT', '3306'))
db_user = os.environ.get('DB_USER', 'appuser')
db_password = os.environ.get('DB_PASSWORD', 'very_strong')
db_name = os.environ.get('DB_NAME', 'appdb')


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🚀 Приложение запускается...")
    if ensure_table_exists():
        print("✅ Таблица 'requests' готова.")
    else:
        print("⚠️ БД недоступна, таблица будет создана при первом запросе.")
    yield
    print("🛑 Приложение останавливается.")


app = FastAPI(
    title="FastAPI + MySQL в Yandex Cloud",
    description="Итоговый проект DevOps",
    version="2.0.0",
    lifespan=lifespan
)


@contextmanager
def get_db_connection():
    db = None
    try:
        db = mysql.connector.connect(
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            database=db_name
        )
        yield db
    finally:
        if db and db.is_connected():
            db.close()


def ensure_table_exists():
    try:
        with get_db_connection() as db:
            cursor = db.cursor()
            cursor.execute(f"""
                CREATE TABLE IF NOT EXISTS {db_name}.requests (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    request_date DATETIME,
                    request_ip VARCHAR(255)
                )
            """)
            db.commit()
            return True
    except Exception as e:
        print(f"Ошибка создания таблицы: {e}")
        return False


def get_client_ip(x_real_ip: Optional[str] = Header(None)):
    return x_real_ip


@app.get("/")
def index(request: Request, ip_address: Optional[str] = Depends(get_client_ip)):
    final_ip = ip_address
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    try:
        with get_db_connection() as db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO requests (request_date, request_ip) VALUES (%s, %s)",
                (now, final_ip)
            )
            db.commit()
    except Exception:
        ensure_table_exists()
        with get_db_connection() as db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO requests (request_date, request_ip) VALUES (%s, %s)",
                (now, final_ip)
            )
            db.commit()

    ip_display = final_ip or "IP не передан"
    return {
        "time": now,
        "ip": ip_display,
        "message": "Привет из Yandex Cloud!"
    }


@app.get("/requests")
def get_requests():
    try:
        with get_db_connection() as db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT id, request_date, request_ip FROM requests ORDER BY id DESC LIMIT 50"
            )
            records = cursor.fetchall()
            result = [
                {"id": r[0], "date": r[1].strftime("%Y-%m-%d %H:%M:%S"), "ip": r[2]}
                for r in records
            ]
            return {"total": len(result), "records": result}
    except Exception as e:
        return {"error": str(e)}


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=5000)