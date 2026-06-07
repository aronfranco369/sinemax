// sinemax-detail.jsx — Detail screen (player + details + episodes expand/collapse + related)
(function () {
  const T = window.SXT, D = window.SinemaxData, Icon = window.Icon;
  const { Poster, MovieCard } = window.SX;

  function Player({ c, onBack }) {
    const [playing, setPlaying] = React.useState(false);
    const [prog, setProg] = React.useState(0.0);
    React.useEffect(() => {
      if (!playing) return;
      const t = setInterval(() => setProg((p) => (p >= 1 ? (clearInterval(t), 1) : p + 0.0025)), 60);
      return () => clearInterval(t);
    }, [playing]);
    const fmt = (f) => { const tot = 96 * 60, s = Math.floor(tot * f); return `${String(Math.floor(s / 60)).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`; };
    return (
      <div style={{ position: "relative", width: "100%", aspectRatio: "16/9", flex: "none",
        background: `linear-gradient(150deg, ${c.poster.from}, ${c.poster.to})`, overflow: "hidden" }}>
        <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center", fontSize: 120, opacity: .12, color: "#fff" }}>{c.poster.glyph}</div>
        <div style={{ position: "absolute", inset: 0, background: "linear-gradient(180deg,rgba(3,8,16,.7),transparent 26%,transparent 64%,rgba(3,8,16,.88))" }} />
        {/* top bar */}
        <div style={{ position: "absolute", top: 0, left: 0, right: 0, display: "flex", alignItems: "center", padding: "10px 12px", gap: 8 }}>
          <button onClick={onBack} style={glassBtn}><Icon name="arrowL" size={20} color="#fff" /></button>
          <div style={{ flex: 1 }} />
          <button style={glassBtn}><Icon name="cast" size={18} color="#fff" /></button>
          <button style={{ ...glassBtn, width: "auto", padding: "0 11px", gap: 5, fontFamily: T.body, fontSize: 12, fontWeight: 700, color: "#fff" }}>
            <Icon name="quality" size={15} color="#fff" /> 1080p</button>
        </div>
        {/* center play */}
        <button onClick={() => setPlaying((p) => !p)} style={{ position: "absolute", top: "50%", left: "50%", transform: "translate(-50%,-50%)",
          width: 64, height: 64, borderRadius: "50%", cursor: "pointer", display: "grid", placeItems: "center",
          background: "rgba(45,142,255,.92)", border: "1px solid rgba(255,255,255,.3)", boxShadow: "0 0 30px rgba(45,142,255,.6)", opacity: playing ? 0 : 1, transition: "opacity .25s" }}>
          <Icon name="play" size={30} filled color="#fff" /></button>
        {/* bottom controls */}
        <div style={{ position: "absolute", left: 12, right: 12, bottom: 10 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <button onClick={() => setPlaying((p) => !p)} style={{ background: "none", border: "none", cursor: "pointer", display: "grid", placeItems: "center" }}>
              <Icon name={playing ? "pause" : "play"} size={20} filled color="#fff" /></button>
            <span style={{ fontFamily: T.body, fontSize: 11, color: "#fff", fontVariantNumeric: "tabular-nums" }}>{fmt(prog)}</span>
            <div onClick={(e) => { const r = e.currentTarget.getBoundingClientRect(); setProg(Math.min(1, Math.max(0, (e.clientX - r.left) / r.width))); }}
              style={{ flex: 1, height: 14, display: "flex", alignItems: "center", cursor: "pointer" }}>
              <div style={{ width: "100%", height: 4, borderRadius: 3, background: "rgba(255,255,255,.25)", position: "relative" }}>
                <div style={{ position: "absolute", left: 0, top: 0, bottom: 0, width: `${prog * 100}%`, borderRadius: 3, background: "linear-gradient(90deg,#19C3FB,#2D8EFF)" }} />
                <div style={{ position: "absolute", left: `${prog * 100}%`, top: "50%", transform: "translate(-50%,-50%)", width: 12, height: 12, borderRadius: "50%", background: "#fff", boxShadow: "0 0 8px rgba(45,142,255,.9)" }} />
              </div>
            </div>
            <span style={{ fontFamily: T.body, fontSize: 11, color: "rgba(255,255,255,.7)", fontVariantNumeric: "tabular-nums" }}>{c.duration || "1:36:00"}</span>
            <button style={{ background: "none", border: "none", cursor: "pointer", display: "grid", placeItems: "center" }}><Icon name="fullscreen" size={18} color="#fff" /></button>
          </div>
        </div>
      </div>
    );
  }

  function ActionBtn({ icon, label, primary, filled, onClick }) {
    return (
      <button onClick={onClick} style={{ flex: primary ? "1 1 auto" : "0 0 auto", display: "flex", alignItems: "center", justifyContent: "center", gap: 7,
        height: 44, padding: primary ? "0 18px" : "0 14px", borderRadius: 13, cursor: "pointer", fontFamily: T.body, fontWeight: 700, fontSize: 13.5,
        color: primary ? "#fff" : T.ink, background: primary ? "linear-gradient(180deg,#2D8EFF,#1A6FE8)" : "rgba(14,29,51,.7)",
        border: `1px solid ${primary ? "transparent" : T.line2}`, boxShadow: primary ? T.glow : "none" }}>
        <Icon name={icon} size={18} filled={filled} color={primary ? "#fff" : T.ink} /> {label && <span>{label}</span>}</button>
    );
  }

  function EpisodeCardH({ e, poster, onPlay }) {
    return (
      <button onClick={onPlay} style={{ width: 150, flex: "0 0 auto", background: "none", border: "none", padding: 0, cursor: "pointer", textAlign: "left", fontFamily: T.body }}>
        <div style={{ position: "relative", width: "100%", aspectRatio: "16/10", borderRadius: 11, overflow: "hidden", border: `1px solid ${T.line2}`,
          background: `linear-gradient(150deg,${poster.from},${poster.to})` }}>
          <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center" }}>
            <div style={{ width: 34, height: 34, borderRadius: "50%", background: "rgba(8,16,30,.55)", backdropFilter: "blur(6px)", border: "1px solid rgba(255,255,255,.25)", display: "grid", placeItems: "center" }}>
              <Icon name="play" size={15} filled color="#fff" /></div></div>
          <div style={{ position: "absolute", top: 6, left: 6, fontFamily: T.disp, fontWeight: 700, fontSize: 12, color: "#fff", background: "rgba(8,16,30,.6)", padding: "1px 7px", borderRadius: 6 }}>EP {e.ep}</div>
          {e.progress > 0 && <div style={{ position: "absolute", left: 0, right: 0, bottom: 0, height: 3, background: "rgba(255,255,255,.2)" }}><div style={{ height: "100%", width: `${e.progress * 100}%`, background: "linear-gradient(90deg,#19C3FB,#2D8EFF)" }} /></div>}
        </div>
        <div style={{ marginTop: 6, fontSize: 12, fontWeight: 600, color: T.ink, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{e.title}</div>
        <div style={{ fontSize: 10.5, color: T.mut2, marginTop: 1 }}>{e.duration}</div>
      </button>
    );
  }

  function EpisodeRowV({ e, poster, onPlay }) {
    const done = e.progress === 1;
    return (
      <button onClick={onPlay} style={{ display: "flex", gap: 12, alignItems: "center", width: "100%", textAlign: "left", padding: "9px 0",
        background: "none", border: "none", borderBottom: `1px solid ${T.line}`, cursor: "pointer", fontFamily: T.body }}>
        <div style={{ position: "relative", width: 108, flex: "none", aspectRatio: "16/10", borderRadius: 10, overflow: "hidden", border: `1px solid ${T.line2}`, background: `linear-gradient(150deg,${poster.from},${poster.to})` }}>
          <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center" }}><Icon name="play" size={18} filled color="rgba(255,255,255,.92)" /></div>
          {e.progress > 0 && <div style={{ position: "absolute", left: 0, right: 0, bottom: 0, height: 3, background: "rgba(255,255,255,.2)" }}><div style={{ height: "100%", width: `${e.progress * 100}%`, background: "linear-gradient(90deg,#19C3FB,#2D8EFF)" }} /></div>}
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <span style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 16, color: T.blueBright }}>{String(e.ep).padStart(2, "0")}</span>
            <span style={{ fontSize: 13.5, fontWeight: 600, color: T.ink, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{e.title}</span></div>
          <div style={{ fontSize: 11, color: T.mut2, marginTop: 3 }}>{e.duration}{done ? " · Completed" : e.progress > 0 ? ` · ${Math.round(e.progress * 100)}% watched` : ""}</div>
        </div>
        <Icon name={done ? "check" : "download"} size={18} color={done ? "#22D3A6" : T.mut2} />
      </button>
    );
  }

  function Detail({ id, onBack, onOpen }) {
    const c = D.byId(id), dj = D.djById(c.dj);
    const isSeries = c.type === "series";
    const [expanded, setExpanded] = React.useState(false);
    const related = D.where((x) => x.id !== id && (x.country === c.country || x.type === c.type)).slice(0, 8);
    const eps = c.episodesList || [];

    return (
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <Player c={c} onBack={onBack} />
        <div style={{ flex: 1, overflowY: "auto", paddingBottom: 28 }} className="sx-scroll">
          {/* actions */}
          <div style={{ display: "flex", gap: 8, padding: "14px 16px 6px" }}>
            <ActionBtn icon="download" label="Download" primary />
            <ActionBtn icon="bookmark" label="Save" />
            <ActionBtn icon="send" label="Share" />
          </div>
          {/* details */}
          <div style={{ padding: "10px 16px 0" }}>
            <div style={{ fontFamily: T.disp, fontWeight: 800, fontSize: 27, lineHeight: 1.0, color: T.ink, textTransform: "uppercase" }}>{c.title}</div>
            <div style={{ fontSize: 12, color: T.mut2, marginTop: 4 }}>{c.original}</div>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 7, marginTop: 11 }}>
              <Badge>{c.year}</Badge>
              <Badge>{D.countries[c.country].flag} {D.countries[c.country].name}</Badge>
              <Badge accent>{isSeries ? `Series · ${c.seasons} ${c.seasons > 1 ? "seasons" : "season"}` : "Movie"}</Badge>
              <Badge gold><Icon name="star" size={12} filled color={T.gold} /> {c.rating} <span style={{ color: T.mut2, fontWeight: 500 }}>({c.votes})</span></Badge>
            </div>
            {/* DJ */}
            <div style={{ display: "flex", alignItems: "center", gap: 10, marginTop: 14 }}>
              <div style={{ width: 38, height: 38, borderRadius: "50%", flex: "none", display: "grid", placeItems: "center", fontFamily: T.disp, fontWeight: 700, fontSize: 15, color: "#fff", background: `linear-gradient(150deg,${dj.accent},${dj.accent}99)`, boxShadow: `0 0 14px ${dj.accent}66` }}>{dj.name.replace("DJ ", "").slice(0, 2).toUpperCase()}</div>
              <div><div style={{ fontSize: 13.5, fontWeight: 700, color: T.ink }}>{dj.name}</div><div style={{ fontSize: 11, color: T.mut2 }}>Translator · {dj.country}</div></div>
              <button style={{ marginLeft: "auto", height: 32, padding: "0 14px", borderRadius: 999, cursor: "pointer", fontFamily: T.body, fontSize: 12, fontWeight: 700, color: T.blueBright, background: "rgba(45,142,255,.12)", border: `1px solid ${T.line2}` }}>Follow</button>
            </div>
            <p style={{ fontSize: 13.5, lineHeight: 1.6, color: T.mut, marginTop: 14, marginBottom: 0, textWrap: "pretty" }}>{c.description}</p>
          </div>

          {/* episodes */}
          {isSeries && (
            <div style={{ marginTop: 22 }}>
              <div style={{ display: "flex", alignItems: "center", padding: "0 16px", marginBottom: 12 }}>
                <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 19, color: T.ink, textTransform: "uppercase", letterSpacing: .4 }}>Episodes</div>
                <span style={{ fontSize: 12, color: T.mut2, marginLeft: 8 }}>{c.episodes} episodes</span>
                <button onClick={() => setExpanded((v) => !v)} style={{ marginLeft: "auto", display: "inline-flex", alignItems: "center", gap: 5, height: 32, padding: "0 12px", borderRadius: 999,
                  cursor: "pointer", fontFamily: T.body, fontSize: 12, fontWeight: 700, color: expanded ? "#fff" : T.blueBright,
                  background: expanded ? "linear-gradient(180deg,#2D8EFF,#1A6FE8)" : "rgba(45,142,255,.12)", border: `1px solid ${expanded ? "transparent" : T.line2}`, boxShadow: expanded ? T.glow : "none" }}>
                  {expanded ? "Collapse" : "Expand"}
                  <span style={{ display: "inline-flex", transition: "transform .3s", transform: expanded ? "rotate(180deg)" : "none" }}><Icon name="chevD" size={15} color={expanded ? "#fff" : T.blueBright} /></span>
                </button>
              </div>
              {expanded ? (
                <div className="sx-expand" style={{ padding: "0 16px" }}>
                  {eps.concat(eps.slice(0, 4).map((e, i) => ({ ...e, ep: eps.length + i + 1, title: "Episode " + (eps.length + i + 1), progress: 0 }))).map((e, i) => (
                    <EpisodeRowV key={i} e={e} poster={c.poster} onPlay={() => {}} />
                  ))}
                </div>
              ) : (
                <div style={{ display: "flex", gap: 12, overflowX: "auto", padding: "0 16px 4px", scrollbarWidth: "none" }} className="sx-rail">
                  {eps.map((e, i) => <EpisodeCardH key={i} e={e} poster={c.poster} onPlay={() => {}} />)}
                  <button onClick={() => setExpanded(true)} style={{ width: 90, flex: "0 0 auto", borderRadius: 11, cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8,
                    background: "rgba(14,29,51,.5)", border: `1px dashed ${T.line2}`, color: T.blueBright, fontFamily: T.body, fontSize: 11.5, fontWeight: 700, aspectRatio: "16/10", alignSelf: "flex-start" }}>
                    <Icon name="list" size={20} color={T.blueBright} /> All</button>
                </div>
              )}
            </div>
          )}

          {/* related — hidden when expanded */}
          {!(isSeries && expanded) && (
            <div className="sx-fade" style={{ marginTop: 24 }}>
              <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 19, color: T.ink, textTransform: "uppercase", letterSpacing: .4, padding: "0 16px", marginBottom: 12 }}>Related</div>
              <div style={{ display: "flex", gap: 12, overflowX: "auto", padding: "0 16px 4px", scrollbarWidth: "none" }} className="sx-rail">
                {related.map((r) => <MovieCard key={r.id} id={r.id} onOpen={onOpen} width={118} />)}
              </div>
            </div>
          )}
        </div>
      </div>
    );
  }

  function Badge({ children, accent, gold }) {
    return <span style={{ display: "inline-flex", alignItems: "center", gap: 4, height: 26, padding: "0 11px", borderRadius: 999, fontFamily: T.body, fontSize: 11.5, fontWeight: 700,
      color: gold ? T.gold : accent ? T.blueBright : T.mut, background: gold ? "rgba(244,193,59,.12)" : accent ? "rgba(45,142,255,.14)" : "rgba(14,29,51,.7)",
      border: `1px solid ${gold ? "rgba(244,193,59,.3)" : accent ? "rgba(45,142,255,.4)" : T.line2}` }}>{children}</span>;
  }

  const glassBtn = { width: 36, height: 36, borderRadius: 11, display: "grid", placeItems: "center", cursor: "pointer",
    background: "rgba(8,16,30,.5)", backdropFilter: "blur(8px)", border: "1px solid rgba(255,255,255,.18)" };

  window.SXDetail = { Detail };
})();
