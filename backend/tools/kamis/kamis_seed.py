#!/usr/bin/env python3
"""
KAMIS real data -> Flyway seed SQL generator (one-shot snapshot).

KAMIS 일별 부류별 도·소매가격정보(action=dailyPriceByCategoryList)를 호출해
지정한 부류(식량작물/채소/특용작물/과일)의 **모든 품목**을 가져와
ingredients + ingredient_aliases + price_snapshots seed SQL을 만든다.
(12개로 필터링하지 않고 KAMIS가 주는 품목 전체를 적재)

usage (로컬, 인터넷 되는 곳 / PowerShell):
  py -m pip install requests
  $env:KAMIS_CERT_KEY="..."; $env:KAMIS_CERT_ID="..."
  py kamis_seed.py [--regday YYYY-MM-DD] [--cls 01|02] [--cats 100,200,300,400]
output:
  generated/V20__seed_ingredient_prices_from_kamis.sql
  generated/kamis_raw_<cat>_<date>.json
검토 후 src/main/resources/db/migration/ 으로 옮기면 Flyway가 적재.
"""
import argparse
import datetime as dt
import json
import os
import re
import sys
from pathlib import Path

try:
    import requests
except ImportError:
    sys.exit("requests needed: py -m pip install requests")

BASE_URL = "http://www.kamis.or.kr/service/price/xml.do"
ACTION = "dailyPriceByCategoryList"

# 부류코드 -> 앱 category 라벨
CAT_LABEL = {
    "100": "곡류",
    "200": "채소",
    "300": "기타",   # 특용작물(참깨/땅콩 등)
    "400": "과일",
    "500": "축산",
    "600": "수산",
}

NAME_FIELDS = ["item_name", "itemname", "productName"]
PRICE_FIELDS = ["dpr1", "price", "dpr"]
UNIT_FIELDS = ["unit"]
ITEMCODE_FIELDS = ["item_code", "itemcode", "productno"]
KIND_FIELDS = ["kind_name", "kindname", "item_kind_name"]


def fetch_category(cert_key, cert_id, cls, category, regday):
    params = {
        "action": ACTION,
        "p_product_cls_code": cls,
        "p_item_category_code": category,
        "p_country_code": "",
        "p_regday": regday,
        "p_convert_kg_yn": "N",
        "p_cert_key": cert_key,
        "p_cert_id": cert_id,
        "p_returntype": "json",
    }
    r = requests.get(BASE_URL, params=params, timeout=20)
    r.raise_for_status()
    try:
        return r.json()
    except json.JSONDecodeError:
        return json.loads(r.text)


def extract_items(payload):
    data = payload.get("data", payload) if isinstance(payload, dict) else payload
    if isinstance(data, dict):
        items = data.get("item") or data.get("items") or []
    elif isinstance(data, list):
        items = data
    else:
        items = []
    if isinstance(items, dict):
        items = [items]
    return items


def first_field(row, candidates):
    for c in candidates:
        if c in row and str(row[c]).strip() not in ("", "-", "null", "None"):
            return str(row[c]).strip()
    return None


def parse_price(raw):
    if raw is None:
        return None
    num = re.sub(r"[^0-9.]", "", raw)
    if not num:
        return None
    try:
        return float(num)
    except ValueError:
        return None


def esc(s):
    return s.replace("'", "''")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--regday", default=None)
    ap.add_argument("--cls", default="01", help="01 retail / 02 wholesale")
    ap.add_argument("--cats", default="100,200,300,400", help="comma-separated 부류코드")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    cert_key = os.environ.get("KAMIS_CERT_KEY")
    cert_id = os.environ.get("KAMIS_CERT_ID")
    if not cert_key or not cert_id:
        sys.exit("set env KAMIS_CERT_KEY / KAMIS_CERT_ID")

    cats = [c.strip() for c in args.cats.split(",") if c.strip()]
    out_dir = Path(__file__).parent / "generated"
    out_dir.mkdir(exist_ok=True)
    out_path = Path(args.out) if args.out else out_dir / "V20__seed_ingredient_prices_from_kamis.sql"
    price_type = "RETAIL" if args.cls == "01" else "WHOLESALE"

    if args.regday:
        candidate_days = [args.regday]
    else:
        today = dt.date.today()
        candidate_days = [(today - dt.timedelta(days=i)).isoformat() for i in range(0, 11)]

    items_by_name = {}   # name -> dict  (전체 품목 적재, 이름 중복은 첫 값 유지)
    used_regday = None
    for regday in candidate_days:
        got_any = False
        for cat in cats:
            try:
                payload = fetch_category(cert_key, cert_id, args.cls, cat, regday)
            except Exception as e:
                print("[warn] " + regday + " cat " + cat + " fail: " + str(e))
                continue
            (out_dir / ("kamis_raw_" + cat + "_" + regday + ".json")).write_text(
                json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
            rows = extract_items(payload)
            if rows:
                got_any = True
            for row in rows:
                if not isinstance(row, dict):
                    continue
                name = first_field(row, NAME_FIELDS)
                price = parse_price(first_field(row, PRICE_FIELDS))
                if not name or price is None:
                    continue
                if name in items_by_name:
                    continue
                items_by_name[name] = {
                    "price": price,
                    "unit": first_field(row, UNIT_FIELDS) or "kg",
                    "kamis_name": name,
                    "item_code": first_field(row, ITEMCODE_FIELDS) or "",
                    "kind": first_field(row, KIND_FIELDS) or "",
                    "category_label": CAT_LABEL.get(cat, "기타"),
                    "category_code": cat,
                    "regday": regday,
                }
        if got_any:
            used_regday = regday
            break  # 첫 유효일로 확정(여러 날 섞이지 않게)

    print("\n=== result (regday " + str(used_regday) + ", " + price_type + ") ===")
    print("적재 품목 수: " + str(len(items_by_name)))
    print("품목: " + ", ".join(sorted(items_by_name.keys())))

    if not items_by_name:
        sys.exit("\n[stop] 받은 품목이 없습니다. generated/kamis_raw_*.json 확인 후 필드명 조정.")

    lines = []
    lines.append("-- AUTO-GENERATED by tools/kamis/kamis_seed.py - real KAMIS snapshot (전체 품목)")
    lines.append("-- regday: " + str(used_regday) + " / type: " + price_type + " / cats: " + ",".join(cats))
    lines.append("-- review before use. re-run safe (NOT EXISTS guards).")
    lines.append("")
    for name, d in items_by_name.items():
        cat = esc(d["category_label"])
        unit = esc(d["unit"])
        kname = esc(d["kamis_name"])
        code = esc(d["item_code"] or (d["category_code"] + "-" + name))
        price = "%.2f" % d["price"]
        nm = esc(name)
        rd = d["regday"]
        lines.append("-- " + name + " (" + d["category_label"] + ") " + price + " / " + unit)
        lines.append(
            "INSERT INTO ingredients (name, category, base_unit, active) "
            "SELECT '" + nm + "', '" + cat + "', '" + unit + "', TRUE "
            "WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '" + nm + "');")
        lines.append(
            "INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) "
            "SELECT i.id, 'KAMIS', '" + code + "', '" + kname + "' FROM ingredients i "
            "WHERE i.name = '" + nm + "' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a "
            "WHERE a.source='KAMIS' AND a.external_code='" + code + "');")
        lines.append(
            "INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) "
            "SELECT i.id, 'KAMIS', '" + price_type + "', " + price + ", '" + unit + "', DATE '" + rd + "' "
            "FROM ingredients i WHERE i.name = '" + nm + "' "
            "AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id "
            "AND p.source='KAMIS' AND p.price_type='" + price_type + "' AND p.observed_date = DATE '" + rd + "');")
        lines.append("")

    # 농가 데이터(producer_offers/specialties)를 이름으로 ingredient에 연결
    lines.append("-- link producer data to ingredients by name (식재료별 농가 비교용)")
    lines.append(
        "UPDATE producer_offers SET ingredient_id = "
        "(SELECT i.id FROM ingredients i WHERE i.name = producer_offers.ingredient_name) "
        "WHERE ingredient_id IS NULL "
        "AND EXISTS (SELECT 1 FROM ingredients i WHERE i.name = producer_offers.ingredient_name);")
    lines.append(
        "UPDATE producer_specialties SET ingredient_id = "
        "(SELECT i.id FROM ingredients i WHERE i.name = producer_specialties.ingredient_name) "
        "WHERE ingredient_id IS NULL "
        "AND EXISTS (SELECT 1 FROM ingredients i WHERE i.name = producer_specialties.ingredient_name);")
    lines.append("")

    out_path.write_text("\n".join(lines), encoding="utf-8")
    print("\nSQL written: " + str(out_path))
    print("move into src/main/resources/db/migration/ after review.")


if __name__ == "__main__":
    main()
