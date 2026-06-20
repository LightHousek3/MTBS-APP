// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_locator_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TheaterDistance {

 Theater get theater; double get distanceKm;
/// Create a copy of TheaterDistance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TheaterDistanceCopyWith<TheaterDistance> get copyWith => _$TheaterDistanceCopyWithImpl<TheaterDistance>(this as TheaterDistance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TheaterDistance&&(identical(other.theater, theater) || other.theater == theater)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,theater,distanceKm);

@override
String toString() {
  return 'TheaterDistance(theater: $theater, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $TheaterDistanceCopyWith<$Res>  {
  factory $TheaterDistanceCopyWith(TheaterDistance value, $Res Function(TheaterDistance) _then) = _$TheaterDistanceCopyWithImpl;
@useResult
$Res call({
 Theater theater, double distanceKm
});


$TheaterCopyWith<$Res> get theater;

}
/// @nodoc
class _$TheaterDistanceCopyWithImpl<$Res>
    implements $TheaterDistanceCopyWith<$Res> {
  _$TheaterDistanceCopyWithImpl(this._self, this._then);

  final TheaterDistance _self;
  final $Res Function(TheaterDistance) _then;

/// Create a copy of TheaterDistance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theater = null,Object? distanceKm = null,}) {
  return _then(_self.copyWith(
theater: null == theater ? _self.theater : theater // ignore: cast_nullable_to_non_nullable
as Theater,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of TheaterDistance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TheaterCopyWith<$Res> get theater {
  
  return $TheaterCopyWith<$Res>(_self.theater, (value) {
    return _then(_self.copyWith(theater: value));
  });
}
}


/// Adds pattern-matching-related methods to [TheaterDistance].
extension TheaterDistancePatterns on TheaterDistance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TheaterDistance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TheaterDistance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TheaterDistance value)  $default,){
final _that = this;
switch (_that) {
case _TheaterDistance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TheaterDistance value)?  $default,){
final _that = this;
switch (_that) {
case _TheaterDistance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Theater theater,  double distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TheaterDistance() when $default != null:
return $default(_that.theater,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Theater theater,  double distanceKm)  $default,) {final _that = this;
switch (_that) {
case _TheaterDistance():
return $default(_that.theater,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Theater theater,  double distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _TheaterDistance() when $default != null:
return $default(_that.theater,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc


class _TheaterDistance implements TheaterDistance {
  const _TheaterDistance({required this.theater, required this.distanceKm});
  

@override final  Theater theater;
@override final  double distanceKm;

/// Create a copy of TheaterDistance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TheaterDistanceCopyWith<_TheaterDistance> get copyWith => __$TheaterDistanceCopyWithImpl<_TheaterDistance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TheaterDistance&&(identical(other.theater, theater) || other.theater == theater)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,theater,distanceKm);

@override
String toString() {
  return 'TheaterDistance(theater: $theater, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$TheaterDistanceCopyWith<$Res> implements $TheaterDistanceCopyWith<$Res> {
  factory _$TheaterDistanceCopyWith(_TheaterDistance value, $Res Function(_TheaterDistance) _then) = __$TheaterDistanceCopyWithImpl;
@override @useResult
$Res call({
 Theater theater, double distanceKm
});


@override $TheaterCopyWith<$Res> get theater;

}
/// @nodoc
class __$TheaterDistanceCopyWithImpl<$Res>
    implements _$TheaterDistanceCopyWith<$Res> {
  __$TheaterDistanceCopyWithImpl(this._self, this._then);

  final _TheaterDistance _self;
  final $Res Function(_TheaterDistance) _then;

/// Create a copy of TheaterDistance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theater = null,Object? distanceKm = null,}) {
  return _then(_TheaterDistance(
theater: null == theater ? _self.theater : theater // ignore: cast_nullable_to_non_nullable
as Theater,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of TheaterDistance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TheaterCopyWith<$Res> get theater {
  
  return $TheaterCopyWith<$Res>(_self.theater, (value) {
    return _then(_self.copyWith(theater: value));
  });
}
}

/// @nodoc
mixin _$TheaterLocatorState {

 int get radiusKm; Position? get position; List<TheaterDistance> get theaters;
/// Create a copy of TheaterLocatorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TheaterLocatorStateCopyWith<TheaterLocatorState> get copyWith => _$TheaterLocatorStateCopyWithImpl<TheaterLocatorState>(this as TheaterLocatorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TheaterLocatorState&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.theaters, theaters));
}


@override
int get hashCode => Object.hash(runtimeType,radiusKm,position,const DeepCollectionEquality().hash(theaters));

@override
String toString() {
  return 'TheaterLocatorState(radiusKm: $radiusKm, position: $position, theaters: $theaters)';
}


}

/// @nodoc
abstract mixin class $TheaterLocatorStateCopyWith<$Res>  {
  factory $TheaterLocatorStateCopyWith(TheaterLocatorState value, $Res Function(TheaterLocatorState) _then) = _$TheaterLocatorStateCopyWithImpl;
@useResult
$Res call({
 int radiusKm, Position? position, List<TheaterDistance> theaters
});




}
/// @nodoc
class _$TheaterLocatorStateCopyWithImpl<$Res>
    implements $TheaterLocatorStateCopyWith<$Res> {
  _$TheaterLocatorStateCopyWithImpl(this._self, this._then);

  final TheaterLocatorState _self;
  final $Res Function(TheaterLocatorState) _then;

/// Create a copy of TheaterLocatorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? radiusKm = null,Object? position = freezed,Object? theaters = null,}) {
  return _then(_self.copyWith(
radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as int,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position?,theaters: null == theaters ? _self.theaters : theaters // ignore: cast_nullable_to_non_nullable
as List<TheaterDistance>,
  ));
}

}


/// Adds pattern-matching-related methods to [TheaterLocatorState].
extension TheaterLocatorStatePatterns on TheaterLocatorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TheaterLocatorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TheaterLocatorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TheaterLocatorState value)  $default,){
final _that = this;
switch (_that) {
case _TheaterLocatorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TheaterLocatorState value)?  $default,){
final _that = this;
switch (_that) {
case _TheaterLocatorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int radiusKm,  Position? position,  List<TheaterDistance> theaters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TheaterLocatorState() when $default != null:
return $default(_that.radiusKm,_that.position,_that.theaters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int radiusKm,  Position? position,  List<TheaterDistance> theaters)  $default,) {final _that = this;
switch (_that) {
case _TheaterLocatorState():
return $default(_that.radiusKm,_that.position,_that.theaters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int radiusKm,  Position? position,  List<TheaterDistance> theaters)?  $default,) {final _that = this;
switch (_that) {
case _TheaterLocatorState() when $default != null:
return $default(_that.radiusKm,_that.position,_that.theaters);case _:
  return null;

}
}

}

/// @nodoc


class _TheaterLocatorState implements TheaterLocatorState {
  const _TheaterLocatorState({this.radiusKm = 10, this.position, final  List<TheaterDistance> theaters = const <TheaterDistance>[]}): _theaters = theaters;
  

@override@JsonKey() final  int radiusKm;
@override final  Position? position;
 final  List<TheaterDistance> _theaters;
@override@JsonKey() List<TheaterDistance> get theaters {
  if (_theaters is EqualUnmodifiableListView) return _theaters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_theaters);
}


/// Create a copy of TheaterLocatorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TheaterLocatorStateCopyWith<_TheaterLocatorState> get copyWith => __$TheaterLocatorStateCopyWithImpl<_TheaterLocatorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TheaterLocatorState&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other._theaters, _theaters));
}


@override
int get hashCode => Object.hash(runtimeType,radiusKm,position,const DeepCollectionEquality().hash(_theaters));

@override
String toString() {
  return 'TheaterLocatorState(radiusKm: $radiusKm, position: $position, theaters: $theaters)';
}


}

/// @nodoc
abstract mixin class _$TheaterLocatorStateCopyWith<$Res> implements $TheaterLocatorStateCopyWith<$Res> {
  factory _$TheaterLocatorStateCopyWith(_TheaterLocatorState value, $Res Function(_TheaterLocatorState) _then) = __$TheaterLocatorStateCopyWithImpl;
@override @useResult
$Res call({
 int radiusKm, Position? position, List<TheaterDistance> theaters
});




}
/// @nodoc
class __$TheaterLocatorStateCopyWithImpl<$Res>
    implements _$TheaterLocatorStateCopyWith<$Res> {
  __$TheaterLocatorStateCopyWithImpl(this._self, this._then);

  final _TheaterLocatorState _self;
  final $Res Function(_TheaterLocatorState) _then;

/// Create a copy of TheaterLocatorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? radiusKm = null,Object? position = freezed,Object? theaters = null,}) {
  return _then(_TheaterLocatorState(
radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as int,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position?,theaters: null == theaters ? _self._theaters : theaters // ignore: cast_nullable_to_non_nullable
as List<TheaterDistance>,
  ));
}


}

// dart format on
