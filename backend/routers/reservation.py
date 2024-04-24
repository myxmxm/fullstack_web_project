from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form, APIRouter
from fastapi.responses import FileResponse, JSONResponse
from utils.basemodel import * 
from utils.autentication import * 
import shutil

router = APIRouter()

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