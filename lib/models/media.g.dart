// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Media _$MediaFromJson(Map<String, dynamic> json) => _Media(
  id: json['id'] as String,
  title: json['title'] as String,
  posterUrl: json['poster_url'] as String?,
  description: json['description'] as String?,
  country: json['country'] as String?,
  year: (json['year'] as num?)?.toInt(),
  type: json['type'] as String? ?? 'movie',
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  dj: json['dj'] as String?,
  viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
  downloadCount: (json['download_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MediaToJson(_Media instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'poster_url': instance.posterUrl,
  'description': instance.description,
  'country': instance.country,
  'year': instance.year,
  'type': instance.type,
  'genres': instance.genres,
  'tags': instance.tags,
  'dj': instance.dj,
  'view_count': instance.viewCount,
  'download_count': instance.downloadCount,
};

_MediaFile _$MediaFileFromJson(Map<String, dynamic> json) => _MediaFile(
  id: json['id'] as String,
  mediaId: json['media_id'] as String,
  season: (json['season'] as num?)?.toInt(),
  label: json['label'] as String?,
  downloadUrl: json['download_url'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  episodeNumber: (json['episode_number'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaFileToJson(_MediaFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_id': instance.mediaId,
      'season': instance.season,
      'label': instance.label,
      'download_url': instance.downloadUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'episode_number': instance.episodeNumber,
    };
