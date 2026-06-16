import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../shared/theme/app_theme.dart';

class LatLngDisplay extends StatelessWidget {
  final AsyncValue<Position> locationAsync;
  final double edgeInset;
  const LatLngDisplay({
    super.key,
    required this.locationAsync,
    required this.edgeInset,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:
          MediaQuery.paddingOf(context).top +
          context.responsiveValue(
            small: 60.0,
            medium: 70.0,
            large: 80.0,
            extraLarge: 90.0,
          ),
      left: edgeInset,
      child: Container(
        padding: EdgeInsets.all(
          context.responsiveValue(
            small: AppTheme.spacing8,
            medium: AppTheme.spacing10,
            large: AppTheme.spacing12,
            extraLarge: AppTheme.spacing14,
          ),
        ),
        decoration: BoxDecoration(
          color: AppTheme.textPrimary.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppTheme.radius8),
        ),
        child: locationAsync.when(
          data: (position) => Text(
            'Lat: ${position.latitude.toStringAsFixed(6)}\n'
            'Lng: ${position.longitude.toStringAsFixed(6)}',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textWhite),
          ),
          loading: () => Text(
            'Getting location...',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textWhite),
          ),
          error: (e, _) => Text(
            'Error: $e',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.errorRed),
          ),
        ),
      ),
    );
  }
}
