import httpx
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse

app = FastAPI()

# Configuración de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    model: str
    prompt: str
    stream: bool = False

@app.post("/api/generate_stream")
async def generate_stream(req: ChatRequest):
    async def event_stream():
        prompt_es = (
            f"Responde SIEMPRE en español, si la pregunta no es referente a agricultura, "
            f"plantas o jardinería, preguntame si debes continuar, sino respondeme:\n{req.prompt}"
        )
        async with httpx.AsyncClient(timeout=None) as client:
            async with client.stream(
                "POST",
                "http://localhost:11434/api/generate",
                json={"model": req.model, "prompt": prompt_es, "stream": True}
            ) as response:
                async for line in response.aiter_lines():
                    if line.strip():
                        yield line + "\n"
    return StreamingResponse(event_stream(), media_type="text/plain")
