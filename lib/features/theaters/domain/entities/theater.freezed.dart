// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Theater {

 String get id; String get name; String get location; String get address; String? get phone;@TheaterCoordinatesConverter() TheaterCoordinates? get coordinates;
/// Create a copy of Theater
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TheaterCopyWith<Theater> get copyWith => _$TheaterCopyWithImpl<Theater>(this as Theater, _$identity);

  /// Serializes this Theater to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Theater&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,location,address,phone,coordinates);

@override
String toString() {
  return 'Theater(id: $id, name: $name, location: $location, address: $address, phone: $phone, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $TheaterCopyWith<$Res>  {
  factory $TheaterCopyWith(Theater value, $Res Function(Theater) _then) = _$TheaterCopyWithImpl;
@useResult
$Res call({
 String id, String name, String location, String address, String? phone,@TheaterCoordinatesConverter() TheaterCoordinates? coordinates
});


$TheaterCoordinatesCopyWith<$Res>? get coordinates;

}
/// @nodoc
class _$TheaterCopyWithImpl<$Res>
    implements $TheaterCopyWith<$Res> {
  _$TheaterCopyWithImpl(this._self, this._then);

  final Theater _self;
  final $Res Function(Theater) _then;

/// Create a copy of Theater
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = null,Object? phone = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as TheaterCoordinates?,
  ));
}
/// Create a copy of Theater
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TheaterCoordinatesCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $TheaterCoordinatesCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [Theater].
extension TheaterPatterns on Theater {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Theater value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Theater() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Theater value)  $default,){
final _that = this;
switch (_that) {
case _Theater():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Theater value)?  $default,){
final _that = this;
switch (_that) {
case _Theater() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String location,  String address,  String? phone, @TheaterCoordinatesConverter()  TheaterCoordinates? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Theater() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address,_that.phone,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String location,  String address,  String? phone, @TheaterCoordinatesConverter()  TheaterCoordinates? coordinates)  $default,) {final _that = this;
switch (_that) {
case _Theater():
return $default(_that.id,_that.name,_that.location,_that.address,_that.phone,_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String location,  String address,  String? phone, @TheaterCoordinatesConverter()  TheaterCoordinates? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _Theater() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address,_that.phone,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Theater implements Theater {
  const _Theater({required this.id, required this.name, this.location = '', required this.address, this.phone, @TheaterCoordinatesConverter() this.coordinates});
  factory _Theater.fromJson(Map<String, dynamic> json) => _$TheaterFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String location;
@override final  String address;
@override final  String? phone;
@override@TheaterCoordinatesConverter() final  TheaterCoordinates? coordinates;

/// Create a copy of Theater
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TheaterCopyWith<_Theater> get copyWith => __$TheaterCopyWithImpl<_Theater>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TheaterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Theater&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,location,address,phone,coordinates);

@override
String toString() {
  return 'Theater(id: $id, name: $name, location: $location, address: $address, phone: $phone, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$TheaterCopyWith<$Res> implements $TheaterCopyWith<$Res> {
  factory _$TheaterCopyWith(_Theater value, $Res Function(_Theater) _then) = __$TheaterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String location, String address, String? phone,@TheaterCoordinatesConverter() TheaterCoordinates? coordinates
});


@override $TheaterCoordinatesCopyWith<$Res>? get coordinates;

}
/// @nodoc
class __$TheaterCopyWithImpl<$Res>
    implements _$TheaterCopyWith<$Res> {
  __$TheaterCopyWithImpl(this._self, this._then);

  final _Theater _self;
  final $Res Function(_Theater) _then;

/// Create a copy of Theater
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = null,Object? phone = freezed,Object? coordinates = freezed,}) {
  return _then(_Theater(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as TheaterCoordinates?,
  ));
}

/// Create a copy of Theater
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TheaterCoordinatesCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $TheaterCoordinatesCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}

/// @nodoc
mixin _$TheaterCoordinates {

 double get latitude; double get longitude;
/// Create a copy of TheaterCoordinates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TheaterCoordinatesCopyWith<TheaterCoordinates> get copyWith => _$TheaterCoordinatesCopyWithImpl<TheaterCoordinates>(this as TheaterCoordinates, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TheaterCoordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'TheaterCoordinates(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $TheaterCoordinatesCopyWith<$Res>  {
  factory $TheaterCoordinatesCopyWith(TheaterCoordinates value, $Res Function(TheaterCoordinates) _then) = _$TheaterCoordinatesCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$TheaterCoordinatesCopyWithImpl<$Res>
    implements $TheaterCoordinatesCopyWith<$Res> {
  _$TheaterCoordinatesCopyWithImpl(this._self, this._then);

  final TheaterCoordinates _self;
  final $Res Function(TheaterCoordinates) _then;

/// Create a copy of TheaterCoordinates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TheaterCoordinates].
extension TheaterCoordinatesPatterns on TheaterCoordinates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TheaterCoordinates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TheaterCoordinates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TheaterCoordinates value)  $default,){
final _that = this;
switch (_that) {
case _TheaterCoordinates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TheaterCoordinates value)?  $default,){
final _that = this;
switch (_that) {
case _TheaterCoordinates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TheaterCoordinates() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _TheaterCoordinates():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _TheaterCoordinates() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _TheaterCoordinates implements TheaterCoordinates {
  const _TheaterCoordinates({required this.latitude, required this.longitude});
  

@override final  double latitude;
@override final  double longitude;

/// Create a copy of TheaterCoordinates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TheaterCoordinatesCopyWith<_TheaterCoordinates> get copyWith => __$TheaterCoordinatesCopyWithImpl<_TheaterCoordinates>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TheaterCoordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'TheaterCoordinates(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$TheaterCoordinatesCopyWith<$Res> implements $TheaterCoordinatesCopyWith<$Res> {
  factory _$TheaterCoordinatesCopyWith(_TheaterCoordinates value, $Res Function(_TheaterCoordinates) _then) = __$TheaterCoordinatesCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$TheaterCoordinatesCopyWithImpl<$Res>
    implements _$TheaterCoordinatesCopyWith<$Res> {
  __$TheaterCoordinatesCopyWithImpl(this._self, this._then);

  final _TheaterCoordinates _self;
  final $Res Function(_TheaterCoordinates) _then;

/// Create a copy of TheaterCoordinates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_TheaterCoordinates(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
