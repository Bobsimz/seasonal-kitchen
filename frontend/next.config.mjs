/** @type {import('next').NextConfig} */
// 배포: NEXT_PUBLIC_API_BASE_URL 은 빌드 타임 build-arg 로 주입된다 (.github/workflows/deploy.yml).
const nextConfig = {
  reactStrictMode: true,
  // Docker 슬림 이미지를 위한 standalone 출력 (node server.js 단독 실행)
  output: "standalone",
};

export default nextConfig;
