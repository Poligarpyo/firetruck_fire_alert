import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../shared/constants/strings.dart';
import '../../domain/entities/firetruck_status.dart';
import '../providers/firetruck_location_providers.dart';
import 'state.dart';

const double _kFollowZoom = 20.0;
const double _kBoundsPadding = 80.0;
DateTime? _lastCameraMove;
// ✅ FIX 1: 30 m threshold — truck at 60 km/h covers this in ~2 s,
// so the route stays tight to the road as the truck moves.
const double _kRouteRefreshMeters = 80;

BitmapDescriptor? _fireStationIcon;
BitmapDescriptor? _fireIcon;
const LatLng _kFireStation = LatLng(10.824424, 119.509337);

class FireTruckNotifier extends StateNotifier<FireTruckState> {
  FireTruckNotifier(this.ref)
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
      super(const FireTruckState());
  final Ref ref;
  final Dio _dio;

  GoogleMapController? _mapController;
  bool _initialBoundsFitted = false;
  String? _publishingTruckId;

  // ─── Map controller ────────────────────────────────────────────────────────

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (state.currentPosition != null && !_initialBoundsFitted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _fitBounds(state.currentPosition!, state.destination);
        _initialBoundsFitted = true;
      });
    }

    _fetchStationRoute();
  }

  // ─── Camera controls ───────────────────────────────────────────────────────

  void zoomIn() => _mapController?.animateCamera(CameraUpdate.zoomIn());

  void zoomOut() => _mapController?.animateCamera(CameraUpdate.zoomOut());

  void centerOnCurrentLocation() {
    if (state.currentPosition == null) return;
    state = state.copyWith(followTruck: true);
    _animateTo(state.currentPosition!, zoom: _kFollowZoom);
  }

  void fitBothMarkers() {
    if (state.currentPosition == null) return;
    state = state.copyWith(followTruck: false);
    _fitBounds(state.currentPosition!, state.destination);
  }

  void onCameraMoveStarted() {
    if (state.followTruck) state = state.copyWith(followTruck: false);
  }

  // ─── Publisher lifecycle ───────────────────────────────────────────────────

  Future<void> startPublishing(
    String truckId, {
    FiretruckStatus initialStatus = FiretruckStatus.enroute,
  }) async {
    if (_publishingTruckId == truckId) return;
    _publishingTruckId = truckId;
    try {
      await ref
          .read(firetruckLocationPublisherProvider)
          .start(truckId, initialStatus: initialStatus);
    } catch (e) {
      debugPrint('[FireTruckNotifier] startPublishing failed: $e');
      // Don't reset _publishingTruckId on error to allow retry
    }
  }

  Future<void> stopPublishing() async {
    if (_publishingTruckId == null) return;
    _publishingTruckId = null;
    try {
      await ref.read(firetruckLocationPublisherProvider).stop();
    } catch (e) {
      debugPrint('[FireTruckNotifier] stopPublishing failed: $e');
    }
  }

  // ─── Position updates ─────────────────────────────────────────────────────

  // ✅ FIX 2: Accept `heading` from the GPS Position object.
  // Without heading the API doesn't know which way the truck faces and may
  // route it backwards or pick the wrong lane at an intersection.
  void onPositionUpdated(
    LatLng current,
    LatLng destination,
    String truckId, {
    double heading = -1, // Geolocator returns -1 when unavailable/stationary
  }) {
    final isFirst = state.currentPosition == null;
    final destinationChanged = state.destination != destination;

    state = state.copyWith(currentPosition: current, destination: destination);

    if (isFirst && _mapController != null && !_initialBoundsFitted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _fitBounds(current, destination);
        _initialBoundsFitted = true;
      });
    }

    if (state.followTruck) {
      final now = DateTime.now();

      if (_lastCameraMove == null ||
          now.difference(_lastCameraMove!) >
              const Duration(milliseconds: 800)) {
        _lastCameraMove = now;
        _animateTo(current);
      }
    }

    if (_publishingTruckId != truckId) {
      unawaited(startPublishing(truckId));
    }

    _fetchFastestRouteIfNeeded(
      current,
      destination,
      heading: heading,
      force: isFirst || destinationChanged,
    );
  }

  // ─── Fire station → destination route (fetched once) ─────────────────────

  Future<void> _fetchStationRoute() async {
    if (state.isFetchingStationRoute || state.stationRoutePoints.isNotEmpty) {
      return;
    }

    state = state.copyWith(isFetchingStationRoute: true);

    try {
      final points = await _fetchRoute(_kFireStation, state.destination);
      state = state.copyWith(stationRoutePoints: points);
      debugPrint('[FireTruckNotifier] Station route: ${points.length} points');
    } catch (e) {
      debugPrint('[FireTruckNotifier] Station route error: $e');
    } finally {
      state = state.copyWith(isFetchingStationRoute: false);
    }
  }

  void resetCloseModals() {
    state = state.copyWith(closeModals: false);
  }

  Future<void> _fetchFastestRouteIfNeeded(
    LatLng current,
    LatLng destination, {
    double heading = -1,
    bool force = false,
  }) async {
    if (state.isFetchingRoute) return;

    if (!force && state.lastRoutePosition != null) {
      final moved = Geolocator.distanceBetween(
        state.lastRoutePosition!.latitude,
        state.lastRoutePosition!.longitude,
        current.latitude,
        current.longitude,
      );
      if (moved < _kRouteRefreshMeters) return;
    }

    // 2. In _fetchFastestRouteIfNeeded — add a hard timeout as a last resort
    state = state.copyWith(isFetchingRoute: true, routeError: null);
    try {
      final points = await _fetchRoute(current, destination).timeout(
        const Duration(seconds: 12),
        onTimeout: () => throw Exception(
          'Route fetch timed out. Please check your internet connection.',
        ),
      );
      state = state.copyWith(
        routePoints: points,
        lastRoutePosition: current,
        isFetchingRoute: false,
      );
      debugPrint('[FireTruckNotifier] Fastest route: ${points.length} points');
    } catch (e) {
      final errorMessage = _getUserFriendlyRouteError(e);
      state = state.copyWith(isFetchingRoute: false, routeError: errorMessage);
      debugPrint('[FireTruckNotifier] Fastest route error: $e');
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  String _getUserFriendlyRouteError(Object error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('timeout') || errorString.contains('timed out')) {
      return 'Route calculation timed out. Please check your internet connection and try again.';
    }
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    if (errorString.contains('api key') ||
        errorString.contains('unauthorized')) {
      return 'Maps service unavailable. Please contact your administrator.';
    }
    if (errorString.contains('not found') || errorString.contains('no route')) {
      return 'Unable to find a route to this location. Please check the address.';
    }
    if (errorString.contains('quota') || errorString.contains('limit')) {
      return 'Maps service temporarily unavailable. Please try again later.';
    }

    return 'Unable to calculate route. Please check your internet connection and try again.';
  }

  // ─── Routes API ────────────────────────────────────────────────────────────

  // 3. Replace the entire _fetchRoute method
  Future<List<LatLng>> _fetchRoute(LatLng origin, LatLng destination) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.trim().isEmpty) {
      throw Exception(
        'Google Maps API key is missing. Please contact your administrator.',
      );
    }

    Response<Map<String, dynamic>> response;
    try {
      response = await _dio.post<Map<String, dynamic>>(
        Strings.kRoutesApiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': apiKey.trim(),
            'X-Goog-FieldMask':
                'routes.duration,'
                'routes.distanceMeters,'
                'routes.polyline.encodedPolyline',
          },
        ),
        data: {
          'origin': {
            'location': {
              'latLng': {
                'latitude': origin.latitude,
                'longitude': origin.longitude,
              },
            },
          },
          'destination': {
            'location': {
              'latLng': {
                'latitude': destination.latitude,
                'longitude': destination.longitude,
              },
            },
          },
          'travelMode': 'DRIVE',
          'routingPreference': 'TRAFFIC_AWARE_OPTIMAL',
          'computeAlternativeRoutes': true,
          'polylineQuality': 'HIGH_QUALITY',
        },
      );
    } on DioException catch (e) {
      // Log the full response body — this is where you'll see the real error
      // e.g. "API not enabled", "billing not set up", "invalid field mask", etc.
      final body = e.response?.data;
      debugPrint(
        '[FireTruckNotifier] Routes API HTTP error: '
        '${e.response?.statusCode} — $body',
      );
      throw Exception(
        'Unable to get route. Please check your internet connection and try again.',
      );
    }

    final routes = response.data?['routes'] as List<dynamic>?;

    if (routes == null || routes.isEmpty) {
      debugPrint('[FireTruckNotifier] Routes API body: ${response.data}');
      throw Exception(
        'No route found between these locations. Please check the addresses.',
      );
    }

    final route = routes[0] as Map<String, dynamic>;

    // Try step-level polylines first (highest detail)
    // final legs = route['legs'] as List<dynamic>?;
    // if (legs != null && legs.isNotEmpty) {
    //   final allStepPoints = <LatLng>[];
    //   for (final leg in legs) {
    //     final steps = leg['steps'] as List<dynamic>?;
    //     if (steps == null) continue;
    //     for (final step in steps) {
    //       final encoded = step['polyline']?['encodedPolyline'] as String?;
    //       if (encoded != null && encoded.isNotEmpty) {
    //         allStepPoints.addAll(_decodePolyline(encoded));
    //       }
    //     }
    //   }
    //   if (allStepPoints.isNotEmpty) {
    //     debugPrint(
    //       '[FireTruckNotifier] Step polylines: ${allStepPoints.length} pts',
    //     );
    //     return allStepPoints;
    //   }
    // }

    // Safe fallback to overview polyline
    final polylineMap = route['polyline'] as Map<String, dynamic>?;
    final encoded = polylineMap?['encodedPolyline'] as String?;
    if (encoded != null && encoded.isNotEmpty) {
      debugPrint('[FireTruckNotifier] Using overview polyline fallback');
      return _decodePolyline(encoded);
    }

    // Log the full response so you can see exactly what came back
    debugPrint('[FireTruckNotifier] Full route response: $route');
    throw Exception(
      'Unable to calculate route. Please check your internet connection and try again.',
    );
  }
  // ─── Polyline decoder ──────────────────────────────────────────────────────

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0;
    final int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _fitBounds(LatLng a, LatLng b) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        a.latitude < b.latitude ? a.latitude : b.latitude,
        a.longitude < b.longitude ? a.longitude : b.longitude,
      ),
      northeast: LatLng(
        a.latitude > b.latitude ? a.latitude : b.latitude,
        a.longitude > b.longitude ? a.longitude : b.longitude,
      ),
    );
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, _kBoundsPadding),
    );
  }

  void _animateTo(LatLng target, {double? zoom}) {
    if (zoom != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, zoom));
    } else {
      _mapController?.animateCamera(CameraUpdate.newLatLng(target));
    }
  }

  Set<Marker> get staticMarkers => {
    Marker(
      markerId: const MarkerId('destination'),
      position: state.destination,
      icon:
          _fireIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Fire Location'),
    ),
    Marker(
      markerId: const MarkerId('fire_station'),
      position: _kFireStation,
      icon:
          _fireStationIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Fire Station'),
    ),
  };

  @override
  void dispose() {
    unawaited(stopPublishing());
    _mapController?.dispose();
    super.dispose();
  }
}

final fireTruckNotifierProvider =
    StateNotifierProvider<FireTruckNotifier, FireTruckState>(
      (ref) => FireTruckNotifier(ref),
    );
