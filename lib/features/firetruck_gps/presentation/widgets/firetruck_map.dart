import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/geolocator/getCurrentLocation.dart';
import '../../domain/constants/destination_arrival_radius.dart';
import '../controller/notifier.dart';
import 'follow_badge.dart';
import 'latlng_display.dart';
import 'map_controls.dart';
import 'map_legend.dart';
import '../../../../shared/theme/app_theme.dart';

// const LatLng _kFireStation = LatLng(10.824424, 119.509337);

class FiretruckMap extends ConsumerStatefulWidget {
  /// The truck's unique ID — used as the RTDB key.
  /// Pass the authenticated user's UID or your own truck ID here.
  final String truckId;
  final LatLng destination;

  const FiretruckMap({
    super.key,
    required this.truckId,
    required this.destination,
  });

  @override
  ConsumerState<FiretruckMap> createState() => _FiretruckMapState();
}

class _FiretruckMapState extends ConsumerState<FiretruckMap> {
  BitmapDescriptor? _firetruckIcon;
  // BitmapDescriptor? _fireStationIcon;
  BitmapDescriptor? _fireIcon;
  bool _markerIconsScheduled = false;
  bool _destinationArrivalDialogShown = false;

  @override
  void initState() {
    super.initState();
    // Riverpod 3: `ref.listen` in build does NOT run for the current value, only
    // on later changes — so GPS could already be AsyncData and we'd never call
    // `onPositionUpdated` (no markers / route). listenManual + fireImmediately
    // applies the latest fix as soon as the map mounts.
    ref.listenManual<AsyncValue<Position>>(
      locationStreamProvider,
      (_, AsyncValue<Position> next) => _onLocationStreamUpdate(next),
      fireImmediately: true,
    );
  }

  void _onLocationStreamUpdate(AsyncValue<Position> next) {
    next.whenData((Position position) {
      // Never call `onPositionUpdated` (mutates providers) from initState /
      // synchronous listen callbacks — Riverpod forbids writes during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final notifier = ref.read(fireTruckNotifierProvider.notifier);
        final latLng = LatLng(position.latitude, position.longitude);
        notifier.onPositionUpdated(
          latLng,
          widget.destination,
          widget.truckId,
          heading: position.heading,
        );

        if (_destinationArrivalDialogShown) return;
        final distanceMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          widget.destination.latitude,
          widget.destination.longitude,
        );
        if (distanceMeters > kDestinationArrivalRadiusMeters) return;
        _destinationArrivalDialogShown = true;
        unawaited(_showDestinationArrivedDialog());
      });
    });
  }

  @override
  void didUpdateWidget(covariant FiretruckMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final LatLng oldDest = oldWidget.destination;
    final LatLng newDest = widget.destination;
    if (oldWidget.truckId != widget.truckId ||
        oldDest.latitude != newDest.latitude ||
        oldDest.longitude != newDest.longitude) {
      _destinationArrivalDialogShown = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Marker builders use context.responsiveValue → MediaQuery; that is invalid
    // from initState(), so start them here once dependencies are available.
    if (!_markerIconsScheduled) {
      _markerIconsScheduled = true;
      _buildFiretruckMarkerIcon();
      // _buildFireStationIcon();
      _buildFireIcon();
    }
  }

  // ─── Responsive helpers ───────────────────────────────────────────────────

  double get _badgeFontSize {
    return context.responsiveValue(
      small: AppTheme.fontSize11,
      medium: AppTheme.fontSize13,
      large: AppTheme.fontSize14,
      extraLarge: AppTheme.fontSize16,
    );
  }

  double get _badgeIconSize {
    return context.responsiveIconSize(
      small: AppTheme.iconSize12,
      medium: AppTheme.iconSize16,
      large: AppTheme.iconSize20,
      extraLarge: AppTheme.iconSize24,
    );
  }

  double get _badgePaddingH {
    return context.responsiveValue(
      small: AppTheme.spacing10,
      medium: AppTheme.spacing14,
      large: AppTheme.spacing16,
      extraLarge: AppTheme.spacing20,
    );
  }

  double get _badgePaddingV {
    return context.responsiveValue(
      small: AppTheme.spacing4,
      medium: AppTheme.spacing6,
      large: AppTheme.spacing8,
      extraLarge: AppTheme.spacing8,
    );
  }

  double get _controlSpacing {
    return context.responsiveValue(
      small: AppTheme.spacing6,
      medium: AppTheme.spacing8,
      large: AppTheme.spacing10,
      extraLarge: AppTheme.spacing12,
    );
  }

  double get _edgeInset {
    return context.responsiveValue(
      small: AppTheme.spacing10,
      medium: AppTheme.spacing16,
      large: AppTheme.spacing20,
      extraLarge: AppTheme.spacing24,
    );
  }

  double get _bottomInset {
    double baseBottomInset = MediaQuery.paddingOf(context).bottom;
    return baseBottomInset +
        context.responsiveValue(
          small: AppTheme.spacing10,
          medium: AppTheme.spacing16,
          large: AppTheme.spacing20,
          extraLarge: AppTheme.spacing24,
        );
  }

  // ─── Marker icon builders ─────────────────────────────────────────────────

  Future<void> _buildMarkerIcon({
    required Color circleColor,
    required Color bgColor,
    required IconData icon,
    required void Function(BitmapDescriptor) onDone,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(96, 96);
    final center = Offset(size.width / 2, size.height / 2);

    canvas
      ..drawCircle(center, 48, Paint()..color = circleColor)
      ..drawCircle(center, 34, Paint()..color = bgColor)
      ..drawCircle(
        center,
        34,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );

    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: context.responsiveValue(
            small: 28,
            medium: 32,
            large: 36,
            extraLarge: 40,
          ),
          fontFamily: icon.fontFamily,
          color: AppTheme.textWhite,
        ),
      )
      ..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(96, 96);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if (mounted) {
      setState(
        () => onDone(BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List())),
      );
    }
  }

  Future<void> _buildFiretruckMarkerIcon() => _buildMarkerIcon(
    circleColor: AppTheme.primaryRed.withValues(alpha: 0.2),
    bgColor: AppTheme.primaryRed,
    icon: Icons.fire_truck,
    onDone: (d) => _firetruckIcon = d,
  );

  // Future<void> _buildFireStationIcon() => _buildMarkerIcon(
  //   circleColor: Colors.blue.withOpacity(0.2),
  //   bgColor: Colors.blue.shade700,
  //   icon: Icons.location_city,
  //   onDone: (d) => _fireStationIcon = d,
  // );

  Future<void> _buildFireIcon() => _buildMarkerIcon(
    circleColor: AppTheme.primaryRed.withValues(alpha: 0.3),
    bgColor: AppTheme.primaryRed,
    icon: Icons.local_fire_department,
    onDone: (d) => _fireIcon = d,
  );

  // ─── Markers ─────────────────────────────────────────────────────────────

  Set<Marker> _buildMarkers(LatLng current) => {
    // Marker(
    //   markerId: const MarkerId('fire_station'),
    //   position: _kFireStation,
    //   icon:
    //       _fireStationIcon ??
    //       BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    //   infoWindow: const InfoWindow(title: 'Fire Station'),
    // ),
    Marker(
      markerId: const MarkerId('firetruck'),
      position: current,
      icon:
          _firetruckIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Firetruck'),
    ),
    Marker(
      markerId: const MarkerId('destination'),
      position: widget.destination,
      icon:
          _fireIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Fire Location'),
    ),
  };

  Future<void> _showDestinationArrivedDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Icon(Icons.flag_circle, color: AppTheme.primaryRed, size: 40),
          title: Text('destination_arrived_title'.tr()),
          content: Text('destination_arrived_message'.tr()),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: AppTheme.textWhite,
              ),
              child: Text('destination_arrived_ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(fireTruckNotifierProvider.notifier);
    final truckState = ref.watch(fireTruckNotifierProvider);
    final locationAsync = ref.watch(locationStreamProvider);

    final currentPosition = truckState.currentPosition ?? widget.destination;

    return LayoutBuilder(
      builder: (context, _) => Stack(
        children: [
          // ── Google Map ────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 13,
            ),
            mapType: MapType.normal,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: truckState.currentPosition != null
                ? _buildMarkers(truckState.currentPosition!)
                : notifier.staticMarkers,
            polylines: {
              if (truckState.routePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('fastest_route'),
                  points: truckState.routePoints,
                  color: AppTheme.infoBlue,
                  width: 5,
                ),
              // Todo: Uncomment mo lang to kapag Gusto mo my static na line sa Firestation to Fire Destination
              // if (truckState.stationRoutePoints.isNotEmpty)
              //   Polyline(
              //     polylineId: const PolylineId('station_route'),
              //     points: truckState.stationRoutePoints,
              //     color: Colors.orange,
              //     width: 4,
              //     patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              //   ),
            },
            onMapCreated: notifier.onMapCreated,
            onCameraMoveStarted: notifier.onCameraMoveStarted,
          ),

          // ── Route legend ──────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.paddingOf(context).top + _edgeInset,
            left: _edgeInset,
            child: MapLegend(truckState: truckState),
          ),

          // ── Lat/Lng display ───────────────────────────────────────────────
          LatLngDisplay(locationAsync: locationAsync, edgeInset: _edgeInset),

          // ── Follow badge ──────────────────────────────────────────────────
          FollowBadge(
            truckState: truckState,
            onTap: notifier.centerOnCurrentLocation,
            edgeInset: _edgeInset,
            bottomInset: _bottomInset,
            badgePaddingH: _badgePaddingH,
            badgePaddingV: _badgePaddingV,
            badgeIconSize: _badgeIconSize,
            badgeFontSize: _badgeFontSize,
            isSmallScreen: context.isSmallScreen,
          ),

          // ── Zoom + locate controls ────────────────────────────────────────
          MapControls(
            zoomIn: notifier.zoomIn,
            zoomOut: notifier.zoomOut,
            center: notifier.centerOnCurrentLocation,
            fitBounds: notifier.fitBothMarkers,
            edgeInset: _edgeInset,
            controlSpacing: _controlSpacing,
          ),
        ],
      ),
    );
  }
}
