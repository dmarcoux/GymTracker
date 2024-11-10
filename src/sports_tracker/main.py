from fastapi import FastAPI

app = FastAPI()


@app.get("/health_check", summary="Perform a health check")
async def health_check() -> bool:
    return True
