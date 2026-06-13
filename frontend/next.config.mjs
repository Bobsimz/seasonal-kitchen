/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Docker 슬림 이미지를 위한 standalone 출력 (node server.js 단독 실행)
  output: "standalone",
};

export default nextConfig;
