// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Promotion {

 String get id; String get title; String? get description; String? get imageUrl; String get discountType; double get discountValue; DateTime get startDate; DateTime get endDate; String get status;
/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromotionCopyWith<Promotion> get copyWith => _$PromotionCopyWithImpl<Promotion>(this as Promotion, _$identity);

  /// Serializes this Promotion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Promotion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imageUrl,discountType,discountValue,startDate,endDate,status);

@override
String toString() {
  return 'Promotion(id: $id, title: $title, description: $description, imageUrl: $imageUrl, discountType: $discountType, discountValue: $discountValue, startDate: $startDate, endDate: $endDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $PromotionCopyWith<$Res>  {
  factory $PromotionCopyWith(Promotion value, $Res Function(Promotion) _then) = _$PromotionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String? imageUrl, String discountType, double discountValue, DateTime startDate, DateTime endDate, String status
});




}
/// @nodoc
class _$PromotionCopyWithImpl<$Res>
    implements $PromotionCopyWith<$Res> {
  _$PromotionCopyWithImpl(this._self, this._then);

  final Promotion _self;
  final $Res Function(Promotion) _then;

/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? imageUrl = freezed,Object? discountType = null,Object? discountValue = null,Object? startDate = null,Object? endDate = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Promotion].
extension PromotionPatterns on Promotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Promotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Promotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Promotion value)  $default,){
final _that = this;
switch (_that) {
case _Promotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Promotion value)?  $default,){
final _that = this;
switch (_that) {
case _Promotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String? imageUrl,  String discountType,  double discountValue,  DateTime startDate,  DateTime endDate,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Promotion() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrl,_that.discountType,_that.discountValue,_that.startDate,_that.endDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String? imageUrl,  String discountType,  double discountValue,  DateTime startDate,  DateTime endDate,  String status)  $default,) {final _that = this;
switch (_that) {
case _Promotion():
return $default(_that.id,_that.title,_that.description,_that.imageUrl,_that.discountType,_that.discountValue,_that.startDate,_that.endDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String? imageUrl,  String discountType,  double discountValue,  DateTime startDate,  DateTime endDate,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Promotion() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrl,_that.discountType,_that.discountValue,_that.startDate,_that.endDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Promotion implements Promotion {
  const _Promotion({required this.id, required this.title, this.description, this.imageUrl, required this.discountType, required this.discountValue, required this.startDate, required this.endDate, required this.status});
  factory _Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String? imageUrl;
@override final  String discountType;
@override final  double discountValue;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  String status;

/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromotionCopyWith<_Promotion> get copyWith => __$PromotionCopyWithImpl<_Promotion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromotionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Promotion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imageUrl,discountType,discountValue,startDate,endDate,status);

@override
String toString() {
  return 'Promotion(id: $id, title: $title, description: $description, imageUrl: $imageUrl, discountType: $discountType, discountValue: $discountValue, startDate: $startDate, endDate: $endDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PromotionCopyWith<$Res> implements $PromotionCopyWith<$Res> {
  factory _$PromotionCopyWith(_Promotion value, $Res Function(_Promotion) _then) = __$PromotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String? imageUrl, String discountType, double discountValue, DateTime startDate, DateTime endDate, String status
});




}
/// @nodoc
class __$PromotionCopyWithImpl<$Res>
    implements _$PromotionCopyWith<$Res> {
  __$PromotionCopyWithImpl(this._self, this._then);

  final _Promotion _self;
  final $Res Function(_Promotion) _then;

/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? imageUrl = freezed,Object? discountType = null,Object? discountValue = null,Object? startDate = null,Object? endDate = null,Object? status = null,}) {
  return _then(_Promotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
