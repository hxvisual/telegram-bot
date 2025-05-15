# 🤖 Telegram Bot на Python с Docker

![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)
![aiogram](https://img.shields.io/badge/aiogram-3.7.0-green.svg)
![Docker](https://img.shields.io/badge/Docker-✓-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

Простой Telegram бот, созданный с использованием Python и библиотеки aiogram v3. 
Проект контейнеризирован с использованием Docker, включает автоматическую настройку окружения, деплой на сервер и интеграцию с GitHub Actions для автоматического обновления.

## 📋 Содержание

- [Возможности](#возможности)
- [Требования](#требования)
- [Установка](#установка)
- [Настройка](#настройка)
- [Деплой](#деплой)
- [Структура проекта](#структура-проекта)
- [Docker](#docker)
- [GitHub Actions](#github-actions)
- [Команды бота](#команды-бота)
- [Логирование](#логирование)
- [Лицензия](#лицензия)

## ✨ Возможности

- Обработка базовых команд Telegram (/start, /help, /time)
- Эхо-режим для всех остальных сообщений
- Хранение токена в файле .env
- Интерактивный ввод токена при деплое
- Игнорирование старых сообщений при запуске
- Контейнеризация с Docker и Docker Compose
- Автоматическая настройка и деплой через скрипт
- CI/CD с использованием GitHub Actions

## 🔧 Требования

- Docker и Docker Compose
- Зарегистрированный Telegram бот (получение токена у [@BotFather](https://t.me/BotFather))
- Сервер с Linux (для деплоя)
- Git

## 🚀 Установка

### С использованием Docker (рекомендуется)

1. Клонируйте репозиторий:

```bash
git clone https://github.com/yourusername/telegram-bot.git
cd telegram-bot
```

2. Запустите скрипт deploy.sh для автоматической настройки:

```bash
chmod +x deploy.sh
./deploy.sh
```

Или настройте вручную:

```bash
# Создайте .env файл с токеном
echo "BOT_TOKEN=your_bot_token_here" > .env

# Соберите и запустите Docker-контейнер
docker-compose up -d
```

### Без Docker

1. Клонируйте репозиторий и создайте виртуальное окружение:

```bash
git clone https://github.com/yourusername/telegram-bot.git
cd telegram-bot
python -m venv venv
source venv/bin/activate  # Для Linux/Mac
# или
venv\Scripts\activate  # Для Windows
```

2. Установите зависимости и создайте .env файл:

```bash
pip install -r requirements.txt
echo "BOT_TOKEN=your_bot_token_here" > .env
```

3. Запустите бота:

```bash
python bot.py
```

## ⚙️ Настройка

1. Получите токен для вашего бота у [@BotFather](https://t.me/BotFather)
2. Добавьте токен в файл `.env` или через интерактивный ввод в скрипте deploy.sh
3. При необходимости настройте параметры Docker в Dockerfile и docker-compose.yml

## 📦 Деплой

### Автоматический деплой с Docker

Проект включает скрипт `deploy.sh`, который автоматизирует процесс деплоя на сервер:

```bash
chmod +x deploy.sh
./deploy.sh
```

Скрипт выполнит следующие действия:
- Проверит и установит Docker и Docker Compose
- Добавит пользователя в группу docker
- Создаст файл .env (если не существует)
- Соберет Docker-образ и запустит контейнер

### Ручной деплой

1. Загрузите код на сервер
2. Создайте .env файл с токеном бота
3. Запустите `docker-compose up -d`

## 📁 Структура проекта

```
telegram-bot/
├── bot.py                  # Основной файл бота
├── requirements.txt        # Зависимости проекта
├── .env                    # Переменные окружения (не коммитить!)
├── Dockerfile              # Инструкции для сборки Docker-образа
├── docker-compose.yml      # Конфигурация Docker Compose
├── deploy.sh               # Скрипт для деплоя
├── .github/                # Конфигурация GitHub Actions
│   └── workflows/
│       └── deploy.yml      # Workflow для автодеплоя
├── .gitignore              # Gitignore
└── README.md               # Документация
```

## 🐳 Docker

Проект использует Docker для контейнеризации и упрощения процесса деплоя.

### Основные команды Docker

```bash
# Запуск контейнера
docker-compose up -d

# Остановка контейнера
docker-compose down

# Просмотр логов
docker logs -f telegram-bot

# Перезапуск контейнера
docker-compose restart

# Обновление и перезапуск
docker-compose up -d --build
```

## 🔄 GitHub Actions

Проект настроен для автоматического деплоя при пуше в ветку `main`. 

Для настройки CI/CD необходимо добавить следующие секреты в настройках репозитория на GitHub:

- `SERVER_HOST` - IP или домен вашего сервера
- `SERVER_USERNAME` - Имя пользователя для подключения к серверу
- `SSH_PRIVATE_KEY` - Приватный SSH-ключ для подключения к серверу
- `PROJECT_PATH` - Полный путь к директории проекта на сервере

## 🤖 Команды бота

- `/start` - Начало работы с ботом
- `/help` - Отображение списка доступных команд
- `/time` - Показать текущее время и дату
- Любое другое сообщение будет отправлено обратно (эхо-режим)

## 📝 Логирование

Бот настроен на вывод логов только в консоль. При запуске в Docker логи можно просмотреть с помощью команды:

```bash
docker logs -f telegram-bot
```

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл LICENSE для получения дополнительной информации. 