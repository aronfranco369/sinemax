import 'package:flutter/material.dart';
import '../models/content.dart';
import '../models/episode.dart';
import '../models/dj.dart';
import '../models/library_item.dart';
import '../models/request.dart';

// ── DJs ──────────────────────────────────────────────────────────────────────

final List<Dj> allDjs = [
  Dj(id: 'dj-afande', name: 'DJ Afande', country: 'Tanzania', accent: Color(0xFF2D8EFF), titles: 3),
  Dj(id: 'dj-kibinda', name: 'DJ Kibinda', country: 'Tanzania', accent: Color(0xFF19C3FB), titles: 2),
  Dj(id: 'dj-mzee', name: 'DJ Mzee', country: 'Tanzania', accent: Color(0xFF7C5CFF), titles: 2),
  Dj(id: 'dj-salama', name: 'DJ Salama', country: 'Tanzania', accent: Color(0xFF22D3A6), titles: 2),
  Dj(id: 'dj-honest', name: 'DJ Honest', country: 'Kenya', accent: Color(0xFFFF8A3D), titles: 3),
  Dj(id: 'dj-pamoja', name: 'DJ Pamoja', country: 'Tanzania', accent: Color(0xFFFF5D7A), titles: 2),
  Dj(id: 'dj-rocky', name: 'DJ Rocky', country: 'Tanzania', accent: Color(0xFFF4C13B), titles: 3),
  Dj(id: 'dj-nash', name: 'DJ Nash', country: 'Kenya', accent: Color(0xFF2D8EFF), titles: 2),
  Dj(id: 'dj-tamaa', name: 'DJ Tamaa', country: 'Tanzania', accent: Color(0xFF19C3FB), titles: 2),
  Dj(id: 'dj-boss', name: 'DJ Boss', country: 'Tanzania', accent: Color(0xFF7C5CFF), titles: 3),
  Dj(id: 'dj-cartoon', name: 'DJ Cartoon', country: 'Tanzania', accent: Color(0xFF22D3A6), titles: 2),
  Dj(id: 'dj-malkia', name: 'DJ Malkia', country: 'Tanzania', accent: Color(0xFFFF5D7A), titles: 2),
];

// ── Episode builder ───────────────────────────────────────────────────────────

const _rt = ['42m', '45m', '48m', '51m', '44m', '47m'];

List<Episode> _eps(List<String> titles) => List.generate(
  titles.length,
  (i) => Episode(
    ep: i + 1,
    title: titles[i],
    duration: _rt[i % _rt.length],
    progress: i == 0
        ? 1.0
        : i == 1
        ? 0.42
        : 0.0,
  ),
);

// ── Catalog ───────────────────────────────────────────────────────────────────

final List<Content> catalog = [
  // ── Korean Series ────────────────────────────────────────────────────────
  Content(
    id: 'ks1',
    type: 'series',
    title: "Winter's Vow",
    year: 2024,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Romance · Drama',
    djId: 'dj-afande',
    rating: 4.8,
    votes: '12.4K',
    seasons: 1,
    totalEpisodes: 16,
    poster: PosterPalette(from: Color(0xFF13315C), to: Color(0xFF0A1A33), accent: Color(0xFF2D8EFF), glyph: '❄'),
    description:
        "When a young doctor returns to her hometown after years away, she comes face to face with the first love who once left her without a word. The winter snow uncovers secrets buried for far too long.",
    episodesList: _eps(['Coming Home', 'First Snow', 'The Lost Letter', 'Night of the Storm', 'Memories', 'An Old Promise', 'Family Secret', 'Winter Tears']),
  ),
  Content(
    id: 'ks2',
    type: 'series',
    title: 'Throne of Shadows',
    year: 2023,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Historical · Action',
    djId: 'dj-kibinda',
    rating: 4.9,
    votes: '20.1K',
    seasons: 2,
    totalEpisodes: 24,
    poster: PosterPalette(from: Color(0xFF3A1C4A), to: Color(0xFF140A1F), accent: Color(0xFF7C5CFF), glyph: '♛'),
    description: "In an ancient kingdom, a dethroned prince plots to reclaim his father's throne. Power struggles, betrayal and forbidden love collide in a gripping tale of ambition.",
    episodesList: _eps(["The King's Fall", 'Oath of Blood', 'Enemy Within', 'Night Battle', 'The New Queen', 'Palace Schemes', 'Vengeance', 'Crown of Gold']),
  ),
  Content(
    id: 'ks3',
    type: 'series',
    title: 'Soul Surgeon',
    year: 2025,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Drama · Medical',
    djId: 'dj-mzee',
    rating: 4.7,
    votes: '8.9K',
    seasons: 1,
    totalEpisodes: 12,
    poster: PosterPalette(from: Color(0xFF0C3B3C), to: Color(0xFF06201F), accent: Color(0xFF22D3A6), glyph: '✚'),
    description: "A brilliant heart surgeon faces the hardest case of his life while battling his own inner wounds. Every operation is a fight between life and death.",
    episodesList: _eps(['24 Hours', 'Broken Heart', 'Hard Choice', 'A Special Patient', 'Human Error', 'New Hope', 'Risky Operation', 'Healing']),
  ),
  Content(
    id: 'ks4',
    type: 'series',
    title: 'Endless Love',
    year: 2022,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Romance · Comedy',
    djId: 'dj-salama',
    rating: 4.6,
    votes: '15.7K',
    seasons: 1,
    totalEpisodes: 18,
    poster: PosterPalette(from: Color(0xFF5A1E3A), to: Color(0xFF250A18), accent: Color(0xFFFF5D7A), glyph: '♥'),
    description: "A sharp-tongued company director hires a new secretary who turns his life completely upside down. Laughter, quarrels and romance fill every corner of the office.",
    episodesList: _eps(['The Interview', 'Strict Boss', 'Day One', 'Secret Contract', 'Business Trip', 'Heartbeat', 'The Truth', 'The Wedding']),
  ),
  Content(
    id: 'ks5',
    type: 'series',
    title: 'Palace Secrets',
    year: 2024,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Mystery · Drama',
    djId: 'dj-afande',
    rating: 4.8,
    votes: '11.2K',
    seasons: 1,
    totalEpisodes: 14,
    poster: PosterPalette(from: Color(0xFF1C2E66), to: Color(0xFF0A1330), accent: Color(0xFF2D8EFF), glyph: '✦'),
    description: "A new servant in the royal palace uncovers a murder hidden for decades. The deeper she digs, the closer she comes to grave danger.",
    episodesList: _eps(['The Hidden Door', 'Shadow of Night', 'Evidence', 'The Suspect', 'Letter in Blood', 'Bitter Truth', 'The Trap', 'Justice']),
  ),
  Content(
    id: 'ks6',
    type: 'series',
    title: 'Path of Stars',
    year: 2025,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Romance · Music',
    djId: 'dj-pamoja',
    rating: 4.5,
    votes: '6.3K',
    seasons: 1,
    totalEpisodes: 16,
    poster: PosterPalette(from: Color(0xFF2A2466), to: Color(0xFF100C2E), accent: Color(0xFF7C5CFF), glyph: '✺'),
    description: "An ordinary girl who dreams of stardom meets a famous singer who has lost his way. Together they rediscover the true meaning of dreams and love.",
    episodesList: _eps(['Golden Voice', 'First Stage', 'The Contest', 'Song of the Heart', 'Defeat', 'Rising Again', 'The Grand Show', 'A New Star']),
  ),

  // ── Indian Series ────────────────────────────────────────────────────────
  Content(
    id: 'is1',
    type: 'series',
    title: 'Blood & Gold',
    year: 2023,
    country: 'India',
    countryFlag: '🇮🇳',
    countryLabel: 'India',
    genre: 'Family · Drama',
    djId: 'dj-honest',
    rating: 4.6,
    votes: '18.5K',
    seasons: 3,
    totalEpisodes: 60,
    poster: PosterPalette(from: Color(0xFF5C2A0C), to: Color(0xFF2A1206), accent: Color(0xFFFF8A3D), glyph: '❖'),
    description: "A wealthy merchant family is torn apart by an inheritance dispute. Two sisters fight for love, fortune and the family's honor.",
    episodesList: _eps(['The Inheritance', 'Two Sisters', 'Forced Marriage', "Father's Secret", 'Betrayal', "Mother's Tears", 'Reconciliation', 'Forgiveness']),
  ),
  Content(
    id: 'is2',
    type: 'series',
    title: 'The Reluctant Bride',
    year: 2024,
    country: 'India',
    countryFlag: '🇮🇳',
    countryLabel: 'India',
    genre: 'Romance · Family',
    djId: 'dj-malkia',
    rating: 4.7,
    votes: '22.9K',
    seasons: 2,
    totalEpisodes: 48,
    poster: PosterPalette(from: Color(0xFF5A1230), to: Color(0xFF260714), accent: Color(0xFFFF5D7A), glyph: '❀'),
    description: "A young woman forced to marry a stranger slowly discovers that an arranged marriage can be the start of true love.",
    episodesList: _eps(['The Wedding Ring', 'A Stranger Husband', 'New Family', 'Wall of Silence', 'First Smile', 'Jealousy', 'The Truth', 'Real Love']),
  ),
  Content(
    id: 'is3',
    type: 'series',
    title: 'Voice of the Heart',
    year: 2022,
    country: 'India',
    countryFlag: '🇮🇳',
    countryLabel: 'India',
    genre: 'Drama · Music',
    djId: 'dj-tamaa',
    rating: 4.5,
    votes: '9.8K',
    seasons: 1,
    totalEpisodes: 32,
    poster: PosterPalette(from: Color(0xFF42235C), to: Color(0xFF1B0E26), accent: Color(0xFF7C5CFF), glyph: '♪'),
    description: "A blind singer with a rare gift searches for a chance to show the world her talent. Her journey is full of obstacles, true friends and envious rivals.",
    episodesList: _eps(['Hidden Talent', 'First Stage', 'A True Friend', 'The Plot', 'Defeat', 'Faith', 'Victory', 'National Star']),
  ),
  Content(
    id: 'is4',
    type: 'series',
    title: 'The Wedding Ring',
    year: 2025,
    country: 'India',
    countryFlag: '🇮🇳',
    countryLabel: 'India',
    genre: 'Romance · Drama',
    djId: 'dj-honest',
    rating: 4.4,
    votes: '7.1K',
    seasons: 1,
    totalEpisodes: 40,
    poster: PosterPalette(from: Color(0xFF5C401C), to: Color(0xFF2A1D0A), accent: Color(0xFFF4C13B), glyph: '◈'),
    description: "On the wedding day the ring goes missing, and with it a great secret comes to light. Two families are caught in a web of love, intrigue and forgiveness.",
    episodesList: _eps(['Preparations', 'The Lost Ring', 'Accusations', 'An Old Secret', 'The Courtroom', 'The Truth', 'Reconciliation', 'A New Wedding']),
  ),

  // ── Turkish Series ───────────────────────────────────────────────────────
  Content(
    id: 'ts1',
    type: 'series',
    title: 'A Century of Love',
    year: 2024,
    country: 'Turkey',
    countryFlag: '🇹🇷',
    countryLabel: 'Turkey',
    genre: 'Romance · Historical',
    djId: 'dj-boss',
    rating: 4.8,
    votes: '25.6K',
    seasons: 2,
    totalEpisodes: 50,
    poster: PosterPalette(from: Color(0xFF3C0F1E), to: Color(0xFF1A060D), accent: Color(0xFFFF5D7A), glyph: '✦'),
    description: "In old Istanbul, love between people of different classes defies the rules of society. A story of passion, honor and freedom.",
    episodesList: _eps(['First Meeting', 'Forbidden', 'Sea of Secrets', 'Family', 'The Decision', 'The Escape', 'The Return', 'Freedom']),
  ),
  Content(
    id: 'ts2',
    type: 'series',
    title: 'The Secret Mountain',
    year: 2023,
    country: 'Turkey',
    countryFlag: '🇹🇷',
    countryLabel: 'Turkey',
    genre: 'Action · Drama',
    djId: 'dj-nash',
    rating: 4.6,
    votes: '13.4K',
    seasons: 1,
    totalEpisodes: 36,
    poster: PosterPalette(from: Color(0xFF1C3A2E), to: Color(0xFF0A1A14), accent: Color(0xFF22D3A6), glyph: '▲'),
    description: "A family living in the remote mountains guards a secret passed down for generations. When a stranger arrives, everything changes forever.",
    episodesList: _eps(['The Stranger', 'Mountain Laws', 'Family Secret', 'Danger', 'Betrayal', 'War', 'The Truth', 'Peace']),
  ),

  // ── Korean Movies ────────────────────────────────────────────────────────
  Content(
    id: 'km1',
    type: 'movie',
    title: 'Last Train',
    year: 2023,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Thriller · Action',
    djId: 'dj-kibinda',
    rating: 4.9,
    votes: '31.2K',
    duration: '1:58',
    poster: PosterPalette(from: Color(0xFF3A1010), to: Color(0xFF180606), accent: Color(0xFFFF5D7A), glyph: '⚠'),
    description: "The last night train becomes a deadly trap as an outbreak spreads among the passengers. It's a fight to survive until the final stop.",
  ),
  Content(
    id: 'km2',
    type: 'movie',
    title: 'Danger Island',
    year: 2024,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Action · Adventure',
    djId: 'dj-mzee',
    rating: 4.5,
    votes: '14.8K',
    duration: '2:12',
    poster: PosterPalette(from: Color(0xFF0C3B3C), to: Color(0xFF06201F), accent: Color(0xFF19C3FB), glyph: '≋'),
    description: "A group of tourists is stranded on a remote island where a terrifying secret awaits. Now they must fight to save their own lives.",
  ),
  Content(
    id: 'km3',
    type: 'movie',
    title: 'Guardian of the Dark',
    year: 2025,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Action · Mystery',
    djId: 'dj-afande',
    rating: 4.7,
    votes: '19.5K',
    duration: '2:04',
    poster: PosterPalette(from: Color(0xFF1C2E66), to: Color(0xFF0A1330), accent: Color(0xFF2D8EFF), glyph: '✦'),
    description: "A retired detective is pulled into one last case involving a powerful crime syndicate. A single night could change everything.",
  ),
  Content(
    id: 'km4',
    type: 'movie',
    title: 'The Final War',
    year: 2022,
    country: 'South Korea',
    countryFlag: '🇰🇷',
    countryLabel: 'Korea',
    genre: 'Action · War',
    djId: 'dj-rocky',
    rating: 4.6,
    votes: '16.0K',
    duration: '2:21',
    poster: PosterPalette(from: Color(0xFF3A2A0C), to: Color(0xFF1A1206), accent: Color(0xFFF4C13B), glyph: '⚔'),
    description: "A heroic soldier leads a small squad in a final battle to defend his nation. Loyalty and courage are tested to the very end.",
  ),

  // ── Indian Movies ────────────────────────────────────────────────────────
  Content(
    id: 'im1',
    type: 'movie',
    title: 'Heart of a Lion',
    year: 2024,
    country: 'India',
    countryFlag: '🇮🇳',
    countryLabel: 'India',
    genre: 'Action · Drama',
    djId: 'dj-honest',
    rating: 4.7,
    votes: '27.3K',
    duration: '2:34',
    poster: PosterPalette(from: Color(0xFF5C2A0C), to: Color(0xFF2A1206), accent: Color(0xFFFF8A3D), glyph: '♦'),
    description: "A village youth rises to become a hero of the people after standing up to the cruelty of the powerful. A story of courage and justice.",
  ),
  Content(
    id: 'im2',
    type: 'movie',
    title: 'Rain Dance',
    year: 2023,
    country: 'India',
    countryFlag: '🇮🇳',
    countryLabel: 'India',
    genre: 'Romance · Music',
    djId: 'dj-tamaa',
    rating: 4.4,
    votes: '11.9K',
    duration: '2:41',
    poster: PosterPalette(from: Color(0xFF42235C), to: Color(0xFF1B0E26), accent: Color(0xFF7C5CFF), glyph: '♫'),
    description: "A dancer and a musician from different worlds meet and fall in love. Music, color and romance fill every frame.",
  ),

  // ── Bongo Movies ─────────────────────────────────────────────────────────
  Content(
    id: 'bm1',
    type: 'movie',
    title: 'Street of Sorrow',
    year: 2025,
    country: 'Tanzania',
    countryFlag: '🇹🇿',
    countryLabel: 'Tanzania',
    genre: 'Drama · Bongo',
    djId: 'dj-pamoja',
    rating: 4.5,
    votes: '8.2K',
    duration: '1:47',
    poster: PosterPalette(from: Color(0xFF143B2A), to: Color(0xFF081A12), accent: Color(0xFF22D3A6), glyph: '✦'),
    description: "On a single street in Dar es Salaam, the dreams of young people collide with the harsh truth of life. A story of hope amid hardship.",
  ),
  Content(
    id: 'bm2',
    type: 'movie',
    title: 'Stepsister',
    year: 2024,
    country: 'Tanzania',
    countryFlag: '🇹🇿',
    countryLabel: 'Tanzania',
    genre: 'Family · Drama',
    djId: 'dj-malkia',
    rating: 4.6,
    votes: '12.7K',
    duration: '1:52',
    poster: PosterPalette(from: Color(0xFF3C1240), to: Color(0xFF18071A), accent: Color(0xFFFF5D7A), glyph: '❀'),
    description: "An orphaned girl lives under the cruelty of her stepmother. But fate has a surprising journey in store, leading her toward freedom and happiness.",
  ),
  Content(
    id: 'bm3',
    type: 'movie',
    title: 'City of Sin',
    year: 2023,
    country: 'Tanzania',
    countryFlag: '🇹🇿',
    countryLabel: 'Tanzania',
    genre: 'Action · Bongo',
    djId: 'dj-boss',
    rating: 4.4,
    votes: '9.6K',
    duration: '1:39',
    poster: PosterPalette(from: Color(0xFF3A1414), to: Color(0xFF180808), accent: Color(0xFFFF5D7A), glyph: '✖'),
    description: "A private investigator enters the dark underworld of city crime in search of the truth. Every corner hides a secret, and every secret has a price.",
  ),
  Content(
    id: 'bm4',
    type: 'movie',
    title: 'Golden Love',
    year: 2025,
    country: 'Tanzania',
    countryFlag: '🇹🇿',
    countryLabel: 'Tanzania',
    genre: 'Romance · Bongo',
    djId: 'dj-salama',
    rating: 4.7,
    votes: '15.3K',
    duration: '1:58',
    poster: PosterPalette(from: Color(0xFF3A2E0C), to: Color(0xFF181406), accent: Color(0xFFF4C13B), glyph: '♥'),
    description: "An up-and-coming musician falls for the daughter of a wealthy tycoon. The gap between their classes tests their love, but the heart knows no limits.",
  ),
  Content(
    id: 'bm5',
    type: 'movie',
    title: 'City Dreams',
    year: 2024,
    country: 'Tanzania',
    countryFlag: '🇹🇿',
    countryLabel: 'Tanzania',
    genre: 'Drama · Bongo',
    djId: 'dj-cartoon',
    rating: 4.3,
    votes: '6.8K',
    duration: '1:44',
    poster: PosterPalette(from: Color(0xFF142E4A), to: Color(0xFF08161F), accent: Color(0xFF2D8EFF), glyph: '✦'),
    description: "A young man moves from the village to the city in search of a better life. He faces deceit, false friendships and unexpected opportunities.",
  ),
  Content(
    id: 'bm6',
    type: 'movie',
    title: 'Bad Luck',
    year: 2023,
    country: 'Tanzania',
    countryFlag: '🇹🇿',
    countryLabel: 'Tanzania',
    genre: 'Comedy · Bongo',
    djId: 'dj-cartoon',
    rating: 4.5,
    votes: '10.1K',
    duration: '1:35',
    poster: PosterPalette(from: Color(0xFF3A2A0C), to: Color(0xFF181206), accent: Color(0xFFF4C13B), glyph: '☺'),
    description: "A man with impossibly bad luck stumbles into hilarious situations every single day. A top-notch comedy that will have you laughing to tears.",
  ),

  // ── Hollywood Movies ─────────────────────────────────────────────────────
  Content(
    id: 'hw1',
    type: 'movie',
    title: 'The Big Heist',
    year: 2024,
    country: 'United States',
    countryFlag: '🇺🇸',
    countryLabel: 'USA',
    genre: 'Action · Heist',
    djId: 'dj-rocky',
    rating: 4.8,
    votes: '42.5K',
    duration: '2:16',
    poster: PosterPalette(from: Color(0xFF1A2E5C), to: Color(0xFF0A1226), accent: Color(0xFF2D8EFF), glyph: '◆'),
    description: "A crew of master thieves plans the biggest heist in history. But not everyone on the team can be trusted — and time is running out.",
  ),
  Content(
    id: 'hw2',
    type: 'movie',
    title: 'Iron Squad',
    year: 2025,
    country: 'United States',
    countryFlag: '🇺🇸',
    countryLabel: 'USA',
    genre: 'Action · Sci-Fi',
    djId: 'dj-nash',
    rating: 4.7,
    votes: '38.9K',
    duration: '2:28',
    poster: PosterPalette(from: Color(0xFF16323A), to: Color(0xFF08171B), accent: Color(0xFF19C3FB), glyph: '⬡'),
    description: "An elite squad of heroes fights to save the world from an inhuman enemy. Pure action, explosions and cutting-edge technology.",
  ),
  Content(
    id: 'hw3',
    type: 'movie',
    title: 'Danger Hour',
    year: 2023,
    country: 'United States',
    countryFlag: '🇺🇸',
    countryLabel: 'USA',
    genre: 'Thriller · Action',
    djId: 'dj-rocky',
    rating: 4.5,
    votes: '21.7K',
    duration: '1:54',
    poster: PosterPalette(from: Color(0xFF3A1010), to: Color(0xFF180606), accent: Color(0xFFFF5D7A), glyph: '◷'),
    description: "A secret agent has just one hour to stop an attack that would shake the world. Every second counts in a race against time.",
  ),
  Content(
    id: 'hw4',
    type: 'movie',
    title: 'Enemy of the State',
    year: 2024,
    country: 'United States',
    countryFlag: '🇺🇸',
    countryLabel: 'USA',
    genre: 'Action · Political',
    djId: 'dj-boss',
    rating: 4.6,
    votes: '29.4K',
    duration: '2:09',
    poster: PosterPalette(from: Color(0xFF2A2A2E), to: Color(0xFF101012), accent: Color(0xFF19C3FB), glyph: '★'),
    description: "A former CIA officer is framed for treason and now the entire government is hunting him. He must prove his innocence before they reach him.",
  ),
];

// ── Lookup helpers ────────────────────────────────────────────────────────────

Content? contentById(String id) {
  try {
    return catalog.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

Dj? djById(String id) {
  try {
    return allDjs.firstWhere((d) => d.id == id);
  } catch (_) {
    return null;
  }
}

List<Content> contentWhere(bool Function(Content) fn) => catalog.where(fn).toList();

// ── Featured ──────────────────────────────────────────────────────────────────

const String featuredId = 'ks2';
const String featuredTagline = 'Most watched this week';
const String featuredBlurb = 'A struggle for the throne, betrayal and revenge — translated by DJ Kibinda.';

// ── Home rows ─────────────────────────────────────────────────────────────────

final List<HomeRow> homeRows = [
  HomeRow(id: 'row-trending', title: 'Trending Now', subtitle: 'Popular this week', itemIds: ['ks2', 'hw1', 'ts1', 'km1', 'is2', 'bm4', 'hw2']),
  HomeRow(id: 'row-kr-series', title: 'Korean Series', subtitle: 'From South Korea', itemIds: ['ks1', 'ks2', 'ks3', 'ks4', 'ks5', 'ks6']),
  HomeRow(id: 'row-in-series', title: 'Indian Series', subtitle: 'From India', itemIds: ['is1', 'is2', 'is3', 'is4']),
  HomeRow(id: 'row-kr-movies', title: 'Korean Movies', subtitle: 'From South Korea', itemIds: ['km1', 'km2', 'km3', 'km4']),
  HomeRow(id: 'row-bongo', title: 'Bongo Movies', subtitle: 'Tanzanian films', itemIds: ['bm1', 'bm2', 'bm3', 'bm4', 'bm5', 'bm6']),
  HomeRow(id: 'row-tr-series', title: 'Turkish Series', subtitle: 'From Turkey', itemIds: ['ts1', 'ts2']),
  HomeRow(id: 'row-hollywood', title: 'Hollywood Action', subtitle: 'Blockbusters', itemIds: ['hw1', 'hw2', 'hw3', 'hw4']),
  HomeRow(id: 'row-india-movies', title: 'Indian Movies', subtitle: 'From India', itemIds: ['im1', 'im2']),
];

// ── Discover filters ──────────────────────────────────────────────────────────

const List<String> filterYears = ['All', '2026', '2025', '2024', '2023', '2022', '2021', '2020'];
const List<String> filterCountries = ['All', 'Korea', 'India', 'Tanzania', 'USA', 'Turkey'];
const List<String> filterTypes = ['All', 'Series', 'Movie', 'Bongo'];

final List<String> filterDjs = ['All', ...allDjs.map((d) => d.name)];

const List<String> discoverGrid = [
  'ks2',
  'hw1',
  'is2',
  'km1',
  'bm4',
  'ts1',
  'ks1',
  'hw2',
  'is1',
  'km3',
  'bm2',
  'ks3',
  'hw4',
  'im1',
  'ts2',
  'bm1',
  'ks5',
  'is3',
  'km2',
  'bm3',
  'hw3',
  'ks4',
  'im2',
  'bm6',
  'ks6',
  'is4',
  'km4',
  'bm5',
];

// ── Library ───────────────────────────────────────────────────────────────────

final List<WatchedItem> recentlyWatched = [
  WatchedItem(contentId: 'ks2', watchedAt: 'Today, 20:14', progress: 0.62, context: 'S2 · Ep 4'),
  WatchedItem(contentId: 'hw1', watchedAt: 'Today, 18:30', progress: 0.18, context: 'Movie'),
  WatchedItem(contentId: 'is2', watchedAt: 'Yesterday, 21:45', progress: 0.91, context: 'S1 · Ep 12'),
  WatchedItem(contentId: 'bm4', watchedAt: 'Yesterday, 19:02', progress: 1.00, context: 'Completed'),
  WatchedItem(contentId: 'km1', watchedAt: '2 days ago, 22:10', progress: 0.45, context: 'Movie'),
  WatchedItem(contentId: 'ks1', watchedAt: 'Jun 2', progress: 0.30, context: 'S1 · Ep 3'),
];

const List<String> savedIds = ['ts1', 'ks5', 'hw2', 'is1', 'km3', 'bm2', 'ks3', 'im1', 'hw4'];

final List<DownloadItem> downloads = [
  DownloadItem(contentId: 'bm4', quality: 'HD 720p', size: '612 MB', at: 'Downloaded yesterday', context: 'Movie'),
  DownloadItem(contentId: 'km1', quality: 'FHD 1080p', size: '1.4 GB', at: 'Downloaded 2 days ago', context: 'Movie'),
  DownloadItem(contentId: 'ks2', quality: 'HD 720p', size: '428 MB', at: 'S2 · Ep 4', context: 'Episode'),
  DownloadItem(contentId: 'hw1', quality: 'FHD 1080p', size: '1.7 GB', at: 'Downloaded this week', context: 'Movie'),
  DownloadItem(contentId: 'is2', quality: 'SD 480p', size: '240 MB', at: 'S1 · Ep 11', context: 'Episode'),
];

const String storageUsed = '4.4 GB';
const String storageTotal = '16 GB';
const double storagePercent = 0.27;

// ── Requests ──────────────────────────────────────────────────────────────────

final List<ContentRequest> requestHistory = [
  ContentRequest(id: 'r1', title: "Korean series — 'City Hunter'", note: 'Season 1, DJ Afande please', status: RequestStatus.added, date: 'Jun 1'),
  ContentRequest(id: 'r2', title: 'New 2025 Indian movie', note: 'The action one with the famous star', status: RequestStatus.reviewing, date: 'May 30'),
  ContentRequest(id: 'r3', title: 'Turkish romance series', note: '', status: RequestStatus.pending, date: 'May 27'),
];

// ── Profile ───────────────────────────────────────────────────────────────────

const String profileName = 'Amani Mushi';
const String profileHandle = '@amanimushi';
const String profileInitials = 'AM';
const String profileMemberSince = 'May 2024';

const String subPlan = 'Premium';
const String subStatus = 'Active';
const String subRenews = '12 July 2026';
const String subPrice = 'TZS 9,900 / month';
const List<String> subPerks = ['Unlimited downloads', 'FHD 1080p quality', 'No ads', '2 devices at once'];

const int statWatched = 128;
const int statSaved = 9;
const int statDownloaded = 5;

// ── Video placeholder ─────────────────────────────────────────────────────────

const String sampleVideoUrl = 'https://www.w3schools.com/html/mov_bbb.mp4';
