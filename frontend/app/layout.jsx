import './globals.css';

export const metadata = {
  title: '제철식탁 — 프로토타입 (스트레치 캔버스)',
  description: '제철 + AI + 가격비교 · iOS 기준 · Fresh Green',
};

export default function RootLayout({ children }) {
  return (
    <html lang="ko">
      <body>{children}</body>
    </html>
  );
}
