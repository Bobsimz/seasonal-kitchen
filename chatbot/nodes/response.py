"""Response 노드: 검색 결과 → 스트리밍 응답 생성."""
import json
import time

from conn.llm import get_llm
from core.config import DEFAULT_RECIPE_COUNT, GEMINI_MODEL
from core.schemas import GraphState
from utils.get_logger import get_logger
from utils.prompt_loader import load_prompt

logger = get_logger(__name__)


async def response_node(state: GraphState) -> dict:
    t0 = time.perf_counter()
    recipe_names = json.dumps(
        [
            {"id": r.get("RCP_SEQ"), "name": r.get("RCP_NM")}
            for r in state.get("recipes", [])
        ],
        ensure_ascii=False,
    )

    period = state.get("period")
    count = period if period is not None else DEFAULT_RECIPE_COUNT
    period_instruction = f"반드시 정확히 {count}개의 레시피를 선택하세요."

    prompt_template = load_prompt("response")
    prompt = (
        prompt_template
        .replace("{query}", state["query"])
        .replace("{recipes}", recipe_names)
        .replace("{period_instruction}", period_instruction)
    )

    chunks: list[str] = []
    try:
        client = get_llm()
        async for chunk in await client.aio.models.generate_content_stream(
            model=GEMINI_MODEL, contents=prompt
        ):
            if chunk.text:
                chunks.append(chunk.text)
    except Exception as e:
        logger.error("└─ [RESPONSE] error=%s | elapsed=%.2fs", e, time.perf_counter() - t0)
        return {"answer": "", "streaming_chunks": [], "error": str(e)}

    answer = "".join(chunks)
    logger.info("└─ [RESPONSE] elapsed=%.2fs", time.perf_counter() - t0)
    return {"answer": answer, "streaming_chunks": chunks}
