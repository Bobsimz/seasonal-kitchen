"""엣지 라우팅 함수."""
from langgraph.graph import END

from core.schemas import GraphState


def route_from_supervisor(state: GraphState) -> str:
    route = state.get("route", "recipe_search")
    if route == "recipe_search":
        return "coordinate"
    return END
