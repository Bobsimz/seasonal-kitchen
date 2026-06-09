# Seasonal Dining Backend

제철식탁 백엔드 설계 문서와 향후 Spring Boot 서버 코드를 관리하는 폴더입니다.

현재 프론트엔드인 `../frontend`는 정적 UI 프로토타입입니다. 이 백엔드는 Swagger/OpenAPI 계약을 먼저 정의하고, 프론트엔드가 DTO 기반으로 병렬 개발할 수 있도록 구성합니다.

## 목표

- 가격, 제철, 레시피, 릴스, AI 추천을 연결하는 API 제공
- Swagger UI와 OpenAPI JSON을 통한 명확한 API 계약 제공
- OpenAPI JSON 기반 TypeScript API client 자동 생성 지원
- 전체 기능을 고려하되 초기 구현은 모듈형 모놀리식으로 유지
- 트래픽 증가 시 배치, 알림, 추천 작업을 별도 서비스로 분리 가능하게 설계

## 문서

| 문서 | 설명 |
| --- | --- |
| [01-architecture.md](docs/01-architecture.md) | 기술 스택, 시스템 구성, 패키지 구조 |
| [02-domains-and-erd.md](docs/02-domains-and-erd.md) | 전체 도메인과 ERD |
| [03-api-contract.md](docs/03-api-contract.md) | Swagger, DTO, API 설계 규칙 |
| [04-roadmap.md](docs/04-roadmap.md) | 구현 순서와 단계별 완료 기준 |

## 권장 기술 스택

| 영역 | 기술 |
| --- | --- |
| API 서버 | Spring Boot 3, Java 21 |
| API 문서 | springdoc-openapi, Swagger UI |
| DB | PostgreSQL |
| ORM | Spring Data JPA |
| DB migration | Flyway |
| 인증 | Spring Security, JWT, OAuth 2.0 |
| 캐시 | Redis |
| 파일 저장 | S3 호환 Object Storage |
| 외부 가격 데이터 | KAMIS Open API |
| AI | LLM API, JSON Schema 기반 구조화 응답 |
| 테스트 | JUnit 5, Testcontainers |

## Supabase DB

Supabase는 PostgreSQL이므로 JPA/Flyway 코드는 그대로 사용합니다. 원격 Supabase DB로 실행할 때는 `supabase` 프로필을 사용합니다.

```powershell
$env:SPRING_PROFILES_ACTIVE="supabase"
$env:SUPABASE_DB_URL="jdbc:postgresql://db.<project-ref>.supabase.co:5432/postgres?sslmode=require"
$env:SUPABASE_DB_USERNAME="postgres"
$env:SUPABASE_DB_PASSWORD="<database-password>"
.\gradlew bootRun
```

Transaction pooler URL을 사용할 경우:

```powershell
$env:SUPABASE_DB_URL="jdbc:postgresql://aws-0-<region>.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0"
```

`supabase` 프로필은 demo seed를 기본 비활성화합니다. 필요할 때만 `DEMO_SEED_ENABLED=true`를 명시합니다.

## 개발 원칙

1. Entity를 API 응답으로 직접 반환하지 않습니다.
2. 모든 API는 `/api/v1` 하위에 둡니다.
3. 금액은 숫자로 전달하며 통화 포맷은 프론트엔드가 처리합니다.
4. AI는 DB에 없는 가격과 구매처를 생성하지 않습니다.
5. 가격 응답에는 기준일, 기준 단위, 출처를 포함합니다.
6. 생성된 OpenAPI JSON을 기준으로 프론트엔드 TypeScript client를 자동 생성합니다.
