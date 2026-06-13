// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaHiveAdapter extends TypeAdapter<_Media> {
  @override
  final typeId = 2;

  @override
  _Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _Media(
      id: fields[0] as String,
      title: fields[1] as String,
      posterUrl: fields[2] as String?,
      description: fields[3] as String?,
      country: fields[4] as String?,
      year: (fields[5] as num?)?.toInt(),
      type: fields[6] == null ? 'movie' : fields[6] as String,
      genres: fields[7] == null ? const [] : (fields[7] as List).cast<String>(),
      tags: fields[8] == null ? const [] : (fields[8] as List).cast<String>(),
      dj: fields[9] as String?,
      viewCount: fields[10] == null ? 0 : (fields[10] as num).toInt(),
      downloadCount: fields[11] == null ? 0 : (fields[11] as num).toInt(),
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, _Media obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterUrl)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.genres)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.dj)
      ..writeByte(10)
      ..write(obj.viewCount)
      ..writeByte(11)
      ..write(obj.downloadCount)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaFileHiveAdapter extends TypeAdapter<_MediaFile> {
  @override
  final typeId = 3;

  @override
  _MediaFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _MediaFile(
      id: fields[0] as String,
      mediaId: fields[1] as String,
      season: (fields[2] as num?)?.toInt(),
      label: fields[3] as String?,
      downloadUrl: fields[4] as String?,
      episodeNumber: (fields[5] as num?)?.toInt(),
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      fileSize: (fields[8] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, _MediaFile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mediaId)
      ..writeByte(2)
      ..write(obj.season)
      ..writeByte(3)
      ..write(obj.label)
      ..writeByte(4)
      ..write(obj.downloadUrl)
      ..writeByte(5)
      ..write(obj.episodeNumber)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.fileSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaFileHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
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
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_MediaFile _$MediaFileFromJson(Map<String, dynamic> json) => _MediaFile(
  id: json['id'] as String,
  mediaId: json['media_id'] as String,
  season: (json['season'] as num?)?.toInt(),
  label: json['label'] as String?,
  downloadUrl: json['download_url'] as String?,
  episodeNumber: (json['episode_number'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  fileSize: (json['file_size'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaFileToJson(_MediaFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_id': instance.mediaId,
      'season': instance.season,
      'label': instance.label,
      'download_url': instance.downloadUrl,
      'episode_number': instance.episodeNumber,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'file_size': instance.fileSize,
    };
