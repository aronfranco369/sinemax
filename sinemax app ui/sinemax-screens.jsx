// sinemax-screens.jsx — Splash, Home, Search, Discover (+ FilterSheet)
(function () {
  const T = window.SXT, D = window.SinemaxData, Icon = window.Icon;
  const { Poster, MovieCard, SectionHeader, SearchBar, FilterChip } = window.SX;

  // ============================================================ SPLASH =====
  function Splash({ variant }) {
    return (
      <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center", zIndex: 60,
        background: "radial-gradient(720px 520px at 50% 42%, rgba(45,142,255,.22), transparent 62%), linear-gradient(180deg,#06101F,#03070F)" }}>
        <div className={"sx-splash sx-splash-" + variant} style={{ textAlign: "center", position: "relative" }}>
          <div style={{ position: "relative", display: "inline-block" }}>
            <div className="sx-logo" style={{ fontFamily: T.disp, fontWeight: 800, fontSize: 52, letterSpacing: 4,
              background: "linear-gradient(180deg,#fff,#9FCBFF 58%,#2D8EFF)", WebkitBackgroundClip: "text", backgroundClip: "text",
              color: "transparent", filter: "drop-shadow(0 0 26px rgba(45,142,255,.6))", lineHeight: 1 }}>SINEMAX</div>
            <div className="sx-sheen" />
          </div>
          <div className="sx-line" style={{ height: 3, margin: "14px auto 0", width: 150, borderRadius: 3,
            background: "linear-gradient(90deg,transparent,#19C3FB,#2D8EFF,transparent)", boxShadow: T.glow }} />
          <div className="sx-tag" style={{ marginTop: 16, fontSize: 12.5, letterSpacing: 2.5, color: T.mut, textTransform: "uppercase", fontWeight: 600 }}>
            Translated Movies &amp; Series</div>
          {variant === "pulse" && <div className="sx-ring" />}
        </div>
        <div style={{ position: "absolute", bottom: 54, left: 0, right: 0, textAlign: "center" }}>
          <div className="sx-dots"><span /><span /><span /></div>
        </div>
      </div>
    );
  }

  // ============================================================ HOME ========
  function HomeRow({ row, onOpen }) {
    return (
      <div style={{ marginTop: 22 }}>
        <SectionHeader title={row.title} subtitle={row.subtitle} onSeeAll={() => {}} />
        <div style={{ display: "flex", gap: 12, overflowX: "auto", padding: "0 16px 4px", scrollbarWidth: "none" }} className="sx-rail">
          {row.items.map((id) => <MovieCard key={id} id={id} onOpen={onOpen} width={124} />)}
        </div>
      </div>
    );
  }

  function Hero({ onOpen }) {
    const f = D.featured, c = D.byId(f.id), dj = D.djById(c.dj);
    return (
      <div style={{ margin: "16px 16px 0", borderRadius: 20, overflow: "hidden", position: "relative", height: 210,
        border: `1px solid ${T.line2}`, boxShadow: "0 16px 40px rgba(0,0,0,.5)" }}>
        <div style={{ position: "absolute", inset: 0, background: `linear-gradient(150deg, ${c.poster.from}, ${c.poster.to})` }} />
        <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center", fontSize: 150, opacity: .14, color: "#fff" }}>{c.poster.glyph}</div>
        <div style={{ position: "absolute", inset: 0, background: "linear-gradient(0deg,rgba(4,9,18,.96),rgba(4,9,18,.2) 60%), linear-gradient(90deg,rgba(4,9,18,.7),transparent 70%)" }} />
        <div style={{ position: "absolute", left: 16, right: 16, bottom: 14 }}>
          <div style={{ display: "inline-flex", alignItems: "center", gap: 6, fontSize: 10.5, fontWeight: 700, color: T.blueBright,
            textTransform: "uppercase", letterSpacing: .6, marginBottom: 6 }}>
            <Icon name="star" size={12} filled color={T.gold} /> {f.tagline}</div>
          <div style={{ fontFamily: T.disp, fontWeight: 800, fontSize: 30, lineHeight: .98, textTransform: "uppercase", color: "#fff", textShadow: "0 2px 14px rgba(0,0,0,.6)" }}>{c.title}</div>
          <div style={{ fontSize: 11.5, color: T.mut, marginTop: 5, display: "flex", gap: 7, alignItems: "center" }}>
            <span>{c.year}</span><span style={{ opacity: .5 }}>·</span><span>{c.genre}</span><span style={{ opacity: .5 }}>·</span>
            <span style={{ color: dj.accent, fontWeight: 600 }}>{dj.name}</span></div>
          <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
            <button onClick={() => onOpen(c.id)} style={{ display: "inline-flex", alignItems: "center", gap: 7, height: 38, padding: "0 20px", borderRadius: 12, border: "none", cursor: "pointer",
              background: "linear-gradient(180deg,#2D8EFF,#1A6FE8)", color: "#fff", fontWeight: 700, fontSize: 13.5, fontFamily: T.body, boxShadow: T.glow }}>
              <Icon name="play" size={16} filled color="#fff" /> Watch</button>
            <button onClick={() => onOpen(c.id)} style={{ width: 38, height: 38, borderRadius: 12, cursor: "pointer", display: "grid", placeItems: "center",
              background: "rgba(14,29,51,.7)", backdropFilter: "blur(8px)", border: `1px solid ${T.line2}` }}>
              <Icon name="plus" size={18} color={T.ink} /></button>
          </div>
        </div>
      </div>
    );
  }

  function Home({ onOpen, onSearch }) {
    return (
      <div style={{ flex: 1, overflowY: "auto", paddingBottom: 96 }} className="sx-scroll">
        <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "6px 16px 12px" }}>
          <div style={{ fontFamily: T.disp, fontWeight: 800, fontSize: 23, letterSpacing: 1.5, lineHeight: 1,
            background: "linear-gradient(180deg,#fff,#2D8EFF)", WebkitBackgroundClip: "text", backgroundClip: "text", color: "transparent",
            filter: "drop-shadow(0 0 10px rgba(45,142,255,.5))", flex: "none" }}>SX</div>
          <div style={{ flex: 1 }} onClick={onSearch}><div style={{ pointerEvents: "none" }}><SearchBar value="" readOnly /></div></div>
        </div>
        <Hero onOpen={onOpen} />
        {D.home.map((row) => <HomeRow key={row.id} row={row} onOpen={onOpen} />)}
      </div>
    );
  }

  // ============================================================ SEARCH ======
  function SearchScreen({ onOpen, onBack }) {
    const [q, setQ] = React.useState("");
    const res = q.trim().length === 0 ? [] : D.where((c) => {
      const s = (c.title + " " + (c.original || "") + " " + D.djById(c.dj).name + " " + c.genre).toLowerCase();
      return s.includes(q.toLowerCase());
    });
    return (
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10, padding: "6px 16px 12px" }}>
          <button onClick={onBack} style={iconBtn}><Icon name="arrowL" size={22} color={T.ink} /></button>
          <div style={{ flex: 1 }}><SearchBar value={q} onChange={setQ} autoFocus /></div>
        </div>
        <div style={{ flex: 1, overflowY: "auto", padding: "4px 16px 96px" }} className="sx-scroll">
          {q.trim().length === 0 ? (
            <>
              <div style={{ fontSize: 11.5, fontWeight: 700, color: T.mut2, textTransform: "uppercase", letterSpacing: .6, margin: "8px 0 12px" }}>Trending</div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginBottom: 24 }}>
                {["Throne of Shadows", "DJ Afande", "Bongo Movies", "Korea", "Indian Series", "DJ Kibinda"].map((s) => (
                  <button key={s} onClick={() => setQ(s)} style={{ ...chipBtn }}>{s}</button>
                ))}
              </div>
              <SearchGrid ids={D.home[0].items} onOpen={onOpen} />
            </>
          ) : res.length === 0 ? (
            <div style={{ textAlign: "center", color: T.mut2, marginTop: 60, fontSize: 13.5 }}>
              <Icon name="search" size={40} color={T.mut2} stroke={1.4} /><div style={{ marginTop: 12 }}>No results for "{q}"</div>
              <div style={{ fontSize: 12, marginTop: 4 }}>Try requesting it via the Requests tab.</div>
            </div>
          ) : (
            <>
              <div style={{ fontSize: 12, color: T.mut, margin: "6px 0 12px" }}>{res.length} results</div>
              <SearchGrid ids={res.map((c) => c.id)} onOpen={onOpen} />
            </>
          )}
        </div>
      </div>
    );
  }
  function SearchGrid({ ids, onOpen }) {
    return <div style={{ display: "grid", gridTemplateColumns: "repeat(3, minmax(0,1fr))", gap: 12 }}>
      {ids.map((id) => <MovieCard key={id} id={id} onOpen={onOpen} />)}</div>;
  }

  // ============================================================ DISCOVER ====
  function Discover({ onOpen, onSearch }) {
    const init = { year: "All", dj: "All", country: "All", type: "All" };
    const [f, setF] = React.useState(init);
    const [sheet, setSheet] = React.useState(null);
    const typeMap = { "Series": "series", "Movie": "movie", "Bongo": "Bongo" };

    const grid = D.discover.grid.map(D.byId).filter((c) => {
      if (f.year !== "All" && String(c.year) !== f.year) return false;
      if (f.dj !== "All" && D.djById(c.dj).name !== f.dj) return false;
      if (f.country !== "All" && D.countries[c.country].label !== f.country && D.countries[c.country].name !== f.country) return false;
      if (f.type !== "All") {
        if (f.type === "Bongo") { if (c.country !== "Tanzania") return false; }
        else if (c.type !== typeMap[f.type]) return false;
      }
      return true;
    });
    const setVal = (k, v) => { setF((p) => ({ ...p, [k]: v })); setSheet(null); };
    const chips = [
      { k: "year", label: "Year", opts: D.discover.filters.year },
      { k: "dj", label: "DJ", opts: D.discover.filters.dj },
      { k: "country", label: "Country", opts: D.discover.filters.country },
      { k: "type", label: "Type", opts: D.discover.filters.type },
    ];
    const anyActive = Object.entries(f).some(([k, v]) => v !== init[k]);

    return (
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", position: "relative" }}>
        <div style={{ padding: "6px 16px 10px" }}>
          <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 26, letterSpacing: .5, color: T.ink, textTransform: "uppercase", marginBottom: 12 }}>Discover</div>
          <div onClick={onSearch}><div style={{ pointerEvents: "none" }}><SearchBar value="" readOnly /></div></div>
        </div>
        <div style={{ display: "flex", gap: 8, overflowX: "auto", padding: "0 16px 12px", scrollbarWidth: "none" }} className="sx-rail">
          {chips.map((ch) => (
            <FilterChip key={ch.k} label={ch.label} value={f[ch.k]} active={f[ch.k] !== init[ch.k]} onClick={() => setSheet(ch)} />
          ))}
          {anyActive && <button onClick={() => setF(init)} style={{ ...chipBtn, color: T.mut, height: 34 }}>Clear</button>}
        </div>
        <div style={{ flex: 1, overflowY: "auto", padding: "2px 16px 96px" }} className="sx-scroll">
          <div style={{ fontSize: 12, color: T.mut, marginBottom: 12 }}>{grid.length} titles</div>
          {grid.length === 0
            ? <div style={{ textAlign: "center", color: T.mut2, marginTop: 50, fontSize: 13.5 }}>Nothing matches these filters.</div>
            : <div style={{ display: "grid", gridTemplateColumns: "repeat(3, minmax(0,1fr))", gap: 12 }}>
                {grid.map((c) => <MovieCard key={c.id} id={c.id} onOpen={onOpen} />)}</div>}
        </div>
        {sheet && <FilterSheet sheet={sheet} current={f[sheet.k]} onPick={(v) => setVal(sheet.k, v)} onClose={() => setSheet(null)} />}
      </div>
    );
  }

  function FilterSheet({ sheet, current, onPick, onClose }) {
    return (
      <div style={{ position: "absolute", inset: 0, zIndex: 50 }}>
        <div onClick={onClose} style={{ position: "absolute", inset: 0, background: "rgba(2,6,12,.6)", backdropFilter: "blur(2px)" }} className="sx-fade" />
        <div className="sx-sheet" style={{ position: "absolute", left: 0, right: 0, bottom: 0, maxHeight: "70%", background: "linear-gradient(180deg,#0E1D33,#0A1628)",
          borderTopLeftRadius: 24, borderTopRightRadius: 24, border: `1px solid ${T.line2}`, borderBottom: "none", display: "flex", flexDirection: "column", overflow: "hidden" }}>
          <div style={{ padding: "12px 0 4px", display: "flex", justifyContent: "center" }}><div style={{ width: 40, height: 4, borderRadius: 3, background: T.line2 }} /></div>
          <div style={{ display: "flex", alignItems: "center", padding: "6px 18px 12px" }}>
            <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 19, color: T.ink, textTransform: "uppercase", letterSpacing: .4 }}>Select {sheet.label}</div>
            <button onClick={onClose} style={{ ...iconBtn, marginLeft: "auto" }}><Icon name="x" size={20} color={T.mut} /></button>
          </div>
          <div style={{ overflowY: "auto", padding: "0 12px 22px" }} className="sx-scroll">
            {sheet.opts.map((o) => {
              const on = o === current;
              return (
                <button key={o} onClick={() => onPick(o)} style={{ display: "flex", alignItems: "center", width: "100%", textAlign: "left",
                  padding: "13px 14px", borderRadius: 12, marginBottom: 2, cursor: "pointer", fontFamily: T.body, fontSize: 14.5, fontWeight: on ? 700 : 500,
                  color: on ? "#fff" : T.mut, background: on ? "rgba(45,142,255,.16)" : "transparent", border: `1px solid ${on ? "rgba(45,142,255,.4)" : "transparent"}` }}>
                  {o}{on && <Icon name="check" size={18} color={T.blueBright} style={{ marginLeft: "auto" }} />}</button>
              );
            })}
          </div>
        </div>
      </div>
    );
  }

  const iconBtn = { width: 38, height: 38, borderRadius: 11, display: "grid", placeItems: "center", background: "none", border: "none", cursor: "pointer", flex: "none" };
  const chipBtn = { height: 32, padding: "0 13px", borderRadius: 999, cursor: "pointer", fontFamily: T.body, fontSize: 12.5, fontWeight: 600,
    color: T.ink, background: "rgba(14,29,51,.6)", border: `1px solid ${T.line2}` };

  window.SXScreens = { Splash, Home, SearchScreen, Discover };
})();
