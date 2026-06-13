# 제철식탁 배포 설계 — Docker 이미지 + GHCR + GitHub Actions

작성일: 2026-06-13

## 목표

모노레포(backend, frontend)를 AWS Lightsail 서버 1대에 Docker 컨테이너로 배포하고,
GitHub Actions로 변경된 부분만 자동 빌드·배포하는 CI/CD 파이프라인을 구축한다.

- backend: Spring Boot 3 / Java 21
- frontend: Next.js 14 (현재는 backend API 미연동 프로토타입, 이번에 `/api` 연동 주소 세팅)
- ai(FastAPI): 이번 범위 제외. 추후 backend에 합칠 예정
- 운영 DB: Supabase (외부, `application-supabase.yml` 프로필 사용)

## 대상 서버 (확인 완료)

- AWS Lightsail, Ubuntu 24.04.4 LTS
- vCPU 4 / RAM 15GB / SSD 309GB (여유 충분)
- 도메인: `h14k011.p.ssafy.io`, SSH 유저 `ubuntu`, 포트 22
- 열린 포트: 22, 80, 443, 1024-65535
- Docker 29.5.3 + Compose v5.1.4 설치 완료 (sudo 없이 동작 확인)
- 유지 기간: 행사 종료 후 약 1개월

## 런타임 아키텍처

EC2 1대 위에 컨테이너 4개를 docker compose로 묶는다. Nginx가 유일한 외부 입구.

```
        인터넷
          │  :80 (추후 :443 HTTPS)
          ▼
   ┌──────────────┐
   │    nginx     │  리버스 프록시 (유일한 입구)
   └──────┬───────┘
     /    │    \
     │    │     └── /api/*  ──► backend  :8080 (Spring Boot)
     │    └──────── /       ──► frontend :3000 (Next.js)
     │
   backend ──► Supabase (외부 DB)
   backend ──► redis :6379 (컨테이너, 내부 전용)
```

- 외부 노출은 Nginx 80(추후 443)만. frontend/backend/redis는 compose 내부 네트워크 전용.
- frontend → backend 호출은 같은 도메인의 `/api` 경로 사용 → **same-origin이라 CORS 불필요**.
- frontend 환경변수: `NEXT_PUBLIC_API_BASE_URL=/api` (서버 IP 변경에 영향 없음).
- DB는 Supabase(외부)라 서버에 postgres 컨테이너를 두지 않음. redis만 컨테이너.

## 컴포넌트별 설계

### backend/Dockerfile (멀티스테이지)
- build stage: gradle로 `bootJar` 빌드 (러너에서 수행)
- run stage: JRE 21 슬림 이미지에 JAR만 복사, `java -jar` 실행
- 노출 포트 8080

### frontend/Dockerfile (멀티스테이지)
- `next.config.mjs`에 `output: 'standalone'` 추가 → 슬림 이미지
- build stage: `npm ci && npm run build`
- run stage: standalone 결과물만 복사, `node server.js`, 포트 3000

### nginx
- `nginx/nginx.conf`: `location /` → frontend:3000, `location /api/` → backend:8080
- 추후 certbot으로 443/HTTPS 확장 가능한 구조

### docker-compose.prod.yml
- 서비스 4개: nginx, frontend, backend, redis
- frontend/backend는 GHCR 이미지 참조 (`ghcr.io/bobsimz/seasonal-kitchen-{backend,frontend}:latest`)
- backend는 `env_file: .env`로 런타임 시크릿 주입
- redis는 내부 네트워크 전용 (포트 외부 노출 안 함)

## 시크릿 관리 (2-tier)

| 종류 | 위치 | 사용 주체 | 내용 |
|------|------|-----------|------|
| 런타임 시크릿 | 서버의 `~/seasonal-kitchen/.env` (git 제외) | backend 컨테이너 | SUPABASE_DB_URL/USERNAME/PASSWORD, JWT_SECRET, REDIS_HOST=redis |
| 배포 시크릿 | GitHub Secrets | GitHub Actions | SSH PEM 키, 서버 호스트 |

- `.env`는 git/GitHub에 올리지 않고 서버에만 둔다. CI는 DB 비밀번호를 모른다.
- GHCR push 인증은 Actions 기본 제공 `GITHUB_TOKEN`으로 처리(별도 시크릿 불필요).

### backend 런타임 환경변수 (코드에서 확인)
- `SPRING_PROFILES_ACTIVE=supabase`
- `SUPABASE_DB_URL`, `SUPABASE_DB_USERNAME`, `SUPABASE_DB_PASSWORD`
- `REDIS_HOST=redis`, `REDIS_PORT=6379`
- `JWT_SECRET` (기본값 있으나 운영용으로 교체)
- `DEMO_SEED_ENABLED` (선택)

## CI/CD 흐름 (GitHub Actions)

```
[git push → main]
  ① 변경 감지 (dorny/paths-filter): frontend/** ? backend/** ?
  ② 바뀐 쪽만 Docker 빌드 → GHCR push
       backend 바뀜  → seasonal-kitchen-backend:{sha,latest}
       frontend 바뀜 → seasonal-kitchen-frontend:{sha,latest}
  ③ SSH로 서버 접속 (PEM은 GitHub Secret)
  ④ 서버에서 docker compose pull && up -d (바뀐 컨테이너만 교체)
```

- 트리거: `main` push (+ 수동 `workflow_dispatch`).
- path filtering으로 변경 폴더만 빌드/배포. 안 바뀐 쪽은 기존 컨테이너 유지.

## 작업 순서

0. (완료) PEM 키 저장, 서버 접속, Docker 설치
1. 서버 준비 마무리: 배포 폴더 생성, GHCR 로그인, `.env` 작성
2. 코드 작성: Dockerfile 2개, next.config standalone, nginx, docker-compose.prod.yml
3. 수동 배포 1회 검증 (자동화 전에 접속 확인)
4. GitHub Actions 작성 + GitHub Secrets 등록
5. (선택) 도메인 HTTPS(Let's Encrypt), 문서화

## 비범위 (YAGNI)

- ai(FastAPI) 컨테이너 — 추후 backend 통합 후 진행
- 무중단 배포, 오토스케일링, 로드밸런서 — 해커톤 규모에 불필요
- 별도 모니터링 스택 — 추후 필요 시
