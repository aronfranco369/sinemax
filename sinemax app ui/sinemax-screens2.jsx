// sinemax-screens2.jsx — Requests, Library, Profile
(function () {
  const T = window.SXT, D = window.SinemaxData, Icon = window.Icon;
  const { MovieCard } = window.SX;

  // ============================================================ REQUESTS ===
  function Requests() {
    const cp = D.requests.copy;
    const [title, setTitle] = React.useState("");
    const [notes, setNotes] = React.useState("");
    const [hist, setHist] = React.useState(D.requests.history);
    const [toast, setToast] = React.useState(false);
    const submit = () => {
      if (!title.trim()) return;
      setHist((h) => [{ id: "n" + Date.now(), title: title.trim(), note: notes.trim(), status: "Inasubiri", date: "Sasa hivi" }, ...h]);
      setTitle(""); setNotes(""); setToast(true); setTimeout(() => setToast(false), 2600);
    };
    return (
      <div style={{ flex: 1, overflowY: "auto", padding: "6px 16px 96px", position: "relative" }} className="sx-scroll">
        <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 26, letterSpacing: .5, color: T.ink, textTransform: "uppercase" }}>{cp.heading}</div>
        <p style={{ fontSize: 13, color: T.mut, lineHeight: 1.55, marginTop: 6, marginBottom: 18, textWrap: "pretty" }}>{cp.subtitle}</p>

        <div style={{ background: "linear-gradient(180deg,rgba(14,29,51,.8),rgba(10,22,40,.7))", border: `1px solid ${T.line2}`, borderRadius: 18, padding: 16, boxShadow: "0 12px 30px rgba(0,0,0,.35)" }}>
          <Label>Movie or series name</Label>
          <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder={cp.titlePlaceholder} style={inp} />
          <Label style={{ marginTop: 14 }}>More details (optional)</Label>
          <textarea value={notes} onChange={(e) => setNotes(e.target.value)} placeholder={cp.notesPlaceholder} rows={3} style={{ ...inp, resize: "none", paddingTop: 11, height: "auto", lineHeight: 1.5 }} />
          <button onClick={submit} disabled={!title.trim()} style={{ width: "100%", height: 48, marginTop: 16, borderRadius: 13, border: "none", cursor: title.trim() ? "pointer" : "not-allowed",
            fontFamily: T.body, fontWeight: 700, fontSize: 14.5, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
            background: title.trim() ? "linear-gradient(180deg,#2D8EFF,#1A6FE8)" : "rgba(45,142,255,.2)", boxShadow: title.trim() ? T.glow : "none", opacity: title.trim() ? 1 : .6, transition: "all .2s" }}>
            <Icon name="send" size={18} filled color="#fff" /> {cp.submit}</button>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 7, color: T.mut2, fontSize: 11.5, marginTop: 12, lineHeight: 1.5 }}>
          <Icon name="info" size={14} color={T.mut2} /> {cp.footnote}</div>

        <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 17, color: T.ink, textTransform: "uppercase", letterSpacing: .4, margin: "26px 0 4px" }}>Your Requests</div>
        {hist.map((r) => {
          const st = D.requests.statuses[r.status];
          return (
            <div key={r.id} style={{ display: "flex", gap: 12, alignItems: "flex-start", padding: "13px 0", borderBottom: `1px solid ${T.line}` }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13.5, fontWeight: 600, color: T.ink }}>{r.title}</div>
                <div style={{ fontSize: 11.5, color: T.mut2, marginTop: 3 }}>{r.note || "—"} · {r.date}</div>
              </div>
              <span style={{ flex: "none", fontSize: 10.5, fontWeight: 700, padding: "4px 10px", borderRadius: 999, color: st.color, background: st.color + "1f", border: `1px solid ${st.color}55` }}>{r.status}</span>
            </div>
          );
        })}
        {toast && (
          <div className="sx-toast" style={{ position: "absolute", left: 16, right: 16, bottom: 20, display: "flex", alignItems: "center", gap: 10, padding: "13px 16px", borderRadius: 14,
            background: "linear-gradient(180deg,#0E2A22,#0A1E18)", border: "1px solid rgba(34,211,166,.4)", boxShadow: "0 12px 30px rgba(0,0,0,.4)" }}>
            <div style={{ width: 26, height: 26, borderRadius: "50%", background: "rgba(34,211,166,.2)", display: "grid", placeItems: "center" }}><Icon name="check" size={16} color="#22D3A6" stroke={2.4} /></div>
            <div style={{ fontSize: 13, fontWeight: 600, color: T.ink }}>Request sent! We'll let you know.</div></div>
        )}
      </div>
    );
  }

  // ============================================================ LIBRARY =====
  function Library({ onOpen }) {
    const [tab, setTab] = React.useState("recent");
    const L = D.library;
    const tabs = [["recent", "Recent"], ["saved", "Saved"], ["downloads", "Downloads"]];
    return (
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <div style={{ padding: "6px 16px 0" }}>
          <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 26, letterSpacing: .5, color: T.ink, textTransform: "uppercase", marginBottom: 14 }}>Library</div>
          <div style={{ display: "flex", gap: 6, background: "rgba(14,29,51,.5)", borderRadius: 12, padding: 4, border: `1px solid ${T.line}` }}>
            {tabs.map(([k, l]) => (
              <button key={k} onClick={() => setTab(k)} style={{ flex: 1, height: 36, borderRadius: 9, border: "none", cursor: "pointer", fontFamily: T.body, fontSize: 12.5, fontWeight: 700,
                color: tab === k ? "#fff" : T.mut, background: tab === k ? "linear-gradient(180deg,#2D8EFF,#1A6FE8)" : "transparent", boxShadow: tab === k ? "0 4px 14px rgba(45,142,255,.4)" : "none", transition: "all .2s" }}>{l}</button>
            ))}
          </div>
        </div>
        <div style={{ flex: 1, overflowY: "auto", padding: "16px 16px 96px" }} className="sx-scroll">
          {tab === "recent" && L.recent.map((it) => {
            const c = D.byId(it.id);
            return (
              <button key={it.id + it.watchedAt} onClick={() => onOpen(it.id)} style={{ display: "flex", gap: 12, alignItems: "center", width: "100%", textAlign: "left", padding: "9px 0", background: "none", border: "none", borderBottom: `1px solid ${T.line}`, cursor: "pointer", fontFamily: T.body }}>
                <Thumb c={c} w={86} ar="16/10" play />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 13.5, fontWeight: 600, color: T.ink, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{c.title}</div>
                  <div style={{ fontSize: 11, color: T.mut2, marginTop: 3 }}>{it.context} · {it.watchedAt}</div>
                  <div style={{ height: 4, borderRadius: 3, background: "rgba(255,255,255,.1)", marginTop: 7, overflow: "hidden" }}><div style={{ height: "100%", width: `${it.progress * 100}%`, background: "linear-gradient(90deg,#19C3FB,#2D8EFF)" }} /></div>
                </div>
              </button>
            );
          })}
          {tab === "saved" && (
            <div style={{ display: "grid", gridTemplateColumns: "repeat(3, minmax(0,1fr))", gap: 12 }}>
              {L.saved.map((id) => <MovieCard key={id} id={id} onOpen={onOpen} />)}</div>
          )}
          {tab === "downloads" && <Downloads L={L} onOpen={onOpen} />}
        </div>
      </div>
    );
  }

  function Downloads({ L, onOpen }) {
    const [items, setItems] = React.useState(L.downloads);
    return (
      <>
        <div style={{ display: "flex", alignItems: "center", gap: 10, padding: "12px 14px", borderRadius: 14, background: "rgba(14,29,51,.6)", border: `1px solid ${T.line}`, marginBottom: 14 }}>
          <Icon name="download" size={20} color={T.blueBright} />
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 12, color: T.mut, marginBottom: 6 }}>Storage: <b style={{ color: T.ink }}>{L.storage.used}</b> / {L.storage.total}</div>
            <div style={{ height: 5, borderRadius: 3, background: "rgba(255,255,255,.1)", overflow: "hidden" }}><div style={{ height: "100%", width: `${L.storage.percent * 100}%`, background: "linear-gradient(90deg,#19C3FB,#2D8EFF)" }} /></div>
          </div>
        </div>
        {items.map((it) => {
          const c = D.byId(it.id);
          return (
            <div key={it.id + it.at} style={{ display: "flex", gap: 12, alignItems: "center", padding: "9px 0", borderBottom: `1px solid ${T.line}` }}>
              <button onClick={() => onOpen(it.id)} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><Thumb c={c} w={64} ar="2/3" play /></button>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13.5, fontWeight: 600, color: T.ink, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{c.title}</div>
                <div style={{ fontSize: 11, color: T.mut2, marginTop: 3 }}>{it.context} · {it.at}</div>
                <div style={{ display: "inline-flex", alignItems: "center", gap: 6, marginTop: 6, fontSize: 10.5, fontWeight: 700, color: "#22D3A6", padding: "3px 9px", borderRadius: 999, background: "rgba(34,211,166,.12)", border: "1px solid rgba(34,211,166,.3)" }}>
                  <Icon name="check" size={11} color="#22D3A6" stroke={2.4} /> {it.quality} · {it.size}</div>
              </div>
              <button onClick={() => setItems((p) => p.filter((x) => x !== it))} style={{ width: 38, height: 38, borderRadius: 11, display: "grid", placeItems: "center", cursor: "pointer", background: "rgba(255,93,122,.1)", border: "1px solid rgba(255,93,122,.25)" }}>
                <Icon name="trash" size={17} color="#FF5D7A" /></button>
            </div>
          );
        })}
        {items.length === 0 && <div style={{ textAlign: "center", color: T.mut2, marginTop: 40, fontSize: 13 }}>No downloads saved.</div>}
      </>
    );
  }

  function Thumb({ c, w, ar, play }) {
    return (
      <div style={{ position: "relative", width: w, flex: "none", aspectRatio: ar, borderRadius: 10, overflow: "hidden", border: `1px solid ${T.line2}`, background: `linear-gradient(150deg,${c.poster.from},${c.poster.to})` }}>
        <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center", fontSize: 26, opacity: .25, color: "#fff" }}>{c.poster.glyph}</div>
        {play && <div style={{ position: "absolute", inset: 0, display: "grid", placeItems: "center" }}><div style={{ width: 28, height: 28, borderRadius: "50%", background: "rgba(8,16,30,.5)", backdropFilter: "blur(5px)", border: "1px solid rgba(255,255,255,.25)", display: "grid", placeItems: "center" }}><Icon name="play" size={13} filled color="#fff" /></div></div>}
      </div>
    );
  }

  // ============================================================ PROFILE =====
  function Profile() {
    const P = D.profile;
    const [settings, setSettings] = React.useState(P.settings);
    const toggle = (id) => setSettings((s) => s.map((x) => x.id === id ? { ...x, on: !x.on } : x));
    return (
      <div style={{ flex: 1, overflowY: "auto", padding: "6px 16px 96px" }} className="sx-scroll">
        <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 26, letterSpacing: .5, color: T.ink, textTransform: "uppercase", marginBottom: 16 }}>Profile</div>
        {/* user */}
        <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
          <div style={{ position: "relative" }}>
            <div style={{ width: 66, height: 66, borderRadius: "50%", display: "grid", placeItems: "center", fontFamily: T.disp, fontWeight: 800, fontSize: 24, color: "#fff",
              background: `linear-gradient(150deg,${P.user.avatarColor[0]},${P.user.avatarColor[1]})`, boxShadow: "0 0 22px rgba(45,142,255,.5)" }}>{P.user.initials}</div>
            <div style={{ position: "absolute", right: -2, bottom: -2, width: 24, height: 24, borderRadius: "50%", background: "#0E1D33", border: `1px solid ${T.line2}`, display: "grid", placeItems: "center" }}><Icon name="edit" size={13} color={T.blueBright} /></div>
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 18, fontWeight: 700, color: T.ink }}>{P.user.name}</div>
            <div style={{ fontSize: 12.5, color: T.mut2 }}>{P.user.handle} · Since {P.user.memberSince}</div>
          </div>
        </div>
        {/* stats */}
        <div style={{ display: "flex", gap: 10, marginTop: 18 }}>
          {P.stats.map((s) => (
            <div key={s.label} style={{ flex: 1, textAlign: "center", padding: "14px 6px", borderRadius: 14, background: "rgba(14,29,51,.5)", border: `1px solid ${T.line}` }}>
              <div style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 24, color: T.ink }}>{s.value}</div>
              <div style={{ fontSize: 10.5, color: T.mut2, marginTop: 2 }}>{s.label}</div></div>
          ))}
        </div>
        {/* subscription */}
        <div style={{ marginTop: 18, borderRadius: 18, padding: 18, position: "relative", overflow: "hidden",
          background: "linear-gradient(140deg,rgba(45,142,255,.22),rgba(25,195,251,.08) 60%,rgba(10,22,40,.6))", border: "1px solid rgba(45,142,255,.4)", boxShadow: "0 14px 34px rgba(45,142,255,.18)" }}>
          <div style={{ position: "absolute", right: -20, top: -20, width: 120, height: 120, borderRadius: "50%", background: "radial-gradient(circle,rgba(45,142,255,.35),transparent 70%)" }} />
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <Icon name="crown" size={17} filled color={T.gold} />
            <span style={{ fontFamily: T.disp, fontWeight: 700, fontSize: 17, color: "#fff", textTransform: "uppercase", letterSpacing: .4, whiteSpace: "nowrap" }}>Sinemax {P.subscription.plan}</span>
            <span style={{ marginLeft: "auto", flex: "none", fontSize: 10.5, fontWeight: 700, color: "#22D3A6", padding: "3px 9px", borderRadius: 999, background: "rgba(34,211,166,.16)" }}>{P.subscription.status}</span>
          </div>
          <div style={{ fontSize: 12.5, color: T.mut, marginTop: 8 }}>{P.subscription.price} · Inaisha {P.subscription.renews}</div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginTop: 12 }}>
            {P.subscription.perks.map((p) => <span key={p} style={{ fontSize: 10.5, color: T.ink, padding: "4px 9px", borderRadius: 999, background: "rgba(255,255,255,.08)", border: "1px solid rgba(255,255,255,.12)" }}>{p}</span>)}</div>
          <button style={{ width: "100%", height: 42, marginTop: 14, borderRadius: 12, border: "none", cursor: "pointer", fontFamily: T.body, fontWeight: 700, fontSize: 13.5, color: "#0A1628", background: "linear-gradient(180deg,#9FD4FF,#2D8EFF)", boxShadow: "0 6px 18px rgba(45,142,255,.4)" }}>Upgrade Plan</button>
        </div>
        {/* settings */}
        <div style={{ marginTop: 20, borderRadius: 16, overflow: "hidden", background: "rgba(14,29,51,.5)", border: `1px solid ${T.line}` }}>
          {settings.map((s, i) => (
            <div key={s.id} style={{ display: "flex", alignItems: "center", gap: 13, padding: "14px 16px", borderBottom: i < settings.length - 1 ? `1px solid ${T.line}` : "none", cursor: "pointer" }}>
              <div style={{ width: 34, height: 34, borderRadius: 10, display: "grid", placeItems: "center", flex: "none",
                background: s.type === "danger" ? "rgba(255,93,122,.12)" : "rgba(45,142,255,.1)" }}>
                <Icon name={s.icon} size={18} color={s.type === "danger" ? "#FF5D7A" : T.blueBright} /></div>
              <span style={{ flex: 1, fontSize: 14, fontWeight: 600, color: s.type === "danger" ? "#FF5D7A" : T.ink }}>{s.label}</span>
              {s.type === "toggle" ? (
                <button onClick={() => toggle(s.id)} style={{ width: 44, height: 26, borderRadius: 999, border: "none", cursor: "pointer", padding: 3, transition: "all .2s",
                  background: s.on ? "linear-gradient(180deg,#2D8EFF,#1A6FE8)" : "rgba(120,160,220,.2)", display: "flex", justifyContent: s.on ? "flex-end" : "flex-start", boxShadow: s.on ? "0 0 12px rgba(45,142,255,.5)" : "none" }}>
                  <div style={{ width: 20, height: 20, borderRadius: "50%", background: "#fff" }} /></button>
              ) : s.type === "link" ? (
                <span style={{ display: "inline-flex", alignItems: "center", gap: 4, fontSize: 12.5, color: T.mut2 }}>{s.value}<Icon name="chevR" size={16} color={T.mut2} /></span>
              ) : <Icon name="chevR" size={16} color="#FF5D7A" />}
            </div>
          ))}
        </div>
        <div style={{ textAlign: "center", color: T.mut2, fontSize: 11, marginTop: 18 }}>Sinemax · Version 1.0.0</div>
      </div>
    );
  }

  function Label({ children, style }) {
    return <div style={{ fontSize: 11.5, fontWeight: 700, color: T.mut, textTransform: "uppercase", letterSpacing: .5, marginBottom: 7, ...style }}>{children}</div>;
  }
  const inp = { width: "100%", height: 46, padding: "0 14px", borderRadius: 12, boxSizing: "border-box", background: "rgba(5,13,26,.6)", border: `1px solid ${T.line2}`, outline: "none", color: T.ink, fontFamily: T.body, fontSize: 14, caretColor: T.blueBright };

  window.SXScreens2 = { Requests, Library, Profile };
})();
