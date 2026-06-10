#!/usr/bin/env python3
"""
KAMIS 품목 코드표(action=productInfo) 조회 헬퍼.
우리 12개 타겟 품목의 부류/품목/품종 코드를 뽑아 보여준다.
이걸로 일별 품목별(#2) / 기간 시세(#17) API를 정확히 호출할 수 있다.

usage (로컬, 인터넷 되는 곳):
  $env:KAMIS_CERT_KEY="..."; $env:KAMIS_CERT_ID="..."   # PowerShell
  py kamis_codes.py
출력: generated/kamis_productinfo.json (원본 전체) + 콘솔에 12품목 매칭표
"""
import json, os, sys
from pathlib import Path
try:
    import requests
except ImportError:
    sys.exit("requests needed: py -m pip install requests")

TARGETS = ["무","배추","봄동","시금치","대파","브로콜리","단호박","콜라비","순무","비트","고구마","감귤"]
URL = "https://www.kamis.or.kr/service/price/xml.do"

params = {"action": "productInfo", "p_returntype": "json"}
# 키가 있으면 붙임(없어도 동작하는 경우가 많음)
if os.environ.get("KAMIS_CERT_KEY"): params["p_cert_key"] = os.environ["KAMIS_CERT_KEY"]
if os.environ.get("KAMIS_CERT_ID"):  params["p_cert_id"]  = os.environ["KAMIS_CERT_ID"]

r = requests.get(URL, params=params, timeout=30)
r.raise_for_status()
try:
    payload = r.json()
except Exception:
    payload = json.loads(r.text)

out_dir = Path(__file__).parent / "generated"
out_dir.mkdir(exist_ok=True)
(out_dir / "kamis_productinfo.json").write_text(
    json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")

# 응답 구조 방어적 추출
data = payload.get("data", payload) if isinstance(payload, dict) else payload
rows = data.get("item") or data.get("items") or data if isinstance(data, (list, dict)) else []
if isinstance(rows, dict): rows = [rows]

print("총 코드행:", len(rows))
if rows:
    print("첫 행 필드들:", list(rows[0].keys()))
print("\n=== 타겟 12품목 매칭 ===")
def name_of(row):
    for k in ("item_name","itemname","productName","product_name","itemkindname","kindname"):
        if k in row: return str(row[k])
    return ""
for t in TARGETS:
    hits = [row for row in rows if isinstance(row, dict) and t in name_of(row)]
    if hits:
        for h in hits[:3]:
            print(f"[{t}] " + json.dumps(h, ensure_ascii=False))
    else:
        print(f"[{t}] (코드표에 없음)")
