# 제철식탁 Seasonal Kitchen

제철 식재료 정보, 레시피, 숏폼 콘텐츠, 농산물 상품 탐색과 판매 등록을 연결하는 해커톤 프로젝트입니다.

## Repository Structure

```text
seasonal-kitchen/
├── openspec/  # 현재 구현 기준 도메인/API spec 및 변경안
├── backend/   # Spring Boot API server
└── frontend/  # Next.js prototype UI
```

## Backend

- Spring Boot 3, Java 21
- PostgreSQL, Flyway
- Spring Security, JWT
- Swagger/OpenAPI
- JUnit 5, Testcontainers

프론트엔드 연동에 필요한 API 계약 문서는 `backend/docs/`에서 확인할 수 있습니다.

- `backend/docs/03-api-contract.md`
- `backend/docs/api-examples.md`
- `backend/docs/frontend-screen-api-coverage.md`
- `backend/docs/frontend-required-fields.md`
- `backend/docs/frontend-integration-verification.md`

```powershell
cd backend
docker compose up -d postgres
.\gradlew test
.\gradlew bootRun
```

Supabase PostgreSQL을 사용할 때는 비밀값을 커밋하지 말고 환경변수로 실행합니다.

```powershell
cd backend
$env:SPRING_PROFILES_ACTIVE="supabase"
$env:SUPABASE_DB_URL="jdbc:postgresql://db.<project-ref>.supabase.co:5432/postgres?sslmode=require"
$env:SUPABASE_DB_USERNAME="postgres"
$env:SUPABASE_DB_PASSWORD="<database-password>"
.\gradlew bootRun
```

Supabase transaction pooler를 쓰는 경우 JDBC URL 끝에 `prepareThreshold=0`을 함께 둡니다.

Swagger:

- `http://localhost:8080/swagger-ui.html`
- `http://localhost:8080/v3/api-docs`

## Frontend

- Next.js 14 (App Router) 모바일 웹앱 — Tailwind CSS, TanStack Query, JWT 인증
- 백엔드가 없어도 동작하는 **데모 폴백** 내장 (mock 데이터)

```bash
cd frontend
npm install
npm run dev   # http://localhost:3000
```

실제 백엔드 연동/구조/추가 개발 요청은 아래 문서를 참고하세요.

- `frontend/FRONTEND-CHANGES.md` — 개편 내용·아키텍처·폴더 구조·실행법
- `frontend/CONVENTIONS.md` — 페이지 구현 규칙(개발자 필독)
- `frontend/BACKEND-REQUIREMENTS.md` — 프론트 기준 백엔드 추가 개발 요청서
- `frontend/.env.local.example` — 백엔드 URL / 데모 폴백 설정

## Specs

`openspec/`에는 현재 구현된 동작을 기준으로 정리한 한글 명세 문서가 들어 있습니다. 인증, 사용자, 식재료, 가격, 레시피, 릴스, 장보기, AI 추천, 알림, 분석, 프론트엔드 연동 범위를 다룹니다.

백엔드 명세는 `openspec/specs/` 아래에서 `backend-` prefix를 사용합니다. 예를 들면 `backend-auth`, `backend-user`, `backend-ingredient`입니다.

프론트엔드 연동 명세는 `frontend-` prefix를 사용합니다.

아직 구현하지 않은 변경안은 `openspec/changes/` 아래에서 관리합니다.
