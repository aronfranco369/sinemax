// sinemax-icons.jsx — line + filled icon set (Lucide-style), brand-tuned.
// <Icon name="home" size={24} filled color="#fff" stroke={2} />
(function () {
  const P = {
    // outline icons: array of <path>/<circle> children using currentColor stroke
    home:    <><path d="M3 10.5 12 3l9 7.5" /><path d="M5 9.5V21h14V9.5" /></>,
    compass: <><circle cx="12" cy="12" r="9" /><path d="m15.5 8.5-2 5-5 2 2-5 5-2Z" /></>,
    inbox:   <><path d="M3 12h5l2 3h4l2-3h5" /><path d="M5.5 5h13l2.5 7v6a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-6l2.5-7Z" /></>,
    bookmark:<><path d="M6 3h12a1 1 0 0 1 1 1v17l-7-4.5L5 21V4a1 1 0 0 1 1-1Z" /></>,
    user:    <><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4 3.5-6 8-6s8 2 8 6" /></>,
    search:  <><circle cx="11" cy="11" r="7" /><path d="m20 20-3.5-3.5" /></>,
    play:    <><path d="M7 4.5v15l13-7.5-13-7.5Z" /></>,
    pause:   <><rect x="6.5" y="5" width="3.5" height="14" rx="1" /><rect x="14" y="5" width="3.5" height="14" rx="1" /></>,
    download:<><path d="M12 3v12" /><path d="m7 11 5 5 5-5" /><path d="M5 21h14" /></>,
    star:    <><path d="m12 3 2.6 5.7 6.2.7-4.6 4.2 1.3 6.1L12 16.8 6.5 19.7l1.3-6.1L3.2 9.4l6.2-.7L12 3Z" /></>,
    chevR:   <><path d="m9 5 7 7-7 7" /></>,
    chevL:   <><path d="m15 5-7 7 7 7" /></>,
    chevD:   <><path d="m5 9 7 7 7-7" /></>,
    chevU:   <><path d="m5 15 7-7 7 7" /></>,
    x:       <><path d="M6 6 18 18M18 6 6 18" /></>,
    plus:    <><path d="M12 5v14M5 12h14" /></>,
    check:   <><path d="m5 12 5 5 9-11" /></>,
    sliders: <><path d="M4 7h11M19 7h1M4 17h7M15 17h5" /><circle cx="16" cy="7" r="2.2" /><circle cx="12.5" cy="17" r="2.2" /></>,
    bell:    <><path d="M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6Z" /><path d="M10 20a2 2 0 0 0 4 0" /></>,
    wifi:    <><path d="M2.5 9a14 14 0 0 1 19 0" /><path d="M6 12.5a9 9 0 0 1 12 0" /><path d="M9.5 16a4 4 0 0 1 5 0" /><circle cx="12" cy="19.5" r="0.6" /></>,
    globe:   <><circle cx="12" cy="12" r="9" /><path d="M3 12h18M12 3c2.5 2.5 2.5 15 0 18M12 3c-2.5 2.5-2.5 15 0 18" /></>,
    info:    <><circle cx="12" cy="12" r="9" /><path d="M12 11v5" /><circle cx="12" cy="7.8" r="0.6" /></>,
    help:    <><circle cx="12" cy="12" r="9" /><path d="M9.2 9.3a2.8 2.8 0 0 1 5.3 1.1c0 1.9-2.5 2.1-2.5 3.9" /><circle cx="12" cy="17" r="0.6" /></>,
    logout:  <><path d="M14 4H6a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h8" /><path d="M16 8l4 4-4 4M10 12h10" /></>,
    fullscreen: <><path d="M4 9V5a1 1 0 0 1 1-1h4M20 9V5a1 1 0 0 0-1-1h-4M4 15v4a1 1 0 0 0 1 1h4M20 15v4a1 1 0 0 1-1 1h-4" /></>,
    gear:    <><circle cx="12" cy="12" r="3.2" /><path d="M12 2.5v2.5M12 19v2.5M4.2 4.2l1.8 1.8M18 18l1.8 1.8M2.5 12H5M19 12h2.5M4.2 19.8 6 18M18 6l1.8-1.8" /></>,
    clock:   <><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3.5 2" /></>,
    trash:   <><path d="M4 7h16M9 7V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2M6 7l1 13a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1l1-13" /></>,
    crown:   <><path d="m3 7 4 4 5-6 5 6 4-4-2 12H5L3 7Z" /></>,
    calendar:<><rect x="3.5" y="5" width="17" height="16" rx="2" /><path d="M3.5 9.5h17M8 3v4M16 3v4" /></>,
    quality: <><rect x="3" y="6" width="18" height="12" rx="2" /><path d="M7 12h2M11 9v6M11 9l2 3-2 3M15 9v6h2" /></>,
    flag:    <><path d="M5 21V4h11l-1.5 3L16 10H5" /></>,
    arrowL:  <><path d="M19 12H5M11 6l-6 6 6 6" /></>,
    send:    <><path d="M5 12 21 4l-7 16-2.5-6.5L5 12Z" /></>,
    list:    <><path d="M8 6h12M8 12h12M8 18h12M4 6h.01M4 12h.01M4 18h.01" /></>,
    grid:    <><rect x="4" y="4" width="7" height="7" rx="1.5" /><rect x="13" y="4" width="7" height="7" rx="1.5" /><rect x="4" y="13" width="7" height="7" rx="1.5" /><rect x="13" y="13" width="7" height="7" rx="1.5" /></>,
    edit:    <><path d="M5 19h3l9-9-3-3-9 9v3Z" /><path d="m14 6 3 3" /></>,
    cast:    <><path d="M3 17a4 4 0 0 1 4 4M3 13a8 8 0 0 1 8 8" /><path d="M3 7V5a1 1 0 0 1 1-1h16a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1h-6" /><circle cx="3.5" cy="20.5" r="0.6" /></>,
    volume:  <><path d="M4 9v6h4l5 4V5L8 9H4Z" /><path d="M16 9a4 4 0 0 1 0 6" /></>,
  };
  // Filled variants for active bottom-nav
  const F = {
    home:    <path d="M12 2.6 21.5 11l-1.3 1.5-.7-.6V21a1 1 0 0 1-1 1h-4v-6h-5v6H6a1 1 0 0 1-1-1v-9.1l-.7.6L3 11 12 2.6Z" />,
    compass: <><circle cx="12" cy="12" r="9.2" /><path d="m15.8 8.2-2.2 5.6-5.4 2.2 2.2-5.6 5.4-2.2Z" fill="#0A1628" stroke="none" /></>,
    inbox:   <path d="M5.5 4h13l2.6 7.3a1 1 0 0 1 .06.34V19a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-7.36a1 1 0 0 1 .06-.34L5.5 4ZM6.9 6l-1.5 5H8l2 3h4l2-3h2.6l-1.5-5H6.9Z" />,
    bookmark:<path d="M6 2h12a1 1 0 0 1 1 1v18.6a.5.5 0 0 1-.78.42L12 18l-6.22 4.02A.5.5 0 0 1 5 21.6V3a1 1 0 0 1 1-1Z" />,
    user:    <><circle cx="12" cy="7.5" r="4.2" /><path d="M3.5 21c.4-4.3 4-6.4 8.5-6.4s8.1 2.1 8.5 6.4H3.5Z" /></>,
  };

  function Icon({ name, size = 24, filled = false, color = "currentColor", stroke = 1.8, style }) {
    const useF = filled && F[name];
    const child = useF ? F[name] : P[name];
    return (
      <svg width={size} height={size} viewBox="0 0 24 24" style={style}
        fill={useF ? color : "none"} stroke={useF ? "none" : color}
        strokeWidth={useF ? 0 : stroke} strokeLinecap="round" strokeLinejoin="round"
        aria-hidden="true">
        {child}
      </svg>
    );
  }
  window.Icon = Icon;
})();
