/* ============================================================================
   SINEMAX — Mock Data Layer (English UI)
   ----------------------------------------------------------------------------
   Streaming/download app for translated movies & series. All content is
   fictional. UI ships in English; localize individual strings as needed.
   Posters are procedural: each item carries a `poster` palette so the UI can
   render an attractive placeholder until real artwork is supplied.

   Consume via:  window.SinemaxData
   Helpers:      SinemaxData.byId(id)  /  SinemaxData.where(fn)
   ========================================================================== */
(function () {
  "use strict";

  /* ---------------------------------------------------------------- DJs --- */
  const djs = [
    { id: "dj-afande",  name: "DJ Afande",  titles: 0, country: "Tanzania", accent: "#2D8EFF" },
    { id: "dj-kibinda", name: "DJ Kibinda", titles: 0, country: "Tanzania", accent: "#19C3FB" },
    { id: "dj-mzee",    name: "DJ Mzee",    titles: 0, country: "Tanzania", accent: "#7C5CFF" },
    { id: "dj-salama",  name: "DJ Salama",  titles: 0, country: "Tanzania", accent: "#22D3A6" },
    { id: "dj-honest",  name: "DJ Honest",  titles: 0, country: "Kenya",    accent: "#FF8A3D" },
    { id: "dj-pamoja",  name: "DJ Pamoja",  titles: 0, country: "Tanzania", accent: "#FF5D7A" },
    { id: "dj-rocky",   name: "DJ Rocky",   titles: 0, country: "Tanzania", accent: "#F4C13B" },
    { id: "dj-nash",    name: "DJ Nash",    titles: 0, country: "Kenya",    accent: "#2D8EFF" },
    { id: "dj-tamaa",   name: "DJ Tamaa",   titles: 0, country: "Tanzania", accent: "#19C3FB" },
    { id: "dj-boss",    name: "DJ Boss",    titles: 0, country: "Tanzania", accent: "#7C5CFF" },
    { id: "dj-cartoon", name: "DJ Cartoon", titles: 0, country: "Tanzania", accent: "#22D3A6" },
    { id: "dj-malkia",  name: "DJ Malkia",  titles: 0, country: "Tanzania", accent: "#FF5D7A" }
  ];

  /* ----------------------------------------------------------- Countries -- */
  const countries = {
    Korea:    { name: "South Korea",   flag: "🇰🇷", label: "Korea" },
    India:    { name: "India",         flag: "🇮🇳", label: "India" },
    Tanzania: { name: "Tanzania",      flag: "🇹🇿", label: "Tanzania" },
    USA:      { name: "United States", flag: "🇺🇸", label: "USA" },
    Turkey:   { name: "Turkey",        flag: "🇹🇷", label: "Turkey" }
  };

  /* ----------------------------------------------- Episode generator ----- */
  function makeEpisodes(seedTitles, palette, runtime) {
    return seedTitles.map((t, i) => ({
      ep: i + 1, title: t, duration: runtime[i % runtime.length],
      progress: i === 0 ? 1 : i === 1 ? 0.42 : 0, poster: palette
    }));
  }

  /* ------------------------------------------------------- The catalog --- */
  const catalog = [
    /* ===== Korean Series ===== */
    { id: "ks1", type: "series", title: "Winter's Vow", year: 2024, country: "Korea", genre: "Romance · Drama",
      dj: "dj-afande", rating: 4.8, votes: "12.4K", seasons: 1, episodes: 16,
      poster: { from: "#13315C", to: "#0A1A33", accent: "#2D8EFF", glyph: "❄" },
      description: "When a young doctor returns to her hometown after years away, she comes face to face with the first love who once left her without a word. The winter snow uncovers secrets buried for far too long.",
      epList: ["Coming Home", "First Snow", "The Lost Letter", "Night of the Storm", "Memories", "An Old Promise", "Family Secret", "Winter Tears"] },
    { id: "ks2", type: "series", title: "Throne of Shadows", year: 2023, country: "Korea", genre: "Historical · Action",
      dj: "dj-kibinda", rating: 4.9, votes: "20.1K", seasons: 2, episodes: 24,
      poster: { from: "#3A1C4A", to: "#140A1F", accent: "#7C5CFF", glyph: "♛" },
      description: "In an ancient kingdom, a dethroned prince plots to reclaim his father's throne. Power struggles, betrayal and forbidden love collide in a gripping tale of ambition.",
      epList: ["The King's Fall", "Oath of Blood", "Enemy Within", "Night Battle", "The New Queen", "Palace Schemes", "Vengeance", "Crown of Gold"] },
    { id: "ks3", type: "series", title: "Soul Surgeon", year: 2025, country: "Korea", genre: "Drama · Medical",
      dj: "dj-mzee", rating: 4.7, votes: "8.9K", seasons: 1, episodes: 12,
      poster: { from: "#0C3B3C", to: "#06201F", accent: "#22D3A6", glyph: "✚" },
      description: "A brilliant heart surgeon faces the hardest case of his life while battling his own inner wounds. Every operation is a fight between life and death.",
      epList: ["24 Hours", "Broken Heart", "Hard Choice", "A Special Patient", "Human Error", "New Hope", "Risky Operation", "Healing"] },
    { id: "ks4", type: "series", title: "Endless Love", year: 2022, country: "Korea", genre: "Romance · Comedy",
      dj: "dj-salama", rating: 4.6, votes: "15.7K", seasons: 1, episodes: 18,
      poster: { from: "#5A1E3A", to: "#250A18", accent: "#FF5D7A", glyph: "♥" },
      description: "A sharp-tongued company director hires a new secretary who turns his life completely upside down. Laughter, quarrels and romance fill every corner of the office.",
      epList: ["The Interview", "Strict Boss", "Day One", "Secret Contract", "Business Trip", "Heartbeat", "The Truth", "The Wedding"] },
    { id: "ks5", type: "series", title: "Palace Secrets", year: 2024, country: "Korea", genre: "Mystery · Drama",
      dj: "dj-afande", rating: 4.8, votes: "11.2K", seasons: 1, episodes: 14,
      poster: { from: "#1C2E66", to: "#0A1330", accent: "#2D8EFF", glyph: "✦" },
      description: "A new servant in the royal palace uncovers a murder hidden for decades. The deeper she digs, the closer she comes to grave danger.",
      epList: ["The Hidden Door", "Shadow of Night", "Evidence", "The Suspect", "Letter in Blood", "Bitter Truth", "The Trap", "Justice"] },
    { id: "ks6", type: "series", title: "Path of Stars", year: 2025, country: "Korea", genre: "Romance · Music",
      dj: "dj-pamoja", rating: 4.5, votes: "6.3K", seasons: 1, episodes: 16,
      poster: { from: "#2A2466", to: "#100C2E", accent: "#7C5CFF", glyph: "✺" },
      description: "An ordinary girl who dreams of stardom meets a famous singer who has lost his way. Together they rediscover the true meaning of dreams and love.",
      epList: ["Golden Voice", "First Stage", "The Contest", "Song of the Heart", "Defeat", "Rising Again", "The Grand Show", "A New Star"] },

    /* ===== Indian Series ===== */
    { id: "is1", type: "series", title: "Blood & Gold", year: 2023, country: "India", genre: "Family · Drama",
      dj: "dj-honest", rating: 4.6, votes: "18.5K", seasons: 3, episodes: 60,
      poster: { from: "#5C2A0C", to: "#2A1206", accent: "#FF8A3D", glyph: "❖" },
      description: "A wealthy merchant family is torn apart by an inheritance dispute. Two sisters fight for love, fortune and the family's honor.",
      epList: ["The Inheritance", "Two Sisters", "Forced Marriage", "Father's Secret", "Betrayal", "Mother's Tears", "Reconciliation", "Forgiveness"] },
    { id: "is2", type: "series", title: "The Reluctant Bride", year: 2024, country: "India", genre: "Romance · Family",
      dj: "dj-malkia", rating: 4.7, votes: "22.9K", seasons: 2, episodes: 48,
      poster: { from: "#5A1230", to: "#260714", accent: "#FF5D7A", glyph: "❀" },
      description: "A young woman forced to marry a stranger slowly discovers that an arranged marriage can be the start of true love.",
      epList: ["The Wedding Ring", "A Stranger Husband", "New Family", "Wall of Silence", "First Smile", "Jealousy", "The Truth", "Real Love"] },
    { id: "is3", type: "series", title: "Voice of the Heart", year: 2022, country: "India", genre: "Drama · Music",
      dj: "dj-tamaa", rating: 4.5, votes: "9.8K", seasons: 1, episodes: 32,
      poster: { from: "#42235C", to: "#1B0E26", accent: "#7C5CFF", glyph: "♪" },
      description: "A blind singer with a rare gift searches for a chance to show the world her talent. Her journey is full of obstacles, true friends and envious rivals.",
      epList: ["Hidden Talent", "First Stage", "A True Friend", "The Plot", "Defeat", "Faith", "Victory", "National Star"] },
    { id: "is4", type: "series", title: "The Wedding Ring", year: 2025, country: "India", genre: "Romance · Drama",
      dj: "dj-honest", rating: 4.4, votes: "7.1K", seasons: 1, episodes: 40,
      poster: { from: "#5C401C", to: "#2A1D0A", accent: "#F4C13B", glyph: "◈" },
      description: "On the wedding day the ring goes missing, and with it a great secret comes to light. Two families are caught in a web of love, intrigue and forgiveness.",
      epList: ["Preparations", "The Lost Ring", "Accusations", "An Old Secret", "The Courtroom", "The Truth", "Reconciliation", "A New Wedding"] },

    /* ===== Turkish Series ===== */
    { id: "ts1", type: "series", title: "A Century of Love", year: 2024, country: "Turkey", genre: "Romance · Historical",
      dj: "dj-boss", rating: 4.8, votes: "25.6K", seasons: 2, episodes: 50,
      poster: { from: "#3C0F1E", to: "#1A060D", accent: "#FF5D7A", glyph: "✦" },
      description: "In old Istanbul, love between people of different classes defies the rules of society. A story of passion, honor and freedom.",
      epList: ["First Meeting", "Forbidden", "Sea of Secrets", "Family", "The Decision", "The Escape", "The Return", "Freedom"] },
    { id: "ts2", type: "series", title: "The Secret Mountain", year: 2023, country: "Turkey", genre: "Action · Drama",
      dj: "dj-nash", rating: 4.6, votes: "13.4K", seasons: 1, episodes: 36,
      poster: { from: "#1C3A2E", to: "#0A1A14", accent: "#22D3A6", glyph: "▲" },
      description: "A family living in the remote mountains guards a secret passed down for generations. When a stranger arrives, everything changes forever.",
      epList: ["The Stranger", "Mountain Laws", "Family Secret", "Danger", "Betrayal", "War", "The Truth", "Peace"] },

    /* ===== Korean Movies ===== */
    { id: "km1", type: "movie", title: "Last Train", year: 2023, country: "Korea", genre: "Thriller · Action",
      dj: "dj-kibinda", rating: 4.9, votes: "31.2K", duration: "1:58:00",
      poster: { from: "#3A1010", to: "#180606", accent: "#FF5D7A", glyph: "⚠" },
      description: "The last night train becomes a deadly trap as an outbreak spreads among the passengers. It's a fight to survive until the final stop." },
    { id: "km2", type: "movie", title: "Danger Island", year: 2024, country: "Korea", genre: "Action · Adventure",
      dj: "dj-mzee", rating: 4.5, votes: "14.8K", duration: "2:12:00",
      poster: { from: "#0C3B3C", to: "#06201F", accent: "#19C3FB", glyph: "≋" },
      description: "A group of tourists is stranded on a remote island where a terrifying secret awaits. Now they must fight to save their own lives." },
    { id: "km3", type: "movie", title: "Guardian of the Dark", year: 2025, country: "Korea", genre: "Action · Mystery",
      dj: "dj-afande", rating: 4.7, votes: "19.5K", duration: "2:04:00",
      poster: { from: "#1C2E66", to: "#0A1330", accent: "#2D8EFF", glyph: "✦" },
      description: "A retired detective is pulled into one last case involving a powerful crime syndicate. A single night could change everything." },
    { id: "km4", type: "movie", title: "The Final War", year: 2022, country: "Korea", genre: "Action · War",
      dj: "dj-rocky", rating: 4.6, votes: "16.0K", duration: "2:21:00",
      poster: { from: "#3A2A0C", to: "#1A1206", accent: "#F4C13B", glyph: "⚔" },
      description: "A heroic soldier leads a small squad in a final battle to defend his nation. Loyalty and courage are tested to the very end." },

    /* ===== Indian Movies ===== */
    { id: "im1", type: "movie", title: "Heart of a Lion", year: 2024, country: "India", genre: "Action · Drama",
      dj: "dj-honest", rating: 4.7, votes: "27.3K", duration: "2:34:00",
      poster: { from: "#5C2A0C", to: "#2A1206", accent: "#FF8A3D", glyph: "♦" },
      description: "A village youth rises to become a hero of the people after standing up to the cruelty of the powerful. A story of courage and justice." },
    { id: "im2", type: "movie", title: "Rain Dance", year: 2023, country: "India", genre: "Romance · Music",
      dj: "dj-tamaa", rating: 4.4, votes: "11.9K", duration: "2:41:00",
      poster: { from: "#42235C", to: "#1B0E26", accent: "#7C5CFF", glyph: "♫" },
      description: "A dancer and a musician from different worlds meet and fall in love. Music, color and romance fill every frame." },

    /* ===== Bongo Movies ===== */
    { id: "bm1", type: "movie", title: "Street of Sorrow", year: 2025, country: "Tanzania", genre: "Drama · Bongo",
      dj: "dj-pamoja", rating: 4.5, votes: "8.2K", duration: "1:47:00",
      poster: { from: "#143B2A", to: "#081A12", accent: "#22D3A6", glyph: "✦" },
      description: "On a single street in Dar es Salaam, the dreams of young people collide with the harsh truth of life. A story of hope amid hardship." },
    { id: "bm2", type: "movie", title: "Stepsister", year: 2024, country: "Tanzania", genre: "Family · Drama",
      dj: "dj-malkia", rating: 4.6, votes: "12.7K", duration: "1:52:00",
      poster: { from: "#3C1240", to: "#18071A", accent: "#FF5D7A", glyph: "❀" },
      description: "An orphaned girl lives under the cruelty of her stepmother. But fate has a surprising journey in store, leading her toward freedom and happiness." },
    { id: "bm3", type: "movie", title: "City of Sin", year: 2023, country: "Tanzania", genre: "Action · Bongo",
      dj: "dj-boss", rating: 4.4, votes: "9.6K", duration: "1:39:00",
      poster: { from: "#3A1414", to: "#180808", accent: "#FF5D7A", glyph: "✖" },
      description: "A private investigator enters the dark underworld of city crime in search of the truth. Every corner hides a secret, and every secret has a price." },
    { id: "bm4", type: "movie", title: "Golden Love", year: 2025, country: "Tanzania", genre: "Romance · Bongo",
      dj: "dj-salama", rating: 4.7, votes: "15.3K", duration: "1:58:00",
      poster: { from: "#3A2E0C", to: "#181406", accent: "#F4C13B", glyph: "♥" },
      description: "An up-and-coming musician falls for the daughter of a wealthy tycoon. The gap between their classes tests their love, but the heart knows no limits." },
    { id: "bm5", type: "movie", title: "City Dreams", year: 2024, country: "Tanzania", genre: "Drama · Bongo",
      dj: "dj-cartoon", rating: 4.3, votes: "6.8K", duration: "1:44:00",
      poster: { from: "#142E4A", to: "#08161F", accent: "#2D8EFF", glyph: "✦" },
      description: "A young man moves from the village to the city in search of a better life. He faces deceit, false friendships and unexpected opportunities." },
    { id: "bm6", type: "movie", title: "Bad Luck", year: 2023, country: "Tanzania", genre: "Comedy · Bongo",
      dj: "dj-cartoon", rating: 4.5, votes: "10.1K", duration: "1:35:00",
      poster: { from: "#3A2A0C", to: "#181206", accent: "#F4C13B", glyph: "☺" },
      description: "A man with impossibly bad luck stumbles into hilarious situations every single day. A top-notch comedy that will have you laughing to tears." },

    /* ===== Hollywood Action ===== */
    { id: "hw1", type: "movie", title: "The Big Heist", year: 2024, country: "USA", genre: "Action · Heist",
      dj: "dj-rocky", rating: 4.8, votes: "42.5K", duration: "2:16:00",
      poster: { from: "#1A2E5C", to: "#0A1226", accent: "#2D8EFF", glyph: "◆" },
      description: "A crew of master thieves plans the biggest heist in history. But not everyone on the team can be trusted — and time is running out." },
    { id: "hw2", type: "movie", title: "Iron Squad", year: 2025, country: "USA", genre: "Action · Sci-Fi",
      dj: "dj-nash", rating: 4.7, votes: "38.9K", duration: "2:28:00",
      poster: { from: "#16323A", to: "#08171B", accent: "#19C3FB", glyph: "⬡" },
      description: "An elite squad of heroes fights to save the world from an inhuman enemy. Pure action, explosions and cutting-edge technology." },
    { id: "hw3", type: "movie", title: "Danger Hour", year: 2023, country: "USA", genre: "Thriller · Action",
      dj: "dj-rocky", rating: 4.5, votes: "21.7K", duration: "1:54:00",
      poster: { from: "#3A1010", to: "#180606", accent: "#FF5D7A", glyph: "◷" },
      description: "A secret agent has just one hour to stop an attack that would shake the world. Every second counts in a race against time." },
    { id: "hw4", type: "movie", title: "Enemy of the State", year: 2024, country: "USA", genre: "Action · Political",
      dj: "dj-boss", rating: 4.6, votes: "29.4K", duration: "2:09:00",
      poster: { from: "#2A2A2E", to: "#101012", accent: "#19C3FB", glyph: "★" },
      description: "A former CIA officer is framed for treason and now the entire government is hunting him. He must prove his innocence before they reach him." }
  ];

  catalog.forEach(c => { const d = djs.find(x => x.id === c.dj); if (d) d.titles += 1; });

  const runtimeBank = ["42m", "45m", "48m", "51m", "44m", "47m"];
  catalog.forEach(c => { if (c.type === "series" && c.epList) c.episodesList = makeEpisodes(c.epList, c.poster, runtimeBank); });

  /* --------------------------------------------------- Home (rows) ------- */
  const home = [
    { id: "row-trending",    title: "Trending Now",     subtitle: "Popular this week", items: ["ks2", "hw1", "ts1", "km1", "is2", "bm4", "hw2"] },
    { id: "row-kr-series",   title: "Korean Series",    subtitle: "From South Korea",  items: ["ks1", "ks2", "ks3", "ks4", "ks5", "ks6"] },
    { id: "row-in-series",   title: "Indian Series",    subtitle: "From India",        items: ["is1", "is2", "is3", "is4"] },
    { id: "row-kr-movies",   title: "Korean Movies",    subtitle: "From South Korea",  items: ["km1", "km2", "km3", "km4"] },
    { id: "row-bongo",       title: "Bongo Movies",     subtitle: "Tanzanian films",   items: ["bm1", "bm2", "bm3", "bm4", "bm5", "bm6"] },
    { id: "row-tr-series",   title: "Turkish Series",   subtitle: "From Turkey",       items: ["ts1", "ts2"] },
    { id: "row-hollywood",   title: "Hollywood Action", subtitle: "Blockbusters",      items: ["hw1", "hw2", "hw3", "hw4"] },
    { id: "row-india-movies", title: "Indian Movies",   subtitle: "From India",        items: ["im1", "im2"] }
  ];

  const featured = {
    id: "ks2", tagline: "Most watched this week",
    blurb: "A struggle for the throne, betrayal and revenge — translated by DJ Kibinda."
  };

  /* ------------------------------------------------- Discover screen ----- */
  const discover = {
    filters: {
      year: ["All", "2026", "2025", "2024", "2023", "2022", "2021", "2020"],
      dj: ["All"].concat(djs.map(d => d.name)),
      country: ["All", "Korea", "India", "Tanzania", "USA", "Turkey"],
      type: ["All", "Series", "Movie", "Bongo"]
    },
    grid: ["ks2", "hw1", "is2", "km1", "bm4", "ts1", "ks1", "hw2", "is1", "km3",
           "bm2", "ks3", "hw4", "im1", "ts2", "bm1", "ks5", "is3", "km2", "bm3",
           "hw3", "ks4", "im2", "bm6", "ks6", "is4", "km4", "bm5"]
  };

  /* -------------------------------------------------- Library screen ----- */
  const library = {
    recent: [
      { id: "ks2", watchedAt: "Today, 20:14",   progress: 0.62, context: "S2 · Ep 4" },
      { id: "hw1", watchedAt: "Today, 18:30",   progress: 0.18, context: "Movie" },
      { id: "is2", watchedAt: "Yesterday, 21:45", progress: 0.91, context: "S1 · Ep 12" },
      { id: "bm4", watchedAt: "Yesterday, 19:02", progress: 1.0,  context: "Completed" },
      { id: "km1", watchedAt: "2 days ago, 22:10", progress: 0.45, context: "Movie" },
      { id: "ks1", watchedAt: "Jun 2",          progress: 0.30, context: "S1 · Ep 3" }
    ],
    saved: ["ts1", "ks5", "hw2", "is1", "km3", "bm2", "ks3", "im1", "hw4"],
    downloads: [
      { id: "bm4", quality: "HD 720p",   size: "612 MB", at: "Downloaded yesterday",  context: "Movie" },
      { id: "km1", quality: "FHD 1080p", size: "1.4 GB", at: "Downloaded 2 days ago",  context: "Movie" },
      { id: "ks2", quality: "HD 720p",   size: "428 MB", at: "S2 · Ep 4",              context: "Episode" },
      { id: "hw1", quality: "FHD 1080p", size: "1.7 GB", at: "Downloaded this week",   context: "Movie" },
      { id: "is2", quality: "SD 480p",   size: "240 MB", at: "S1 · Ep 11",             context: "Episode" }
    ],
    storage: { used: "4.4 GB", total: "16 GB", percent: 0.27 }
  };

  /* -------------------------------------------------- Requests screen ---- */
  const requests = {
    copy: {
      heading: "Request a Movie or Series",
      subtitle: "Can't find what you're looking for? Let us know and we'll add it as soon as we can.",
      titlePlaceholder: "Type a movie or series name...",
      notesPlaceholder: "Any extra details? (year, language, season, DJ...)",
      submit: "Send Request",
      footnote: "We review all requests and add them as soon as possible."
    },
    history: [
      { id: "r1", title: "Korean series — 'City Hunter'", note: "Season 1, DJ Afande please", status: "Added", date: "Jun 1" },
      { id: "r2", title: "New 2025 Indian movie", note: "The action one with the famous star", status: "Reviewing", date: "May 30" },
      { id: "r3", title: "Turkish romance series", note: "", status: "Pending", date: "May 27" }
    ],
    statuses: {
      "Added":     { color: "#22D3A6", note: "Now on the app" },
      "Reviewing": { color: "#2D8EFF", note: "Team is checking" },
      "Pending":   { color: "#F4C13B", note: "In the queue" }
    }
  };

  /* --------------------------------------------------- Profile screen ---- */
  const profile = {
    user: {
      name: "Amani Mushi", handle: "@amanimushi",
      avatarColor: ["#2D8EFF", "#19C3FB"], initials: "AM", memberSince: "May 2024"
    },
    subscription: {
      plan: "Premium", status: "Active", renews: "12 July 2026", price: "TZS 9,900 / month",
      perks: ["Unlimited downloads", "FHD 1080p quality", "No ads", "2 devices at once"]
    },
    stats: [
      { label: "Watched", value: "128" },
      { label: "Saved", value: "9" },
      { label: "Downloaded", value: "5" }
    ],
    settings: [
      { id: "notifications", label: "Notifications", icon: "bell", value: "On", type: "toggle", on: true },
      { id: "downloads-wifi", label: "Download on Wi-Fi only", icon: "wifi", value: "", type: "toggle", on: true },
      { id: "quality", label: "Video Quality", icon: "sliders", value: "Auto", type: "link" },
      { id: "language", label: "Language", icon: "globe", value: "English", type: "link" },
      { id: "about", label: "About Sinemax", icon: "info", value: "", type: "link" },
      { id: "help", label: "Help & Support", icon: "help", value: "", type: "link" },
      { id: "logout", label: "Log Out", icon: "logout", value: "", type: "danger" }
    ]
  };

  /* --------------------------------------------------- Brand / app ------- */
  const app = {
    name: "SINEMAX",
    tagline: "Translated Movies & Series",
    searchPlaceholder: "Search movies, series...",
    nav: [
      { id: "home",     label: "Home",     icon: "home" },
      { id: "discover", label: "Discover", icon: "compass" },
      { id: "requests", label: "Requests", icon: "inbox" },
      { id: "library",  label: "Library",  icon: "bookmark" },
      { id: "profile",  label: "Profile",  icon: "user" }
    ]
  };

  const index = Object.fromEntries(catalog.map(c => [c.id, c]));
  window.SinemaxData = {
    app, djs, countries, catalog, home, featured, discover, library, requests, profile,
    byId: (id) => index[id],
    djById: (id) => djs.find(d => d.id === id),
    where: (fn) => catalog.filter(fn)
  };
})();
