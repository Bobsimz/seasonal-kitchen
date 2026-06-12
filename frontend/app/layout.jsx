import './globals.css';
import { Providers } from '@/lib/providers';

export const metadata = {
  title: '제철식탁 — 제철 식재료 · 레시피 · 농가 직거래',
  description: '제철 식재료 정보부터 산지 농가 직거래까지, 가장 신선한 한 끼를 연결합니다.',
};

export const viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  themeColor: '#FBE3C8',
};

export default function RootLayout({ children }) {
  return (
    <html lang="ko">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
