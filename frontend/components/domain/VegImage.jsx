import { vegImg } from '@/components/legacy/mock-images';
import { cn } from '@/lib/cn';

// 식재료/상품 썸네일. src 가 있으면 그대로, 없으면 식재료명으로 로컬 이미지를 찾고,
// 그래도 없으면 이름 텍스트 플레이스홀더를 보여줍니다.
export function VegImage({ name, src, size = 56, rounded = 'rounded-2xl', className }) {
  const url = src || vegImg(name);
  const style = { width: size, height: size };

  if (url) {
    return (
      <div
        style={{ ...style, backgroundImage: `url(${url})` }}
        className={cn('shrink-0 bg-cover bg-center', rounded, className)}
        role="img"
        aria-label={name}
      />
    );
  }
  return (
    <div
      style={style}
      className={cn('ph ph-veg grid shrink-0 place-items-center text-center', rounded, className)}
    >
      <span className="truncate px-1 text-[11px] font-bold text-brand-dark">{name}</span>
    </div>
  );
}
