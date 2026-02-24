from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="CloudShop Auth Service")

Instrumentator().instrument(app).expose(app)


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/login")
def login(credentials: dict):
    # TODO: implement real authentication
    return {"token": "placeholder-token"}


@app.post("/register")
def register(user: dict):
    # TODO: implement real user registration
    return {"message": "User registered"}
