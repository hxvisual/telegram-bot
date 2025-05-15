#!/bin/bash
#
# ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗     ██████╗  ██████╗ ████████╗
# ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗    ██╔══██╗██╔═══██╗╚══██╔══╝
# ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝    ██████╔╝██║   ██║   ██║   
# ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗    ██╔══██╗██║   ██║   ██║   
# ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║    ██████╔╝╚██████╔╝   ██║   
# ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   
#
# Скрипт развертывания Telegram бота в Docker
# Разработано для автоматизации процесса установки и запуска бота

set -e  # Остановка скрипта при любой ошибке

echo "
╔════════════════════════════════════════════════════╗
║  🐳 УСТАНОВКА И ЗАПУСК TELEGRAM БОТА В DOCKER      ║
╚════════════════════════════════════════════════════╝
"

echo "🔄 Обновление системных пакетов..."
sudo apt update && sudo apt upgrade -y


sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker
echo "✅ Docker успешно установлен"

# Установка Docker Compose, если не установлен

sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "✅ Docker Compose успешно установлен"


# Добавление текущего пользователя в группу docker
if ! groups $(whoami) | grep -q '\bdocker\b'; then
    echo "🔧 Добавление пользователя $(whoami) в группу docker..."
    sudo usermod -aG docker $(whoami)
    echo "✅ Пользователь добавлен в группу docker"
    echo "⚠️ Внимание: Для применения изменений рекомендуется перезайти в систему"
fi

# Создание файла .env с токеном, указанным пользователем
if [ ! -f .env ]; then
    echo "⚙️ Настройка конфигурации бота..."
    echo -n "📲 Пожалуйста, введите токен вашего бота (получить у @BotFather): "
    read -r token
    
    if [ -z "$token" ]; then
        echo "❌ Токен не указан! Вам придется вручную отредактировать файл .env позже."
        echo "BOT_TOKEN=" > .env
    else
        echo "BOT_TOKEN=$token" > .env
        echo "✅ Токен успешно сохранен в файле .env"
    fi
else
    echo "✅ Файл .env уже существует"
    echo "ℹ️ Если вы хотите обновить токен, отредактируйте файл .env вручную"
fi

# Сборка и запуск Docker-контейнера
echo "🔧 Сборка Docker-образа..."
docker-compose build

echo "🚀 Запуск контейнера..."
docker-compose up -d

echo "
╔════════════════════════════════════════════════════╗
║  ✅ УСТАНОВКА В DOCKER ЗАВЕРШЕНА УСПЕШНО           ║
╚════════════════════════════════════════════════════╝

🔍 Проверить статус контейнера:   docker ps -a | grep telegram-bot
📋 Просмотреть логи:              docker logs -f telegram-bot
🔄 Перезапустить контейнер:       docker-compose restart
⏹️ Остановить контейнер:          docker-compose down
🔄 Обновить и перезапустить:      docker-compose up -d --build
" 