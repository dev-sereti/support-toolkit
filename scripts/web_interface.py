# web_interface.py
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import uvicorn
import json

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/api/incidents")
async def get_incidents(days: int = 7):
    incidents = []
    for file in os.listdir(INCIDENT_DIR):
        if file.endswith('.json'):
            with open(f"{INCIDENT_DIR}/{file}") as f:
                incidents.append(json.load(f))
    return {"incidents": incidents}