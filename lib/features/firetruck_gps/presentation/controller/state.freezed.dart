// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FireTruckState {

// ── Position ─────────────────────────────────────────────────────────────
 LatLng? get currentPosition;// ── Destination ──────────────────────────────────────────────────────────
 LatLng get destination;// ── Firetruck route (live position → destination) ─────────────────────────
 List<LatLng> get routePoints; LatLng? get lastRoutePosition; bool get isFetchingRoute; String? get routeError;// ── Fire station route (fire station → destination) ───────────────────────
/// Static route fetched once on startup — never changes during a dispatch.
 List<LatLng> get stationRoutePoints; bool get isFetchingStationRoute;// ── Camera / UI ───────────────────────────────────────────────────────────
 bool get followTruck; int get selectedMapTypeIndex; bool get closeModals;
/// Create a copy of FireTruckState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FireTruckStateCopyWith<FireTruckState> get copyWith => _$FireTruckStateCopyWithImpl<FireTruckState>(this as FireTruckState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FireTruckState&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.destination, destination) || other.destination == destination)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.lastRoutePosition, lastRoutePosition) || other.lastRoutePosition == lastRoutePosition)&&(identical(other.isFetchingRoute, isFetchingRoute) || other.isFetchingRoute == isFetchingRoute)&&(identical(other.routeError, routeError) || other.routeError == routeError)&&const DeepCollectionEquality().equals(other.stationRoutePoints, stationRoutePoints)&&(identical(other.isFetchingStationRoute, isFetchingStationRoute) || other.isFetchingStationRoute == isFetchingStationRoute)&&(identical(other.followTruck, followTruck) || other.followTruck == followTruck)&&(identical(other.selectedMapTypeIndex, selectedMapTypeIndex) || other.selectedMapTypeIndex == selectedMapTypeIndex)&&(identical(other.closeModals, closeModals) || other.closeModals == closeModals));
}


@override
int get hashCode => Object.hash(runtimeType,currentPosition,destination,const DeepCollectionEquality().hash(routePoints),lastRoutePosition,isFetchingRoute,routeError,const DeepCollectionEquality().hash(stationRoutePoints),isFetchingStationRoute,followTruck,selectedMapTypeIndex,closeModals);

@override
String toString() {
  return 'FireTruckState(currentPosition: $currentPosition, destination: $destination, routePoints: $routePoints, lastRoutePosition: $lastRoutePosition, isFetchingRoute: $isFetchingRoute, routeError: $routeError, stationRoutePoints: $stationRoutePoints, isFetchingStationRoute: $isFetchingStationRoute, followTruck: $followTruck, selectedMapTypeIndex: $selectedMapTypeIndex, closeModals: $closeModals)';
}


}

/// @nodoc
abstract mixin class $FireTruckStateCopyWith<$Res>  {
  factory $FireTruckStateCopyWith(FireTruckState value, $Res Function(FireTruckState) _then) = _$FireTruckStateCopyWithImpl;
@useResult
$Res call({
 LatLng? currentPosition, LatLng destination, List<LatLng> routePoints, LatLng? lastRoutePosition, bool isFetchingRoute, String? routeError, List<LatLng> stationRoutePoints, bool isFetchingStationRoute, bool followTruck, int selectedMapTypeIndex, bool closeModals
});




}
/// @nodoc
class _$FireTruckStateCopyWithImpl<$Res>
    implements $FireTruckStateCopyWith<$Res> {
  _$FireTruckStateCopyWithImpl(this._self, this._then);

  final FireTruckState _self;
  final $Res Function(FireTruckState) _then;

/// Create a copy of FireTruckState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPosition = freezed,Object? destination = null,Object? routePoints = null,Object? lastRoutePosition = freezed,Object? isFetchingRoute = null,Object? routeError = freezed,Object? stationRoutePoints = null,Object? isFetchingStationRoute = null,Object? followTruck = null,Object? selectedMapTypeIndex = null,Object? closeModals = null,}) {
  return _then(_self.copyWith(
currentPosition: freezed == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as LatLng?,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as LatLng,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<LatLng>,lastRoutePosition: freezed == lastRoutePosition ? _self.lastRoutePosition : lastRoutePosition // ignore: cast_nullable_to_non_nullable
as LatLng?,isFetchingRoute: null == isFetchingRoute ? _self.isFetchingRoute : isFetchingRoute // ignore: cast_nullable_to_non_nullable
as bool,routeError: freezed == routeError ? _self.routeError : routeError // ignore: cast_nullable_to_non_nullable
as String?,stationRoutePoints: null == stationRoutePoints ? _self.stationRoutePoints : stationRoutePoints // ignore: cast_nullable_to_non_nullable
as List<LatLng>,isFetchingStationRoute: null == isFetchingStationRoute ? _self.isFetchingStationRoute : isFetchingStationRoute // ignore: cast_nullable_to_non_nullable
as bool,followTruck: null == followTruck ? _self.followTruck : followTruck // ignore: cast_nullable_to_non_nullable
as bool,selectedMapTypeIndex: null == selectedMapTypeIndex ? _self.selectedMapTypeIndex : selectedMapTypeIndex // ignore: cast_nullable_to_non_nullable
as int,closeModals: null == closeModals ? _self.closeModals : closeModals // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FireTruckState].
extension FireTruckStatePatterns on FireTruckState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FireTruckState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FireTruckState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FireTruckState value)  $default,){
final _that = this;
switch (_that) {
case _FireTruckState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FireTruckState value)?  $default,){
final _that = this;
switch (_that) {
case _FireTruckState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LatLng? currentPosition,  LatLng destination,  List<LatLng> routePoints,  LatLng? lastRoutePosition,  bool isFetchingRoute,  String? routeError,  List<LatLng> stationRoutePoints,  bool isFetchingStationRoute,  bool followTruck,  int selectedMapTypeIndex,  bool closeModals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FireTruckState() when $default != null:
return $default(_that.currentPosition,_that.destination,_that.routePoints,_that.lastRoutePosition,_that.isFetchingRoute,_that.routeError,_that.stationRoutePoints,_that.isFetchingStationRoute,_that.followTruck,_that.selectedMapTypeIndex,_that.closeModals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LatLng? currentPosition,  LatLng destination,  List<LatLng> routePoints,  LatLng? lastRoutePosition,  bool isFetchingRoute,  String? routeError,  List<LatLng> stationRoutePoints,  bool isFetchingStationRoute,  bool followTruck,  int selectedMapTypeIndex,  bool closeModals)  $default,) {final _that = this;
switch (_that) {
case _FireTruckState():
return $default(_that.currentPosition,_that.destination,_that.routePoints,_that.lastRoutePosition,_that.isFetchingRoute,_that.routeError,_that.stationRoutePoints,_that.isFetchingStationRoute,_that.followTruck,_that.selectedMapTypeIndex,_that.closeModals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LatLng? currentPosition,  LatLng destination,  List<LatLng> routePoints,  LatLng? lastRoutePosition,  bool isFetchingRoute,  String? routeError,  List<LatLng> stationRoutePoints,  bool isFetchingStationRoute,  bool followTruck,  int selectedMapTypeIndex,  bool closeModals)?  $default,) {final _that = this;
switch (_that) {
case _FireTruckState() when $default != null:
return $default(_that.currentPosition,_that.destination,_that.routePoints,_that.lastRoutePosition,_that.isFetchingRoute,_that.routeError,_that.stationRoutePoints,_that.isFetchingStationRoute,_that.followTruck,_that.selectedMapTypeIndex,_that.closeModals);case _:
  return null;

}
}

}

/// @nodoc


class _FireTruckState implements FireTruckState {
  const _FireTruckState({this.currentPosition, this.destination = _kDefaultDestination, final  List<LatLng> routePoints = const [], this.lastRoutePosition, this.isFetchingRoute = false, this.routeError, final  List<LatLng> stationRoutePoints = const [], this.isFetchingStationRoute = false, this.followTruck = true, this.selectedMapTypeIndex = 0, this.closeModals = false}): _routePoints = routePoints,_stationRoutePoints = stationRoutePoints;
  

// ── Position ─────────────────────────────────────────────────────────────
@override final  LatLng? currentPosition;
// ── Destination ──────────────────────────────────────────────────────────
@override@JsonKey() final  LatLng destination;
// ── Firetruck route (live position → destination) ─────────────────────────
 final  List<LatLng> _routePoints;
// ── Firetruck route (live position → destination) ─────────────────────────
@override@JsonKey() List<LatLng> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override final  LatLng? lastRoutePosition;
@override@JsonKey() final  bool isFetchingRoute;
@override final  String? routeError;
// ── Fire station route (fire station → destination) ───────────────────────
/// Static route fetched once on startup — never changes during a dispatch.
 final  List<LatLng> _stationRoutePoints;
// ── Fire station route (fire station → destination) ───────────────────────
/// Static route fetched once on startup — never changes during a dispatch.
@override@JsonKey() List<LatLng> get stationRoutePoints {
  if (_stationRoutePoints is EqualUnmodifiableListView) return _stationRoutePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stationRoutePoints);
}

@override@JsonKey() final  bool isFetchingStationRoute;
// ── Camera / UI ───────────────────────────────────────────────────────────
@override@JsonKey() final  bool followTruck;
@override@JsonKey() final  int selectedMapTypeIndex;
@override@JsonKey() final  bool closeModals;

/// Create a copy of FireTruckState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FireTruckStateCopyWith<_FireTruckState> get copyWith => __$FireTruckStateCopyWithImpl<_FireTruckState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FireTruckState&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.destination, destination) || other.destination == destination)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.lastRoutePosition, lastRoutePosition) || other.lastRoutePosition == lastRoutePosition)&&(identical(other.isFetchingRoute, isFetchingRoute) || other.isFetchingRoute == isFetchingRoute)&&(identical(other.routeError, routeError) || other.routeError == routeError)&&const DeepCollectionEquality().equals(other._stationRoutePoints, _stationRoutePoints)&&(identical(other.isFetchingStationRoute, isFetchingStationRoute) || other.isFetchingStationRoute == isFetchingStationRoute)&&(identical(other.followTruck, followTruck) || other.followTruck == followTruck)&&(identical(other.selectedMapTypeIndex, selectedMapTypeIndex) || other.selectedMapTypeIndex == selectedMapTypeIndex)&&(identical(other.closeModals, closeModals) || other.closeModals == closeModals));
}


@override
int get hashCode => Object.hash(runtimeType,currentPosition,destination,const DeepCollectionEquality().hash(_routePoints),lastRoutePosition,isFetchingRoute,routeError,const DeepCollectionEquality().hash(_stationRoutePoints),isFetchingStationRoute,followTruck,selectedMapTypeIndex,closeModals);

@override
String toString() {
  return 'FireTruckState(currentPosition: $currentPosition, destination: $destination, routePoints: $routePoints, lastRoutePosition: $lastRoutePosition, isFetchingRoute: $isFetchingRoute, routeError: $routeError, stationRoutePoints: $stationRoutePoints, isFetchingStationRoute: $isFetchingStationRoute, followTruck: $followTruck, selectedMapTypeIndex: $selectedMapTypeIndex, closeModals: $closeModals)';
}


}

/// @nodoc
abstract mixin class _$FireTruckStateCopyWith<$Res> implements $FireTruckStateCopyWith<$Res> {
  factory _$FireTruckStateCopyWith(_FireTruckState value, $Res Function(_FireTruckState) _then) = __$FireTruckStateCopyWithImpl;
@override @useResult
$Res call({
 LatLng? currentPosition, LatLng destination, List<LatLng> routePoints, LatLng? lastRoutePosition, bool isFetchingRoute, String? routeError, List<LatLng> stationRoutePoints, bool isFetchingStationRoute, bool followTruck, int selectedMapTypeIndex, bool closeModals
});




}
/// @nodoc
class __$FireTruckStateCopyWithImpl<$Res>
    implements _$FireTruckStateCopyWith<$Res> {
  __$FireTruckStateCopyWithImpl(this._self, this._then);

  final _FireTruckState _self;
  final $Res Function(_FireTruckState) _then;

/// Create a copy of FireTruckState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPosition = freezed,Object? destination = null,Object? routePoints = null,Object? lastRoutePosition = freezed,Object? isFetchingRoute = null,Object? routeError = freezed,Object? stationRoutePoints = null,Object? isFetchingStationRoute = null,Object? followTruck = null,Object? selectedMapTypeIndex = null,Object? closeModals = null,}) {
  return _then(_FireTruckState(
currentPosition: freezed == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as LatLng?,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as LatLng,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<LatLng>,lastRoutePosition: freezed == lastRoutePosition ? _self.lastRoutePosition : lastRoutePosition // ignore: cast_nullable_to_non_nullable
as LatLng?,isFetchingRoute: null == isFetchingRoute ? _self.isFetchingRoute : isFetchingRoute // ignore: cast_nullable_to_non_nullable
as bool,routeError: freezed == routeError ? _self.routeError : routeError // ignore: cast_nullable_to_non_nullable
as String?,stationRoutePoints: null == stationRoutePoints ? _self._stationRoutePoints : stationRoutePoints // ignore: cast_nullable_to_non_nullable
as List<LatLng>,isFetchingStationRoute: null == isFetchingStationRoute ? _self.isFetchingStationRoute : isFetchingStationRoute // ignore: cast_nullable_to_non_nullable
as bool,followTruck: null == followTruck ? _self.followTruck : followTruck // ignore: cast_nullable_to_non_nullable
as bool,selectedMapTypeIndex: null == selectedMapTypeIndex ? _self.selectedMapTypeIndex : selectedMapTypeIndex // ignore: cast_nullable_to_non_nullable
as int,closeModals: null == closeModals ? _self.closeModals : closeModals // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
