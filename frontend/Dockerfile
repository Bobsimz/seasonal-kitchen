# syntax=docker/dockerfile:1

# 1) 의존성 설치 (package*.json 변경 시에만 재실행되도록 분리)
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# 2) 빌드
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
# frontend가 호출할 백엔드 공개 주소. lib/config.js 가 여기에 API_PREFIX(/api/v1)를 붙인다.
# 같은 도메인이라 nginx가 /api/ 를 backend로 라우팅하고 CORS도 발생하지 않는다.
ARG NEXT_PUBLIC_API_BASE_URL=http://h14k011.p.ssafy.io
ENV NEXT_PUBLIC_API_BASE_URL=${NEXT_PUBLIC_API_BASE_URL}
RUN npm run build

# 3) 실행 (standalone 결과물만 복사한 최소 이미지)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
