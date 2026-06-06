"""Qdrant 레시피 컬렉션 CRUD."""
from qdrant_client import AsyncQdrantClient
from qdrant_client.models import PointIdsList, PointStruct

from core.config import RECIPE_COLLECTION


async def get_recipe_by_id(client: AsyncQdrantClient, recipe_id: str) -> dict | None:
    results = await client.retrieve(
        collection_name=RECIPE_COLLECTION,
        ids=[recipe_id],
        with_payload=True,
    )
    return results[0].payload if results else None


async def upsert_recipe(client: AsyncQdrantClient, recipe_id: str, vector: list[float], payload: dict) -> None:
    await client.upsert(
        collection_name=RECIPE_COLLECTION,
        points=[PointStruct(id=recipe_id, vector=vector, payload=payload)],
    )


async def bulk_upsert_recipes(client: AsyncQdrantClient, recipes: list[dict], vectors: list[list[float]]) -> None:
    points = [
        PointStruct(id=r["RCP_SEQ"], vector=v, payload=r)
        for r, v in zip(recipes, vectors)
    ]
    await client.upsert(collection_name=RECIPE_COLLECTION, points=points)


async def delete_recipe(client: AsyncQdrantClient, recipe_id: str) -> None:
    await client.delete(
        collection_name=RECIPE_COLLECTION,
        points_selector=PointIdsList(points=[recipe_id]),
    )
