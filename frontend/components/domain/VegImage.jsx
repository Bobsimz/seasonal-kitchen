import { vegImg, vegEmoji } from '@/lib/veg-images';
import { cn } from '@/lib/cn';

// 식재료/상품 썸네일. src 가 있으면 그대로, 없으면 식재료명으로 로컬 이미지를 찾고,
// 그래도 없으면 식재료 이모지 + 이름의 그라데이션 플레이스홀더를 보여줍니다.
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

  // 이미지가 없을 때: 부드러운 그라데이션 배경 위에 대표 이모지를 띄우고,
  // 작은 칩에는 이름을 함께 보여 식별성을 높인다.
  const emojiSize = Math.round(size * 0.42);
  return (
    <div
      style={style}
      className={cn(
        'relative grid shrink-0 place-items-center overflow-hidden',
        'bg-gradient-to-br from-brand-bg via-emerald-50 to-white',
        'ring-1 ring-inset ring-brand/10',
        rounded,
        className,
      )}
      role="img"
      aria-label={name || '식재료'}
    >
      <span style={{ fontSize: emojiSize, lineHeight: 1 }} aria-hidden="true">
        {vegEmoji(name)}
      </span>
      {name && size >= 48 ? (
        <span className="absolute inset-x-1 bottom-1 truncate rounded-full bg-white/70 px-1 text-center text-[10px] font-semibold text-brand-dark backdrop-blur-sm">
          {name}
        </span>
      ) : null}
    </div>
  );
}
