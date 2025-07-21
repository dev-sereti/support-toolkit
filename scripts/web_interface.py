import os
import json
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import uvicorn

app = FastAPI()

# Define your directory where incident JSON files are stored
INCIDENT_DIR = "incidents"

# Mount static files if needed
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/api/incidents")
async def get_incidents(days: int = 7):
    incidents = []
    for file in os.listdir(INCIDENT_DIR):
        if file.endswith('.json'):
            with open(os.path.join(INCIDENT_DIR, file)) as f:
                incidents.append(json.load(f))
    return {"incidents": incidents}

# Run the app (optional if using `uvicorn` CLI)
# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)
