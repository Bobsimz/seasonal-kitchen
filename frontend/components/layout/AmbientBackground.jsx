// 모바일 프레임 "밖" 배경 — 데스크탑/와이드 화면에서 보이는 영역.
// 제철·신선·자연 무드: 짙은 농장 그린 베이스 + 유기적인 그린 글로우 +
// 잎사귀 실루엣 + 미세 노이즈. 모바일 폭에서는 프레임에 가려 거의 안 보입니다.
export function AmbientBackground() {
  return (
    <div aria-hidden className="pointer-events-none fixed inset-0 -z-10 overflow-hidden bg-[#0c1f15]">
      {/* 베이스 그라데이션 */}
      <div className="absolute inset-0 bg-gradient-to-br from-[#0e2419] via-[#0b1d13] to-[#06120c]" />

      {/* 유기적인 그린 글로우 */}
      <div className="absolute -left-40 top-[-10%] h-[60vh] w-[60vh] rounded-full bg-[#16C172]/25 blur-[120px]" />
      <div className="absolute -right-32 top-1/3 h-[55vh] w-[55vh] rounded-full bg-[#2EA84E]/20 blur-[130px]" />
      <div className="absolute bottom-[-15%] left-1/3 h-[50vh] w-[50vh] rounded-full bg-[#8FD688]/15 blur-[120px]" />

      {/* 큰 잎사귀 실루엣 (장식) */}
      <svg className="absolute -left-10 bottom-[-6%] h-[42vh] w-auto text-[#16C172]/[0.06]" viewBox="0 0 200 320" fill="currentColor">
        <path d="M100 0C40 60 0 140 0 220c0 60 40 100 100 100s100-40 100-100C200 140 160 60 100 0Zm0 40c0 90 0 200 0 260" stroke="currentColor" strokeWidth="2" fill="currentColor" />
      </svg>
      <svg className="absolute right-[-4%] top-[8%] h-[34vh] w-auto rotate-[18deg] text-[#8FD688]/[0.05]" viewBox="0 0 200 320" fill="currentColor">
        <path d="M100 0C40 60 0 140 0 220c0 60 40 100 100 100s100-40 100-100C200 140 160 60 100 0Z" />
      </svg>

      {/* 데스크탑 사이드 브랜드 워드마크 */}
      <div className="absolute left-[max(2.5rem,calc(50%-560px))] top-1/2 hidden -translate-y-1/2 lg:block">
        <p className="font-display text-[44px] font-bold leading-tight text-white/90">
          제철식탁
        </p>
        <p className="mt-2 max-w-[220px] text-[14px] leading-relaxed text-white/45">
          제철 식재료부터 산지 농가 직거래까지,
          <br />
          가장 신선한 한 끼를 연결합니다.
        </p>
      </div>

      {/* 미세 노이즈 오버레이 */}
      <div
        className="absolute inset-0 opacity-[0.04] mix-blend-overlay"
        style={{
          backgroundImage:
            "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E\")",
        }}
      />
    </div>
  );
}
