from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form, APIRouter
from fastapi.responses import FileResponse, JSONResponse
from utils.basemodel import * 
from utils.autentication import * 
import shutil

router = APIRouter()

@router.post("/login", tags=["authentication"], summary="Login to get a bearer token")
async def login(user: UserLogin):
    if await authenticate_user(user.username, user.password):
        token = generate_token(user.username, user.password)
        return {"message": "Login successfully!","token": token, "username": user.username}
    else:
        # raise HTTPException(status_code=401, detail="Invalid username or password")
        return JSONResponse(content={"message": "Invalid username or password"}, status_code=401)
    
@router.post("/reservation")
async def create_reservation(reservation: Reservation):
    connection = await connect_to_database()
    async with connection.cursor() as cursor:
        try:
            await cursor.execute(
                "INSERT INTO reservation (date, email, name, time) VALUES (%s, %s, %s, %s)",
                (reservation.date, reservation.email, reservation.name, reservation.time)
            )
            await connection.commit()
            return {"message": "Reservation created successfully"}
        except aiomysql.Error as err:
            return {"error": f"MySQL Error: {err}"}
        finally:
            await cursor.close()
            connection.close()

@router.put(("/reservation/{reservation_id}"))
async def update_menu(authorization: str = Header(...), reservation_id: int = Path(...)):
    token = authorization.split(" ")[1]  
    decode_token(token)
    try:
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "UPDATE reservation SET status=%s WHERE reservation_id=%s",
                ("confirmed",reservation_id)
            )
            await connection.commit()
            return {"message": f"Reservation {reservation_id} has been confirmed successfully"}
    except aiomysql.Error as err:
        return {"error": f"MySQL Error: {err}"}
    finally:
        await cursor.close()
        connection.close()

@router.get("/reservations")
async def get_reservations(authorization: str = Header(...)):
    token = authorization.split(" ")[1]
    decode_token(token)
    connection = await connect_to_database()
    async with connection.cursor(aiomysql.DictCursor) as cursor:
        try:
            await cursor.execute("SELECT * FROM reservation")
            reservations = await cursor.fetchall()
            return reservations
        except aiomysql.Error as err:
            return {"error": f"MySQL Error: {err}"}
        finally:
            await cursor.close()
            connection.close()

@router.delete("/reservations/{reservation_id}")
async def delete_reservation(authorization: str = Header(...), reservation_id: int = Path(...)):
    try:
        token = authorization.split(" ")[1]
        decode_token(token)
        connection = await connect_to_database()
        async with connection.cursor() as cursor:
            await cursor.execute(
                "DELETE FROM reservation WHERE reservation_id = %s",
                (reservation_id,)
            )
            await connection.commit()

            if cursor.rowcount > 0:
                return {"message": f"Reservation with id {reservation_id} deleted successfully"}
            else:
                return {"message": f"No Reservation found with id {reservation_id}"}
    except Exception as e:
        return JSONResponse(content={"detail": str(e)}, status_code=500)

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