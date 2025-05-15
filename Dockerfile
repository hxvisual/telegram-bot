FROM python:3.10-slim

WORKDIR /app

# Установка зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копирование кода
COPY bot.py .

# Настройка переменных окружения (будут переопределены через env-файл)
ENV BOT_TOKEN=""

# Запуск бота
CMD ["python", "bot.py"] 