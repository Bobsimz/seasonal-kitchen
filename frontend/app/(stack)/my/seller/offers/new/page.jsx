'use client';

import { useRef, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Plus, Store, Sparkles, X, PencilLine, Camera } from 'lucide-react';
import { useMyProducer, useAddMyOffer } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { endpoints } from '@/lib/endpoints';
import { cn } from '@/lib/cn';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';

const UNITS = ['개', '봉', '포기', '단', 'kg'];
const CHECKPOINTS = ['당일배송', '당일수확', '유기농', '산지직송', '안심패킹', '소분포장'];
const CATEGORIES = ['채소', '과일', '곡류', '기타'];
const CERTIFICATIONS = ['무농약', '유기농(유기농산물)', '친환경', 'GAP인증', '저농약'];

function FieldLabel({ label, required, hint }) {
  return (
    <div className="mb-2">
      <div className="flex items-center gap-1.5">
        <span className="text-[12.5px] font-extrabold text-ink">{label}</span>
        {required && (
          <span className="rounded-full bg-hot-bg px-1.5 py-0.5 text-[10px] font-extrabold text-hot">필수</span>
        )}
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
      className={cn(
        'tap rounded-full px-3.5 py-2 text-[12.5px] font-bold transition-colors',
        active ? 'bg-brand text-white' : 'border border-line bg-white text-ink-mid',
      )}
    >
      {children}
    </button>
  );
}

function SectionTitle({ children }) {
  return (
    <div className="mb-4 mt-7 flex items-center gap-2">
      <span className="text-[13px] font-extrabold text-ink">{children}</span>
      <div className="h-px flex-1 bg-line-soft" />
    </div>
  );
}

export default function SellerOfferNewPage() {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const { data: producer, isLoading, error, refetch } = useMyProducer();
  const addOffer = useAddMyOffer();

  // 모드
  const [mode, setMode] = useState('ai');

  // AI 전용 상태
  const aiPhotoInputRef = useRef(null);
  const [aiPhotos, setAiPhotos] = useState([]); // { id, preview, file, url, uploading }
  const [analyzing, setAnalyzing] = useState(false);
  const [analysis, setAnalysis] = useState(null);
  const [generating, setGenerating] = useState(false);

  // 직접 입력 모드 - 사진
  const photoInputRef = useRef(null);
  const [photos, setPhotos] = useState([]); // { id, preview, url, uploading }
  const [generatingAiImage, setGeneratingAiImage] = useState(false);

  // 공유 폼 상태
  const [ingredientName, setIngredientName] = useState('');
  const [price, setPrice] = useState('');
  const [unit, setUnit] = useState('개');
  const [checkpoints, setCheckpoints] = useState([]);

  const toggleCheckpoint = (v) => {
    const next = checkpoints.includes(v)
      ? checkpoints.filter((c) => c !== v)
      : checkpoints.length < 2 ? [...checkpoints, v] : checkpoints;
    setCheckpoints(next);
    if (next.length === 2 && ingredientName.trim() && producer?.name) {
      runGenerateDescription(next);
    }
  };
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState('');
  const [certifications, setCertifications] = useState([]);
  const [stockQuantity, setStockQuantity] = useState('');
  const [storageNote, setStorageNote] = useState('');

  const canSubmit = ingredientName.trim().length > 0 && Number(price) > 0;

  // ── AI 사진 업로드 + 분석 ───────────────────────────────────
  const onAiPhotosChange = async (e) => {
    const files = Array.from(e.target.files || []);
    e.target.value = '';
    const toUpload = files.slice(0, 10 - aiPhotos.length);
    if (toUpload.length === 0) return;

    const isFirstBatch = aiPhotos.length === 0;
    const placeholders = toUpload.map((f) => ({
      id: Math.random().toString(36).slice(2),
      preview: URL.createObjectURL(f),
      file: f,
      url: null,
      uploading: true,
    }));
    setAiPhotos((prev) => [...prev, ...placeholders]);
    setAnalysis(null);

    // 첫 번째 사진이 새로 추가됐으면 분석 시작
    if (isFirstBatch) analyze(placeholders[0].file);

    // S3 업로드
    try {
      const fd = new FormData();
      toUpload.forEach((f) => fd.append('files', f));
      const results = await endpoints.uploadImages(fd);
      setAiPhotos((prev) => {
        const updated = [...prev];
        placeholders.forEach((pl, i) => {
          const idx = updated.findIndex((p) => p.id === pl.id);
          if (idx !== -1) updated[idx] = { ...updated[idx], url: results[i]?.url ?? null, uploading: false };
        });
        return updated;
      });
    } catch {
      setAiPhotos((prev) => prev.map((p) =>
        placeholders.some((pl) => pl.id === p.id) ? { ...p, uploading: false } : p,
      ));
      toast.show('사진 업로드에 실패했어요', { type: 'error' });
    }
  };

  const removeAiPhoto = (id) => {
    const wasFirst = aiPhotos[0]?.id === id;
    const next = aiPhotos.filter((p) => p.id !== id);
    setAiPhotos(next);
    if (wasFirst) {
      setAnalysis(null);
      if (next.length > 0) analyze(next[0].file);
    }
  };

  const analyze = async (f) => {
    setAnalyzing(true);
    try {
      const fd = new FormData();
      fd.append('image', f);
      const result = await endpoints.analyzeOfferPhoto(fd);
      setAnalysis(result);
      if (result.ingredientName) setIngredientName(result.ingredientName);
      if (result.productName) setTitle(result.productName);
      if (result.category) setCategory(CATEGORIES.includes(result.category) ? result.category : '');
      if (result.storageTip) setStorageNote(result.storageTip);
      toast.show('AI 분석 완료! 아래 필드를 확인해주세요.', { type: 'success' });
    } catch {
      toast.show('AI 분석에 실패했어요. 다시 시도해주세요.', { type: 'error' });
    } finally {
      setAnalyzing(false);
    }
  };

  const runGenerateDescription = async (keywords) => {
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
      toast.show('소구문장 생성에 실패했어요.', { type: 'error' });
    } finally {
      setGenerating(false);
    }
  };

  // ── 직접 입력 모드 사진 업로드 ───────────────────────────────
  const onPhotosChange = async (e) => {
    const files = Array.from(e.target.files || []);
    e.target.value = '';
    const toUpload = files.slice(0, 10 - photos.length);
    if (toUpload.length === 0) return;

    const placeholders = toUpload.map((f) => ({
      id: Math.random().toString(36).slice(2),
      preview: URL.createObjectURL(f),
      url: null,
      uploading: true,
    }));
    setPhotos((prev) => [...prev, ...placeholders]);

    try {
      const fd = new FormData();
      toUpload.forEach((f) => fd.append('files', f));
      const results = await endpoints.uploadImages(fd);
      setPhotos((prev) => {
        const updated = [...prev];
        placeholders.forEach((pl, i) => {
          const idx = updated.findIndex((p) => p.id === pl.id);
          if (idx !== -1) updated[idx] = { ...updated[idx], url: results[i].url, uploading: false };
        });
        return updated;
      });
    } catch {
      setPhotos((prev) => prev.filter((p) => !placeholders.some((pl) => pl.id === p.id)));
      toast.show('사진 업로드에 실패했어요', { type: 'error' });
    }
  };

  // ── AI 이미지 생성 (직접 입력 모드) ──────────────────────────
  const generateAiImage = async () => {
    const refFile = mode === 'ai' ? aiPhotos[0]?.file : null;
    if (!refFile) {
      toast.show('먼저 대표 사진을 업로드해주세요', { type: 'error' });
      return;
    }
    const placeholder = { id: Math.random().toString(36).slice(2), preview: null, url: null, uploading: true };
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
      const blob = new Blob([byteArray], { type: result.mimeType });
      const previewUrl = URL.createObjectURL(blob);
      setPhotos((prev) => prev.map((p) => p.id === placeholder.id ? { ...p, preview: previewUrl } : p));
      // S3 업로드
      const uploadFd = new FormData();
      uploadFd.append('files', new File([blob], 'ai-image.png', { type: result.mimeType }));
      const [uploaded] = await endpoints.uploadImages(uploadFd);
      setPhotos((prev) =>
        prev.map((p) => p.id === placeholder.id ? { ...p, url: uploaded.url, uploading: false } : p),
      );
    } catch {
      setPhotos((prev) => prev.filter((p) => p.id !== placeholder.id));
      toast.show('AI 이미지 생성에 실패했어요', { type: 'error' });
    } finally {
      setGeneratingAiImage(false);
    }
  };

  // ── 인증마크 ──────────────────────────────────────────────────
  const toggleCert = (cert) =>
    setCertifications(
      certifications.includes(cert) ? certifications.filter((c) => c !== cert) : [...certifications, cert],
    );

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
    if (mode === 'manual' && photos.some((p) => p.uploading)) {
      toast.show('사진 업로드 중이에요, 잠시 기다려주세요', { type: 'error' });
      return;
    }
    if (mode === 'ai' && aiPhotos.some((p) => p.uploading)) {
      toast.show('사진 업로드 중이에요, 잠시 기다려주세요', { type: 'error' });
      return;
    }
    try {
      const isAi = mode === 'ai' && !!analysis;
      const photoUrls = mode === 'manual'
        ? photos.map((p) => p.url).filter(Boolean)
        : [...aiPhotos.map((p) => p.url).filter(Boolean), ...photos.map((p) => p.url).filter(Boolean)];

      await addOffer.mutateAsync({
        ingredientName: ingredientName.trim(),
        price: Number(price),
        unit,
        freshnessLabel: null,
        title: title.trim() || null,
        description: description.trim() || null,
        category: category || null,
        photoUrls,
        tags: checkpoints.length > 0 ? checkpoints : null,
        options: [],
        certifications: certifications.length > 0 ? certifications : null,
        stockQuantity: stockQuantity ? Number(stockQuantity) : null,
        storageMethod: null,
        storageNote: storageNote.trim() || null,
        aiGenerated: isAi || null,
        appealKeywords: isAi ? analysis.checkpoints?.map((cp) => cp.keyword) ?? null : null,
        appealSentence: isAi ? description.trim() || null : null,
      });
      toast.show('상품을 등록했어요', { type: 'success' });
      router.replace('/my/seller/dashboard');
    } catch (e) {
      toast.show(e?.message || '등록에 실패했어요', { type: 'error' });
    }
  };

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
          {/* 모드 탭 */}
          <div className="sticky top-0 z-10 flex gap-2 border-b border-line bg-white px-5 py-3">
            <button
              type="button"
              onClick={() => setMode('ai')}
              className={cn(
                'tap flex flex-1 items-center justify-center gap-1.5 rounded-xl py-2.5 text-[13px] font-extrabold transition-colors',
                mode === 'ai' ? 'bg-brand text-white' : 'border border-line bg-white text-ink-mid',
              )}
            >
              <Sparkles size={15} />
              AI로 생성하기
            </button>
            <button
              type="button"
              onClick={() => setMode('manual')}
              className={cn(
                'tap flex flex-1 items-center justify-center gap-1.5 rounded-xl py-2.5 text-[13px] font-extrabold transition-colors',
                mode === 'manual' ? 'bg-brand text-white' : 'border border-line bg-white text-ink-mid',
              )}
            >
              <PencilLine size={15} />
              직접 입력하기
            </button>
          </div>

          <div className="animate-fade-up px-5 pb-28 pt-4">

            {/* ── AI 사진 업로드 (AI 모드 전용) ── */}
            {mode === 'ai' && (
              <div className="mb-2">
                <FieldLabel label="상품 사진" hint="첫 번째(대표) 사진으로 AI가 자동 분석해요 · 최대 10장" required />
                <input
                  ref={aiPhotoInputRef}
                  type="file"
                  accept="image/*"
                  multiple
                  className="hidden"
                  onChange={onAiPhotosChange}
                />

                <div className="flex gap-2 overflow-x-auto pb-1 phone-scroll">
                  {aiPhotos.map((photo, idx) => (
                    <div key={photo.id} className="relative shrink-0">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={photo.preview} alt="" className="h-[84px] w-[84px] rounded-2xl object-cover" />
                      {photo.uploading ? (
                        <div className="absolute inset-0 flex items-center justify-center rounded-2xl bg-black/20">
                          <div className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
                        </div>
                      ) : (
                        <button
                          type="button"
                          onClick={() => removeAiPhoto(photo.id)}
                          className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-ink text-white shadow"
                        >
                          <X size={10} />
                        </button>
                      )}
                      {idx === 0 && (
                        <span className="absolute bottom-1 left-1 rounded-md bg-black/60 px-1.5 py-0.5 text-[9px] font-bold text-white">
                          대표
                        </span>
                      )}
                    </div>
                  ))}
                  {aiPhotos.length < 10 && (
                    <button
                      type="button"
                      onClick={() => aiPhotoInputRef.current?.click()}
                      className={cn(
                        'tap flex h-[84px] w-[84px] shrink-0 flex-col items-center justify-center gap-1 rounded-2xl border-[1.5px] border-dashed text-brand-dark',
                        aiPhotos.length === 0
                          ? 'border-brand bg-brand-bg'
                          : 'border-line bg-surface-soft text-ink-soft',
                      )}
                    >
                      <Camera size={aiPhotos.length === 0 ? 28 : 22} />
                      <span className="text-[10.5px] font-bold">
                        {aiPhotos.length === 0 ? '사진 선택' : `${aiPhotos.length}/10`}
                      </span>
                    </button>
                  )}
                </div>

                {analyzing && (
                  <div className="mt-3 flex items-center justify-center gap-2 rounded-xl bg-brand-bg py-3 text-[13px] font-bold text-brand-dark">
                    <Sparkles size={14} className="animate-pulse" />
                    AI가 대표 사진을 분석 중이에요...
                  </div>
                )}

                {analysis && !analyzing && (
                  <Card className="mt-3 flex items-center gap-2 border border-brand-soft px-4 py-2.5">
                    <Sparkles size={14} className="shrink-0 text-brand" />
                    <p className="text-[12px] text-ink-mid">
                      AI 분석 완료 — 아래 필드에 자동으로 입력됐어요. 수정 후 등록하세요.
                    </p>
                  </Card>
                )}

                {aiPhotos.length > 0 && photos.length > 0 && (
                  <div className="mt-3 flex gap-2 overflow-x-auto pb-1 phone-scroll">
                    {photos.map((photo) => (
                      <div key={photo.id} className="relative shrink-0">
                        {photo.preview ? (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img src={photo.preview} alt="" className="h-[84px] w-[84px] rounded-2xl object-cover" />
                        ) : (
                          <div className="flex h-[84px] w-[84px] items-center justify-center rounded-2xl bg-brand-bg">
                            <Sparkles size={22} className="animate-pulse text-brand" />
                          </div>
                        )}
                        {photo.uploading ? (
                          <div className="absolute inset-0 flex items-center justify-center rounded-2xl bg-black/20">
                            <div className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
                          </div>
                        ) : (
                          <button
                            type="button"
                            onClick={() => setPhotos((prev) => prev.filter((p) => p.id !== photo.id))}
                            className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-ink text-white shadow"
                          >
                            <X size={10} />
                          </button>
                        )}
                      </div>
                    ))}
                  </div>
                )}
                {analysis && !analyzing && photos.length < 10 && (
                  <button
                    type="button"
                    onClick={generateAiImage}
                    disabled={generatingAiImage}
                    className="tap mt-2 flex w-full items-center justify-center gap-1.5 rounded-xl border border-dashed border-brand py-2.5 text-[12.5px] font-bold text-brand-dark disabled:opacity-50"
                  >
                    <Sparkles size={13} />
                    {generatingAiImage ? 'AI 이미지 생성 중...' : 'AI로 이미지 생성하기'}
                  </button>
                )}
              </div>
            )}

            {/* ── 직접 입력 모드: 사진 ── */}
            {mode === 'manual' && (
              <div className="mb-2">
                <FieldLabel label="상품 사진" hint="최대 10장 · 첫 사진이 대표 이미지예요" />
                <input
                  ref={photoInputRef}
                  type="file"
                  accept="image/png,image/jpeg,image/webp,image/gif"
                  multiple
                  className="hidden"
                  onChange={onPhotosChange}
                />
                <div className="flex gap-2 overflow-x-auto pb-1 phone-scroll">
                  {photos.map((photo, idx) => (
                    <div key={photo.id} className="relative shrink-0">
                      {photo.preview ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img src={photo.preview} alt="" className="h-[84px] w-[84px] rounded-2xl object-cover" />
                      ) : (
                        <div className="flex h-[84px] w-[84px] items-center justify-center rounded-2xl bg-brand-bg">
                          <Sparkles size={22} className="animate-pulse text-brand" />
                        </div>
                      )}
                      {photo.uploading ? (
                        <div className="absolute inset-0 flex items-center justify-center rounded-2xl bg-black/20">
                          <div className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
                        </div>
                      ) : (
                        <button
                          type="button"
                          onClick={() => setPhotos((prev) => prev.filter((p) => p.id !== photo.id))}
                          className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-ink text-white shadow"
                        >
                          <X size={10} />
                        </button>
                      )}
                      {idx === 0 && photo.preview && (
                        <span className="absolute bottom-1 left-1 rounded-md bg-black/60 px-1.5 py-0.5 text-[9px] font-bold text-white">
                          대표
                        </span>
                      )}
                    </div>
                  ))}
                  {photos.length < 10 && (
                    <button
                      type="button"
                      onClick={() => photoInputRef.current?.click()}
                      className="tap flex h-[84px] w-[84px] shrink-0 flex-col items-center justify-center gap-1 rounded-2xl border-[1.5px] border-dashed border-line bg-surface-soft text-ink-soft"
                    >
                      <Plus size={22} />
                      <span className="text-[10.5px] font-bold">{photos.length}/10</span>
                    </button>
                  )}
                </div>
              </div>
            )}

            {(mode === 'manual' || analysis) && <SectionTitle>기본 정보</SectionTitle>}
            {(mode === 'manual' || analysis) && <>

            {/* 식재료명 */}
            <div>
              <FieldLabel label="식재료명" required />
              <input
                value={ingredientName}
                onChange={(e) => setIngredientName(e.target.value)}
                placeholder="예: 봄동"
                className="w-full rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand"
              />
            </div>

            {/* 가격 · 단위 */}
            <div className="mt-5">
              <FieldLabel label="가격 · 단위" required />
              <div className="flex gap-2">
                <div className="flex flex-[1.4] items-center gap-1 rounded-xl border border-line bg-surface-soft px-3.5 py-3">
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
            </div>

            {/* checkpoint */}
            <div className="mt-5">
              <FieldLabel label="checkpoint" hint="2개 선택 시 상품 설명이 자동 생성돼요 (최대 2개)" />
              <div className="flex flex-wrap gap-1.5">
                {CHECKPOINTS.map((f) => (
                  <Pill key={f} active={checkpoints.includes(f)} onClick={() => toggleCheckpoint(f)}>
                    {f}
                  </Pill>
                ))}
              </div>
            </div>

            <SectionTitle>상품 정보</SectionTitle>

            {/* 상품명 */}
            <div>
              <FieldLabel label="상품명" hint="없으면 식재료명으로 표시돼요" />
              <input
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="예: 해남 황토밭 봄동 1.5kg 산지직송"
                maxLength={150}
                className="w-full rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand"
              />
            </div>

            {/* 상품 설명 */}
            <div className="mt-4">
              <div className="mb-2 flex items-center justify-between">
                <FieldLabel label="상품 설명" />
                {generating && (
                  <span className="flex items-center gap-1 text-[11.5px] font-bold text-brand">
                    <Sparkles size={11} />
                    생성 중...
                  </span>
                )}
              </div>
              <textarea
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder={generating ? '' : '상품의 특징이나 재배 방식 등을 자유롭게 적어주세요'}
                maxLength={1000}
                rows={3}
                disabled={generating}
                className="w-full resize-none rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand disabled:opacity-60"
              />
            </div>

            {/* 카테고리 */}
            <div className="mt-4">
              <FieldLabel label="카테고리" />
              <div className="flex flex-wrap gap-1.5">
                {CATEGORIES.map((c) => (
                  <Pill key={c} active={category === c} onClick={() => setCategory(category === c ? '' : c)}>
                    {c}
                  </Pill>
                ))}
              </div>
            </div>

            {/* 보관 안내 */}
            <div className="mt-4">
              <FieldLabel label="보관 안내" />
              <textarea
                value={storageNote}
                onChange={(e) => setStorageNote(e.target.value)}
                placeholder="예: 신문지에 싸서 냉장 보관하면 2주까지 신선해요."
                maxLength={500}
                rows={2}
                className="w-full resize-none rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand"
              />
            </div>

            <SectionTitle>인증 · 재고</SectionTitle>

            {/* 인증마크 */}
            <div>
              <FieldLabel label="인증마크" hint="해당하는 인증을 모두 선택해주세요" />
              <div className="flex flex-wrap gap-1.5">
                {CERTIFICATIONS.map((cert) => (
                  <Pill key={cert} active={certifications.includes(cert)} onClick={() => toggleCert(cert)}>
                    {cert}
                  </Pill>
                ))}
              </div>
            </div>

            {/* 재고 수량 */}
            <div className="mt-5">
              <FieldLabel label="재고 수량" hint="판매 가능 수량 (미입력 시 무제한으로 표시)" />
              <input
                inputMode="numeric"
                value={stockQuantity}
                onChange={(e) => setStockQuantity(e.target.value.replace(/[^0-9]/g, ''))}
                placeholder="예: 50"
                className="w-full rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand"
              />
            </div>

          </>}
          </div>

          {(mode === 'manual' || analysis) && (
            <BottomBar>
              <Button block size="lg" loading={addOffer.isPending} disabled={!canSubmit} onClick={onSubmit}>
                등록하기
              </Button>
            </BottomBar>
          )}
        </>
      )}
    </>
  );
}
