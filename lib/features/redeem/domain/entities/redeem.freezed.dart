// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'redeem.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Redeem {

 String get id; String get name; String get description; int get pointsRequired; MediaAsset? get image; int get quantity; String get status; DateTime? get createdAt;
/// Create a copy of Redeem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedeemCopyWith<Redeem> get copyWith => _$RedeemCopyWithImpl<Redeem>(this as Redeem, _$identity);

  /// Serializes this Redeem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Redeem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pointsRequired, pointsRequired) || other.pointsRequired == pointsRequired)&&(identical(other.image, image) || other.image == image)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,pointsRequired,image,quantity,status,createdAt);

@override
String toString() {
  return 'Redeem(id: $id, name: $name, description: $description, pointsRequired: $pointsRequired, image: $image, quantity: $quantity, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RedeemCopyWith<$Res>  {
  factory $RedeemCopyWith(Redeem value, $Res Function(Redeem) _then) = _$RedeemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, int pointsRequired, MediaAsset? image, int quantity, String status, DateTime? createdAt
});


$MediaAssetCopyWith<$Res>? get image;

}
/// @nodoc
class _$RedeemCopyWithImpl<$Res>
    implements $RedeemCopyWith<$Res> {
  _$RedeemCopyWithImpl(this._self, this._then);

  final Redeem _self;
  final $Res Function(Redeem) _then;

/// Create a copy of Redeem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? pointsRequired = null,Object? image = freezed,Object? quantity = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pointsRequired: null == pointsRequired ? _self.pointsRequired : pointsRequired // ignore: cast_nullable_to_non_nullable
as int,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as MediaAsset?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Redeem
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
}
}


/// Adds pattern-matching-related methods to [Redeem].
extension RedeemPatterns on Redeem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Redeem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Redeem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Redeem value)  $default,){
final _that = this;
switch (_that) {
case _Redeem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Redeem value)?  $default,){
final _that = this;
switch (_that) {
case _Redeem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int pointsRequired,  MediaAsset? image,  int quantity,  String status,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Redeem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pointsRequired,_that.image,_that.quantity,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int pointsRequired,  MediaAsset? image,  int quantity,  String status,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Redeem():
return $default(_that.id,_that.name,_that.description,_that.pointsRequired,_that.image,_that.quantity,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  int pointsRequired,  MediaAsset? image,  int quantity,  String status,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Redeem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pointsRequired,_that.image,_that.quantity,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Redeem implements Redeem {
  const _Redeem({required this.id, required this.name, this.description = '', this.pointsRequired = 0, this.image, this.quantity = 0, this.status = 'AVAILABLE', this.createdAt});
  factory _Redeem.fromJson(Map<String, dynamic> json) => _$RedeemFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  int pointsRequired;
@override final  MediaAsset? image;
@override@JsonKey() final  int quantity;
@override@JsonKey() final  String status;
@override final  DateTime? createdAt;

/// Create a copy of Redeem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RedeemCopyWith<_Redeem> get copyWith => __$RedeemCopyWithImpl<_Redeem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RedeemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Redeem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pointsRequired, pointsRequired) || other.pointsRequired == pointsRequired)&&(identical(other.image, image) || other.image == image)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,pointsRequired,image,quantity,status,createdAt);

@override
String toString() {
  return 'Redeem(id: $id, name: $name, description: $description, pointsRequired: $pointsRequired, image: $image, quantity: $quantity, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RedeemCopyWith<$Res> implements $RedeemCopyWith<$Res> {
  factory _$RedeemCopyWith(_Redeem value, $Res Function(_Redeem) _then) = __$RedeemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, int pointsRequired, MediaAsset? image, int quantity, String status, DateTime? createdAt
});


@override $MediaAssetCopyWith<$Res>? get image;

}
/// @nodoc
class __$RedeemCopyWithImpl<$Res>
    implements _$RedeemCopyWith<$Res> {
  __$RedeemCopyWithImpl(this._self, this._then);

  final _Redeem _self;
  final $Res Function(_Redeem) _then;

/// Create a copy of Redeem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? pointsRequired = null,Object? image = freezed,Object? quantity = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_Redeem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pointsRequired: null == pointsRequired ? _self.pointsRequired : pointsRequired // ignore: cast_nullable_to_non_nullable
as int,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as MediaAsset?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Redeem
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
}
}

// dart format on
