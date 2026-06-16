import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'state.freezed.dart';

const LatLng _kDefaultDestination =
    LatLng(10.824579357750448, 119.51540299564952);

@freezed
abstract class FireTruckState with _$FireTruckState {
  const factory FireTruckState({
    // ── Position ─────────────────────────────────────────────────────────────
    LatLng? currentPosition,

    // ── Destination ──────────────────────────────────────────────────────────
    @Default(_kDefaultDestination) LatLng destination,

    // ── Firetruck route (live position → destination) ─────────────────────────
    @Default([]) List<LatLng> routePoints,
    LatLng? lastRoutePosition,
    @Default(false) bool isFetchingRoute,
    String? routeError,

    // ── Fire station route (fire station → destination) ───────────────────────
    /// Static route fetched once on startup — never changes during a dispatch.
    @Default([]) List<LatLng> stationRoutePoints,
    @Default(false) bool isFetchingStationRoute,

    // ── Camera / UI ───────────────────────────────────────────────────────────
    @Default(true) bool followTruck,
    @Default(0) int selectedMapTypeIndex,
    @Default(false) bool closeModals,
  }) = _FireTruckState;
}