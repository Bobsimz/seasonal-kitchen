"""비즈니스 로직: LangGraph 실행 및 스트리밍 이벤트 생성."""
import json
import time
from typing import AsyncGenerator

from agents.graph import get_graph
from core.schemas import GraphState, RecipeListEvent, TextStreamEvent
from utils.get_logger import get_logger

logger = get_logger(__name__)

_INITIAL_STATE: GraphState = {
    "query": "",
    "route": "",
    "category": None,
    "cooking_method": None,
    "include_ingredients": [],
    "exclude_ingredients": [],
    "price": None,
    "period": None,
    "time": None,
    "preference": [],
    "target": None,
    "difficulty": None,
    "semantic_context": None,
    "recipes": [],
    "answer": "",
    "streaming_chunks": [],
    "error": None,
}


async def run_query(query: str) -> GraphState:
    t0 = time.perf_counter()
    logger.info("┌─ [QUERY] %s", query)
    graph = get_graph()
    initial = {**_INITIAL_STATE, "query": query}
    result: GraphState = await graph.ainvoke(initial)
    logger.info("└─ [TOTAL] elapsed=%.2fs", time.perf_counter() - t0)
    return result


async def stream_query(query: str) -> AsyncGenerator[str, None]:
    t0 = time.perf_counter()
    logger.info("┌─ [QUERY] %s", query)
    graph = get_graph()
    initial = {**_INITIAL_STATE, "query": query}

    async for event in graph.astream_events(initial, version="v2"):
        kind = event.get("event")

        if kind == "on_chain_stream":
            chunk = event.get("data", {}).get("chunk", {})
            for text in chunk.get("streaming_chunks", []):
                yield json.dumps(TextStreamEvent(content=text).model_dump())

        elif kind == "on_chain_end":
            output = event.get("data", {}).get("output", {})
            recipes = output.get("recipes")
            if recipes:
                yield json.dumps(RecipeListEvent(items=recipes).model_dump())

    logger.info("└─ [TOTAL] elapsed=%.2fs", time.perf_counter() - t0)
