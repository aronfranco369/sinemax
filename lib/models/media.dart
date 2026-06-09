import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

String _titleCase(String s) => s.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

@freezed
abstract class Media with _$Media {
  const Media._();

  const factory Media({
    required String id,
    required String title,
    @JsonKey(name: 'poster_url') String? posterUrl,
    String? description,
    String? country,
    int? year,
    @Default('movie') String type,
    @Default([]) List<String> genres,
    @Default([]) List<String> tags,
    String? dj,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'download_count') @Default(0) int downloadCount,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  bool get isSeries => type == 'series';
  String get djDisplay => dj != null ? 'DJ $dj' : '';
  String get genreDisplay => genres.join(' · ');
  String get countryDisplay => country != null ? _titleCase(country!) : '';
}

@freezed
abstract class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String id,
    @JsonKey(name: 'media_id') required String mediaId,
    int? season,
    String? label,
    @JsonKey(name: 'download_url') String? downloadUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'episode_number') int? episodeNumber,
  }) = _MediaFile;

  factory MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);
}

class HomeRow {
  final String id;
  final String title;
  final List<Media> items;
  const HomeRow({required this.id, required this.title, required this.items});
}
