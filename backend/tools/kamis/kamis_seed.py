#!/usr/bin/env python3
"""
KAMIS real data -> Flyway seed SQL generator (one-shot snapshot).

KAMIS Open-API를 로컬에서 한 번 호출해 실제 농산물 품목/가격을 가져와
ingredients + ingredient_aliases + price_snapshots seed SQL을 만든다.
발표 시점엔 외부 API 의존 없이, 숫자는 전부 진짜 KAMIS 데이터.

usage:
  pip install requests
  export KAMIS_CERT_KEY=... ; export KAMIS_CERT_ID=...
  python kamis_seed.py [--regday YYYY-MM-DD] [--cls 01|02]
output:
  generated/V20__seed_ingredient_prices_from_kamis.sql
  generated/kamis_raw_<cat>_<date>.json   (debug raw)
검토 후 src/main/resources/db/migration/ 으로 옮기면 Flyway가 적재.
파싱이 비면 generated/kamis_raw_*.json 을 보고 NAME_FIELDS/PRICE_FIELDS 조정.
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
    sys.exit("requests needed: pip install requests")

BASE_URL = "http://www.kamis.or.kr/service/price/xml.do"
ACTION = "dailyPriceByCategoryList"
CATEGORIES = {"100": "grain", "200": "vegetable", "400": "fruit"}

TARGETS = {
    "무": "채소", "배추": "채소", "봄동": "채소", "시금치": "채소",
    "대파": "채소", "브로콜리": "채소", "단호박": "채소", "콜라비": "채소",
    "순무": "채소", "비트": "채소", "고구마": "채소", "감귤": "과일",
}

NAME_FIELDS = ["item_name", "itemname", "productName"]
PRICE_FIELDS = ["dpr1", "price", "dpr"]
UNIT_FIELDS = ["unit"]
ITEMCODE_FIELDS = ["item_code", "itemcode", "productno"]


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


def match_target(kamis_name):
    for std in TARGETS:
        if std in kamis_name or kamis_name in std:
            return std
    return None


def esc(s):
    return s.replace("'", "''")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--regday", default=None)
    ap.add_argument("--cls", default="01", help="01 retail / 02 wholesale")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    cert_key = os.environ.get("KAMIS_CERT_KEY")
    cert_id = os.environ.get("KAMIS_CERT_ID")
    if not cert_key or not cert_id:
        sys.exit("set env KAMIS_CERT_KEY / KAMIS_CERT_ID")

    out_dir = Path(__file__).parent / "generated"
    out_dir.mkdir(exist_ok=True)
    out_path = Path(args.out) if args.out else out_dir / "V20__seed_ingredient_prices_from_kamis.sql"
    price_type = "RETAIL" if args.cls == "01" else "WHOLESALE"

    if args.regday:
        candidate_days = [args.regday]
    else:
        today = dt.date.today()
        candidate_days = [(today - dt.timedelta(days=i)).isoformat() for i in range(0, 11)]

    found = {}
    used_regday = None
    for regday in candidate_days:
        got_any = False
        for cat_code in CATEGORIES:
            try:
                payload = fetch_category(cert_key, cert_id, args.cls, cat_code, regday)
            except Exception as e:
                print("[warn] " + regday + " cat " + cat_code + " fail: " + str(e))
                continue
            (out_dir / ("kamis_raw_" + cat_code + "_" + regday + ".json")).write_text(
                json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
            items = extract_items(payload)
            if items:
                got_any = True
            for row in items:
                name = first_field(row, NAME_FIELDS)
                if not name:
                    continue
                std = match_target(name)
                if not std or std in found:
                    continue
                price = parse_price(first_field(row, PRICE_FIELDS))
                if price is None:
                    continue
                found[std] = {
                    "price": price,
                    "unit": first_field(row, UNIT_FIELDS) or "kg",
                    "kamis_name": name,
                    "item_code": first_field(row, ITEMCODE_FIELDS) or "",
                    "category_code": cat_code,
                    "regday": regday,
                }
        if got_any:
            used_regday = regday
        if len(found) == len(TARGETS):
            break
        if got_any:
            break

    missing = [t for t in TARGETS if t not in found]
    print("\n=== result (regday " + str(used_regday) + ", " + price_type + ") ===")
    print("found " + str(len(found)) + "/" + str(len(TARGETS)) + ": " + ", ".join(found.keys()))
    if missing:
        print("missing: " + ", ".join(missing) + "  (not in KAMIS -> curate or drop)")

    if not found:
        sys.exit("\n[stop] no match. check generated/kamis_raw_*.json and adjust NAME_FIELDS/PRICE_FIELDS.")

    lines = []
    lines.append("-- AUTO-GENERATED by tools/kamis/kamis_seed.py - real KAMIS snapshot")
    lines.append("-- regday: " + str(used_regday) + " / type: " + price_type + " / source: KAMIS Open-API")
    lines.append("-- review before use. re-run safe (NOT EXISTS guards).")
    lines.append("")
    for std, d in found.items():
        cat = TARGETS[std]
        unit = esc(d["unit"])
        kname = esc(d["kamis_name"])
        code = esc(d["item_code"] or (d["category_code"] + "-" + std))
        price = "%.2f" % d["price"]
        name = esc(std)
        rd = d["regday"]
        lines.append("-- " + std + " (" + kname + ") " + price + " / " + unit)
        lines.append(
            "INSERT INTO ingredients (name, category, base_unit, active) "
            "SELECT '" + name + "', '" + esc(cat) + "', '" + unit + "', TRUE "
            "WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '" + name + "');")
        lines.append(
            "INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) "
            "SELECT i.id, 'KAMIS', '" + code + "', '" + kname + "' FROM ingredients i "
            "WHERE i.name = '" + name + "' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a "
            "WHERE a.source='KAMIS' AND a.external_code='" + code + "');")
        lines.append(
            "INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) "
            "SELECT i.id, 'KAMIS', '" + price_type + "', " + price + ", '" + unit + "', DATE '" + rd + "' "
            "FROM ingredients i WHERE i.name = '" + name + "' "
            "AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id "
            "AND p.source='KAMIS' AND p.price_type='" + price_type + "' AND p.observed_date = DATE '" + rd + "');")
        lines.append("")

    lines.append("-- link producer data to ingredients by name (enables ingredient->producers compare)")
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
