from google import genai

from core.config import GEMINI_MODEL, settings

_client: genai.Client | None = None


def get_llm() -> genai.Client:
    global _client
    if _client is None:
        _client = genai.Client(api_key=settings.gemini_api_key)
    return _client
