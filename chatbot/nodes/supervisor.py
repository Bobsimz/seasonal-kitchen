"""Supervisor 노드: 쿼리 분류 및 라우팅."""
import json
import time

from conn.llm import get_llm
from core.config import GEMINI_MODEL
from core.schemas import GraphState
from utils.get_logger import get_logger
from utils.prompt_loader import load_prompt

logger = get_logger(__name__)

_VALID_ROUTES = {"recipe_search", "ingredient_search", "recipe_execution", "exception"}

_AGENT_ANSWERS = {
    "ingredient_search": "재료 탐색 agent입니다.",
    "recipe_execution": "레시피 진행 agent입니다.",
    "exception": "요리 관련 질의만 답변할 수 있습니다.",
}


async def supervisor_node(state: GraphState) -> dict:
    t0 = time.perf_counter()
    prompt_template = load_prompt("supervisor")
    prompt = prompt_template.replace("{query}", state["query"])

    try:
        client = get_llm()
        response = await client.aio.models.generate_content(
            model=GEMINI_MODEL, contents=prompt
        )
        parsed = json.loads(response.text)
        route = parsed.get("route", "recipe_search")
        if route not in _VALID_ROUTES:
            route = "recipe_search"
    except Exception as e:
        logger.error("├─ [SUPERVISOR] error=%s | elapsed=%.2fs", e, time.perf_counter() - t0)
        return {
            "route": "exception",
            "answer": "요리 관련 질의만 답변할 수 있습니다.",
            "error": str(e),
        }

    logger.info("├─ [SUPERVISOR] route=%s | elapsed=%.2fs", route, time.perf_counter() - t0)

    if route != "recipe_search":
        answer = _AGENT_ANSWERS.get(route, "요리 관련 질의만 답변할 수 있습니다.")
        return {"route": route, "answer": answer}

    return {"route": route}
