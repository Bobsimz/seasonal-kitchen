"""LangGraph StateGraph 정의 및 컴파일."""
from langgraph.graph import END, START, StateGraph

from agents.edges import route_from_supervisor
from core.schemas import GraphState
from nodes.coordinate import coordinate_node
from nodes.response import response_node
from nodes.semantic_search import semantic_search_node
from nodes.supervisor import supervisor_node


def build_graph() -> StateGraph:
    graph = StateGraph(GraphState)

    graph.add_node("supervisor", supervisor_node)
    graph.add_node("coordinate", coordinate_node)
    graph.add_node("semantic_search", semantic_search_node)
    graph.add_node("response", response_node)

    graph.add_edge(START, "supervisor")
    graph.add_conditional_edges(
        "supervisor",
        route_from_supervisor,
        {"coordinate": "coordinate", END: END},
    )
    graph.add_edge("coordinate", "semantic_search")
    graph.add_edge("semantic_search", "response")
    graph.add_edge("response", END)

    return graph


_compiled = None


def get_graph():
    global _compiled
    if _compiled is None:
        _compiled = build_graph().compile()
    return _compiled
