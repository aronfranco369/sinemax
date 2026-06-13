// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Media {

@HiveField(0) String get id;@HiveField(1) String get title;@HiveField(2)@JsonKey(name: 'poster_url') String? get posterUrl;@HiveField(3) String? get description;@HiveField(4) String? get country;@HiveField(5) int? get year;@HiveField(6) String get type;@HiveField(7) List<String> get genres;@HiveField(8) List<String> get tags;@HiveField(9) String? get dj;@HiveField(10)@JsonKey(name: 'view_count') int get viewCount;@HiveField(11)@JsonKey(name: 'download_count') int get downloadCount;@HiveField(12)@JsonKey(name: 'created_at') DateTime? get createdAt;@HiveField(13)@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCopyWith<Media> get copyWith => _$MediaCopyWithImpl<Media>(this as Media, _$identity);

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Media&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.country, country) || other.country == country)&&(identical(other.year, year) || other.year == year)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.dj, dj) || other.dj == dj)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,posterUrl,description,country,year,type,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(tags),dj,viewCount,downloadCount,createdAt,updatedAt);

@override
String toString() {
  return 'Media(id: $id, title: $title, posterUrl: $posterUrl, description: $description, country: $country, year: $year, type: $type, genres: $genres, tags: $tags, dj: $dj, viewCount: $viewCount, downloadCount: $downloadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MediaCopyWith<$Res>  {
  factory $MediaCopyWith(Media value, $Res Function(Media) _then) = _$MediaCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'poster_url') String? posterUrl,@HiveField(3) String? description,@HiveField(4) String? country,@HiveField(5) int? year,@HiveField(6) String type,@HiveField(7) List<String> genres,@HiveField(8) List<String> tags,@HiveField(9) String? dj,@HiveField(10)@JsonKey(name: 'view_count') int viewCount,@HiveField(11)@JsonKey(name: 'download_count') int downloadCount,@HiveField(12)@JsonKey(name: 'created_at') DateTime? createdAt,@HiveField(13)@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$MediaCopyWithImpl<$Res>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._self, this._then);

  final Media _self;
  final $Res Function(Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? posterUrl = freezed,Object? description = freezed,Object? country = freezed,Object? year = freezed,Object? type = null,Object? genres = null,Object? tags = null,Object? dj = freezed,Object? viewCount = null,Object? downloadCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,dj: freezed == dj ? _self.dj : dj // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Media].
extension MediaPatterns on Media {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Media value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Media value)  $default,){
final _that = this;
switch (_that) {
case _Media():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Media value)?  $default,){
final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'poster_url')  String? posterUrl, @HiveField(3)  String? description, @HiveField(4)  String? country, @HiveField(5)  int? year, @HiveField(6)  String type, @HiveField(7)  List<String> genres, @HiveField(8)  List<String> tags, @HiveField(9)  String? dj, @HiveField(10)@JsonKey(name: 'view_count')  int viewCount, @HiveField(11)@JsonKey(name: 'download_count')  int downloadCount, @HiveField(12)@JsonKey(name: 'created_at')  DateTime? createdAt, @HiveField(13)@JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.title,_that.posterUrl,_that.description,_that.country,_that.year,_that.type,_that.genres,_that.tags,_that.dj,_that.viewCount,_that.downloadCount,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'poster_url')  String? posterUrl, @HiveField(3)  String? description, @HiveField(4)  String? country, @HiveField(5)  int? year, @HiveField(6)  String type, @HiveField(7)  List<String> genres, @HiveField(8)  List<String> tags, @HiveField(9)  String? dj, @HiveField(10)@JsonKey(name: 'view_count')  int viewCount, @HiveField(11)@JsonKey(name: 'download_count')  int downloadCount, @HiveField(12)@JsonKey(name: 'created_at')  DateTime? createdAt, @HiveField(13)@JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Media():
return $default(_that.id,_that.title,_that.posterUrl,_that.description,_that.country,_that.year,_that.type,_that.genres,_that.tags,_that.dj,_that.viewCount,_that.downloadCount,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'poster_url')  String? posterUrl, @HiveField(3)  String? description, @HiveField(4)  String? country, @HiveField(5)  int? year, @HiveField(6)  String type, @HiveField(7)  List<String> genres, @HiveField(8)  List<String> tags, @HiveField(9)  String? dj, @HiveField(10)@JsonKey(name: 'view_count')  int viewCount, @HiveField(11)@JsonKey(name: 'download_count')  int downloadCount, @HiveField(12)@JsonKey(name: 'created_at')  DateTime? createdAt, @HiveField(13)@JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.title,_that.posterUrl,_that.description,_that.country,_that.year,_that.type,_that.genres,_that.tags,_that.dj,_that.viewCount,_that.downloadCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 2, adapterName: 'MediaHiveAdapter')
class _Media extends Media {
  const _Media({@HiveField(0) required this.id, @HiveField(1) required this.title, @HiveField(2)@JsonKey(name: 'poster_url') this.posterUrl, @HiveField(3) this.description, @HiveField(4) this.country, @HiveField(5) this.year, @HiveField(6) this.type = 'movie', @HiveField(7) final  List<String> genres = const [], @HiveField(8) final  List<String> tags = const [], @HiveField(9) this.dj, @HiveField(10)@JsonKey(name: 'view_count') this.viewCount = 0, @HiveField(11)@JsonKey(name: 'download_count') this.downloadCount = 0, @HiveField(12)@JsonKey(name: 'created_at') this.createdAt, @HiveField(13)@JsonKey(name: 'updated_at') this.updatedAt}): _genres = genres,_tags = tags,super._();
  factory _Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String title;
@override@HiveField(2)@JsonKey(name: 'poster_url') final  String? posterUrl;
@override@HiveField(3) final  String? description;
@override@HiveField(4) final  String? country;
@override@HiveField(5) final  int? year;
@override@JsonKey()@HiveField(6) final  String type;
 final  List<String> _genres;
@override@JsonKey()@HiveField(7) List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<String> _tags;
@override@JsonKey()@HiveField(8) List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@HiveField(9) final  String? dj;
@override@HiveField(10)@JsonKey(name: 'view_count') final  int viewCount;
@override@HiveField(11)@JsonKey(name: 'download_count') final  int downloadCount;
@override@HiveField(12)@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@HiveField(13)@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaCopyWith<_Media> get copyWith => __$MediaCopyWithImpl<_Media>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Media&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.country, country) || other.country == country)&&(identical(other.year, year) || other.year == year)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.dj, dj) || other.dj == dj)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,posterUrl,description,country,year,type,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_tags),dj,viewCount,downloadCount,createdAt,updatedAt);

@override
String toString() {
  return 'Media(id: $id, title: $title, posterUrl: $posterUrl, description: $description, country: $country, year: $year, type: $type, genres: $genres, tags: $tags, dj: $dj, viewCount: $viewCount, downloadCount: $downloadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$MediaCopyWith(_Media value, $Res Function(_Media) _then) = __$MediaCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'poster_url') String? posterUrl,@HiveField(3) String? description,@HiveField(4) String? country,@HiveField(5) int? year,@HiveField(6) String type,@HiveField(7) List<String> genres,@HiveField(8) List<String> tags,@HiveField(9) String? dj,@HiveField(10)@JsonKey(name: 'view_count') int viewCount,@HiveField(11)@JsonKey(name: 'download_count') int downloadCount,@HiveField(12)@JsonKey(name: 'created_at') DateTime? createdAt,@HiveField(13)@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$MediaCopyWithImpl<$Res>
    implements _$MediaCopyWith<$Res> {
  __$MediaCopyWithImpl(this._self, this._then);

  final _Media _self;
  final $Res Function(_Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? posterUrl = freezed,Object? description = freezed,Object? country = freezed,Object? year = freezed,Object? type = null,Object? genres = null,Object? tags = null,Object? dj = freezed,Object? viewCount = null,Object? downloadCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Media(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,dj: freezed == dj ? _self.dj : dj // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MediaFile {

@HiveField(0) String get id;@HiveField(1)@JsonKey(name: 'media_id') String get mediaId;@HiveField(2) int? get season;@HiveField(3) String? get label;@HiveField(4)@JsonKey(name: 'download_url') String? get downloadUrl;@HiveField(5)@JsonKey(name: 'episode_number') int? get episodeNumber;@HiveField(6)@JsonKey(name: 'created_at') DateTime? get createdAt;@HiveField(7)@JsonKey(name: 'updated_at') DateTime? get updatedAt;@HiveField(8)@JsonKey(name: 'file_size') int? get fileSize;
/// Create a copy of MediaFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaFileCopyWith<MediaFile> get copyWith => _$MediaFileCopyWithImpl<MediaFile>(this as MediaFile, _$identity);

  /// Serializes this MediaFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaFile&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.season, season) || other.season == season)&&(identical(other.label, label) || other.label == label)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaId,season,label,downloadUrl,episodeNumber,createdAt,updatedAt,fileSize);

@override
String toString() {
  return 'MediaFile(id: $id, mediaId: $mediaId, season: $season, label: $label, downloadUrl: $downloadUrl, episodeNumber: $episodeNumber, createdAt: $createdAt, updatedAt: $updatedAt, fileSize: $fileSize)';
}


}

/// @nodoc
abstract mixin class $MediaFileCopyWith<$Res>  {
  factory $MediaFileCopyWith(MediaFile value, $Res Function(MediaFile) _then) = _$MediaFileCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1)@JsonKey(name: 'media_id') String mediaId,@HiveField(2) int? season,@HiveField(3) String? label,@HiveField(4)@JsonKey(name: 'download_url') String? downloadUrl,@HiveField(5)@JsonKey(name: 'episode_number') int? episodeNumber,@HiveField(6)@JsonKey(name: 'created_at') DateTime? createdAt,@HiveField(7)@JsonKey(name: 'updated_at') DateTime? updatedAt,@HiveField(8)@JsonKey(name: 'file_size') int? fileSize
});




}
/// @nodoc
class _$MediaFileCopyWithImpl<$Res>
    implements $MediaFileCopyWith<$Res> {
  _$MediaFileCopyWithImpl(this._self, this._then);

  final MediaFile _self;
  final $Res Function(MediaFile) _then;

/// Create a copy of MediaFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaId = null,Object? season = freezed,Object? label = freezed,Object? downloadUrl = freezed,Object? episodeNumber = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? fileSize = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaFile].
extension MediaFilePatterns on MediaFile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaFile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaFile value)  $default,){
final _that = this;
switch (_that) {
case _MediaFile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaFile value)?  $default,){
final _that = this;
switch (_that) {
case _MediaFile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)@JsonKey(name: 'media_id')  String mediaId, @HiveField(2)  int? season, @HiveField(3)  String? label, @HiveField(4)@JsonKey(name: 'download_url')  String? downloadUrl, @HiveField(5)@JsonKey(name: 'episode_number')  int? episodeNumber, @HiveField(6)@JsonKey(name: 'created_at')  DateTime? createdAt, @HiveField(7)@JsonKey(name: 'updated_at')  DateTime? updatedAt, @HiveField(8)@JsonKey(name: 'file_size')  int? fileSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaFile() when $default != null:
return $default(_that.id,_that.mediaId,_that.season,_that.label,_that.downloadUrl,_that.episodeNumber,_that.createdAt,_that.updatedAt,_that.fileSize);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)@JsonKey(name: 'media_id')  String mediaId, @HiveField(2)  int? season, @HiveField(3)  String? label, @HiveField(4)@JsonKey(name: 'download_url')  String? downloadUrl, @HiveField(5)@JsonKey(name: 'episode_number')  int? episodeNumber, @HiveField(6)@JsonKey(name: 'created_at')  DateTime? createdAt, @HiveField(7)@JsonKey(name: 'updated_at')  DateTime? updatedAt, @HiveField(8)@JsonKey(name: 'file_size')  int? fileSize)  $default,) {final _that = this;
switch (_that) {
case _MediaFile():
return $default(_that.id,_that.mediaId,_that.season,_that.label,_that.downloadUrl,_that.episodeNumber,_that.createdAt,_that.updatedAt,_that.fileSize);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)@JsonKey(name: 'media_id')  String mediaId, @HiveField(2)  int? season, @HiveField(3)  String? label, @HiveField(4)@JsonKey(name: 'download_url')  String? downloadUrl, @HiveField(5)@JsonKey(name: 'episode_number')  int? episodeNumber, @HiveField(6)@JsonKey(name: 'created_at')  DateTime? createdAt, @HiveField(7)@JsonKey(name: 'updated_at')  DateTime? updatedAt, @HiveField(8)@JsonKey(name: 'file_size')  int? fileSize)?  $default,) {final _that = this;
switch (_that) {
case _MediaFile() when $default != null:
return $default(_that.id,_that.mediaId,_that.season,_that.label,_that.downloadUrl,_that.episodeNumber,_that.createdAt,_that.updatedAt,_that.fileSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 3, adapterName: 'MediaFileHiveAdapter')
class _MediaFile extends MediaFile {
  const _MediaFile({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'media_id') required this.mediaId, @HiveField(2) this.season, @HiveField(3) this.label, @HiveField(4)@JsonKey(name: 'download_url') this.downloadUrl, @HiveField(5)@JsonKey(name: 'episode_number') this.episodeNumber, @HiveField(6)@JsonKey(name: 'created_at') this.createdAt, @HiveField(7)@JsonKey(name: 'updated_at') this.updatedAt, @HiveField(8)@JsonKey(name: 'file_size') this.fileSize}): super._();
  factory _MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1)@JsonKey(name: 'media_id') final  String mediaId;
@override@HiveField(2) final  int? season;
@override@HiveField(3) final  String? label;
@override@HiveField(4)@JsonKey(name: 'download_url') final  String? downloadUrl;
@override@HiveField(5)@JsonKey(name: 'episode_number') final  int? episodeNumber;
@override@HiveField(6)@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@HiveField(7)@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@HiveField(8)@JsonKey(name: 'file_size') final  int? fileSize;

/// Create a copy of MediaFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaFileCopyWith<_MediaFile> get copyWith => __$MediaFileCopyWithImpl<_MediaFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaFile&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.season, season) || other.season == season)&&(identical(other.label, label) || other.label == label)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaId,season,label,downloadUrl,episodeNumber,createdAt,updatedAt,fileSize);

@override
String toString() {
  return 'MediaFile(id: $id, mediaId: $mediaId, season: $season, label: $label, downloadUrl: $downloadUrl, episodeNumber: $episodeNumber, createdAt: $createdAt, updatedAt: $updatedAt, fileSize: $fileSize)';
}


}

/// @nodoc
abstract mixin class _$MediaFileCopyWith<$Res> implements $MediaFileCopyWith<$Res> {
  factory _$MediaFileCopyWith(_MediaFile value, $Res Function(_MediaFile) _then) = __$MediaFileCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1)@JsonKey(name: 'media_id') String mediaId,@HiveField(2) int? season,@HiveField(3) String? label,@HiveField(4)@JsonKey(name: 'download_url') String? downloadUrl,@HiveField(5)@JsonKey(name: 'episode_number') int? episodeNumber,@HiveField(6)@JsonKey(name: 'created_at') DateTime? createdAt,@HiveField(7)@JsonKey(name: 'updated_at') DateTime? updatedAt,@HiveField(8)@JsonKey(name: 'file_size') int? fileSize
});




}
/// @nodoc
class __$MediaFileCopyWithImpl<$Res>
    implements _$MediaFileCopyWith<$Res> {
  __$MediaFileCopyWithImpl(this._self, this._then);

  final _MediaFile _self;
  final $Res Function(_MediaFile) _then;

/// Create a copy of MediaFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaId = null,Object? season = freezed,Object? label = freezed,Object? downloadUrl = freezed,Object? episodeNumber = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? fileSize = freezed,}) {
  return _then(_MediaFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
