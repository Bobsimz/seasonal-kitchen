from pydantic_settings import BaseSettings, SettingsConfigDict

GEMINI_MODEL = "gemini-3.1-flash-lite"
LOG_LEVEL = "INFO"

RECIPE_COLLECTION = "recipes"
RECIPE_VECTOR_DIMS = 1024
EMBEDDING_MODEL = "intfloat/multilingual-e5-large"
RECIPE_SEARCH_K = 10
DEFAULT_RECIPE_COUNT = 1


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    # Gemini
    gemini_api_key: str

    # Qdrant
    qdrant_host: str = "localhost"
    qdrant_port: int = 6333
    qdrant_api_key: str | None = None



settings = Settings()
