from typing import Annotated, Any, Literal, Union
from typing_extensions import TypedDict

from pydantic import BaseModel


# ── LangGraph State ──────────────────────────────────────────────
class GraphState(TypedDict):
    query: str
    # Supervisor 출력
    route: str                         # "recipe_search" | "ingredient_search" | "recipe_execution" | "exception"
    # CoordinateNode 출력
    category: str | None               # 종류: 반찬/국&찌개/후식/밥/면/빵 등
    cooking_method: str | None         # 조리방법: 볶음/끓이기/튀김/굽기/무침 등
    include_ingredients: list[str]     # 꼭 들어가야 하는 재료
    exclude_ingredients: list[str]     # 피해야 하는 재료
    price: int | None                  # 가격 상한 (원 단위)
    period: int | None                 # 기간 (일 단위)
    time: int | None                   # 조리 시간 (분 단위)
    preference: list[str]              # 취향: 맵게/달콤하게 등
    spicy_min: int | None              # 맵기 최솟값 (1~5)
    spicy_max: int | None              # 맵기 최댓값 (1~5)
    target: str | None                 # 대상: 아이/노인/직장인 등
    difficulty: str | None             # 난이도: 쉬움/중간/어려움
    semantic_context: str | None
    # Search 출력
    recipes: list[dict[str, Any]]
    # Synthesis 출력
    answer: str
    streaming_chunks: list[str]
    error: str | None


# ── Response Blocks ───────────────────────────────────────────────
class TextBlock(BaseModel):
    type: Literal["text"] = "text"
    content: str


class RecipesBlock(BaseModel):
    type: Literal["recipes"] = "recipes"
    items: list[dict[str, Any]]


Block = Union[TextBlock, RecipesBlock]


# ── API Request / Response ────────────────────────────────────────
class RecipeQueryRequest(BaseModel):
    query: str
    session_id: str
    user_id: str | None = None


class RecipeQueryResponse(BaseModel):
    blocks: list[Block]


# ── Streaming Events ──────────────────────────────────────────────
class TextStreamEvent(BaseModel):
    type: str = "text"
    content: str


class RecipeListEvent(BaseModel):
    type: str = "recipes"
    items: list[dict[str, Any]]
