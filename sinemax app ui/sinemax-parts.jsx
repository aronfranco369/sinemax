// sinemax-parts.jsx — shared UI primitives + phone frame + bottom-nav variants
(function () {
  const T = {
    bg: "#050D1A", bg2: "#0A1628", panel: "#0E1D33", panel2: "#11233D",
    line: "rgba(120,160,220,.14)", line2: "rgba(120,160,220,.26)",
    blue: "#2D8EFF", blueBright: "#19C3FB", blueDeep: "#1A6FE8",
    ink: "#EAF2FF", mut: "#8FA6C8", mut2: "#5E7298", gold: "#F4C13B",
    glow: "0 0 22px rgba(45,142,255,.5)",
    disp: '"Barlow Condensed", system-ui, sans-serif',
    body: '"DM Sans", system-ui, sans-serif',
  };
  window.SXT = T;
  const D = window.SinemaxData;
  const Icon = window.Icon;

  // ---- Procedural / real poster -------------------------------------------
  function Poster({ item, radius = 14, showChip = true, showType = false, showTitle = false, glyphSize = 54 }) {
    const p = item.poster;
    const dj = D.djById(item.dj);
    return (
      <div style={{ position: "relative", width: "100%", aspectRatio: "2/3", borderRadius: radius,
        overflow: "hidden", border: `1px solid ${T.line2}`,
        boxShadow: "0 10px 26px rgba(0,0,0,.45), inset 0 0 0 1px rgba(255,255,255,.03)",
        background: `linear-gradient(155deg, ${p.from}, ${p.to})` }}>
        {item.posterUrl
          ? <img src={item.posterUrl} alt="" style={{ position: "absolute", inset: 0, width: "100%", height: "100%", objectFit: "cover" }} />
          : <>
              <div style={{ position: "absolute", inset: 0, background: "linear-gradient(135deg,rgba(255,255,255,.16),transparent 38%)" }} />
              <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center", fontSize: glyphSize, opacity: .28, color: "#fff" }}>{p.glyph || "✦"}</div>
              <div style={{ position: "absolute", inset: 0, background: "linear-gradient(0deg,rgba(5,11,22,.66),transparent 46%)" }} />
            </>}
        {showType && (
          <div style={{ position: "absolute", top: 8, right: 8, fontSize: 9.5, fontWeight: 800, letterSpacing: .6,
            padding: "3px 7px", borderRadius: 999, color: p.accent, textTransform: "uppercase",
            background: "rgba(5,13,26,.58)", backdropFilter: "blur(6px)", border: "1px solid rgba(255,255,255,.16)" }}>
            {item.type === "series" ? "Series" : "Movie"}</div>
        )}
        {showTitle && (
          <div style={{ position: "absolute", left: 9, right: 9, bottom: 36, fontFamily: T.disp, fontWeight: 700,
            fontSize: 17, lineHeight: 1.0, textTransform: "uppercase", color: "#fff", textShadow: "0 2px 10px rgba(0,0,0,.7)" }}>{item.title}</div>
        )}
        {showChip && (
          <div style={{ position: "absolute", left: 8, bottom: 8, display: "inline-flex", alignItems: "center", gap: 5,
            fontFamily: T.body, fontSize: 10.5, fontWeight: 600, color: "#fff", padding: "4px 9px 4px 7px", borderRadius: 999,
            background: "rgba(8,16,30,.5)", backdropFilter: "blur(9px)", border: "1px solid rgba(255,255,255,.2)" }}>
            <span style={{ width: 6, height: 6, borderRadius: "50%", background: dj.accent, boxShadow: `0 0 7px ${dj.accent}` }} />
            {dj.name}</div>
        )}
      </div>
    );
  }

  // ---- Card (poster + title + meta) ---------------------------------------
  function MovieCard({ id, onOpen, width }) {
    const c = D.byId(id);
    return (
      <button onClick={() => onOpen(id)} style={{ width: width || "100%", textAlign: "left", background: "none", border: "none",
        padding: 0, cursor: "pointer", fontFamily: T.body, flex: width ? "0 0 auto" : "initial" }}>
        <Poster item={c} showType />
        <div style={{ marginTop: 8 }}>
          <div style={{ fontWeight: 600, fontSize: 13, color: T.ink, lineHeight: 1.2, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{c.title}</div>
          <div style={{ marginTop: 2, fontSize: 11.5, color: T.mut2, display: "flex", alignItems: "center", gap: 6 }}>
            <span>{c.year}</span><span style={{ opacity: .5 }}>·</span><span>{D.countries[c.country].label}</span>
            <span style={{ marginLeft: "auto", color: T.gold, display: "inline-flex", alignItems: "center", gap: 3, fontWeight: 600 }}>
              <Icon name="star" size={11} filled color={T.gold} />{c.rating}</span>
          </div>
        </div>
      </button>
    );
  }

  // ---- Section header ------------------------------------------------------
  function SectionHeader({ title, subtitle, onSeeAll }) {
    return (
      <div style={{ display: "flex", alignItems: "flex-end", gap: 10, padding: "0 16px", marginBottom: 12 }}>
        <div style={{ minWidth: 0, overflow: "hidden" }}>
          <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 19, letterSpacing: .4, color: T.ink, textTransform: "uppercase", lineHeight: 1, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{title}</div>
          {subtitle && <div style={{ fontSize: 11, color: T.mut2, marginTop: 3, whiteSpace: "nowrap" }}>{subtitle}</div>}
        </div>
        {onSeeAll && (
          <button onClick={onSeeAll} style={{ marginLeft: "auto", background: "none", border: "none", color: T.blueBright,
            fontFamily: T.body, fontSize: 12, fontWeight: 600, cursor: "pointer", display: "inline-flex", alignItems: "center", gap: 2, whiteSpace: "nowrap" }}>
            See All <Icon name="chevR" size={13} color={T.blueBright} /></button>
        )}
      </div>
    );
  }

  // ---- Search bar ----------------------------------------------------------
  function SearchBar({ value, onChange, onFocus, readOnly, autoFocus }) {
    const [foc, setFoc] = React.useState(false);
    return (
      <div style={{ display: "flex", alignItems: "center", gap: 10, height: 46, padding: "0 8px 0 16px", borderRadius: 14,
        background: "rgba(14,29,51,.7)", backdropFilter: "blur(10px)",
        border: `1px solid ${foc ? T.blue : T.line}`, boxShadow: foc ? T.glow : "none", transition: "all .2s" }}>
        <input value={value} readOnly={readOnly} autoFocus={autoFocus}
          onFocus={(e) => { setFoc(true); onFocus && onFocus(e); }} onBlur={() => setFoc(false)}
          onChange={(e) => onChange && onChange(e.target.value)}
          placeholder={D.app.searchPlaceholder}
          style={{ flex: 1, background: "none", border: "none", outline: "none", color: T.ink, fontFamily: T.body, fontSize: 14, caretColor: T.blueBright }} />
        <div style={{ width: 34, height: 34, borderRadius: 10, display: "grid", placeItems: "center",
          background: "linear-gradient(180deg," + T.blue + "," + T.blueDeep + ")", boxShadow: T.glow }}>
          <Icon name="search" size={18} color="#fff" stroke={2.2} />
        </div>
      </div>
    );
  }

  // ---- Filter chip ---------------------------------------------------------
  function FilterChip({ label, value, active, onClick, hasMenu = true }) {
    return (
      <button onClick={onClick} style={{ flex: "0 0 auto", display: "inline-flex", alignItems: "center", gap: 6,
        height: 34, padding: "0 13px", borderRadius: 999, cursor: "pointer", fontFamily: T.body, fontSize: 12.5, fontWeight: 600,
        color: active ? "#fff" : T.mut,
        background: active ? "linear-gradient(180deg," + T.blue + "," + T.blueDeep + ")" : "rgba(14,29,51,.6)",
        border: `1px solid ${active ? "transparent" : T.line2}`, boxShadow: active ? T.glow : "none", transition: "all .18s", whiteSpace: "nowrap" }}>
        {active && value ? value : label}{hasMenu && <Icon name="chevD" size={13} color={active ? "#fff" : T.mut} />}
      </button>
    );
  }

  // ---- Status bar ----------------------------------------------------------
  function StatusBar() {
    return (
      <div style={{ height: 38, display: "flex", alignItems: "center", justifyContent: "space-between", padding: "0 20px", position: "relative", flex: "none" }}>
        <span style={{ fontFamily: T.body, fontSize: 13.5, fontWeight: 600, color: T.ink, letterSpacing: .3 }}>9:30</span>
        <div style={{ position: "absolute", left: "50%", top: 9, transform: "translateX(-50%)", width: 9, height: 9, borderRadius: 99, background: "#02060c", boxShadow: "inset 0 0 0 1.5px rgba(255,255,255,.08)" }} />
        <div style={{ display: "flex", alignItems: "center", gap: 6, color: T.ink }}>
          <svg width="16" height="12" viewBox="0 0 18 12"><rect x="0" y="8" width="3" height="4" rx="1" fill="currentColor"/><rect x="5" y="5" width="3" height="7" rx="1" fill="currentColor"/><rect x="10" y="2.5" width="3" height="9.5" rx="1" fill="currentColor"/><rect x="15" y="0" width="3" height="12" rx="1" fill="currentColor" opacity="0.4"/></svg>
          <Icon name="wifi" size={15} color={T.ink} stroke={1.6} />
          <svg width="22" height="12" viewBox="0 0 24 12"><rect x="0.6" y="0.6" width="20" height="10.8" rx="2.6" fill="none" stroke="currentColor" strokeWidth="1.2" opacity="0.6"/><rect x="2.4" y="2.4" width="14.5" height="7.2" rx="1.4" fill="currentColor"/><rect x="21.5" y="3.6" width="1.8" height="4.8" rx="0.9" fill="currentColor" opacity="0.6"/></svg>
        </div>
      </div>
    );
  }

  // ---- Bottom nav (3 variants) --------------------------------------------
  function BottomNav({ active, onChange, variant }) {
    const items = D.app.nav;
    if (variant === "floating") {
      return (
        <div style={{ position: "absolute", left: 14, right: 14, bottom: 14, height: 64, borderRadius: 22, zIndex: 30,
          background: "rgba(10,20,38,.82)", backdropFilter: "blur(18px)", border: `1px solid ${T.line2}`,
          boxShadow: "0 12px 34px rgba(0,0,0,.5)", display: "flex", alignItems: "center", justifyContent: "space-around", padding: "0 6px" }}>
          {items.map((it) => {
            const on = active === it.id;
            return (
              <button key={it.id} onClick={() => onChange(it.id)} style={navBtn}>
                <div style={{ width: 44, height: 36, borderRadius: 13, display: "grid", placeItems: "center", transition: "all .22s",
                  background: on ? "linear-gradient(180deg," + T.blue + "," + T.blueDeep + ")" : "transparent",
                  boxShadow: on ? T.glow : "none" }}>
                  <Icon name={it.icon} size={22} filled={on} color={on ? "#fff" : T.mut2} stroke={1.9} />
                </div>
                {on && <span style={{ fontSize: 9.5, fontWeight: 700, color: T.blueBright, marginTop: 2, letterSpacing: .2 }}>{it.label}</span>}
              </button>
            );
          })}
        </div>
      );
    }
    if (variant === "underline") {
      return (
        <div style={{ position: "absolute", left: 0, right: 0, bottom: 0, zIndex: 30, paddingBottom: 8,
          background: "linear-gradient(180deg, rgba(5,11,22,0), rgba(5,11,22,.92) 32%)", borderTop: `1px solid ${T.line}` }}>
          <div style={{ display: "flex", alignItems: "stretch", justifyContent: "space-around", padding: "8px 6px 4px" }}>
            {items.map((it) => {
              const on = active === it.id;
              return (
                <button key={it.id} onClick={() => onChange(it.id)} style={{ ...navBtn, position: "relative", gap: 5 }}>
                  <div style={{ position: "absolute", top: -8, width: 26, height: 3, borderRadius: 3, transition: "all .2s",
                    background: on ? "linear-gradient(90deg," + T.blueBright + "," + T.blue + ")" : "transparent", boxShadow: on ? T.glow : "none" }} />
                  <Icon name={it.icon} size={23} filled={on} color={on ? T.blueBright : T.mut2} stroke={1.9} />
                  <span style={{ fontSize: 9.5, fontWeight: on ? 700 : 500, color: on ? T.ink : T.mut2 }}>{it.label}</span>
                </button>
              );
            })}
          </div>
        </div>
      );
    }
    // default: glowpill
    return (
      <div style={{ position: "absolute", left: 0, right: 0, bottom: 0, zIndex: 30, paddingBottom: 10,
        background: "linear-gradient(180deg, rgba(5,11,22,0), rgba(8,15,28,.96) 30%)", borderTop: `1px solid ${T.line}` }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-around", padding: "10px 8px 4px" }}>
          {items.map((it) => {
            const on = active === it.id;
            return (
              <button key={it.id} onClick={() => onChange(it.id)} style={{ ...navBtn, gap: 0 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 7, padding: on ? "7px 13px" : "7px 8px", borderRadius: 999, transition: "all .24s",
                  background: on ? "linear-gradient(180deg, rgba(45,142,255,.22), rgba(45,142,255,.08))" : "transparent",
                  border: `1px solid ${on ? "rgba(45,142,255,.5)" : "transparent"}`, boxShadow: on ? "0 0 18px rgba(45,142,255,.32)" : "none" }}>
                  <Icon name={it.icon} size={22} filled={on} color={on ? T.blueBright : T.mut2} stroke={1.9} />
                  {on && <span style={{ fontSize: 12, fontWeight: 700, color: T.ink, letterSpacing: .2 }}>{it.label}</span>}
                </div>
              </button>
            );
          })}
        </div>
      </div>
    );
  }
  const navBtn = { background: "none", border: "none", cursor: "pointer", display: "flex", flexDirection: "column",
    alignItems: "center", justifyContent: "center", flex: 1, padding: 0, fontFamily: '"DM Sans",sans-serif' };

  // ---- Phone frame ---------------------------------------------------------
  function Phone({ children }) {
    return (
      <div style={{ width: 412, height: 892, borderRadius: 46, padding: 11, background: "linear-gradient(160deg,#1c2533,#0a0f18)",
        boxShadow: "0 40px 100px rgba(0,0,0,.6), inset 0 0 0 1.5px rgba(255,255,255,.06)", flex: "none" }}>
        <div style={{ position: "relative", width: "100%", height: "100%", borderRadius: 36, overflow: "hidden",
          background: "radial-gradient(900px 480px at 80% -8%, rgba(45,142,255,.16), transparent 60%), radial-gradient(620px 380px at -12% 16%, rgba(25,195,251,.1), transparent 55%), " + T.bg,
          display: "flex", flexDirection: "column", fontFamily: T.body }}>
          {children}
        </div>
      </div>
    );
  }

  function GesturePill() {
    return <div style={{ height: 22, display: "flex", alignItems: "center", justifyContent: "center", flex: "none", zIndex: 40, position: "relative" }}>
      <div style={{ width: 120, height: 4.5, borderRadius: 3, background: "rgba(234,242,255,.45)" }} /></div>;
  }

  window.SX = { Poster, MovieCard, SectionHeader, SearchBar, FilterChip, StatusBar, BottomNav, Phone, GesturePill };
})();
