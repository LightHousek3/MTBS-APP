// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 List<HomeBanner> get banners; List<Movie> get nowShowing; List<Movie> get comingSoon; List<Promotion> get promotions; List<News> get news; List<Festival> get festivals; List<String> get locations; String? get selectedLocation;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&const DeepCollectionEquality().equals(other.banners, banners)&&const DeepCollectionEquality().equals(other.nowShowing, nowShowing)&&const DeepCollectionEquality().equals(other.comingSoon, comingSoon)&&const DeepCollectionEquality().equals(other.promotions, promotions)&&const DeepCollectionEquality().equals(other.news, news)&&const DeepCollectionEquality().equals(other.festivals, festivals)&&const DeepCollectionEquality().equals(other.locations, locations)&&(identical(other.selectedLocation, selectedLocation) || other.selectedLocation == selectedLocation));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(banners),const DeepCollectionEquality().hash(nowShowing),const DeepCollectionEquality().hash(comingSoon),const DeepCollectionEquality().hash(promotions),const DeepCollectionEquality().hash(news),const DeepCollectionEquality().hash(festivals),const DeepCollectionEquality().hash(locations),selectedLocation);

@override
String toString() {
  return 'HomeState(banners: $banners, nowShowing: $nowShowing, comingSoon: $comingSoon, promotions: $promotions, news: $news, festivals: $festivals, locations: $locations, selectedLocation: $selectedLocation)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 List<HomeBanner> banners, List<Movie> nowShowing, List<Movie> comingSoon, List<Promotion> promotions, List<News> news, List<Festival> festivals, List<String> locations, String? selectedLocation
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? banners = null,Object? nowShowing = null,Object? comingSoon = null,Object? promotions = null,Object? news = null,Object? festivals = null,Object? locations = null,Object? selectedLocation = freezed,}) {
  return _then(_self.copyWith(
banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<HomeBanner>,nowShowing: null == nowShowing ? _self.nowShowing : nowShowing // ignore: cast_nullable_to_non_nullable
as List<Movie>,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as List<Movie>,promotions: null == promotions ? _self.promotions : promotions // ignore: cast_nullable_to_non_nullable
as List<Promotion>,news: null == news ? _self.news : news // ignore: cast_nullable_to_non_nullable
as List<News>,festivals: null == festivals ? _self.festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<Festival>,locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as List<String>,selectedLocation: freezed == selectedLocation ? _self.selectedLocation : selectedLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HomeBanner> banners,  List<Movie> nowShowing,  List<Movie> comingSoon,  List<Promotion> promotions,  List<News> news,  List<Festival> festivals,  List<String> locations,  String? selectedLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.banners,_that.nowShowing,_that.comingSoon,_that.promotions,_that.news,_that.festivals,_that.locations,_that.selectedLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HomeBanner> banners,  List<Movie> nowShowing,  List<Movie> comingSoon,  List<Promotion> promotions,  List<News> news,  List<Festival> festivals,  List<String> locations,  String? selectedLocation)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.banners,_that.nowShowing,_that.comingSoon,_that.promotions,_that.news,_that.festivals,_that.locations,_that.selectedLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HomeBanner> banners,  List<Movie> nowShowing,  List<Movie> comingSoon,  List<Promotion> promotions,  List<News> news,  List<Festival> festivals,  List<String> locations,  String? selectedLocation)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.banners,_that.nowShowing,_that.comingSoon,_that.promotions,_that.news,_that.festivals,_that.locations,_that.selectedLocation);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({final  List<HomeBanner> banners = const <HomeBanner>[], final  List<Movie> nowShowing = const <Movie>[], final  List<Movie> comingSoon = const <Movie>[], final  List<Promotion> promotions = const <Promotion>[], final  List<News> news = const <News>[], final  List<Festival> festivals = const <Festival>[], final  List<String> locations = const <String>[], this.selectedLocation}): _banners = banners,_nowShowing = nowShowing,_comingSoon = comingSoon,_promotions = promotions,_news = news,_festivals = festivals,_locations = locations;
  

 final  List<HomeBanner> _banners;
@override@JsonKey() List<HomeBanner> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

 final  List<Movie> _nowShowing;
@override@JsonKey() List<Movie> get nowShowing {
  if (_nowShowing is EqualUnmodifiableListView) return _nowShowing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nowShowing);
}

 final  List<Movie> _comingSoon;
@override@JsonKey() List<Movie> get comingSoon {
  if (_comingSoon is EqualUnmodifiableListView) return _comingSoon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comingSoon);
}

 final  List<Promotion> _promotions;
@override@JsonKey() List<Promotion> get promotions {
  if (_promotions is EqualUnmodifiableListView) return _promotions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_promotions);
}

 final  List<News> _news;
@override@JsonKey() List<News> get news {
  if (_news is EqualUnmodifiableListView) return _news;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_news);
}

 final  List<Festival> _festivals;
@override@JsonKey() List<Festival> get festivals {
  if (_festivals is EqualUnmodifiableListView) return _festivals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_festivals);
}

 final  List<String> _locations;
@override@JsonKey() List<String> get locations {
  if (_locations is EqualUnmodifiableListView) return _locations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_locations);
}

@override final  String? selectedLocation;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&const DeepCollectionEquality().equals(other._banners, _banners)&&const DeepCollectionEquality().equals(other._nowShowing, _nowShowing)&&const DeepCollectionEquality().equals(other._comingSoon, _comingSoon)&&const DeepCollectionEquality().equals(other._promotions, _promotions)&&const DeepCollectionEquality().equals(other._news, _news)&&const DeepCollectionEquality().equals(other._festivals, _festivals)&&const DeepCollectionEquality().equals(other._locations, _locations)&&(identical(other.selectedLocation, selectedLocation) || other.selectedLocation == selectedLocation));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_banners),const DeepCollectionEquality().hash(_nowShowing),const DeepCollectionEquality().hash(_comingSoon),const DeepCollectionEquality().hash(_promotions),const DeepCollectionEquality().hash(_news),const DeepCollectionEquality().hash(_festivals),const DeepCollectionEquality().hash(_locations),selectedLocation);

@override
String toString() {
  return 'HomeState(banners: $banners, nowShowing: $nowShowing, comingSoon: $comingSoon, promotions: $promotions, news: $news, festivals: $festivals, locations: $locations, selectedLocation: $selectedLocation)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 List<HomeBanner> banners, List<Movie> nowShowing, List<Movie> comingSoon, List<Promotion> promotions, List<News> news, List<Festival> festivals, List<String> locations, String? selectedLocation
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? banners = null,Object? nowShowing = null,Object? comingSoon = null,Object? promotions = null,Object? news = null,Object? festivals = null,Object? locations = null,Object? selectedLocation = freezed,}) {
  return _then(_HomeState(
banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<HomeBanner>,nowShowing: null == nowShowing ? _self._nowShowing : nowShowing // ignore: cast_nullable_to_non_nullable
as List<Movie>,comingSoon: null == comingSoon ? _self._comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as List<Movie>,promotions: null == promotions ? _self._promotions : promotions // ignore: cast_nullable_to_non_nullable
as List<Promotion>,news: null == news ? _self._news : news // ignore: cast_nullable_to_non_nullable
as List<News>,festivals: null == festivals ? _self._festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<Festival>,locations: null == locations ? _self._locations : locations // ignore: cast_nullable_to_non_nullable
as List<String>,selectedLocation: freezed == selectedLocation ? _self.selectedLocation : selectedLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
