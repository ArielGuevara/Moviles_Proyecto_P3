from fastapi import FastAPI
from pydantic import BaseModel
import subprocess
import json
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Configuración de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],  # GET, POST, PUT, DELETE, OPTIONS
    allow_headers=["*"],  # Authorization, Content-Type...
)

class ChatRequest(BaseModel):
    model: str
    prompt: str
    stream: bool = False

@app.post("/api/generate")
async def generate(req: ChatRequest):
    # Forzar idioma español
    prompt_es = f"Responde SIEMPRE en español:\n{req.prompt}"

    # Llamar a Ollama para TinyLlama (asegurando UTF-8)
    process = subprocess.run(
        ["ollama", "run", "llama3", req.model, prompt_es],
        capture_output=True,
        text=True,
        encoding="utf-8" 
    )

    return {"response": process.stdout.strip()}
