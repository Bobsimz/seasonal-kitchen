import Link from 'next/link';
import { Clock, Heart } from 'lucide-react';
import { cn } from '@/lib/cn';
import { compact } from '@/lib/format';
import { Chip } from '@/components/ui/Chip';

// 레시피 세로 카드 (그리드/캐러셀).
export function RecipeCard({ recipe: r, className, width }) {
  return (
    <Link
      href={`/recipes/${r.id}`}
      className={cn('tap block overflow-hidden', className)}
      style={width ? { width } : undefined}
    >
      {/* 쇼츠 썸네일(1280×720, 가운데 9:16 영상 + 양옆 어두운 여백)을 정사각으로 꽉 채운다.
          object-cover 후 16/9≈1.8배 확대하면 가운데 영상만 남고 양옆 여백은 화면 밖으로 크롭된다. */}
      <div className="relative aspect-square w-full overflow-hidden rounded-2xl bg-line-soft">
        {r.imageUrl && <img src={r.imageUrl} alt={r.title} className="h-full w-full scale-[1.8] object-cover" />}
        {r.seasonal && <span className="absolute left-2 top-2"><Chip tone="brand">제철</Chip></span>}
        <span className="absolute bottom-2 right-2 flex items-center gap-1 rounded-full bg-black/55 px-2 py-0.5 text-[11px] font-semibold text-white">
          <Heart size={11} className="fill-white" /> {compact(r.likes)}
        </span>
      </div>
      <p className="mt-2 line-clamp-2 text-[13.5px] font-bold leading-snug text-ink">{r.title}</p>
      <div className="mt-1 flex items-center gap-2 text-[11.5px] text-ink-soft">
        <span className="flex items-center gap-0.5">
          <Clock size={12} /> {r.cookMinutes}분
        </span>
        <span>· {r.difficulty}</span>
      </div>
    </Link>
  );
}

// 레시피 가로 리스트 행.
export function RecipeRow({ recipe: r, divider = true }) {
  return (
    <Link href={`/recipes/${r.id}`} className={cn('tap flex items-center gap-3 px-4 py-3', divider && 'border-b border-line-soft')}>
      <div className="h-[68px] w-[68px] shrink-0 overflow-hidden rounded-xl bg-line-soft">
        {r.imageUrl && <img src={r.imageUrl} alt={r.title} className="h-full w-full object-cover" />}
      </div>
      <div className="min-w-0 flex-1">
        <p className="line-clamp-1 text-[14.5px] font-bold text-ink">{r.title}</p>
        <div className="mt-1 flex items-center gap-2 text-[11.5px] text-ink-soft">
          <span className="flex items-center gap-0.5"><Clock size={12} /> {r.cookMinutes}분</span>
          <span>· {r.difficulty}</span>
          <span className="flex items-center gap-0.5"><Heart size={11} /> {compact(r.likes)}</span>
        </div>
        {r.tags?.length ? (
          <div className="mt-1.5 flex gap-1">
            {r.tags.slice(0, 3).map((t) => (
              <span key={t} className="text-[11px] font-semibold text-brand-dark">{t}</span>
            ))}
          </div>
        ) : null}
      </div>
    </Link>
  );
}
