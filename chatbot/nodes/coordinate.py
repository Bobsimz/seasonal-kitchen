"""쿼리 분석 노드: 사용자 입력 → 검색 파라미터 추출."""
import json
import time as time_mod

from conn.llm import get_llm
from core.config import GEMINI_MODEL
from core.schemas import GraphState
from utils.get_logger import get_logger
from utils.prompt_loader import load_prompt

logger = get_logger(__name__)


async def coordinate_node(state: GraphState) -> dict:
    t0 = time_mod.perf_counter()
    prompt_template = load_prompt("coordinate")
    prompt = prompt_template.replace("{query}", state["query"])

    try:
        client = get_llm()
        response = await client.aio.models.generate_content(
            model=GEMINI_MODEL, contents=prompt
        )
        parsed = json.loads(response.text)
    except Exception as e:
        logger.error("├─ [COORDINATE] error=%s | elapsed=%.2fs", e, time_mod.perf_counter() - t0)
        return {"error": str(e)}

    category = parsed.get("category")
    cooking_method = parsed.get("cooking_method")
    include_ingredients = parsed.get("include_ingredients", [])
    exclude_ingredients = parsed.get("exclude_ingredients", [])
    price = parsed.get("price")
    period = parsed.get("period")
    time = parsed.get("time")
    preference = parsed.get("preference", [])
    spicy_min = parsed.get("spicy_min")
    spicy_max = parsed.get("spicy_max")
    target = parsed.get("target")
    difficulty = parsed.get("difficulty")
    semantic_context = parsed.get("semantic_context")

    logger.info(
        "├─ [COORDINATE] category=%s | method=%s"
        " | include=%s | exclude=%s | price=%s | period=%s | time=%s"
        " | preference=%s | spicy=[%s,%s] | target=%s | difficulty=%s | semantic=%s | elapsed=%.2fs",
        category, cooking_method,
        include_ingredients, exclude_ingredients, price, period, time,
        preference, spicy_min, spicy_max, target, difficulty, semantic_context, time_mod.perf_counter() - t0,
    )

    return {
        "category": category,
        "cooking_method": cooking_method,
        "include_ingredients": include_ingredients,
        "exclude_ingredients": exclude_ingredients,
        "price": price,
        "period": period,
        "time": time,
        "preference": preference,
        "spicy_min": spicy_min,
        "spicy_max": spicy_max,
        "target": target,
        "difficulty": difficulty,
        "semantic_context": semantic_context,
        "error": None,
    }
