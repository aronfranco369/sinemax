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

 String get id; String get title;@JsonKey(name: 'poster_url') String? get posterUrl; String? get description; String? get country; int? get year; String get type; List<String> get genres; List<String> get tags; String? get dj;@JsonKey(name: 'view_count') int get viewCount;@JsonKey(name: 'download_count') int get downloadCount;
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCopyWith<Media> get copyWith => _$MediaCopyWithImpl<Media>(this as Media, _$identity);

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Media&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.country, country) || other.country == country)&&(identical(other.year, year) || other.year == year)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.dj, dj) || other.dj == dj)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,posterUrl,description,country,year,type,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(tags),dj,viewCount,downloadCount);

@override
String toString() {
  return 'Media(id: $id, title: $title, posterUrl: $posterUrl, description: $description, country: $country, year: $year, type: $type, genres: $genres, tags: $tags, dj: $dj, viewCount: $viewCount, downloadCount: $downloadCount)';
}


}

/// @nodoc
abstract mixin class $MediaCopyWith<$Res>  {
  factory $MediaCopyWith(Media value, $Res Function(Media) _then) = _$MediaCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'poster_url') String? posterUrl, String? description, String? country, int? year, String type, List<String> genres, List<String> tags, String? dj,@JsonKey(name: 'view_count') int viewCount,@JsonKey(name: 'download_count') int downloadCount
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? posterUrl = freezed,Object? description = freezed,Object? country = freezed,Object? year = freezed,Object? type = null,Object? genres = null,Object? tags = null,Object? dj = freezed,Object? viewCount = null,Object? downloadCount = null,}) {
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
as int,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'poster_url')  String? posterUrl,  String? description,  String? country,  int? year,  String type,  List<String> genres,  List<String> tags,  String? dj, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'download_count')  int downloadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.title,_that.posterUrl,_that.description,_that.country,_that.year,_that.type,_that.genres,_that.tags,_that.dj,_that.viewCount,_that.downloadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'poster_url')  String? posterUrl,  String? description,  String? country,  int? year,  String type,  List<String> genres,  List<String> tags,  String? dj, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'download_count')  int downloadCount)  $default,) {final _that = this;
switch (_that) {
case _Media():
return $default(_that.id,_that.title,_that.posterUrl,_that.description,_that.country,_that.year,_that.type,_that.genres,_that.tags,_that.dj,_that.viewCount,_that.downloadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'poster_url')  String? posterUrl,  String? description,  String? country,  int? year,  String type,  List<String> genres,  List<String> tags,  String? dj, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'download_count')  int downloadCount)?  $default,) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.title,_that.posterUrl,_that.description,_that.country,_that.year,_that.type,_that.genres,_that.tags,_that.dj,_that.viewCount,_that.downloadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Media extends Media {
  const _Media({required this.id, required this.title, @JsonKey(name: 'poster_url') this.posterUrl, this.description, this.country, this.year, this.type = 'movie', final  List<String> genres = const [], final  List<String> tags = const [], this.dj, @JsonKey(name: 'view_count') this.viewCount = 0, @JsonKey(name: 'download_count') this.downloadCount = 0}): _genres = genres,_tags = tags,super._();
  factory _Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'poster_url') final  String? posterUrl;
@override final  String? description;
@override final  String? country;
@override final  int? year;
@override@JsonKey() final  String type;
 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? dj;
@override@JsonKey(name: 'view_count') final  int viewCount;
@override@JsonKey(name: 'download_count') final  int downloadCount;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Media&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.country, country) || other.country == country)&&(identical(other.year, year) || other.year == year)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.dj, dj) || other.dj == dj)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,posterUrl,description,country,year,type,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_tags),dj,viewCount,downloadCount);

@override
String toString() {
  return 'Media(id: $id, title: $title, posterUrl: $posterUrl, description: $description, country: $country, year: $year, type: $type, genres: $genres, tags: $tags, dj: $dj, viewCount: $viewCount, downloadCount: $downloadCount)';
}


}

/// @nodoc
abstract mixin class _$MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$MediaCopyWith(_Media value, $Res Function(_Media) _then) = __$MediaCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'poster_url') String? posterUrl, String? description, String? country, int? year, String type, List<String> genres, List<String> tags, String? dj,@JsonKey(name: 'view_count') int viewCount,@JsonKey(name: 'download_count') int downloadCount
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? posterUrl = freezed,Object? description = freezed,Object? country = freezed,Object? year = freezed,Object? type = null,Object? genres = null,Object? tags = null,Object? dj = freezed,Object? viewCount = null,Object? downloadCount = null,}) {
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
as int,
  ));
}


}


/// @nodoc
mixin _$MediaFile {

 String get id;@JsonKey(name: 'media_id') String get mediaId; int? get season; String? get label;@JsonKey(name: 'download_url') String? get downloadUrl;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'episode_number') int? get episodeNumber;
/// Create a copy of MediaFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaFileCopyWith<MediaFile> get copyWith => _$MediaFileCopyWithImpl<MediaFile>(this as MediaFile, _$identity);

  /// Serializes this MediaFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaFile&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.season, season) || other.season == season)&&(identical(other.label, label) || other.label == label)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaId,season,label,downloadUrl,createdAt,episodeNumber);

@override
String toString() {
  return 'MediaFile(id: $id, mediaId: $mediaId, season: $season, label: $label, downloadUrl: $downloadUrl, createdAt: $createdAt, episodeNumber: $episodeNumber)';
}


}

/// @nodoc
abstract mixin class $MediaFileCopyWith<$Res>  {
  factory $MediaFileCopyWith(MediaFile value, $Res Function(MediaFile) _then) = _$MediaFileCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'media_id') String mediaId, int? season, String? label,@JsonKey(name: 'download_url') String? downloadUrl,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'episode_number') int? episodeNumber
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaId = null,Object? season = freezed,Object? label = freezed,Object? downloadUrl = freezed,Object? createdAt = freezed,Object? episodeNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'media_id')  String mediaId,  int? season,  String? label, @JsonKey(name: 'download_url')  String? downloadUrl, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'episode_number')  int? episodeNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaFile() when $default != null:
return $default(_that.id,_that.mediaId,_that.season,_that.label,_that.downloadUrl,_that.createdAt,_that.episodeNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'media_id')  String mediaId,  int? season,  String? label, @JsonKey(name: 'download_url')  String? downloadUrl, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'episode_number')  int? episodeNumber)  $default,) {final _that = this;
switch (_that) {
case _MediaFile():
return $default(_that.id,_that.mediaId,_that.season,_that.label,_that.downloadUrl,_that.createdAt,_that.episodeNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'media_id')  String mediaId,  int? season,  String? label, @JsonKey(name: 'download_url')  String? downloadUrl, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'episode_number')  int? episodeNumber)?  $default,) {final _that = this;
switch (_that) {
case _MediaFile() when $default != null:
return $default(_that.id,_that.mediaId,_that.season,_that.label,_that.downloadUrl,_that.createdAt,_that.episodeNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaFile implements MediaFile {
  const _MediaFile({required this.id, @JsonKey(name: 'media_id') required this.mediaId, this.season, this.label, @JsonKey(name: 'download_url') this.downloadUrl, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'episode_number') this.episodeNumber});
  factory _MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);

@override final  String id;
@override@JsonKey(name: 'media_id') final  String mediaId;
@override final  int? season;
@override final  String? label;
@override@JsonKey(name: 'download_url') final  String? downloadUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'episode_number') final  int? episodeNumber;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaFile&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.season, season) || other.season == season)&&(identical(other.label, label) || other.label == label)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaId,season,label,downloadUrl,createdAt,episodeNumber);

@override
String toString() {
  return 'MediaFile(id: $id, mediaId: $mediaId, season: $season, label: $label, downloadUrl: $downloadUrl, createdAt: $createdAt, episodeNumber: $episodeNumber)';
}


}

/// @nodoc
abstract mixin class _$MediaFileCopyWith<$Res> implements $MediaFileCopyWith<$Res> {
  factory _$MediaFileCopyWith(_MediaFile value, $Res Function(_MediaFile) _then) = __$MediaFileCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'media_id') String mediaId, int? season, String? label,@JsonKey(name: 'download_url') String? downloadUrl,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'episode_number') int? episodeNumber
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaId = null,Object? season = freezed,Object? label = freezed,Object? downloadUrl = freezed,Object? createdAt = freezed,Object? episodeNumber = freezed,}) {
  return _then(_MediaFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
