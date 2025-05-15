set -e 

echo "🤖 Starting Telegram Bot setup and deployment..."

sudo apt update && sudo apt upgrade -y

sudo apt install -y python3 python3-pip python3-venv
echo "✅ Python 3 is installed."

sudo apt install -y git
echo "✅ Git is installed."

echo "🔧 Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "📦 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file with user-provided token
if [ ! -f .env ]; then
    echo "⚙️ Setting up your bot configuration..."
    echo -n "📲 Please enter your Telegram BOT_TOKEN (получить у @BotFather): "
    read -r token
    
    if [ -z "$token" ]; then
        echo "❌ No token provided! You will need to manually edit the .env file later."
        echo "BOT_TOKEN=" > .env
    else
        echo "BOT_TOKEN=$token" > .env
        echo "✅ Token successfully saved to .env file."
    fi
else
    echo "✅ .env file already exists."
    echo "ℹ️ If you want to update your token, edit the .env file manually."
fi

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

echo "🔄 Setting up systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable telegram-bot.service
sudo systemctl start telegram-bot.service

echo "✅ Deployment complete!"
echo ""
echo "🔍 Check status with: sudo systemctl status telegram-bot.service"
echo "📋 View logs with: sudo journalctl -u telegram-bot.service -f"
echo ""
echo "Don't forget to set your BOT_TOKEN in the .env file!" 