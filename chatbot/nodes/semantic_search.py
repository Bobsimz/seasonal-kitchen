"""Qdrant 벡터 검색 노드."""
import asyncio
import time

from qdrant_client.models import FieldCondition, Filter, MatchValue, Range

from conn.qdrant import get_qdrant
from core.config import RECIPE_COLLECTION, RECIPE_SEARCH_K
from core.schemas import GraphState
from models.embedding import embed_query
from utils.get_logger import get_logger

logger = get_logger(__name__)


async def _embed(text: str) -> list[float]:
    return await asyncio.get_event_loop().run_in_executor(None, embed_query, text)


def _build_filter(
    category: str | None,
    cooking_method: str | None,
    include_ingredients: list[str],
    exclude_ingredients: list[str],
    spicy_min: int | None,
    spicy_max: int | None,
    time: int | None,
) -> Filter | None:
    must = []
    must_not = []

    if category:
        must.append(FieldCondition(key="RCP_PAT2", match=MatchValue(value=category)))
    if cooking_method:
        must.append(FieldCondition(key="RCP_WAY2", match=MatchValue(value=cooking_method)))
    for ingredient in include_ingredients:
        must.append(FieldCondition(key="ingredients", match=MatchValue(value=ingredient)))
    for ingredient in exclude_ingredients:
        must_not.append(FieldCondition(key="ingredients", match=MatchValue(value=ingredient)))
    if spicy_min is not None or spicy_max is not None:
        must.append(FieldCondition(
            key="spicy_level",
            range=Range(gte=spicy_min, lte=spicy_max),
        ))
    if time is not None:
        must.append(FieldCondition(
            key="cooking_time_min",
            range=Range(lte=time),
        ))

    if not must and not must_not:
        return None
    return Filter(must=must or None, must_not=must_not or None)


def _build_knn_context(state: GraphState) -> str:
    parts = []
    if state.get("category") and state["category"] != "기타":
        parts.append(state["category"])
    if state.get("include_ingredients"):
        parts.append(" ".join(state["include_ingredients"]))
    if state.get("preference"):
        parts.append(" ".join(state["preference"]))
    if state.get("semantic_context"):
        parts.append(state["semantic_context"])
    return " ".join(parts) if parts else state["query"]


async def semantic_search_node(state: GraphState) -> dict:
    t0 = time.perf_counter()
    context = _build_knn_context(state)
    category = state.get("category")
    cooking_method = state.get("cooking_method")
    include_ingredients = state.get("include_ingredients") or []
    exclude_ingredients = state.get("exclude_ingredients") or []
    spicy_min = state.get("spicy_min")
    spicy_max = state.get("spicy_max")
    time_limit = state.get("time")

    # 아이/노인 대상이면 spicy_max를 3으로 강제 cap
    TARGET_SPICY_CAP = {"아이", "노인"}
    target = state.get("target") or ""
    if any(t in target for t in TARGET_SPICY_CAP):
        spicy_max = min(spicy_max, 3) if spicy_max is not None else 3

    query_filter = _build_filter(category, cooking_method, include_ingredients, exclude_ingredients, spicy_min, spicy_max, time_limit)

    preference = state.get("preference") or []
    applied_filters = {k: v for k, v in {
        "category": category,
        "cooking_method": cooking_method,
        "include_ingredients": include_ingredients or None,
        "exclude_ingredients": exclude_ingredients or None,
        "preference": preference or None,
        "spicy_min": spicy_min,
        "spicy_max": spicy_max,
        "time_limit": time_limit,
    }.items() if v}
    logger.info("├─ [KNN] filters_applied=%s", applied_filters)

    try:
        vector = await _embed(context)
    except NotImplementedError as e:
        logger.warning("├─ [KNN] embedding not implemented: %s | elapsed=%.2fs", e, time.perf_counter() - t0)
        return {"recipes": [], "error": str(e)}
    except Exception as e:
        logger.error("├─ [KNN] embedding error=%s | elapsed=%.2fs", e, time.perf_counter() - t0)
        return {"recipes": [], "error": str(e)}

    try:
        client = get_qdrant()
        response = await client.query_points(
            collection_name=RECIPE_COLLECTION,
            query=vector,
            query_filter=query_filter,
            limit=RECIPE_SEARCH_K,
            with_payload=True,
        )
        recipes = [r.payload for r in response.points if r.payload]
    except Exception as e:
        logger.error("├─ [KNN] qdrant error=%s | elapsed=%.2fs", e, time.perf_counter() - t0)
        return {"recipes": [], "error": str(e)}

    names = [r.get("RCP_NM") for r in recipes]
    logger.info(
        "├─ [KNN] embedded_sentence=%s | after_filter: remaining=%d | top10=%s | elapsed=%.2fs",
        context, len(recipes), names, time.perf_counter() - t0,
    )
    return {"recipes": recipes}
