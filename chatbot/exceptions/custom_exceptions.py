class AIChefError(Exception):
    pass


class LLMError(AIChefError):
    pass


class SearchError(AIChefError):
    pass


class EmbeddingError(AIChefError):
    pass
