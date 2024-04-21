from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form
import aiomysql
import jwt
from dotenv import load_dotenv
import os
from database import connect_to_database 

load_dotenv()

# Function to generate a random bearer token
def generate_token(username: str, password: str):
    payload = {"username": username, "password": password}
    token = jwt.encode(payload, os.getenv("SECRET_KEY"), algorithm="HS256")
    return token

# Function to authenticate user using database
async def authenticate_user(username: str, password: str):
    try:
        connection = await connect_to_database()
        async with connection.cursor(aiomysql.DictCursor) as cursor:
            await cursor.execute("SELECT * FROM user WHERE username = %s AND password = %s", (username, password))
            user = await cursor.fetchone()
            if user:
                return True
            else:
                return False
    except aiomysql.Error as err:
        raise HTTPException(status_code=500, detail=f"MySQL Error: {err}")
    finally:
        connection.close()

def decode_token(token: str):
    try:
        payload = jwt.decode(token, os.getenv("SECRET_KEY"), algorithms=["HS256"])
        username = payload.get("username")
        password = payload.get("password")
        if username and password:
            return {"username": username, "password": password}
        else:
            raise HTTPException(status_code=400, detail="Invalid token payload")
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token has expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")