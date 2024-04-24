from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form, APIRouter
from fastapi.responses import FileResponse, JSONResponse
from utils.basemodel import * 
from utils.autentication import * 
import shutil

router = APIRouter()

@router.post("/message")
async def create_message(message: Message):
    connection = await connect_to_database()
    async with connection.cursor() as cursor:
        try:
            await cursor.execute(
                "INSERT INTO message (email, message) VALUES (%s, %s)",
                (message.email, message.message)
            )
            await connection.commit()
            return {"message": "Message send successfully"}
        except aiomysql.Error as err:
            return {"error": f"MySQL Error: {err}"}
        finally:
            await cursor.close()
            connection.close()

@router.put(("/message/{message_id}"))
async def update_message(authorization: str = Header(...), message_id: int = Path(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "UPDATE message SET status=%s WHERE message_id=%s",
                ("acknowledged",message_id)
            )
            await connection.commit()
            return {"message": f"Message {message_id} has been acknowledged successfully"}
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()

@router.get("/messages")
async def get_messages(authorization: str = Header(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor(aiomysql.DictCursor) as cursor:
            await cursor.execute("SELECT * FROM message")
            messages = await cursor.fetchall()
            return messages
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()

@router.delete("/message/{message_id}")
async def delete_message(authorization: str = Header(...), message_id: int = Path(...)):
    try:
        token = authorization.split(" ")[1]
        decode_token(token)
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "DELETE FROM message WHERE message_id = %s",
                (message_id,)
            )
            await connection.commit()

            if cursor.rowcount > 0:
                return {"message": f"Message with id {message_id} deleted successfully"}
            else:
                return {"message": f"No message found with id {message_id}"}
    except Exception as e:
        return JSONResponse(content={"detail": str(e)}, status_code=500)