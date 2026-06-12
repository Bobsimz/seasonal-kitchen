'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ChefHat, Crown, Play } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { useProducers, useRecipes } from '@/lib/queries';
import { Button } from '@/components/ui/Button';
import { compact } from '@/lib/format';

// 흩뿌림 카드 좌표 (4장).
const SCATTER = [
  { x: 0, y: 0, rot: -7 },
  { x: 170, y: 18, rot: 6 },
  { x: 4, y: 198, rot: 5 },
  { x: 168, y: 212, rot: -6 },
];

function ProducerScatter() {
  const { data: producers = [] } = useProducers();
  const picks = producers.slice(0, 4);
  return (
    <div className="relative mx-auto" style={{ width: 304, height: 358 }}>
      {picks.map((p, i) => (
        <div key={p.id} className="absolute" style={{ left: SCATTER[i].x, top: SCATTER[i].y, transform: `rotate(${SCATTER[i].rot}deg)` }}>
          <div className="w-[134px] rounded-2xl border border-line-soft bg-white p-3 shadow-float">
            <div className="relative h-24 w-full overflow-hidden rounded-xl bg-cover bg-center" style={{ backgroundImage: p.photoUrl ? `url(${p.photoUrl})` : undefined, backgroundColor: '#e8f1de' }}>
              {p.honorary && (
                <span className="absolute right-2 top-2 grid h-5 w-5 place-items-center rounded-full border-2 border-white bg-brand text-white">
                  <Crown size={10} className="fill-white" />
                </span>
              )}
            </div>
            <p className="mt-2.5 text-[13px] font-extrabold tracking-tight text-ink">{p.region} {p.name}</p>
            <p className="mt-0.5 text-[11px] font-semibold text-brand-dark">{p.specialties?.[0]}</p>
          </div>
        </div>
      ))}
    </div>
  );
}

function RecipeScatter() {
  const { data: recipes = [] } = useRecipes();
  const picks = recipes.slice(0, 4);
  return (
    <div className="relative mx-auto" style={{ width: 304, height: 358 }}>
      {picks.map((r, i) => (
        <div key={r.id} className="absolute h-[188px] w-[134px] overflow-hidden rounded-2xl shadow-float" style={{ left: SCATTER[i].x, top: SCATTER[i].y, transform: `rotate(${SCATTER[i].rot}deg)` }}>
          {r.imageUrl && <img src={r.imageUrl} alt={r.title} className="absolute inset-0 h-full w-full object-cover" />}
          <div className="absolute inset-0 bg-gradient-to-b from-black/15 to-black/70" />
          <span className="absolute left-2 top-2 rounded-md bg-hot px-2 py-0.5 text-[9.5px] font-extrabold text-white">HOT</span>
          <span className="absolute left-1/2 top-1/2 grid h-7 w-7 -translate-x-1/2 -translate-y-1/2 place-items-center rounded-full bg-white/25 backdrop-blur">
            <Play size={11} className="fill-white text-white" />
          </span>
          <div className="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/85 to-transparent p-3 text-white">
            <p className="text-[12px] font-extrabold leading-tight">{r.title}</p>
            <p className="mt-1 text-[10px] font-bold text-[#FFB7A7]">♥ {compact(r.likes)}</p>
          </div>
        </div>
      ))}
    </div>
  );
}

const SLIDES = [
  { kind: 'brand' },
  {
    kind: 'feature',
    title: (
      <>
        제철 식재료를 직접 키우는
        <br />
        <span className="text-brand">다양한 농가</span>를 만나요
      </>
    ),
    desc: '저렴이부터 프리미엄·유기농까지,\n내 기호에 맞는 농가의 재료를 골라보세요.',
    visual: <ProducerScatter />,
  },
  {
    kind: 'feature',
    title: (
      <>
        요즘 뜨는 <span className="text-brand">제철 음식</span>이
        <br />
        궁금하다면
      </>
    ),
    desc: 'SNS·유튜브에서 가장 많이 언급된 재료와\n트렌드 레시피를 매주 모아 보여드려요.',
    visual: <RecipeScatter />,
  },
];

export default function OnboardingPage() {
  const router = useRouter();
  const [step, setStep] = useState(0);
  const slide = SLIDES[step];
  const isLast = step === SLIDES.length - 1;

  const next = () => (isLast ? router.push('/signup') : setStep((s) => s + 1));

  if (slide.kind === 'brand') {
    return (
      <div className="flex min-h-full flex-1 flex-col items-center justify-center bg-gradient-to-b from-brand to-brand-dark px-8 text-center text-white">
        <div className="grid h-22 w-22 place-items-center rounded-[24px] border border-white/25 bg-white/15 p-5 backdrop-blur">
          <ChefHat size={56} className="text-white" />
        </div>
        <h1 className="mt-6 font-display text-[34px] font-bold tracking-tight">제철식탁</h1>
        <p className="mt-2 text-[15px] text-white/85">제철 식재료부터 산지 농가 직거래까지</p>
        <div className="mt-12 w-full max-w-xs space-y-3">
          <Button variant="secondary" block size="lg" className="!bg-white !text-brand-dark" onClick={() => setStep(1)}>
            시작하기
          </Button>
          <Link href="/login" className="block py-1 text-[14px] font-semibold text-white/90">
            이미 계정이 있어요 · 로그인
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="flex min-h-full flex-1 flex-col px-6 pb-6 pt-14">
      <AnimatePresence mode="wait">
        <motion.div
          key={step}
          initial={{ opacity: 0, x: 24 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -24 }}
          transition={{ duration: 0.3 }}
          className="flex flex-1 flex-col"
        >
          <h2 className="pt-4 font-display text-[27px] font-bold leading-snug tracking-tight text-ink">{slide.title}</h2>
          <p className="mt-3 whitespace-pre-line text-[14px] leading-relaxed text-ink-mid">{slide.desc}</p>
          <div className="flex flex-1 items-center justify-center py-4">{slide.visual}</div>
        </motion.div>
      </AnimatePresence>

      <div className="mb-4 flex justify-center gap-1.5">
        {SLIDES.slice(1).map((_, i) => (
          <span key={i} className={'h-1.5 rounded-full transition-all ' + (i + 1 === step ? 'w-6 bg-brand' : 'w-1.5 bg-line')} />
        ))}
      </div>
      <Button block size="lg" onClick={next}>
        {isLast ? '시작하기' : '다음'}
      </Button>
      <Link href="/login" className="mt-3.5 text-center text-[13px] text-ink-soft">
        이미 계정이 있어요 · <span className="font-semibold text-brand">로그인</span>
      </Link>
    </div>
  );
}
