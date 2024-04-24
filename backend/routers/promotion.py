from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form, APIRouter
from fastapi.responses import FileResponse, JSONResponse
from utils.basemodel import * 
from utils.autentication import * 
import shutil

router = APIRouter()

@router.post("/promotion")
async def create_promotion(promotion: Promotion, authorization: str = Header(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    connection = await connect_to_database()
    async with connection.cursor() as cursor:
        try:
            await cursor.execute(
                "INSERT INTO promotion (name, description) VALUES (%s, %s)",
                (promotion.name, promotion.description)
            )
            await connection.commit()
            return {"message": f"New promotion {promotion.name} created successfully"}
        except aiomysql.Error as err:
            return {"error": f"MySQL Error: {err}"}
        finally:
            await cursor.close()
            connection.close()

@router.delete("/promotion/{promotion_id}")
async def delete_promotion(authorization: str = Header(...), promotion_id: int = Path(...)):
    try:
        token = authorization.split(" ")[1]
        decode_token(token)
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "DELETE FROM promotion WHERE promotion_id = %s",
                (promotion_id,)
            )
            await connection.commit()

            if cursor.rowcount > 0:
                return {"message": f"Promotion with id {promotion_id} deleted successfully"}
            else:
                return {"message": f"No promotion found with id {promotion_id}"}
    except Exception as e:
        return JSONResponse(content={"detail": str(e)}, status_code=500)
    
@router.put(("/promotion/{promotion_id}"))
async def update_promotion(promotion: Promotion, authorization: str = Header(...), promotion_id: int = Path(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "UPDATE promotion SET name=%s, description=%s WHERE promotion_id=%s",
                (promotion.name, promotion.description, promotion_id)
            )
            await connection.commit()
            return {"message": f"Promotion {promotion.name} updated successfully"}
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()

@router.get("/promotions")
async def get_reservations():
    connection = await connect_to_database()
    async with connection.cursor(aiomysql.DictCursor) as cursor:
        try:
            await cursor.execute("SELECT * FROM promotion")
            promotions = await cursor.fetchall()
            return promotions
        except aiomysql.Error as err:
            return {"error": f"MySQL Error: {err}"}
        finally:
            await cursor.close()
            connection.close()

@router.get("/promotion/{promotion_id}")
async def get_promotion_by_id(authorization: str = Header(...), promotion_id: int = Path(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor(aiomysql.DictCursor) as cursor:
            await cursor.execute("SELECT * FROM promotion Where promotion_id=%s", (promotion_id))
            menu = await cursor.fetchone()
            return menu
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()