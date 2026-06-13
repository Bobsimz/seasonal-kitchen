# CLAUDE.md

제철식탁(seasonal-kitchen) — 제철 식재료·레시피·숏폼·농가 직거래를 연결하는 해커톤 프로젝트.
모노레포: `backend`(Spring Boot), `frontend`(Next.js), `ai`(FastAPI, 미배포).

## 구조

```
backend/    Spring Boot 3.5 / Java 21 API 서버 (PostgreSQL, Flyway, JWT, Swagger)
frontend/   Next.js 14 모바일 웹앱 (App Router, Tailwind). lib/api.js 로 백엔드 호출
ai/         FastAPI (uv). 아직 미배포 — 추후 backend 통합 예정
nginx/      운영 리버스 프록시 설정
openspec/   현재 구현 기준 도메인/API 한글 스펙 (backend-/frontend- prefix)
docs/       설계 문서 (배포 설계: docs/superpowers/specs/2026-06-13-docker-ghcr-deploy-design.md)
```

## 로컬 개발

```bash
# backend (기본 프로필 local — localhost:5433 postgres 필요)
cd backend
docker compose up -d            # 로컬 postgres(5433) + redis(6379)
./gradlew test                  # JUnit5 + Testcontainers
./gradlew bootRun               # http://localhost:8080, Swagger: /swagger-ui.html

# frontend
cd frontend
npm install
npm run dev                     # http://localhost:3000
```

backend 프로필: `local`(기본), `dev`, `supabase`(운영), `test`. 비밀값은 환경변수로 주입하고 커밋하지 않는다.

## 배포 (Docker 이미지 + GHCR + GitHub Actions)

**운영 주소**: https://h14k011.p.ssafy.io (http는 https로 301 리다이렉트)

### 런타임 구조
AWS Lightsail(Ubuntu) 1대에서 `docker-compose.prod.yml`로 컨테이너 4개를 띄운다.

```
인터넷 → nginx(80/443) ┬─ /        → frontend(3000, Next.js)
                       └─ /api/     → backend(8080, Spring Boot) → Supabase(외부 DB), redis
```

- nginx가 유일한 외부 입구. frontend/backend/redis는 compose 내부 네트워크 전용.
- frontend → backend 호출은 same-origin(`/api/v1/...`)이라 **CORS 불필요**.
- 운영 DB는 외부 **Supabase**(`application-supabase.yml`). 서버엔 postgres 컨테이너 없음.

### 자동 배포 흐름
`main` 브랜치 push 시 `.github/workflows/deploy.yml`이 실행:

1. **변경 감지**(dorny/paths-filter): `backend/**` / `frontend/**` 중 바뀐 쪽만 처리
2. 바뀐 이미지만 빌드 → **GHCR** push (`ghcr.io/bobsimz/seasonal-kitchen-{backend,frontend}`)
3. SSH로 서버 접속 → `docker compose pull && up -d`
4. 배포 후 `/api/v1/health` 헬스체크 검증 (실패 시 job 실패)

**평소엔 코드 수정 후 main에 push만 하면 자동 배포된다.**

### 시크릿 (2단 분리, 절대 git에 넣지 않는다)
- **GitHub Secrets** (배포용): `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`
- **서버 `~/seasonal-kitchen/.env`** (런타임용): `SUPABASE_DB_URL/USERNAME/PASSWORD`, `JWT_SECRET` 등.
  비밀 아닌 고정값(`SPRING_PROFILES_ACTIVE=supabase`, `REDIS_HOST=redis`)은 compose `environment`에 있다.

### frontend API 주소
빌드 타임에 `NEXT_PUBLIC_API_BASE_URL=https://h14k011.p.ssafy.io`가 번들에 인라인된다
(워크플로 build-arg + Dockerfile ARG). `lib/config.js`가 여기에 `API_PREFIX=/api/v1`을 붙인다.
도메인/스킴(http↔https)이 바뀌면 이 build-arg를 고쳐 frontend를 재빌드해야 한다(mixed content 주의).

### HTTPS / 인증서
Let's Encrypt 인증서를 certbot으로 발급, 서버 `/etc/letsencrypt`에 저장하고 nginx가 ro 마운트한다.
자동 갱신은 미설정(인증서 90일, 해커톤 기간엔 갱신 불필요). 갱신이 필요하면 서버에서:

```bash
cd ~/seasonal-kitchen
docker compose -f docker-compose.prod.yml stop nginx
docker run --rm -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  certbot/certbot renew
docker compose -f docker-compose.prod.yml up -d nginx
```

### 서버 접속
```bash
ssh -i ~/.ssh/seasonal-kitchen.pem ubuntu@h14k011.p.ssafy.io
```
배포 폴더는 `~/seasonal-kitchen`. 컨테이너 상태/로그: `docker compose -f docker-compose.prod.yml ps|logs`.
