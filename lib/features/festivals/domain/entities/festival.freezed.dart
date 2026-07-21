// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'festival.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Festival {

 String get id; String get title; String get subtitle; String? get content; String? get imageUrl; String? get category; String? get location; String? get status; DateTime? get startTime; DateTime? get endTime; DateTime? get createdAt;
/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalCopyWith<Festival> get copyWith => _$FestivalCopyWithImpl<Festival>(this as Festival, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Festival&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,content,imageUrl,category,location,status,startTime,endTime,createdAt);

@override
String toString() {
  return 'Festival(id: $id, title: $title, subtitle: $subtitle, content: $content, imageUrl: $imageUrl, category: $category, location: $location, status: $status, startTime: $startTime, endTime: $endTime, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FestivalCopyWith<$Res>  {
  factory $FestivalCopyWith(Festival value, $Res Function(Festival) _then) = _$FestivalCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String? content, String? imageUrl, String? category, String? location, String? status, DateTime? startTime, DateTime? endTime, DateTime? createdAt
});




}
/// @nodoc
class _$FestivalCopyWithImpl<$Res>
    implements $FestivalCopyWith<$Res> {
  _$FestivalCopyWithImpl(this._self, this._then);

  final Festival _self;
  final $Res Function(Festival) _then;

/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? content = freezed,Object? imageUrl = freezed,Object? category = freezed,Object? location = freezed,Object? status = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Festival].
extension FestivalPatterns on Festival {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Festival value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Festival() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Festival value)  $default,){
final _that = this;
switch (_that) {
case _Festival():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Festival value)?  $default,){
final _that = this;
switch (_that) {
case _Festival() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String? content,  String? imageUrl,  String? category,  String? location,  String? status,  DateTime? startTime,  DateTime? endTime,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Festival() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.content,_that.imageUrl,_that.category,_that.location,_that.status,_that.startTime,_that.endTime,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String? content,  String? imageUrl,  String? category,  String? location,  String? status,  DateTime? startTime,  DateTime? endTime,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Festival():
return $default(_that.id,_that.title,_that.subtitle,_that.content,_that.imageUrl,_that.category,_that.location,_that.status,_that.startTime,_that.endTime,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  String? content,  String? imageUrl,  String? category,  String? location,  String? status,  DateTime? startTime,  DateTime? endTime,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Festival() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.content,_that.imageUrl,_that.category,_that.location,_that.status,_that.startTime,_that.endTime,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Festival implements Festival {
  const _Festival({required this.id, required this.title, required this.subtitle, this.content, this.imageUrl, this.category, this.location, this.status, this.startTime, this.endTime, this.createdAt});
  

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  String? content;
@override final  String? imageUrl;
@override final  String? category;
@override final  String? location;
@override final  String? status;
@override final  DateTime? startTime;
@override final  DateTime? endTime;
@override final  DateTime? createdAt;

/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalCopyWith<_Festival> get copyWith => __$FestivalCopyWithImpl<_Festival>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Festival&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,content,imageUrl,category,location,status,startTime,endTime,createdAt);

@override
String toString() {
  return 'Festival(id: $id, title: $title, subtitle: $subtitle, content: $content, imageUrl: $imageUrl, category: $category, location: $location, status: $status, startTime: $startTime, endTime: $endTime, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FestivalCopyWith<$Res> implements $FestivalCopyWith<$Res> {
  factory _$FestivalCopyWith(_Festival value, $Res Function(_Festival) _then) = __$FestivalCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String? content, String? imageUrl, String? category, String? location, String? status, DateTime? startTime, DateTime? endTime, DateTime? createdAt
});




}
/// @nodoc
class __$FestivalCopyWithImpl<$Res>
    implements _$FestivalCopyWith<$Res> {
  __$FestivalCopyWithImpl(this._self, this._then);

  final _Festival _self;
  final $Res Function(_Festival) _then;

/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? content = freezed,Object? imageUrl = freezed,Object? category = freezed,Object? location = freezed,Object? status = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? createdAt = freezed,}) {
  return _then(_Festival(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
