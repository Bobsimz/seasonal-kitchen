// 모바일 프레임 "밖" 배경 — "선라이즈 필드".
// 새벽이 밭 위로 밝아오는 무드: 위쪽 복숭아/앰버 → 아래쪽 신선한 그린 세로 그라데이션,
// 윗 코너의 반짝이는 태양 글로우, 바람결에 흔들리는 손그림 밀/풀, 아침 공기 입자 트윙클.
// 모바일 폭에서는 디바이스에 가려 거의 안 보이고, 데스크탑에서 중앙의 흰 폰이 또렷이 떠 보입니다.
// 모션은 '모션 최소화' 설정 시 자동 정지됩니다.
export function AmbientBackground() {
  return (
    <div
      aria-hidden
      className="pointer-events-none fixed inset-0 -z-10 overflow-hidden bg-[#FBE3C8]"
    >
      {/* 풀·밀 바람결 흔들림 · 태양 글로우 반짝 · 입자 트윙클 (모션 최소화 시 정지) */}
      <style
        dangerouslySetInnerHTML={{
          __html: `
            @keyframes sk-sway { from { transform: rotate(-2.8deg); } to { transform: rotate(2.8deg); } }
            .sk-grass-l { transform-origin: 50% 100%; animation: sk-sway 3.4s ease-in-out infinite alternate; }
            .sk-grass-r { transform-origin: 50% 100%; animation: sk-sway 4.2s ease-in-out infinite alternate; animation-delay: -1.4s; }
            @keyframes sk-glow { 0%,100% { opacity: .82; transform: scale(1); } 50% { opacity: 1; transform: scale(1.05); } }
            .sk-glow-core { transform-origin: center; animation: sk-glow 3.4s ease-in-out infinite; }
            .sk-glow-bloom { transform-origin: center; animation: sk-glow 5s ease-in-out infinite; }
            @keyframes sk-twinkle { 0%,100% { opacity: .12; } 50% { opacity: .85; } }
            .sk-twinkle > circle { animation: sk-twinkle 3s ease-in-out infinite; }
            .sk-twinkle > circle:nth-child(2n) { animation-duration: 4.3s; animation-delay: -1.1s; }
            .sk-twinkle > circle:nth-child(3n) { animation-duration: 5.1s; animation-delay: -2.3s; }
            @media (prefers-reduced-motion: reduce) {
              .sk-grass-l, .sk-grass-r, .sk-glow-core, .sk-glow-bloom, .sk-twinkle > circle { animation: none; }
            }
          `,
        }}
      />

      {/* 베이스: 위 복숭아/앰버 → 아래 신선 그린 세로 그라데이션 */}
      <div
        className="absolute inset-0"
        style={{
          background:
            // warm peach → (밝은 모닝 지평선) → fresh green. 49% 지점을 카키 대신 밝은 톤으로 통과시켜 탁함 제거.
            'linear-gradient(180deg, #FBE3C8 0%, #FAD7A6 19%, #F5E7C6 37%, #EEF1DA 49%, #D4EAB6 64%, #ABD594 81%, #82BC6E 100%)',
        }}
      />

      {/* 수평 모닝 헤이즈 — 해 뜨는 지평선의 옅은 빛띠 (warm↔cool 전이 탁함 완화 + 안개감/깊이) */}
      <div
        className="absolute inset-x-0 top-[40%] h-[26%]"
        style={{
          background:
            'linear-gradient(180deg, rgba(255,251,238,0) 0%, rgba(255,250,236,0.5) 50%, rgba(255,251,238,0) 100%)',
          filter: 'blur(10px)',
        }}
      />

      {/* 윗 코너 태양 글로우 블룸 (메인) */}
      <div
        className="sk-glow-bloom absolute -right-[12%] -top-[18%] h-[78vh] w-[78vh] rounded-full"
        style={{
          background:
            'radial-gradient(circle at center, rgba(255,241,214,0.95) 0%, rgba(252,221,160,0.7) 32%, rgba(249,206,140,0.28) 56%, rgba(249,206,140,0) 72%)',
          filter: 'blur(8px)',
        }}
      />
      {/* 태양 코어 — 작고 또렷한 따뜻한 해 (살짝 밝은 중심) */}
      <div
        className="sk-glow-core absolute right-[6%] top-[5%] h-[20vh] w-[20vh] rounded-full"
        style={{
          background:
            'radial-gradient(circle at center, rgba(255,253,247,1) 0%, rgba(255,247,224,0.92) 18%, rgba(255,236,196,0.5) 46%, rgba(255,236,196,0) 72%)',
          filter: 'blur(5px)',
        }}
      />
      {/* 반대편 보조 그린 글로우 — 균형 */}
      <div
        className="absolute -left-[14%] bottom-[2%] h-[60vh] w-[60vh] rounded-full"
        style={{
          background:
            'radial-gradient(circle at center, rgba(143,214,136,0.5) 0%, rgba(127,179,106,0.22) 45%, rgba(127,179,106,0) 70%)',
          filter: 'blur(10px)',
        }}
      />

      {/* 손그림 밀/풀/새싹 — 아래 가장자리 (overflow-visible: 흔들릴 때 잘리지 않음) */}
      {/* 왼쪽 군집 */}
      <svg
        className="sk-grass-l absolute bottom-[-1%] left-[3%] h-[30vh] w-auto overflow-visible text-[#5E8C45]/50"
        viewBox="0 0 220 280"
        fill="none"
        stroke="currentColor"
        strokeWidth="3.4"
        strokeLinecap="round"
      >
        <path d="M40 280 C36 200 30 150 24 96" />
        <path d="M70 280 C70 196 74 150 86 70" />
        <path d="M104 280 C104 210 100 168 92 120" />
        <path d="M138 280 C140 206 150 156 168 92" />
        <path d="M176 280 C176 214 172 178 164 140" />
        <g strokeWidth="2.6">
          <path d="M86 70 q-14 6 -20 22 q16 -2 22 -16" />
          <path d="M86 70 q14 6 20 22 q-16 -2 -22 -16" />
          <path d="M88 88 q-13 6 -18 20 q14 -2 20 -14" />
          <path d="M88 88 q13 6 18 20 q-14 -2 -20 -14" />
          <path d="M90 106 q-12 5 -16 18 q13 -2 18 -13" />
          <path d="M90 106 q12 5 16 18 q-13 -2 -18 -13" />
        </g>
        <path d="M24 96 q-22 -10 -34 6 q20 12 34 -6" strokeWidth="2.6" />
        <path d="M168 92 q20 -12 36 2 q-18 14 -36 -2" strokeWidth="2.6" />
      </svg>

      {/* 오른쪽 군집 */}
      <svg
        className="sk-grass-r absolute bottom-[-1%] right-[2%] h-[26vh] w-auto overflow-visible text-[#4F7E3A]/50"
        viewBox="0 0 200 260"
        fill="none"
        stroke="currentColor"
        strokeWidth="3.2"
        strokeLinecap="round"
      >
        <path d="M150 260 C154 184 150 140 142 84" />
        <path d="M118 260 C116 188 110 150 96 78" />
        <path d="M88 260 C90 196 100 152 120 96" />
        <path d="M56 260 C56 200 52 168 44 124" />
        <g strokeWidth="2.4">
          <path d="M96 78 q-13 6 -18 20 q14 -2 20 -14" />
          <path d="M96 78 q13 6 18 20 q-14 -2 -20 -14" />
          <path d="M98 96 q-12 5 -16 18 q13 -2 18 -13" />
          <path d="M98 96 q12 5 16 18 q-13 -2 -18 -13" />
        </g>
        <path d="M142 84 q20 -10 34 4 q-18 13 -34 -4" strokeWidth="2.4" />
        <path d="M44 124 q-20 -10 -34 4 q18 13 34 -4" strokeWidth="2.4" />
      </svg>

      {/* 떠다니는 홀씨/포자 입자 — 아침 공기감 (트윙클) */}
      <svg
        className="absolute inset-0 h-full w-full text-[#fff7e8]"
        viewBox="0 0 1000 700"
        fill="currentColor"
        preserveAspectRatio="xMidYMid slice"
      >
        <g className="sk-twinkle">
          <circle cx="120" cy="140" r="2.5" />
          <circle cx="210" cy="260" r="1.8" />
          <circle cx="70" cy="420" r="2.2" />
          <circle cx="880" cy="180" r="2.6" />
          <circle cx="930" cy="320" r="1.8" />
          <circle cx="820" cy="430" r="2.2" />
          <circle cx="160" cy="540" r="1.6" />
          <circle cx="900" cy="560" r="2" />
        </g>
      </svg>

      {/* 중앙 세로 밴드 보정 — 흰 폰 뒤를 살짝 정돈해 디바이스가 또렷하게 */}
      <div
        className="absolute inset-y-0 left-1/2 w-[560px] -translate-x-1/2"
        style={{
          background:
            'radial-gradient(ellipse 60% 70% at center, rgba(255,250,240,0.5) 0%, rgba(255,250,240,0) 70%)',
        }}
      />

      {/* 비네트 — 가장자리를 눌러 흰 디바이스 대비 확보 */}
      <div
        className="absolute inset-0"
        style={{
          background:
            'radial-gradient(ellipse 78% 92% at 50% 46%, rgba(80,60,30,0) 52%, rgba(96,72,38,0.16) 80%, rgba(70,80,40,0.32) 100%)',
        }}
      />

      {/* 데스크탑 사이드 브랜드 워드마크 */}
      <div className="absolute left-[max(2.5rem,calc(50%-560px))] top-1/2 hidden -translate-y-1/2 lg:block">
        <p className="font-display text-[44px] font-bold leading-tight text-[#3D5A2B]">제철식탁</p>
        <p className="mt-2 max-w-[220px] text-[14px] leading-relaxed text-[#5E7A45]">
          지금 가장 사랑받는 한 끼를, 더 신선하고 똑똑하게.
          <br />
          그리고 그 한 끼를 모아 내일의 들녘을 키우도록.
        </p>
      </div>

      {/* 미세 노이즈 — 그라데이션 밴딩 완화 */}
      <div
        className="absolute inset-0 opacity-[0.05] mix-blend-soft-light"
        style={{
          backgroundImage:
            "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E\")",
        }}
      />
    </div>
  );
}
