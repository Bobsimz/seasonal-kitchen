from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from fastapi.responses import StreamingResponse

from core.schemas import RecipeQueryRequest, RecipeQueryResponse, RecipesBlock, TextBlock
from service import run_query, stream_query
from utils.get_logger import get_logger

logger = get_logger(__name__)

router = APIRouter()


@router.post("/api/recipe/query", response_model=RecipeQueryResponse)
async def query_recipe(request: RecipeQueryRequest):
    result = await run_query(request.query)
    blocks = []
    if result.get("answer"):
        blocks.append(TextBlock(content=result["answer"]))
    if result.get("recipes"):
        blocks.append(RecipesBlock(items=result["recipes"]))
    return RecipeQueryResponse(blocks=blocks)


@router.get("/api/recipe/stream")
async def stream_recipe(query: str):
    async def event_generator():
        async for chunk in stream_query(query):
            yield f"data: {chunk}\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")


@router.websocket("/ws/recipe")
async def websocket_recipe(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            query = await websocket.receive_text()
            async for chunk in stream_query(query):
                await websocket.send_text(chunk)
    except WebSocketDisconnect:
        logger.info("WebSocket disconnected")
