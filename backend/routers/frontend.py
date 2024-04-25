from fastapi import FastAPI, HTTPException, Body, Path, Depends, Header, File, UploadFile, Form, APIRouter
from fastapi.responses import FileResponse, JSONResponse
from utils.basemodel import * 
from utils.autentication import * 
import shutil

router = APIRouter()

@router.get("/")
async def serve_index():
    return FileResponse("../frontend/index.html")