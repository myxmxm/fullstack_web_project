import aiomysql
from dotenv import load_dotenv
import os

load_dotenv()

async def connect_to_database():
    return await aiomysql.connect(
        host=os.getenv("DATABASE_HOST"),
        user=os.getenv("DATABASE_USER"),
        password=os.getenv("DATABASE_PASSWORD"),
        db=os.getenv("DATABASE_NAME")
    )