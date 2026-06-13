// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchedItemAdapter extends TypeAdapter<WatchedItem> {
  @override
  final typeId = 0;

  @override
  WatchedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchedItem(
      contentId: fields[0] as String,
      watchedAt: fields[1] as String,
      progress: fields[2] == null ? 0.0 : (fields[2] as num).toDouble(),
      context: fields[3] == null ? '' : fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WatchedItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.contentId)
      ..writeByte(1)
      ..write(obj.watchedAt)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.context);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadRecordAdapter extends TypeAdapter<DownloadRecord> {
  @override
  final typeId = 4;

  @override
  DownloadRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadRecord(
      fileId: fields[0] as String,
      mediaId: fields[1] as String,
      label: fields[2] as String,
      title: fields[3] as String,
      url: fields[4] as String,
      status: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      progress: fields[6] == null ? 0.0 : (fields[6] as num).toDouble(),
      totalBytes: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      at: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.fileId)
      ..writeByte(1)
      ..write(obj.mediaId)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.progress)
      ..writeByte(7)
      ..write(obj.totalBytes)
      ..writeByte(8)
      ..write(obj.at);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
