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