from pydantic import BaseModel, Field
from datetime import date , time

class UserLogin(BaseModel):
    username: str
    password: str

class Reservation(BaseModel):
    date: date
    email: str
    name: str
    time: time

class Menu(BaseModel):
    name: str
    description: str
    price: float

class Promotion(BaseModel):
    name: str 
    description: str 