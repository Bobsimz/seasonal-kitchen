'use client';

import { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  Store, Sparkles, X, Camera, TrendingUp, Star,
  ChevronLeft, ChevronRight, RotateCw,
} from 'lucide-react';
import { useMyProducer, useAddMyOffer, useIngredients } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { endpoints } from '@/lib/endpoints';
import { cn } from '@/lib/cn';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { ImageLightbox } from '@/components/ui/ImageLightbox';

const UNITS = ['개', '봉', '포기', '단', '100g'];

// 시세(price/unit)를 1개·1봉·1포기·1단·100g 기준 단가로 환산하고 110%를 추천가로 산출.
// 무게 단위(kg·g)는 100g당, 개수 단위(개·봉·포기·단)는 1개당으로 정규화한다.
function normalizedRecommendation(currentPrice, rawUnit) {
  if (currentPrice == null || !rawUnit) return null;
  const price = Number(currentPrice);
  if (!(price > 0)) return null;
  const m = String(rawUnit).trim().match(/^(\d+(?:\.\d+)?)?\s*(kg|g|개|봉|포기|단)/i);
  if (!m) return null;
  const qty = m[1] ? Number(m[1]) : 1;
  const token = m[2].toLowerCase();
  let perBase;
  let unit;
  if (token === 'kg' || token === 'g') {
    const grams = token === 'kg' ? qty * 1000 : qty;
    if (!(grams > 0)) return null;
    perBase = (price / grams) * 100; // 100g당
    unit = '100g';
  } else {
    perBase = price / (qty || 1); // 1개/1봉/1포기/1단당
    unit = token;
  }
  return { price: Math.round(perBase * 1.1), unit };
}
const QUICK_BADGES = ['당일배송', '당일수확', '유기농', '산지직송', '안심패킹', '소분포장'];
const CATEGORIES = ['채소', '과일', '곡류', '기타'];

const STEPS = [
  { n: 1, title: '상품 사진' },
  { n: 2, title: 'AI 분석 확인' },
  { n: 3, title: '강조 & 설명' },
  { n: 4, title: '가격 · 재고' },
  { n: 5, title: '확인 & 등록' },
];

const isBlobUrl = (u) => typeof u === 'string' && u.startsWith('blob:');

function FieldLabel({ label, required, optional, hint }) {
  return (
    <div className="mb-2">
      <div className="flex items-center gap-1.5">
        <span className="text-[12.5px] font-extrabold text-ink">{label}</span>
        {required && (
          <span className="rounded-full bg-brand-bg px-1.5 py-0.5 text-[10px] font-extrabold text-brand-dark">필수</span>
        )}
        {optional && <span className="text-[11px] font-bold text-ink-soft">선택</span>}
      </div>
      {hint && <p className="mt-1 text-[11px] text-ink-soft">{hint}</p>}
    </div>
  );
}

function Pill({ active, onClick, children }) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-pressed={active}
      className={cn(
        'tap rounded-full px-3.5 py-2 text-[12.5px] font-bold transition-colors',
        active ? 'bg-brand text-white' : 'border border-line bg-white text-ink-mid',
      )}
    >
      {children}
    </button>
  );
}

function StepDots({ current }) {
  return (
    <div className="flex items-center gap-1.5">
      {STEPS.map((s) => (
        <span
          key={s.n}
          className={cn(
            'h-1.5 rounded-full transition-all',
            s.n === current ? 'w-5 bg-brand' : s.n < current ? 'w-1.5 bg-brand-soft' : 'w-1.5 bg-line',
          )}
        />
      ))}
    </div>
  );
}

export default function SellerOfferNewPage() {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const { data: producer, isLoading, error, refetch } = useMyProducer();
  const addOffer = useAddMyOffer();
  const { data: ingredientPriceList } = useIngredients({ size: 200 }); // 식재료 시세 조회용

  // 단계 / 모드
  const [step, setStep] = useState(1);
  const [aiAssist, setAiAssist] = useState(true);

  // 사진 (업로드 + AI 생성본 통합 배열) — { id, preview, url, uploading, file, source: 'upload' | 'ai' }
  const photoInputRef = useRef(null);
  const [photos, setPhotos] = useState([]);
  const [generatingAiImage, setGeneratingAiImage] = useState(false);

  // AI 분석
  const [analyzing, setAnalyzing] = useState(false);
  const [analysis, setAnalysis] = useState(null);
  const [analysisError, setAnalysisError] = useState(false);
  const [analyzedId, setAnalyzedId] = useState(null); // 실제로 분석에 사용된 사진 id

  // 폼 상태
  const [ingredientName, setIngredientName] = useState('');
  const [price, setPrice] = useState('');
  const [unit, setUnit] = useState('개');
  const [tags, setTags] = useState([]); // 강조포인트(고정 배지) — 정확히 2개 선택
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [generating, setGenerating] = useState(false);
  const [category, setCategory] = useState('');
  const [stockQuantity, setStockQuantity] = useState('');
  const [storageMethod, setStorageMethod] = useState('');
  const [storageNote, setStorageNote] = useState('');

  const [lightboxSrc, setLightboxSrc] = useState(null);

  const uploadedPhotos = photos.filter((p) => p.source === 'upload');
  const isUploading = photos.some((p) => p.uploading);
  const canSubmit = ingredientName.trim().length > 0 && Number(price) > 0;
  const MAX_APPEALS = 2; // 강조포인트(고정 배지)는 정확히 2개 선택 필수

  // 식재료명과 일치하는 시세를 1개/1봉/1포기/1단/100g 기준으로 환산해 110%를 추천 적정가로 제안
  const matchedIngredient = (ingredientPriceList ?? []).find((i) => i.name === ingredientName.trim());
  const recommendation = normalizedRecommendation(matchedIngredient?.currentPrice, matchedIngredient?.unit);

  // objectURL 누수 방지: 언마운트 시 모든 blob 미리보기 회수
  const photosRef = useRef(photos);
  photosRef.current = photos;
  useEffect(() => () => {
    photosRef.current.forEach((p) => { if (isBlobUrl(p.preview)) URL.revokeObjectURL(p.preview); });
  }, []);

  // 단계 전환 시 스크롤 상단으로 리셋
  useEffect(() => {
    if (typeof document !== 'undefined') document.querySelector('main')?.scrollTo({ top: 0 });
  }, [step]);

  // ── 사진 업로드 ──────────────────────────────────────────────
  const onPhotosChange = async (e) => {
    const files = Array.from(e.target.files || []);
    e.target.value = '';
    const toUpload = files.slice(0, 10 - photos.length);
    if (toUpload.length === 0) return;

    const isFirstUpload = uploadedPhotos.length === 0;
    const placeholders = toUpload.map((f) => ({
      id: Math.random().toString(36).slice(2),
      preview: URL.createObjectURL(f),
      file: f,
      url: null,
      uploading: true,
      source: 'upload',
    }));
    setPhotos((prev) => [...prev, ...placeholders]);

    // 토글 ON + 첫 업로드면 대표 사진 분석 시작
    if (aiAssist && isFirstUpload) analyze(placeholders[0].file, placeholders[0].id);

    // S3 개별 업로드 (배치 요청 크기 제한 우회)
    await Promise.all(
      toUpload.map(async (file, i) => {
        const placeholder = placeholders[i];
        try {
          const fd = new FormData();
          fd.append('file', file);
          const result = await endpoints.uploadImage(fd);
          setPhotos((prev) =>
            prev.map((p) => (p.id === placeholder.id ? { ...p, url: result?.url ?? null, uploading: false } : p)),
          );
        } catch {
          setPhotos((prev) => prev.filter((p) => p.id !== placeholder.id));
          if (isBlobUrl(placeholder.preview)) URL.revokeObjectURL(placeholder.preview);
          toast.show('사진 업로드에 실패했어요', { type: 'error' });
        }
      }),
    );
  };

  const removePhoto = (id) => {
    const removed = photos.find((p) => p.id === id);
    const next = photos.filter((p) => p.id !== id);
    setPhotos(next);
    if (isBlobUrl(removed?.preview)) URL.revokeObjectURL(removed.preview);
    // 분석에 실제로 사용된 사진을 지웠을 때만 재분석
    if (id === analyzedId) {
      setAnalysis(null);
      setAnalysisError(false);
      setAnalyzedId(null);
      const nextUpload = next.find((p) => p.source === 'upload');
      if (aiAssist && nextUpload?.file) analyze(nextUpload.file, nextUpload.id);
    }
  };

  const makeRepresentative = (id) => {
    setPhotos((prev) => {
      const target = prev.find((p) => p.id === id);
      if (!target) return prev;
      return [target, ...prev.filter((p) => p.id !== id)];
    });
  };

  const analyze = async (f, id) => {
    setAnalyzing(true);
    setAnalysisError(false);
    setAnalyzedId(id ?? null);
    try {
      const fd = new FormData();
      fd.append('image', f);
      const result = await endpoints.analyzeOfferPhoto(fd);
      setAnalysis(result);
      // 사용자가 이미 입력한 값은 덮어쓰지 않음(함수형 가드 — 늦게 도착한 분석 race도 안전)
      if (result.ingredientName) setIngredientName((prev) => (prev.trim() ? prev : result.ingredientName));
      if (result.productName) setTitle((prev) => (prev.trim() ? prev : result.productName));
      if (result.category) {
        setCategory((prev) => (prev ? prev : (CATEGORIES.includes(result.category) ? result.category : '')));
      }
      if (result.storageMethod) setStorageMethod((prev) => (prev.trim() ? prev : result.storageMethod));
      if (result.storageTip) setStorageNote((prev) => (prev.trim() ? prev : result.storageTip));
      toast.show('AI 분석 완료! 내용을 확인해주세요.', { type: 'success' });
    } catch {
      setAnalysisError(true);
      toast.show('AI 분석에 실패했어요. 다시 시도하거나 직접 입력해주세요.', { type: 'error' });
    } finally {
      setAnalyzing(false);
    }
  };

  const retryAnalyze = () => {
    const first = uploadedPhotos[0];
    if (first?.file) analyze(first.file, first.id);
  };

  // ── 강조포인트 토글 (정확히 2개 — 2개째 선택 시 AI 설명 자동 생성) ──
  const toggleTag = (v) => {
    if (tags.includes(v)) { setTags(tags.filter((t) => t !== v)); return; }
    if (tags.length >= MAX_APPEALS) { toast.show('강조포인트는 2개까지 선택할 수 있어요', { type: 'error' }); return; }
    const next = [...tags, v];
    setTags(next);
    // 2개가 채워지고 아직 설명이 없으면 AI 설명을 자동 생성 (첫 문구)
    if (next.length === MAX_APPEALS && aiAssist && !description.trim()) {
      runGenerateDescription(next);
    }
  };

  // ── AI 설명 생성 (강조포인트 키워드 기반) ─────────────────────
  const runGenerateDescription = async (keywords = tags) => {
    if (!producer?.name || !ingredientName.trim()) {
      toast.show('식재료명을 먼저 입력해주세요', { type: 'error' });
      return;
    }
    setGenerating(true);
    try {
      const result = await endpoints.generateDescription({
        ingredientName: ingredientName.trim(),
        producerName: producer.name,
        keywords,
      });
      const generated = result.description || result.sentence || '';
      if (generated) setDescription(generated);
    } catch {
      toast.show('상품 설명 생성에 실패했어요.', { type: 'error' });
    } finally {
      setGenerating(false);
    }
  };

  // ── AI 이미지에 워터마크 소각 ────────────────────────────────
  const stampAiWatermark = (blob) =>
    new Promise((resolve) => {
      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement('canvas');
        canvas.width = img.width;
        canvas.height = img.height;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0);

        const fontSize = Math.max(10, Math.round(img.width * 0.028));
        ctx.font = `${fontSize}px sans-serif`;
        ctx.fillStyle = 'white';
        ctx.textAlign = 'right';
        ctx.textBaseline = 'bottom';
        ctx.shadowColor = 'rgba(0, 0, 0, 0.6)';
        ctx.shadowBlur = Math.round(fontSize * 0.6);
        ctx.shadowOffsetX = 1;
        ctx.shadowOffsetY = 1;
        const pad = Math.round(fontSize * 0.55);
        ctx.fillText('AI로 생성된 이미지입니다.', img.width - pad, img.height - pad);

        canvas.toBlob((b) => resolve(b ?? blob), 'image/png');
        URL.revokeObjectURL(img.src);
      };
      img.src = URL.createObjectURL(blob);
    });

  // ── AI 이미지 생성 (대표 이미지는 그대로, 뒤에 추가) ─────────
  const generateAiImage = async () => {
    const refFile = uploadedPhotos[0]?.file;
    if (!refFile) {
      toast.show('먼저 대표 사진을 업로드해주세요', { type: 'error' });
      return;
    }
    const placeholder = {
      id: Math.random().toString(36).slice(2),
      preview: null, url: null, uploading: true, source: 'ai',
    };
    // AI 생성본은 대표(맨 앞)를 바꾸지 않고 배열 끝에 추가
    setPhotos((prev) => [...prev, placeholder]);
    setGeneratingAiImage(true);
    try {
      const genFd = new FormData();
      genFd.append('image', refFile);
      const result = await endpoints.generateImage(genFd);
      // base64 → Blob → File
      const byteChars = atob(result.imageData);
      const byteArray = new Uint8Array(byteChars.length);
      for (let i = 0; i < byteChars.length; i++) byteArray[i] = byteChars.charCodeAt(i);
      const rawBlob = new Blob([byteArray], { type: result.mimeType });
      const blob = await stampAiWatermark(rawBlob);
      const previewUrl = URL.createObjectURL(blob);
      setPhotos((prev) => prev.map((p) => (p.id === placeholder.id ? { ...p, preview: previewUrl } : p)));
      // S3 업로드
      const uploadFd = new FormData();
      uploadFd.append('files', new File([blob], 'ai-image.png', { type: 'image/png' }));
      const [uploaded] = await endpoints.uploadImages(uploadFd);
      setPhotos((prev) =>
        prev.map((p) => (p.id === placeholder.id ? { ...p, url: uploaded.url, uploading: false } : p)),
      );
    } catch {
      setPhotos((prev) => prev.filter((p) => p.id !== placeholder.id));
      toast.show('AI 이미지 생성에 실패했어요', { type: 'error' });
    } finally {
      setGeneratingAiImage(false);
    }
  };

  // ── 단계 이동 ────────────────────────────────────────────────
  const canNext = () => {
    if (step === 1) return uploadedPhotos.length > 0; // 사진은 모드 무관 1장 필수
    if (step === 2) return ingredientName.trim().length > 0;
    if (step === 3) return tags.length === 2; // 강조포인트 정확히 2개 필수
    if (step === 4) return Number(price) > 0;
    return true;
  };
  const nextStep = () => {
    if (!canNext()) return;
    setStep((s) => Math.min(5, s + 1));
  };
  const prevStep = () => setStep((s) => Math.max(1, s - 1));

  // ── 제출 ─────────────────────────────────────────────────────
  const onSubmit = async () => {
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=/my/seller/offers/new');
      return;
    }
    if (!canSubmit) {
      toast.show('식재료명과 가격을 입력해주세요', { type: 'error' });
      return;
    }
    if (isUploading) {
      toast.show('사진 업로드 중이에요, 잠시 기다려주세요', { type: 'error' });
      return;
    }
    try {
      const photoUrls = photos.map((p) => p.url).filter(Boolean); // 순서 = 표시 순서, 대표가 맨 앞
      // AI 생성 사진의 표식은 source 기준 — AI 도움받기 토글 상태와 무관하게 결정
      const aiGeneratedUrls = photos.filter((p) => p.source === 'ai').map((p) => p.url).filter(Boolean);
      const aiUsed = !!analysis || aiGeneratedUrls.length > 0;

      await addOffer.mutateAsync({
        ingredientName: ingredientName.trim(),
        price: Number(price),
        unit,
        freshnessLabel: null,
        title: title.trim() || null,
        description: description.trim() || null,
        category: category || null,
        photoUrls,
        aiGeneratedPhotoUrls: aiGeneratedUrls.length > 0 ? aiGeneratedUrls : null,
        tags: tags.length > 0 ? tags : null,
        options: [],
        stockQuantity: stockQuantity ? Number(stockQuantity) : null,
        storageMethod: storageMethod.trim() || null,
        storageNote: storageNote.trim() || null,
        aiGenerated: aiUsed || null,
        appealKeywords: tags.length > 0 ? tags : null,
        appealSentence: analysis ? description.trim() || null : null,
      });
      toast.show('상품을 등록했어요', { type: 'success' });
      router.replace('/my/seller/dashboard');
    } catch (e) {
      toast.show(e?.message || '등록에 실패했어요', { type: 'error' });
    }
  };

  // ── 사진 스트립 (렌더 함수 — 컴포넌트로 정의하지 않아 리마운트 방지) ──
  const photoStrip = () => (
    <div className="flex gap-2 overflow-x-auto pb-1 phone-scroll">
      {photos.map((photo, idx) => (
        <div key={photo.id} className="relative shrink-0">
          {photo.preview ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={photo.preview}
              alt={`상품 사진 ${idx + 1}${photo.source === 'ai' ? ' (AI 생성)' : ''}`}
              onClick={() => setLightboxSrc(photo.preview)}
              className="h-[84px] w-[84px] cursor-zoom-in rounded-2xl object-cover"
            />
          ) : (
            <div className="flex h-[84px] w-[84px] items-center justify-center rounded-2xl bg-brand-bg">
              <Sparkles size={22} className="animate-pulse text-brand" />
            </div>
          )}
          {photo.source === 'ai' && (
            <span className="absolute left-1 top-1 rounded-md bg-brand px-1.5 py-0.5 text-[9px] font-bold text-white">
              AI
            </span>
          )}
          {photo.uploading ? (
            <div className="absolute inset-0 flex items-center justify-center rounded-2xl bg-black/20">
              <div className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
            </div>
          ) : (
            <button
              type="button"
              aria-label="사진 삭제"
              onClick={() => removePhoto(photo.id)}
              className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-ink text-white shadow"
            >
              <X size={10} />
            </button>
          )}
          {idx === 0 ? (
            <span className="absolute bottom-1 left-1 rounded-md bg-black/60 px-1.5 py-0.5 text-[9px] font-bold text-white">
              대표
            </span>
          ) : (
            !photo.uploading && (
              <button
                type="button"
                aria-label="대표 사진으로 지정"
                onClick={() => makeRepresentative(photo.id)}
                className="absolute bottom-1 left-1 flex items-center gap-0.5 rounded-md bg-black/55 px-1.5 py-0.5 text-[9px] font-bold text-white"
              >
                <Star size={9} />
                대표로
              </button>
            )
          )}
        </div>
      ))}
      {photos.length < 10 && (
        <button
          type="button"
          onClick={() => photoInputRef.current?.click()}
          className={cn(
            'tap flex h-[84px] w-[84px] shrink-0 flex-col items-center justify-center gap-1 rounded-2xl border-[1.5px] border-dashed text-brand-dark',
            photos.length === 0 ? 'border-brand bg-brand-bg' : 'border-line bg-surface-soft text-ink-soft',
          )}
        >
          <Camera size={photos.length === 0 ? 28 : 22} />
          <span className="text-[10.5px] font-bold">
            {photos.length === 0 ? '사진 선택' : `${photos.length}/10`}
          </span>
        </button>
      )}
    </div>
  );

  const inputCls =
    'w-full rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand focus:bg-white focus:ring-2 focus:ring-brand/20';

  return (
    <>
      <AppHeader title="상품 등록" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && !producer && (
        <div className="px-4 pt-10">
          <EmptyState
            icon={<Store size={34} />}
            title="먼저 농가 등록이 필요해요"
            description="판매 상품을 올리려면 농가 정보를 먼저 등록해주세요."
            action={
              <Link href="/my/seller/register">
                <Button size="sm">농가 등록하기</Button>
              </Link>
            }
          />
        </div>
      )}

      {!isLoading && !error && producer && (
        <>
          {/* 진행도 (AppHeader 높이만큼 내려서 고정) */}
          <div className="sticky top-14 z-10 flex items-center justify-between gap-3 border-b border-line bg-white px-5 py-3">
            <StepDots current={step} />
            <span className="text-[12px] font-extrabold text-ink-mid">
              {step} / 5 · {STEPS[step - 1].title}
            </span>
          </div>

          <input
            ref={photoInputRef}
            type="file"
            accept="image/png,image/jpeg,image/webp,image/gif"
            multiple
            className="hidden"
            onChange={onPhotosChange}
          />

          <div key={step} className="animate-fade-up px-5 pb-28 pt-5">

            {/* ── STEP 1 · 상품 사진 ── */}
            {step === 1 && (
              <>
                <button
                  type="button"
                  role="switch"
                  aria-checked={aiAssist}
                  aria-label="AI 도움받기"
                  onClick={() => setAiAssist((v) => !v)}
                  className={cn(
                    'tap mb-5 flex w-full items-center justify-between rounded-2xl border px-4 py-3 transition-colors',
                    aiAssist ? 'border-brand-soft bg-brand-bg' : 'border-line bg-surface-soft',
                  )}
                >
                  <span className="flex items-center gap-2">
                    <Sparkles size={16} className={aiAssist ? 'text-brand' : 'text-ink-soft'} />
                    <span className="text-left">
                      <span className="block text-[13px] font-extrabold text-ink">AI 도움받기</span>
                      <span className="block text-[11px] text-ink-soft">
                        {aiAssist ? '사진을 분석해 정보·설명을 자동으로 채워요' : '직접 입력 모드 — 모든 항목을 직접 작성'}
                      </span>
                    </span>
                  </span>
                  <span
                    className={cn(
                      'relative h-6 w-10 shrink-0 rounded-full transition-colors',
                      aiAssist ? 'bg-brand' : 'bg-line',
                    )}
                  >
                    <span
                      className={cn(
                        'absolute top-0.5 h-5 w-5 rounded-full bg-white shadow transition-all',
                        aiAssist ? 'left-[18px]' : 'left-0.5',
                      )}
                    />
                  </span>
                </button>

                <FieldLabel
                  label="상품 사진"
                  required
                  hint={
                    aiAssist
                      ? '여러 장 가능 · 최대 10장 · 첫 번째(대표) 사진으로 AI가 자동 분석해요'
                      : '여러 장 가능 · 최대 10장 · 첫 번째가 대표 이미지예요'
                  }
                />
                {photoStrip()}

                {aiAssist && uploadedPhotos.length > 0 && photos.length < 10 && (
                  <button
                    type="button"
                    onClick={generateAiImage}
                    disabled={generatingAiImage || analyzing}
                    className="tap mt-3 flex w-full items-center justify-center gap-1.5 rounded-xl border border-dashed border-brand py-2.5 text-[12.5px] font-bold text-brand-dark disabled:opacity-50"
                  >
                    <Sparkles size={13} />
                    {generatingAiImage
                      ? 'AI 이미지 생성 중...'
                      : analyzing
                        ? 'AI 분석 중에는 사용할 수 없어요'
                        : 'AI로 상품사진 만들기 · 배경을 깔끔하게'}
                  </button>
                )}
              </>
            )}

            {/* ── STEP 2 · AI 분석 확인 / 기본 정보 ── */}
            {step === 2 && (
              <>
                {aiAssist && analyzing && (
                  <Card className="mb-5 flex items-center gap-2 border border-brand-soft px-4 py-3">
                    <Sparkles size={14} className="shrink-0 animate-pulse text-brand" />
                    <p className="text-[12.5px] font-bold text-brand-dark">AI가 사진을 분석 중이에요...</p>
                  </Card>
                )}
                {aiAssist && !analyzing && analysis && (
                  <Card className="mb-5 border border-brand-soft px-4 py-3">
                    <div className="flex items-center gap-1.5 text-[12.5px] font-extrabold text-brand-dark">
                      <Sparkles size={14} /> AI가 이렇게 봤어요
                    </div>
                    <p className="mt-1 text-[12px] text-ink-mid">
                      {analysis.ingredientName || analysis.productName
                        ? '아래 내용을 자동으로 채웠어요. 수정 후 다음으로 넘어가세요.'
                        : '사진에서 식재료를 명확히 인식하지 못했어요. 아래에 직접 입력해주세요.'}
                    </p>
                  </Card>
                )}
                {aiAssist && !analyzing && analysisError && (
                  <Card className="mb-5 border border-hot/30 bg-hot-bg/50 px-4 py-3">
                    <p className="text-[12.5px] font-bold text-ink">분석을 못했어요</p>
                    <p className="mt-1 text-[12px] text-ink-mid">다시 시도하거나, 아래에 직접 입력해도 돼요.</p>
                    <button
                      type="button"
                      onClick={retryAnalyze}
                      className="tap mt-2 inline-flex items-center gap-1.5 rounded-lg border border-brand px-3 py-1.5 text-[12px] font-bold text-brand-dark"
                    >
                      <RotateCw size={12} /> 다시 시도
                    </button>
                  </Card>
                )}

                <div>
                  <FieldLabel label="식재료명" required />
                  <input
                    value={ingredientName}
                    onChange={(e) => setIngredientName(e.target.value)}
                    placeholder="예: 봄동"
                    className={inputCls}
                  />
                </div>

                <div className="mt-5">
                  <FieldLabel label="카테고리" optional />
                  <div className="flex flex-wrap gap-1.5">
                    {CATEGORIES.map((c) => (
                      <Pill key={c} active={category === c} onClick={() => setCategory(category === c ? '' : c)}>
                        {c}
                      </Pill>
                    ))}
                  </div>
                </div>

                <div className="mt-5">
                  <FieldLabel label="보관 방법" optional />
                  <input
                    value={storageMethod}
                    onChange={(e) => setStorageMethod(e.target.value)}
                    placeholder="예: 냉장 보관"
                    className={inputCls}
                  />
                </div>

                <div className="mt-4">
                  <FieldLabel label="보관 안내" optional />
                  <textarea
                    value={storageNote}
                    onChange={(e) => setStorageNote(e.target.value)}
                    placeholder="예: 신문지에 싸서 냉장 보관하면 2주까지 신선해요."
                    maxLength={500}
                    rows={2}
                    className={cn(inputCls, 'resize-none')}
                  />
                </div>
              </>
            )}

            {/* ── STEP 3 · 강조 & 설명 ── */}
            {step === 3 && (
              <>
                <FieldLabel label="강조포인트" required hint="딱 2개를 골라주세요 · 선택하면 AI가 설명을 만들어요." />
                <p className={cn('-mt-1 mb-3 text-[11px] font-bold', tags.length === 2 ? 'text-brand' : 'text-ink-soft')}>
                  {tags.length}/2 선택됨
                </p>
                <div className="flex flex-wrap gap-1.5">
                  {QUICK_BADGES.map((b) => (
                    <Pill key={b} active={tags.includes(b)} onClick={() => toggleTag(b)}>
                      {b}
                    </Pill>
                  ))}
                </div>

                <div className="mt-6">
                  <div className="mb-2 flex items-center justify-between">
                    <FieldLabel label="상품 설명" optional />
                    {aiAssist && (description.trim() || generating) && (
                      <button
                        type="button"
                        onClick={() => runGenerateDescription()}
                        disabled={generating}
                        className="tap flex items-center gap-1 text-[11.5px] font-extrabold text-brand disabled:opacity-50"
                      >
                        {generating ? (
                          <>
                            <Sparkles size={11} className="animate-pulse" /> 생성 중...
                          </>
                        ) : (
                          <>
                            <RotateCw size={11} /> AI 설명 다시 만들기
                          </>
                        )}
                      </button>
                    )}
                  </div>
                  <textarea
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder={generating ? '' : '상품의 특징이나 재배 방식 등을 자유롭게 적어주세요'}
                    maxLength={1000}
                    rows={4}
                    disabled={generating}
                    className={cn(inputCls, 'resize-none disabled:opacity-60')}
                  />
                </div>

                <div className="mt-4">
                  <FieldLabel label="상품명" optional hint="없으면 식재료명으로 표시돼요" />
                  <input
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    placeholder="예: 해남 황토밭 봄동 1.5kg 산지직송"
                    maxLength={150}
                    className={inputCls}
                  />
                </div>
              </>
            )}

            {/* ── STEP 4 · 가격 · 재고 ── */}
            {step === 4 && (
              <>
                <FieldLabel label="가격 · 단위" required />
                {recommendation && (
                  <p className="-mt-1 mb-2 text-[12px] text-ink-mid">
                    추천 적정 가격입니다 :{' '}
                    <button
                      type="button"
                      onClick={() => { setPrice(String(recommendation.price)); setUnit(recommendation.unit); }}
                      className="font-extrabold text-brand underline underline-offset-2"
                    >
                      {recommendation.price.toLocaleString()}원 / {recommendation.unit}
                    </button>
                  </p>
                )}
                <div className="flex gap-2">
                  <div className="flex flex-[1.4] items-center gap-1 rounded-xl border border-line bg-surface-soft px-3.5 py-3 focus-within:border-brand focus-within:bg-white focus-within:ring-2 focus-within:ring-brand/20">
                    <span className="text-ink-soft">₩</span>
                    <input
                      inputMode="numeric"
                      value={price}
                      onChange={(e) => setPrice(e.target.value.replace(/[^0-9]/g, ''))}
                      placeholder="4,000"
                      className="w-full bg-transparent text-[13.5px] text-ink outline-none placeholder:text-ink-soft"
                    />
                  </div>
                  <div className="flex flex-1 items-center justify-center rounded-xl border border-line bg-white px-2 py-1.5">
                    <div className="flex flex-wrap justify-center gap-1.5">
                      {UNITS.map((u) => (
                        <Pill key={u} active={unit === u} onClick={() => setUnit(u)}>
                          {u}
                        </Pill>
                      ))}
                    </div>
                  </div>
                </div>

                {Number(price) > 0 && (
                  <div className="mt-3 flex items-center gap-2.5 rounded-2xl border border-brand-soft bg-brand-bg px-4 py-3">
                    <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-xl bg-brand">
                      <TrendingUp size={14} className="text-white" />
                    </div>
                    <p className="text-[12.5px] leading-snug text-ink-mid">
                      직거래를 통해{' '}
                      <span className="font-extrabold text-brand">
                        ₩{Math.round(Number(price) * 0.04).toLocaleString()}
                      </span>
                      의 추가 이윤이 생겨요
                    </p>
                  </div>
                )}

                <div className="mt-5">
                  <FieldLabel label="재고 수량" optional hint="판매 가능 수량 (미입력 시 무제한으로 표시)" />
                  <input
                    inputMode="numeric"
                    value={stockQuantity}
                    onChange={(e) => setStockQuantity(e.target.value.replace(/[^0-9]/g, ''))}
                    placeholder="예: 50"
                    className={inputCls}
                  />
                </div>
              </>
            )}

            {/* ── STEP 5 · 확인 & 등록 ── */}
            {step === 5 && (
              <>
                <Card className="flex gap-3 p-3">
                  {photos[0]?.preview ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img
                      src={photos[0].preview}
                      alt={title.trim() || ingredientName.trim() || '상품 사진'}
                      className="h-16 w-16 shrink-0 rounded-xl object-cover"
                    />
                  ) : (
                    <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-xl bg-surface-soft text-ink-soft">
                      <Camera size={20} />
                    </div>
                  )}
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[14px] font-extrabold text-ink">
                      {title.trim() || ingredientName.trim() || '식재료명 미입력'}
                    </p>
                    <p className="mt-0.5 text-[13px] font-bold text-brand">
                      {price ? `₩${Number(price).toLocaleString()} / ${unit}` : '가격 미입력'}
                    </p>
                    {tags.length > 0 && (
                      <p className="mt-1 text-[11.5px] text-ink-mid">
                        {tags.join(' · ')}
                      </p>
                    )}
                  </div>
                </Card>

                {description.trim() && (
                  <p className="mt-3 whitespace-pre-wrap rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[12.5px] leading-relaxed text-ink-mid">
                    {description.trim()}
                  </p>
                )}

                <div className="mt-4 space-y-1.5 text-[12px] text-ink-soft">
                  <button type="button" onClick={() => setStep(1)} className="tap block underline">사진 {photos.length}장 · 수정</button>
                  <button type="button" onClick={() => setStep(2)} className="tap block underline">카테고리·보관 정보 수정</button>
                  <button type="button" onClick={() => setStep(3)} className="tap block underline">강조 포인트·설명 수정</button>
                  <button type="button" onClick={() => setStep(4)} className="tap block underline">가격·재고 수정</button>
                </div>

                {!canSubmit && (
                  <p className="mt-4 text-[12px] font-bold text-hot">
                    식재료명과 가격을 입력해야 등록할 수 있어요.
                  </p>
                )}
              </>
            )}
          </div>

          {/* 하단 네비게이션 */}
          <BottomBar>
            {step > 1 && (
              <Button variant="outline" size="lg" onClick={prevStep} className="flex-none px-5">
                <ChevronLeft size={18} />
              </Button>
            )}
            {step < 5 ? (
              <Button
                size="lg"
                onClick={nextStep}
                loading={step === 1 && analyzing}
                disabled={!canNext()}
                className="flex-1"
              >
                {step === 1 && analyzing ? 'AI 분석 중...' : (<>다음 <ChevronRight size={16} className="ml-0.5" /></>)}
              </Button>
            ) : (
              <Button size="lg" loading={addOffer.isPending} disabled={!canSubmit || isUploading} onClick={onSubmit} className="flex-1">
                등록하기
              </Button>
            )}
          </BottomBar>
        </>
      )}

      <ImageLightbox src={lightboxSrc} onClose={() => setLightboxSrc(null)} />
    </>
  );
}
