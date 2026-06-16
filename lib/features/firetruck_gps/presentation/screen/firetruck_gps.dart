import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/geolocator/getCurrentLocation.dart';
import '../../../../shared/theme/app_theme.dart';
import '../controller/notifier.dart';
import '../providers/assignment_provider.dart';
import '../widgets/dispatch_fab.dart';
import '../widgets/firetruck_map.dart';
import '../widgets/location_publishing_gate.dart';
import '../widgets/profile_dropdown.dart';

class FiretruckGPSPage extends ConsumerStatefulWidget {
  const FiretruckGPSPage({super.key});

  @override
  ConsumerState<FiretruckGPSPage> createState() => _FiretruckGPSPageState();
}

class _FiretruckGPSPageState extends ConsumerState<FiretruckGPSPage> {
  bool _isRefreshing = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
 
      ref
        ..invalidate(fireTruckNotifierProvider)
        ..invalidate(locationStreamProvider)
        ..invalidate(firetruckAssignmentRealtimeProvider)
        ..invalidate(myAssignedTruckIdProvider);

      // Wait a moment to ensure the refresh is visible
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentAsync = ref.watch(firetruckAssignmentRealtimeProvider);
    final truckIdAsync = ref.watch(myAssignedTruckIdProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: _isRefreshing
              ? SizedBox(
                  width: context.responsiveValue(
                    small: 16.0,
                    medium: 20.0,
                    large: 24.0,
                    extraLarge: 24.0,
                  ),
                  height: context.responsiveValue(
                    small: 16.0,
                    medium: 20.0,
                    large: 24.0,
                    extraLarge: 24.0,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.textWhite,
                    ),
                  ),
                )
              : Icon(
                  Icons.refresh,
                  size: context.responsiveIconSize(
                    small: AppTheme.iconSize20,
                    medium: AppTheme.iconSize24,
                    large: AppTheme.iconSize24,
                    extraLarge: AppTheme.iconSize24,
                  ),
                ),
          onPressed: _isRefreshing ? null : _refreshData,
        ),
        title: const Text('Firetruck GPS').tr(),
        centerTitle: true,
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: AppTheme.textWhite,
        actions: const [ProfileDropdown()],
      ),
      // The gate must wrap *every* path of the body so the publisher keeps
      // running even when the body shows the "no incident" or "loading" state.
      body: _isRefreshing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryRed,
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveValue(
                      small: AppTheme.spacing12,
                      medium: AppTheme.spacing16,
                      large: AppTheme.spacing20,
                      extraLarge: AppTheme.spacing20,
                    ),
                  ),
                  Text(
                    'Refreshing data...',
                    style: context.responsiveBodyText(
                      fontSizeSmall: AppTheme.fontSize14,
                      fontSizeMedium: AppTheme.fontSize16,
                      fontSizeLarge: AppTheme.fontSize18,
                      fontSizeExtraLarge: AppTheme.fontSize18,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : LocationPublishingGate(
              child: _GpsBody(
                assignmentAsync: assignmentAsync,
                truckIdAsync: truckIdAsync,
              ),
            ),
    );
  }
}

class _GpsBody extends StatelessWidget {
  const _GpsBody({required this.assignmentAsync, required this.truckIdAsync});

  final AsyncValue<FiretruckAssignment?> assignmentAsync;
  final AsyncValue<String?> truckIdAsync;

  @override
  Widget build(BuildContext context) {
    return assignmentAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
        ),
      ),
      error: (error, _) => _ErrorMessage(
        message: error.toString().replaceFirst('Exception: ', ''),
      ),
      data: (assignment) {
        if (assignment != null) {
          return Stack(
            children: <Widget>[
              FiretruckMap(
                truckId: assignment.truckId,
                destination: assignment.destination,
              ),

              const DispatchFab(),
            ],
          );
        }

        // No active incident — but we may still know the truck id, in which
        // case the publisher is already broadcasting the driver's location
        // as `available`. Show a friendlier message instead of an error.
        return _StandbyMessage(truckIdAsync: truckIdAsync);
      },
      skipLoadingOnReload: true,
    );
  }
}

class _StandbyMessage extends StatelessWidget {
  const _StandbyMessage({required this.truckIdAsync});

  final AsyncValue<String?> truckIdAsync;

  @override
  Widget build(BuildContext context) {
    final truckId = truckIdAsync.value;
    final headline = truckId != null
        ? 'Standing by — your location is being shared.'
        : 'Waiting for truck assignment…';
    final subhead = truckId != null
        ? 'No active incident. Truck $truckId is available.'
        : 'You will appear on the dispatcher map once a truck is assigned.';

    return Center(
      child: Padding(
        padding: context.responsivePadding(
          small: EdgeInsets.all(AppTheme.spacing16),
          medium: EdgeInsets.all(AppTheme.spacing20),
          large: EdgeInsets.all(AppTheme.spacing24),
          extraLarge: EdgeInsets.all(AppTheme.spacing28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              truckId != null ? Icons.gps_fixed : Icons.local_fire_department,
              size: context.responsiveIconSize(
                small: AppTheme.iconSize32,
                medium: AppTheme.iconSize40,
                large: AppTheme.iconSize48,
                extraLarge: AppTheme.iconSize48,
              ),
              color: AppTheme.primaryRed,
            ),
            SizedBox(
              height: context.responsiveValue(
                small: AppTheme.spacing12,
                medium: AppTheme.spacing16,
                large: AppTheme.spacing20,
                extraLarge: AppTheme.spacing24,
              ),
            ),
            Text(
              headline,
              textAlign: TextAlign.center,
              style: context.responsiveBodyText(
                fontSizeSmall: AppTheme.fontSize16,
                fontSizeMedium: AppTheme.fontSize18,
                fontSizeLarge: AppTheme.fontSize20,
                fontSizeExtraLarge: AppTheme.fontSize22,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                small: AppTheme.spacing6,
                medium: AppTheme.spacing8,
                large: AppTheme.spacing10,
                extraLarge: AppTheme.spacing12,
              ),
            ),
            Text(
              subhead,
              textAlign: TextAlign.center,
              style: context.responsiveBodyText(
                fontSizeSmall: AppTheme.fontSize14,
                fontSizeMedium: AppTheme.fontSize16,
                fontSizeLarge: AppTheme.fontSize18,
                fontSizeExtraLarge: AppTheme.fontSize18,
                color: AppTheme.errorRed.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsivePadding(
          small: EdgeInsets.all(AppTheme.spacing16),
          medium: EdgeInsets.all(AppTheme.spacing20),
          large: EdgeInsets.all(AppTheme.spacing24),
          extraLarge: EdgeInsets.all(AppTheme.spacing28),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: context.responsiveBodyText(
            fontSizeSmall: AppTheme.fontSize14,
            fontSizeMedium: AppTheme.fontSize16,
            fontSizeLarge: AppTheme.fontSize18,
            fontSizeExtraLarge: AppTheme.fontSize18,
            color: AppTheme.errorRed,
          ),
        ),
      ),
    );
  }
}
