from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form, APIRouter
from fastapi.responses import FileResponse, JSONResponse
from utils.basemodel import * 
from utils.autentication import * 
import shutil

router = APIRouter()

@router.get("/download/{filename}")
async def download_file(filename: str):
    file_path = f"static/{filename}"
    return FileResponse(file_path)

async def create_menu(name: str, description: str, price: str, menu_pic: str):
    try:
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "INSERT INTO menu (name, description, price, menu_pic) VALUES (%s, %s, %s, %s)",
                (name, description, price, menu_pic)
            )
            await connection.commit()
            return {"message": "Menu created successfully"}
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()

@router.post("/menu/")
async def upload_file(authorization: str = Header(...), file: UploadFile = File(...), name: str = Form(...), description: str = Form(...), price: str = Form(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    os.makedirs("static/", exist_ok=True)
    try:
        with open(os.path.join("static/", file.filename), "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        response = await create_menu(name, description, price, file.filename)
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.delete("/menu/{menu_id}")
async def delete_reservation(authorization: str = Header(...), menu_id: int = Path(...)):
    try:
        token = authorization.split(" ")[1]
        decode_token(token)
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "DELETE FROM menu WHERE menu_id = %s",
                (menu_id,)
            )
            await connection.commit()

            if cursor.rowcount > 0:
                return {"message": f"Menu with id {menu_id} deleted successfully"}
            else:
                return {"message": f"No menu found with id {menu_id}"}
    except Exception as e:
        return JSONResponse(content={"detail": str(e)}, status_code=500)
    
@router.get("/menus")
async def get_reservations():
    connection = await connect_to_database()
    async with connection.cursor(aiomysql.DictCursor) as cursor:
        try:
            await cursor.execute("SELECT * FROM menu")
            menus = await cursor.fetchall()
            return menus
        except aiomysql.Error as err:
            return {"error": f"MySQL Error: {err}"}
        finally:
            await cursor.close()
            connection.close()

@router.get("/menu/{menu_id}")
async def get_menu_by_id(authorization: str = Header(...), menu_id: int = Path(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor(aiomysql.DictCursor) as cursor:
            await cursor.execute("SELECT * FROM menu Where menu_id=%s", (menu_id))
            menu = await cursor.fetchone()
            return menu
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()

@router.put(("/menu/{menu_id}"))
async def update_menu(authorization: str = Header(...), name: str = Form(...), description: str = Form(...), price: float = Form(...), menu_id: int = Path(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "UPDATE menu SET name=%s, description=%s, price=%s WHERE menu_id=%s",
                (name, description, price, menu_id)
            )
            await connection.commit()
            return {"message": f"Menu {name} updated successfully"}
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()