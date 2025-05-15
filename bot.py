import os
import asyncio
from datetime import datetime
from dotenv import load_dotenv
from loguru import logger

from aiogram import Bot, Dispatcher, types
from aiogram.filters import CommandStart, Command
from aiogram.enums import ParseMode
from aiogram.client.default import DefaultBotProperties

# Load environment variables
load_dotenv()

# Configure logging
logger.add("logs/bot_{time}.log", rotation="1 day", compression="zip")

# Initialize bot and dispatcher
BOT_TOKEN = os.getenv("BOT_TOKEN")
if not BOT_TOKEN:
    logger.error("No BOT_TOKEN provided in .env file")
    exit(1)

bot = Bot(token=BOT_TOKEN, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
dp = Dispatcher()

# Command handlers
@dp.message(CommandStart())
async def cmd_start(message: types.Message):
    """Handle the /start command."""
    user_name = message.from_user.full_name
    await message.answer(f"👋 Привет, {user_name}!\n\nЯ простой Telegram бот на aiogram v3.")
    logger.info(f"User {message.from_user.id} started the bot")

@dp.message(Command("help"))
async def cmd_help(message: types.Message):
    """Handle the /help command."""
    help_text = (
        "🔍 <b>Доступные команды:</b>\n\n"
        "/start - Начать взаимодействие с ботом\n"
        "/help - Показать это сообщение\n"
        "/time - Показать текущее время"
    )
    await message.answer(help_text)

@dp.message(Command("time"))
async def cmd_time(message: types.Message):
    """Handle the /time command."""
    current_time = datetime.now().strftime("%H:%M:%S")
    current_date = datetime.now().strftime("%d.%m.%Y")
    await message.answer(f"⏰ Текущее время: {current_time}\n📅 Дата: {current_date}")

@dp.message()
async def echo_message(message: types.Message):
    """Echo all other messages."""
    await message.answer(f"Вы написали: {message.text}")

async def main():
    """Main function to start the bot."""
    logger.info("Starting bot...")
    
    # Create logs directory if it doesn't exist
    os.makedirs("logs", exist_ok=True)
    
    # Start the bot
    await dp.start_polling(bot, skip_updates=True)

if __name__ == "__main__":
    asyncio.run(main())