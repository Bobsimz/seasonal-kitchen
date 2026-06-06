import re


def extract_recipe_ids(text: str) -> list[str]:
    """응답 텍스트에서 <|RECIPES|>...<|/RECIPES|> 마커 안의 ID 추출."""
    match = re.search(r"<\|RECIPES\|>(.*?)<\|/RECIPES\|>", text, re.DOTALL)
    if not match:
        return []
    return [rid.strip() for rid in match.group(1).split(",") if rid.strip()]


def strip_recipe_markers(text: str) -> str:
    return re.sub(r"<\|RECIPES\|>.*?<\|/RECIPES\|>", "", text, flags=re.DOTALL).strip()
