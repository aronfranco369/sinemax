// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive_ce.dart';

part 'media.freezed.dart';
part 'media.g.dart';

String _titleCase(String s) => s.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

@freezed
abstract class Media with _$Media {
  const Media._();

  @HiveType(typeId: 2, adapterName: 'MediaHiveAdapter')
  const factory Media({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) @JsonKey(name: 'poster_url') String? posterUrl,
    @HiveField(3) String? description,
    @HiveField(4) String? country,
    @HiveField(5) int? year,
    @HiveField(6) @Default('movie') String type,
    @HiveField(7) @Default([]) List<String> genres,
    @HiveField(8) @Default([]) List<String> tags,
    @HiveField(9) String? dj,
    @HiveField(10) @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @HiveField(11) @JsonKey(name: 'download_count') @Default(0) int downloadCount,
    @HiveField(12) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(13) @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  bool get isSeries => type == 'series';
  String get djDisplay => dj != null ? 'DJ $dj' : '';
  String get genreDisplay => genres.join(' · ');
  String get countryDisplay => country != null ? _titleCase(country!) : '';
}

@freezed
abstract class MediaFile with _$MediaFile {
  const MediaFile._();

  @HiveType(typeId: 3, adapterName: 'MediaFileHiveAdapter')
  const factory MediaFile({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'media_id') required String mediaId,
    @HiveField(2) int? season,
    @HiveField(3) String? label,
    @HiveField(4) @JsonKey(name: 'download_url') String? downloadUrl,
    @HiveField(5) @JsonKey(name: 'episode_number') int? episodeNumber,
    @HiveField(6) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(7) @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @HiveField(8) @JsonKey(name: 'file_size') int? fileSize,
  }) = _MediaFile;

  factory MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);

  /// File size (stored in bytes) formatted as megabytes for display,
  /// e.g. `"720 MB"`. Empty string when the size is unknown or zero.
  String get sizeDisplay {
    final bytes = fileSize;
    if (bytes == null || bytes <= 0) return '';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(mb >= 100 ? 0 : 1)} MB';
  }
}

class HomeRow {
  final String id;
  final String title;
  final List<Media> items;
  const HomeRow({required this.id, required this.title, required this.items});
}
