#!/bin/bash

# Telegram Bot Deployment Script
# This script sets up and deploys the Telegram bot on your server

set -e  # Exit on any error

echo "🤖 Starting Telegram Bot setup and deployment..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Installing..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
else
    echo "✅ Python 3 is installed."
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Installing..."
    sudo apt update
    sudo apt install -y git
else
    echo "✅ Git is installed."
fi

# Create virtual environment
echo "🔧 Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install dependencies
echo "📦 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "⚙️ Creating .env file..."
    echo "BOT_TOKEN=" > .env
    echo "❗ Please edit the .env file and add your BOT_TOKEN."
else
    echo "✅ .env file already exists."
fi

# Create systemd service file
echo "🔧 Creating systemd service file..."
SERVICE_FILE="/etc/systemd/system/telegram-bot.service"

sudo bash -c "cat > $SERVICE_FILE" << EOL
[Unit]
Description=Telegram Bot Service
After=network.target

[Service]
User=$(whoami)
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/venv/bin/python $(pwd)/bot.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

# Set up systemd service
echo "🔄 Setting up systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable telegram-bot.service
sudo systemctl start telegram-bot.service

# Create directory for logs if it doesn't exist
mkdir -p logs

echo "✅ Deployment complete!"
echo ""
echo "🔍 Check status with: sudo systemctl status telegram-bot.service"
echo "📋 View logs with: sudo journalctl -u telegram-bot.service -f"
echo ""
echo "Don't forget to set your BOT_TOKEN in the .env file!" 