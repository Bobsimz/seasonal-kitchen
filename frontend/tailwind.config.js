/** @type {import('tailwindcss').Config} */
//
// 제철식탁 디자인 시스템 — 색은 전부 여기서 관리합니다.
// 메인 브랜드 그린(#16C172)은 고정. 보조 그린/포인트/중립 톤은
// legacy/design-tokens.jsx의 spring + coral + pure 프리셋을 확정값으로 옮긴 것입니다.
// 색을 바꾸고 싶으면 이 파일만 수정하면 앱 전체에 반영됩니다.
//
module.exports = {
  content: ['./app/**/*.{js,jsx,ts,tsx}', './components/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        // 브랜드 그린 (메인 · 고정)
        brand: {
          DEFAULT: '#16C172',
          dark: '#2EA84E', // 강조 · 그라데이션 끝 · hover
          bg: '#E9FAE4', // 연한 배경 (칩/하이라이트)
          soft: '#B5E5B0', // 부드러운 하이라이트
        },
        // 포인트 컬러 (가격↑ · 핫템 · 경고)
        hot: { DEFAULT: '#FF5A36', bg: '#FFEFEA' },
        warn: { DEFAULT: '#F6A323', bg: '#FFF6E5' },
        info: '#3B82F6',
        danger: '#EF4444',
        // 중립 톤
        ink: { DEFAULT: '#0A0A0A', mid: '#4A4A4A', soft: '#8E8E8E' },
        surface: { DEFAULT: '#FFFFFF', soft: '#F6F6F7' },
        line: { DEFAULT: '#ECECEC', soft: '#F3F3F3' },
        // 차트
        chart: { green: '#8FD688', greenDark: '#3FA84E', gray: '#D4D9D2' },
      },
      fontFamily: {
        sans: ['Pretendard', '-apple-system', 'BlinkMacSystemFont', 'system-ui', 'sans-serif'],
        display: ['"Gmarket Sans"', 'Pretendard', 'sans-serif'],
      },
      borderRadius: {
        '4xl': '2rem',
        '5xl': '2.5rem',
      },
      maxWidth: {
        phone: '440px',
      },
      boxShadow: {
        card: '0 1px 3px rgba(20,40,30,0.06), 0 6px 20px rgba(20,40,30,0.06)',
        float: '0 8px 28px rgba(20,40,30,0.14)',
        nav: '0 -1px 0 rgba(0,0,0,0.04), 0 -8px 24px rgba(20,40,30,0.05)',
        device: '0 40px 80px -24px rgba(8,30,18,0.45), 0 0 0 1px rgba(0,0,0,0.06)',
      },
      keyframes: {
        'fade-up': {
          '0%': { opacity: 0, transform: 'translateY(10px)' },
          '100%': { opacity: 1, transform: 'translateY(0)' },
        },
        'scale-in': {
          '0%': { opacity: 0, transform: 'scale(0.96)' },
          '100%': { opacity: 1, transform: 'scale(1)' },
        },
        shimmer: {
          '100%': { transform: 'translateX(100%)' },
        },
        'sheet-up': {
          '0%': { transform: 'translateY(100%)' },
          '100%': { transform: 'translateY(0)' },
        },
      },
      animation: {
        'fade-up': 'fade-up 0.4s cubic-bezier(0.2,0.7,0.3,1) both',
        'scale-in': 'scale-in 0.25s cubic-bezier(0.2,0.7,0.3,1) both',
        'sheet-up': 'sheet-up 0.32s cubic-bezier(0.2,0.8,0.2,1) both',
      },
    },
  },
  plugins: [],
};
