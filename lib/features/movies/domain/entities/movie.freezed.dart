// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Genre {

 String get id; String get name;
/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreCopyWith<Genre> get copyWith => _$GenreCopyWithImpl<Genre>(this as Genre, _$identity);

  /// Serializes this Genre to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Genre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Genre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $GenreCopyWith<$Res>  {
  factory $GenreCopyWith(Genre value, $Res Function(Genre) _then) = _$GenreCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$GenreCopyWithImpl<$Res>
    implements $GenreCopyWith<$Res> {
  _$GenreCopyWithImpl(this._self, this._then);

  final Genre _self;
  final $Res Function(Genre) _then;

/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Genre].
extension GenrePatterns on Genre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Genre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Genre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Genre value)  $default,){
final _that = this;
switch (_that) {
case _Genre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Genre value)?  $default,){
final _that = this;
switch (_that) {
case _Genre() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Genre() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _Genre():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _Genre() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Genre implements Genre {
  const _Genre({required this.id, required this.name});
  factory _Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreCopyWith<_Genre> get copyWith => __$GenreCopyWithImpl<_Genre>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Genre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Genre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$GenreCopyWith<$Res> implements $GenreCopyWith<$Res> {
  factory _$GenreCopyWith(_Genre value, $Res Function(_Genre) _then) = __$GenreCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$GenreCopyWithImpl<$Res>
    implements _$GenreCopyWith<$Res> {
  __$GenreCopyWithImpl(this._self, this._then);

  final _Genre _self;
  final $Res Function(_Genre) _then;

/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_Genre(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MediaAsset {

 String? get url; String? get publicId;
/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<MediaAsset> get copyWith => _$MediaAssetCopyWithImpl<MediaAsset>(this as MediaAsset, _$identity);

  /// Serializes this MediaAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAsset&&(identical(other.url, url) || other.url == url)&&(identical(other.publicId, publicId) || other.publicId == publicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,publicId);

@override
String toString() {
  return 'MediaAsset(url: $url, publicId: $publicId)';
}


}

/// @nodoc
abstract mixin class $MediaAssetCopyWith<$Res>  {
  factory $MediaAssetCopyWith(MediaAsset value, $Res Function(MediaAsset) _then) = _$MediaAssetCopyWithImpl;
@useResult
$Res call({
 String? url, String? publicId
});




}
/// @nodoc
class _$MediaAssetCopyWithImpl<$Res>
    implements $MediaAssetCopyWith<$Res> {
  _$MediaAssetCopyWithImpl(this._self, this._then);

  final MediaAsset _self;
  final $Res Function(MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? publicId = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAsset].
extension MediaAssetPatterns on MediaAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaAsset value)  $default,){
final _that = this;
switch (_that) {
case _MediaAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaAsset value)?  $default,){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? url,  String? publicId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.url,_that.publicId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? url,  String? publicId)  $default,) {final _that = this;
switch (_that) {
case _MediaAsset():
return $default(_that.url,_that.publicId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? url,  String? publicId)?  $default,) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.url,_that.publicId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaAsset implements MediaAsset {
  const _MediaAsset({this.url, this.publicId});
  factory _MediaAsset.fromJson(Map<String, dynamic> json) => _$MediaAssetFromJson(json);

@override final  String? url;
@override final  String? publicId;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaAssetCopyWith<_MediaAsset> get copyWith => __$MediaAssetCopyWithImpl<_MediaAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaAsset&&(identical(other.url, url) || other.url == url)&&(identical(other.publicId, publicId) || other.publicId == publicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,publicId);

@override
String toString() {
  return 'MediaAsset(url: $url, publicId: $publicId)';
}


}

/// @nodoc
abstract mixin class _$MediaAssetCopyWith<$Res> implements $MediaAssetCopyWith<$Res> {
  factory _$MediaAssetCopyWith(_MediaAsset value, $Res Function(_MediaAsset) _then) = __$MediaAssetCopyWithImpl;
@override @useResult
$Res call({
 String? url, String? publicId
});




}
/// @nodoc
class __$MediaAssetCopyWithImpl<$Res>
    implements _$MediaAssetCopyWith<$Res> {
  __$MediaAssetCopyWithImpl(this._self, this._then);

  final _MediaAsset _self;
  final $Res Function(_MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? publicId = freezed,}) {
  return _then(_MediaAsset(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Movie {

 String get id; String get title;@GenreListConverter() List<Genre> get genres; String get description; String get author; MediaAsset? get image; MediaAsset? get trailer; String get type; int get duration; String get origin; DateTime? get releaseDate; DateTime? get endDate; String get ageRating; List<String> get actors; int get totalBookings; double get ratingAverage;
/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieCopyWith<Movie> get copyWith => _$MovieCopyWithImpl<Movie>(this as Movie, _$identity);

  /// Serializes this Movie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Movie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&(identical(other.image, image) || other.image == image)&&(identical(other.trailer, trailer) || other.trailer == trailer)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.ageRating, ageRating) || other.ageRating == ageRating)&&const DeepCollectionEquality().equals(other.actors, actors)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(genres),description,author,image,trailer,type,duration,origin,releaseDate,endDate,ageRating,const DeepCollectionEquality().hash(actors),totalBookings,ratingAverage);

@override
String toString() {
  return 'Movie(id: $id, title: $title, genres: $genres, description: $description, author: $author, image: $image, trailer: $trailer, type: $type, duration: $duration, origin: $origin, releaseDate: $releaseDate, endDate: $endDate, ageRating: $ageRating, actors: $actors, totalBookings: $totalBookings, ratingAverage: $ratingAverage)';
}


}

/// @nodoc
abstract mixin class $MovieCopyWith<$Res>  {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) _then) = _$MovieCopyWithImpl;
@useResult
$Res call({
 String id, String title,@GenreListConverter() List<Genre> genres, String description, String author, MediaAsset? image, MediaAsset? trailer, String type, int duration, String origin, DateTime? releaseDate, DateTime? endDate, String ageRating, List<String> actors, int totalBookings, double ratingAverage
});


$MediaAssetCopyWith<$Res>? get image;$MediaAssetCopyWith<$Res>? get trailer;

}
/// @nodoc
class _$MovieCopyWithImpl<$Res>
    implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._self, this._then);

  final Movie _self;
  final $Res Function(Movie) _then;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? genres = null,Object? description = null,Object? author = null,Object? image = freezed,Object? trailer = freezed,Object? type = null,Object? duration = null,Object? origin = null,Object? releaseDate = freezed,Object? endDate = freezed,Object? ageRating = null,Object? actors = null,Object? totalBookings = null,Object? ratingAverage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as MediaAsset?,trailer: freezed == trailer ? _self.trailer : trailer // ignore: cast_nullable_to_non_nullable
as MediaAsset?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,ageRating: null == ageRating ? _self.ageRating : ageRating // ignore: cast_nullable_to_non_nullable
as String,actors: null == actors ? _self.actors : actors // ignore: cast_nullable_to_non_nullable
as List<String>,totalBookings: null == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $MediaAssetCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<$Res>? get trailer {
    if (_self.trailer == null) {
    return null;
  }

  return $MediaAssetCopyWith<$Res>(_self.trailer!, (value) {
    return _then(_self.copyWith(trailer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Movie].
extension MoviePatterns on Movie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Movie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Movie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Movie value)  $default,){
final _that = this;
switch (_that) {
case _Movie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Movie value)?  $default,){
final _that = this;
switch (_that) {
case _Movie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @GenreListConverter()  List<Genre> genres,  String description,  String author,  MediaAsset? image,  MediaAsset? trailer,  String type,  int duration,  String origin,  DateTime? releaseDate,  DateTime? endDate,  String ageRating,  List<String> actors,  int totalBookings,  double ratingAverage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Movie() when $default != null:
return $default(_that.id,_that.title,_that.genres,_that.description,_that.author,_that.image,_that.trailer,_that.type,_that.duration,_that.origin,_that.releaseDate,_that.endDate,_that.ageRating,_that.actors,_that.totalBookings,_that.ratingAverage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @GenreListConverter()  List<Genre> genres,  String description,  String author,  MediaAsset? image,  MediaAsset? trailer,  String type,  int duration,  String origin,  DateTime? releaseDate,  DateTime? endDate,  String ageRating,  List<String> actors,  int totalBookings,  double ratingAverage)  $default,) {final _that = this;
switch (_that) {
case _Movie():
return $default(_that.id,_that.title,_that.genres,_that.description,_that.author,_that.image,_that.trailer,_that.type,_that.duration,_that.origin,_that.releaseDate,_that.endDate,_that.ageRating,_that.actors,_that.totalBookings,_that.ratingAverage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @GenreListConverter()  List<Genre> genres,  String description,  String author,  MediaAsset? image,  MediaAsset? trailer,  String type,  int duration,  String origin,  DateTime? releaseDate,  DateTime? endDate,  String ageRating,  List<String> actors,  int totalBookings,  double ratingAverage)?  $default,) {final _that = this;
switch (_that) {
case _Movie() when $default != null:
return $default(_that.id,_that.title,_that.genres,_that.description,_that.author,_that.image,_that.trailer,_that.type,_that.duration,_that.origin,_that.releaseDate,_that.endDate,_that.ageRating,_that.actors,_that.totalBookings,_that.ratingAverage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Movie implements Movie {
  const _Movie({required this.id, required this.title, @GenreListConverter() final  List<Genre> genres = const <Genre>[], this.description = '', this.author = '', this.image, this.trailer, this.type = '2D', this.duration = 0, this.origin = '', this.releaseDate, this.endDate, this.ageRating = 'P', final  List<String> actors = const <String>[], this.totalBookings = 0, this.ratingAverage = 0}): _genres = genres,_actors = actors;
  factory _Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

@override final  String id;
@override final  String title;
 final  List<Genre> _genres;
@override@JsonKey()@GenreListConverter() List<Genre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey() final  String description;
@override@JsonKey() final  String author;
@override final  MediaAsset? image;
@override final  MediaAsset? trailer;
@override@JsonKey() final  String type;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String origin;
@override final  DateTime? releaseDate;
@override final  DateTime? endDate;
@override@JsonKey() final  String ageRating;
 final  List<String> _actors;
@override@JsonKey() List<String> get actors {
  if (_actors is EqualUnmodifiableListView) return _actors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actors);
}

@override@JsonKey() final  int totalBookings;
@override@JsonKey() final  double ratingAverage;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieCopyWith<_Movie> get copyWith => __$MovieCopyWithImpl<_Movie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Movie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&(identical(other.image, image) || other.image == image)&&(identical(other.trailer, trailer) || other.trailer == trailer)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.ageRating, ageRating) || other.ageRating == ageRating)&&const DeepCollectionEquality().equals(other._actors, _actors)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_genres),description,author,image,trailer,type,duration,origin,releaseDate,endDate,ageRating,const DeepCollectionEquality().hash(_actors),totalBookings,ratingAverage);

@override
String toString() {
  return 'Movie(id: $id, title: $title, genres: $genres, description: $description, author: $author, image: $image, trailer: $trailer, type: $type, duration: $duration, origin: $origin, releaseDate: $releaseDate, endDate: $endDate, ageRating: $ageRating, actors: $actors, totalBookings: $totalBookings, ratingAverage: $ratingAverage)';
}


}

/// @nodoc
abstract mixin class _$MovieCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$MovieCopyWith(_Movie value, $Res Function(_Movie) _then) = __$MovieCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@GenreListConverter() List<Genre> genres, String description, String author, MediaAsset? image, MediaAsset? trailer, String type, int duration, String origin, DateTime? releaseDate, DateTime? endDate, String ageRating, List<String> actors, int totalBookings, double ratingAverage
});


@override $MediaAssetCopyWith<$Res>? get image;@override $MediaAssetCopyWith<$Res>? get trailer;

}
/// @nodoc
class __$MovieCopyWithImpl<$Res>
    implements _$MovieCopyWith<$Res> {
  __$MovieCopyWithImpl(this._self, this._then);

  final _Movie _self;
  final $Res Function(_Movie) _then;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? genres = null,Object? description = null,Object? author = null,Object? image = freezed,Object? trailer = freezed,Object? type = null,Object? duration = null,Object? origin = null,Object? releaseDate = freezed,Object? endDate = freezed,Object? ageRating = null,Object? actors = null,Object? totalBookings = null,Object? ratingAverage = null,}) {
  return _then(_Movie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as MediaAsset?,trailer: freezed == trailer ? _self.trailer : trailer // ignore: cast_nullable_to_non_nullable
as MediaAsset?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,ageRating: null == ageRating ? _self.ageRating : ageRating // ignore: cast_nullable_to_non_nullable
as String,actors: null == actors ? _self._actors : actors // ignore: cast_nullable_to_non_nullable
as List<String>,totalBookings: null == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $MediaAssetCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<$Res>? get trailer {
    if (_self.trailer == null) {
    return null;
  }

  return $MediaAssetCopyWith<$Res>(_self.trailer!, (value) {
    return _then(_self.copyWith(trailer: value));
  });
}
}

// dart format on
