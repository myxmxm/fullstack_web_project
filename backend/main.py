from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
# from routers import router
from routers import login, reservation, menu, promotion, message, frontend

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")
app.mount("/frontend", StaticFiles(directory="../frontend"), name="frontend")

origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://127.0.0.1",
    "http://127.0.0.1:8000",
    "http://127.0.0.1:5501",
    "http://10.120.32.84",
    "http://10.120.32.84:8000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)

app.include_router(login.router)
app.include_router(reservation.router)
app.include_router(menu.router)
app.include_router(promotion.router)
app.include_router(message.router)
app.include_router(frontend.router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
