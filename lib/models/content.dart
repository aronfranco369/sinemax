import 'package:flutter/material.dart';
import 'episode.dart';

class PosterPalette {
  final Color from;
  final Color to;
  final Color accent;
  final String glyph;

  const PosterPalette({
    required this.from,
    required this.to,
    required this.accent,
    required this.glyph,
  });
}

class Content {
  final String id;
  final String type; // 'movie' or 'series'
  final String title;
  final int year;
  final String country;
  final String countryFlag;
  final String countryLabel;
  final String genre;
  final String djId;
  final double rating;
  final String votes;
  final int? seasons;
  final int? totalEpisodes;
  final String? duration; // movies only
  final PosterPalette poster;
  final String description;
  final List<Episode> episodesList;

  const Content({
    required this.id,
    required this.type,
    required this.title,
    required this.year,
    required this.country,
    required this.countryFlag,
    required this.countryLabel,
    required this.genre,
    required this.djId,
    required this.rating,
    required this.votes,
    this.seasons,
    this.totalEpisodes,
    this.duration,
    required this.poster,
    required this.description,
    this.episodesList = const [],
  });

  bool get isSeries => type == 'series';
}

class HomeRow {
  final String id;
  final String title;
  final String subtitle;
  final List<String> itemIds;

  const HomeRow({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.itemIds,
  });
}
