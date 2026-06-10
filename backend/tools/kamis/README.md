# KAMIS 실데이터 seed (1회 스냅샷)

발표 때 가짜 숫자 대신 **진짜 KAMIS 농산물 가격**을 쓰기 위한 도구.
KAMIS Open-API를 로컬에서 한 번 호출 → `ingredients` / `ingredient_aliases` / `price_snapshots`
seed SQL을 생성한다. 적재 후엔 외부 API 의존이 없다.

## 1. KAMIS Open-API 키 발급 (최초 1회)

1. https://www.kamis.or.kr 회원가입 후 로그인
2. 상단 **고객센터 → Open-API → Open-API 이용안내**
   (https://www.kamis.or.kr/customer/reference/openapi_list.do)
3. 이용 신청 → 승인되면 **인증키(cert_key)** 와 **인증ID(cert_id)** 발급
   - 승인은 보통 즉시~하루.
   - 정부24 경로로도 신청 가능: https://www.gov.kr/portal/service/serviceInfo/B55284500023

## 2. 실행

```bash
cd backend/tools/kamis
pip install requests

export KAMIS_CERT_KEY=발급받은_인증키
export KAMIS_CERT_ID=발급받은_인증ID      # Windows PowerShell: $env:KAMIS_CERT_KEY="..."

# 오늘 기준 소매가 (데이터 없으면 직전 영업일로 최대 10일 폴백)
python kamis_seed.py

# 옵션
python kamis_seed.py --regday 2026-06-05   # 특정일
python kamis_seed.py --cls 02              # 도매 (기본 01 소매)
```

## 3. 결과 확인 & 적용

- 생성물: `generated/V20__seed_ingredient_prices_from_kamis.sql`
- 원본 응답(디버그): `generated/kamis_raw_<부류>_<날짜>.json`

SQL을 검토한 뒤 마이그레이션 폴더로 옮기면 Flyway가 적재한다:

```bash
cp generated/V20__seed_ingredient_prices_from_kamis.sql \
   ../../src/main/resources/db/migration/
```

생성된 V20에는 ingredients 적재 + **농가 데이터 이름 연결(producer_offers/specialties.ingredient_id 백필)** 까지 포함된다.
이게 적용되면 "식재료별 농가 비교"(`GET /api/v1/ingredients/{id}/producers`)가 ID 기준으로 동작한다.
(적용 전에도 서비스가 이름 폴백으로 동작하므로 화면은 깨지지 않는다.)

> 생성 SQL은 `WHERE NOT EXISTS` 가드가 있어 재실행/중복 적재에 안전하다.
> 단, Flyway 체크섬 때문에 **이미 적용된 마이그레이션 파일 내용을 나중에 바꾸지 말 것**
> (수정이 필요하면 다음 버전(V21+)으로 새로 만든다). 참고: V14는 농가 시드.

## 4. 대상 품목

프론트 데모 기준 12종: 무·배추·봄동·시금치·대파·브로콜리·단호박·콜라비·순무·비트·고구마·감귤.
KAMIS에 없는 품목(봄동·콜라비·순무·비트 등 소품목 가능성)은 "못 찾음"으로 리포트되며,
그건 수기 보정하거나 데모 목록에서 빼면 된다.

## 5. 트러블슈팅

- **매칭 0건**: `generated/kamis_raw_*.json` 을 열어 실제 필드명을 확인하고
  `kamis_seed.py` 의 `NAME_FIELDS` / `PRICE_FIELDS` 를 응답에 맞게 조정.
- **error_code != 000**: 키/ID 오류 또는 쿼터. 응답 JSON의 메시지 확인.
- **단위 불일치**: KAMIS 단위(예: 20kg, 1kg, 1개)가 앱 `base_unit`과 다를 수 있음.
  `producer_offers` 로 내릴 때 단위 환산이 필요하면 별도 큐레이션.

## 참고

- �