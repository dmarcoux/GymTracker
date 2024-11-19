from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from backend.config import ORIGIN_FRONTEND

app = FastAPI()

# Cross-Origin Resource Sharing (CORS)
origins = [ORIGIN_FRONTEND]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", name="index", response_class=JSONResponse)
async def index() -> JSONResponse:
    return JSONResponse(content={"message": "Hello World"})


@app.get("/health_check", summary="Perform a health check", response_class=JSONResponse)
async def health_check() -> JSONResponse:
    return JSONResponse(content={"status": "UP"})
