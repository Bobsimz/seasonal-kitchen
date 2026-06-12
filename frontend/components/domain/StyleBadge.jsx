import { Chip } from '@/components/ui/Chip';

// 농가 판매 스타일(enum) → 라벨/톤. API 는 대문자(VALUE/ORGANIC/PREMIUM),
// legacy 데이터는 소문자였어서 둘 다 받습니다.
const STYLE = {
  VALUE: { label: '저렴이·실속형', tone: 'warn' },
  ORGANIC: { label: '유기농·무농약', tone: 'brand' },
  PREMIUM: { label: '프리미엄·싱싱', tone: 'hot' },
};

export function styleMeta(style) {
  return STYLE[String(style || '').toUpperCase()] || STYLE.PREMIUM;
}

export function StyleBadge({ style, className }) {
  const m = styleMeta(style);
  return (
    <Chip tone={m.tone} className={className}>
      {m.label}
    </Chip>
  );
}
