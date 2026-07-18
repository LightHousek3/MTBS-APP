// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewUser {

 String get id; String get firstName; String get lastName; String get email;
/// Create a copy of ReviewUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewUserCopyWith<ReviewUser> get copyWith => _$ReviewUserCopyWithImpl<ReviewUser>(this as ReviewUser, _$identity);

  /// Serializes this ReviewUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewUser&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,email);

@override
String toString() {
  return 'ReviewUser(id: $id, firstName: $firstName, lastName: $lastName, email: $email)';
}


}

/// @nodoc
abstract mixin class $ReviewUserCopyWith<$Res>  {
  factory $ReviewUserCopyWith(ReviewUser value, $Res Function(ReviewUser) _then) = _$ReviewUserCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, String lastName, String email
});




}
/// @nodoc
class _$ReviewUserCopyWithImpl<$Res>
    implements $ReviewUserCopyWith<$Res> {
  _$ReviewUserCopyWithImpl(this._self, this._then);

  final ReviewUser _self;
  final $Res Function(ReviewUser) _then;

/// Create a copy of ReviewUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewUser].
extension ReviewUserPatterns on ReviewUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewUser value)  $default,){
final _that = this;
switch (_that) {
case _ReviewUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewUser value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewUser() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String email)  $default,) {final _that = this;
switch (_that) {
case _ReviewUser():
return $default(_that.id,_that.firstName,_that.lastName,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  String lastName,  String email)?  $default,) {final _that = this;
switch (_that) {
case _ReviewUser() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewUser implements ReviewUser {
  const _ReviewUser({required this.id, this.firstName = '', this.lastName = '', this.email = ''});
  factory _ReviewUser.fromJson(Map<String, dynamic> json) => _$ReviewUserFromJson(json);

@override final  String id;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  String email;

/// Create a copy of ReviewUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewUserCopyWith<_ReviewUser> get copyWith => __$ReviewUserCopyWithImpl<_ReviewUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewUser&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,email);

@override
String toString() {
  return 'ReviewUser(id: $id, firstName: $firstName, lastName: $lastName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$ReviewUserCopyWith<$Res> implements $ReviewUserCopyWith<$Res> {
  factory _$ReviewUserCopyWith(_ReviewUser value, $Res Function(_ReviewUser) _then) = __$ReviewUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, String lastName, String email
});




}
/// @nodoc
class __$ReviewUserCopyWithImpl<$Res>
    implements _$ReviewUserCopyWith<$Res> {
  __$ReviewUserCopyWithImpl(this._self, this._then);

  final _ReviewUser _self;
  final $Res Function(_ReviewUser) _then;

/// Create a copy of ReviewUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,}) {
  return _then(_ReviewUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReviewMovie {

 String get id; String get title;
/// Create a copy of ReviewMovie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewMovieCopyWith<ReviewMovie> get copyWith => _$ReviewMovieCopyWithImpl<ReviewMovie>(this as ReviewMovie, _$identity);

  /// Serializes this ReviewMovie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'ReviewMovie(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class $ReviewMovieCopyWith<$Res>  {
  factory $ReviewMovieCopyWith(ReviewMovie value, $Res Function(ReviewMovie) _then) = _$ReviewMovieCopyWithImpl;
@useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class _$ReviewMovieCopyWithImpl<$Res>
    implements $ReviewMovieCopyWith<$Res> {
  _$ReviewMovieCopyWithImpl(this._self, this._then);

  final ReviewMovie _self;
  final $Res Function(ReviewMovie) _then;

/// Create a copy of ReviewMovie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewMovie].
extension ReviewMoviePatterns on ReviewMovie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewMovie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewMovie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewMovie value)  $default,){
final _that = this;
switch (_that) {
case _ReviewMovie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewMovie value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewMovie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewMovie() when $default != null:
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title)  $default,) {final _that = this;
switch (_that) {
case _ReviewMovie():
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title)?  $default,) {final _that = this;
switch (_that) {
case _ReviewMovie() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewMovie implements ReviewMovie {
  const _ReviewMovie({required this.id, this.title = ''});
  factory _ReviewMovie.fromJson(Map<String, dynamic> json) => _$ReviewMovieFromJson(json);

@override final  String id;
@override@JsonKey() final  String title;

/// Create a copy of ReviewMovie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewMovieCopyWith<_ReviewMovie> get copyWith => __$ReviewMovieCopyWithImpl<_ReviewMovie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewMovieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'ReviewMovie(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ReviewMovieCopyWith<$Res> implements $ReviewMovieCopyWith<$Res> {
  factory _$ReviewMovieCopyWith(_ReviewMovie value, $Res Function(_ReviewMovie) _then) = __$ReviewMovieCopyWithImpl;
@override @useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class __$ReviewMovieCopyWithImpl<$Res>
    implements _$ReviewMovieCopyWith<$Res> {
  __$ReviewMovieCopyWithImpl(this._self, this._then);

  final _ReviewMovie _self;
  final $Res Function(_ReviewMovie) _then;

/// Create a copy of ReviewMovie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_ReviewMovie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Review {

 String get id;@ReviewUserConverter() ReviewUser? get user;@ReviewMovieConverter() ReviewMovie? get movie; int get rating; String get content; String get status; DateTime? get createdAt;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.id, id) || other.id == id)&&(identical(other.user, user) || other.user == user)&&(identical(other.movie, movie) || other.movie == movie)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.content, content) || other.content == content)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user,movie,rating,content,status,createdAt);

@override
String toString() {
  return 'Review(id: $id, user: $user, movie: $movie, rating: $rating, content: $content, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String id,@ReviewUserConverter() ReviewUser? user,@ReviewMovieConverter() ReviewMovie? movie, int rating, String content, String status, DateTime? createdAt
});


$ReviewUserCopyWith<$Res>? get user;$ReviewMovieCopyWith<$Res>? get movie;

}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? user = freezed,Object? movie = freezed,Object? rating = null,Object? content = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ReviewUser?,movie: freezed == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as ReviewMovie?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ReviewUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewMovieCopyWith<$Res>? get movie {
    if (_self.movie == null) {
    return null;
  }

  return $ReviewMovieCopyWith<$Res>(_self.movie!, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @ReviewUserConverter()  ReviewUser? user, @ReviewMovieConverter()  ReviewMovie? movie,  int rating,  String content,  String status,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.user,_that.movie,_that.rating,_that.content,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @ReviewUserConverter()  ReviewUser? user, @ReviewMovieConverter()  ReviewMovie? movie,  int rating,  String content,  String status,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.id,_that.user,_that.movie,_that.rating,_that.content,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @ReviewUserConverter()  ReviewUser? user, @ReviewMovieConverter()  ReviewMovie? movie,  int rating,  String content,  String status,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.user,_that.movie,_that.rating,_that.content,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.id, @ReviewUserConverter() this.user, @ReviewMovieConverter() this.movie, this.rating = 0, this.content = '', this.status = 'PENDING', this.createdAt});
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String id;
@override@ReviewUserConverter() final  ReviewUser? user;
@override@ReviewMovieConverter() final  ReviewMovie? movie;
@override@JsonKey() final  int rating;
@override@JsonKey() final  String content;
@override@JsonKey() final  String status;
@override final  DateTime? createdAt;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.id, id) || other.id == id)&&(identical(other.user, user) || other.user == user)&&(identical(other.movie, movie) || other.movie == movie)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.content, content) || other.content == content)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user,movie,rating,content,status,createdAt);

@override
String toString() {
  return 'Review(id: $id, user: $user, movie: $movie, rating: $rating, content: $content, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String id,@ReviewUserConverter() ReviewUser? user,@ReviewMovieConverter() ReviewMovie? movie, int rating, String content, String status, DateTime? createdAt
});


@override $ReviewUserCopyWith<$Res>? get user;@override $ReviewMovieCopyWith<$Res>? get movie;

}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? user = freezed,Object? movie = freezed,Object? rating = null,Object? content = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ReviewUser?,movie: freezed == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as ReviewMovie?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ReviewUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewMovieCopyWith<$Res>? get movie {
    if (_self.movie == null) {
    return null;
  }

  return $ReviewMovieCopyWith<$Res>(_self.movie!, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}

/// @nodoc
mixin _$ReviewPageResult {

 List<Review> get reviews; bool get hasNextPage; int get nextPage; double get ratingAverage; int get totalResults;
/// Create a copy of ReviewPageResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewPageResultCopyWith<ReviewPageResult> get copyWith => _$ReviewPageResultCopyWithImpl<ReviewPageResult>(this as ReviewPageResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewPageResult&&const DeepCollectionEquality().equals(other.reviews, reviews)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reviews),hasNextPage,nextPage,ratingAverage,totalResults);

@override
String toString() {
  return 'ReviewPageResult(reviews: $reviews, hasNextPage: $hasNextPage, nextPage: $nextPage, ratingAverage: $ratingAverage, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $ReviewPageResultCopyWith<$Res>  {
  factory $ReviewPageResultCopyWith(ReviewPageResult value, $Res Function(ReviewPageResult) _then) = _$ReviewPageResultCopyWithImpl;
@useResult
$Res call({
 List<Review> reviews, bool hasNextPage, int nextPage, double ratingAverage, int totalResults
});




}
/// @nodoc
class _$ReviewPageResultCopyWithImpl<$Res>
    implements $ReviewPageResultCopyWith<$Res> {
  _$ReviewPageResultCopyWithImpl(this._self, this._then);

  final ReviewPageResult _self;
  final $Res Function(ReviewPageResult) _then;

/// Create a copy of ReviewPageResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reviews = null,Object? hasNextPage = null,Object? nextPage = null,Object? ratingAverage = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<Review>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewPageResult].
extension ReviewPageResultPatterns on ReviewPageResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewPageResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewPageResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewPageResult value)  $default,){
final _that = this;
switch (_that) {
case _ReviewPageResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewPageResult value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewPageResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Review> reviews,  bool hasNextPage,  int nextPage,  double ratingAverage,  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewPageResult() when $default != null:
return $default(_that.reviews,_that.hasNextPage,_that.nextPage,_that.ratingAverage,_that.totalResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Review> reviews,  bool hasNextPage,  int nextPage,  double ratingAverage,  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _ReviewPageResult():
return $default(_that.reviews,_that.hasNextPage,_that.nextPage,_that.ratingAverage,_that.totalResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Review> reviews,  bool hasNextPage,  int nextPage,  double ratingAverage,  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _ReviewPageResult() when $default != null:
return $default(_that.reviews,_that.hasNextPage,_that.nextPage,_that.ratingAverage,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewPageResult implements ReviewPageResult {
  const _ReviewPageResult({required final  List<Review> reviews, this.hasNextPage = false, this.nextPage = 1, this.ratingAverage = 0, this.totalResults = 0}): _reviews = reviews;
  

 final  List<Review> _reviews;
@override List<Review> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}

@override@JsonKey() final  bool hasNextPage;
@override@JsonKey() final  int nextPage;
@override@JsonKey() final  double ratingAverage;
@override@JsonKey() final  int totalResults;

/// Create a copy of ReviewPageResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewPageResultCopyWith<_ReviewPageResult> get copyWith => __$ReviewPageResultCopyWithImpl<_ReviewPageResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewPageResult&&const DeepCollectionEquality().equals(other._reviews, _reviews)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reviews),hasNextPage,nextPage,ratingAverage,totalResults);

@override
String toString() {
  return 'ReviewPageResult(reviews: $reviews, hasNextPage: $hasNextPage, nextPage: $nextPage, ratingAverage: $ratingAverage, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$ReviewPageResultCopyWith<$Res> implements $ReviewPageResultCopyWith<$Res> {
  factory _$ReviewPageResultCopyWith(_ReviewPageResult value, $Res Function(_ReviewPageResult) _then) = __$ReviewPageResultCopyWithImpl;
@override @useResult
$Res call({
 List<Review> reviews, bool hasNextPage, int nextPage, double ratingAverage, int totalResults
});




}
/// @nodoc
class __$ReviewPageResultCopyWithImpl<$Res>
    implements _$ReviewPageResultCopyWith<$Res> {
  __$ReviewPageResultCopyWithImpl(this._self, this._then);

  final _ReviewPageResult _self;
  final $Res Function(_ReviewPageResult) _then;

/// Create a copy of ReviewPageResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reviews = null,Object? hasNextPage = null,Object? nextPage = null,Object? ratingAverage = null,Object? totalResults = null,}) {
  return _then(_ReviewPageResult(
reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<Review>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
