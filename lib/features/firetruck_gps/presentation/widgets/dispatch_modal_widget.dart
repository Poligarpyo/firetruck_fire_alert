import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/dispatch_feed_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/firetruck_location_providers.dart';

class DispatchModalWidget extends ConsumerWidget {
  const DispatchModalWidget({
    super.key,
    required this.dispatch,
    required this.scrollController, // add this
  });

  final DispatchInfo dispatch;
  final ScrollController scrollController; // add this

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: context.responsivePadding(
            small: const EdgeInsets.all(AppTheme.spacing16),
            medium: const EdgeInsets.all(AppTheme.spacing20),
            large: const EdgeInsets.all(AppTheme.spacing24),
            extraLarge: const EdgeInsets.all(AppTheme.spacing28),
          ),
          decoration: const BoxDecoration(
            color: AppTheme.errorRed,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radius20),
              topRight: Radius.circular(AppTheme.radius20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppTheme.iconSize40,
                height: 4,
                margin: EdgeInsets.only(bottom: AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.textWhite.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing8),
                    decoration: BoxDecoration(
                      color: AppTheme.textWhite.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radius8),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: AppTheme.textWhite,
                      size: context.responsiveIconSize(
                        small: AppTheme.iconSize16,
                        medium: AppTheme.iconSize20,
                        large: AppTheme.iconSize24,
                        extraLarge: AppTheme.iconSize24,
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Text(
                    'DISPATCH REPORT',
                    style: AppTheme.h6.copyWith(
                      color: AppTheme.textWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Scrollable body ──────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: context.responsivePadding(
              small: EdgeInsets.all(AppTheme.spacing16),
              medium: EdgeInsets.all(AppTheme.spacing20),
              large: EdgeInsets.all(AppTheme.spacing24),
              extraLarge: EdgeInsets.all(AppTheme.spacing28),
            ),
            child: Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController, // ← key change
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppTheme.spacing12),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryOrange.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius8,
                            ),
                            border: Border.all(
                              color: AppTheme.secondaryOrange.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.priority_high,
                                color: AppTheme.secondaryOrange,
                                size: context.responsiveIconSize(
                                  small: AppTheme.iconSize16,
                                  medium: AppTheme.iconSize20,
                                  large: AppTheme.iconSize24,
                                  extraLarge: AppTheme.iconSize24,
                                ),
                              ),
                              SizedBox(width: AppTheme.spacing8),
                              Expanded(
                                child: Text(
                                  'Dispatched by: Fire Department Control Center',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.secondaryOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing20),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: AppTheme.primaryRed,
                              size: context.responsiveIconSize(
                                small: AppTheme.iconSize16,
                                medium: AppTheme.iconSize20,
                                large: AppTheme.iconSize24,
                                extraLarge: AppTheme.iconSize24,
                              ),
                            ),
                            SizedBox(width: AppTheme.spacing12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reported by: ${dispatch.reporterName}',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: AppTheme.spacing6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppTheme.spacing8,
                                          vertical: AppTheme.spacing4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryRed,
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radius6,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.sms,
                                              color: AppTheme.textWhite,
                                              size: context.responsiveIconSize(
                                                small: AppTheme.iconSize12,
                                                medium: AppTheme.iconSize12,
                                                large: AppTheme.iconSize14,
                                                extraLarge: AppTheme.iconSize14,
                                              ),
                                            ),
                                            SizedBox(width: AppTheme.spacing4),
                                            Text(
                                              dispatch.source,
                                              style: AppTheme.overline.copyWith(
                                                color: AppTheme.textWhite,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: AppTheme.spacing12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: AppTheme.textSecondary,
                                            size: context.responsiveIconSize(
                                              small: AppTheme.iconSize14,
                                              medium: AppTheme.iconSize16,
                                              large: AppTheme.iconSize18,
                                              extraLarge: AppTheme.iconSize18,
                                            ),
                                          ),
                                          SizedBox(width: AppTheme.spacing4),
                                          Text(
                                            dispatch.reporterPhone ??
                                                'No phone provided',
                                            style: AppTheme.bodySmall.copyWith(
                                              color: AppTheme.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing20),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppTheme.primaryRed,
                              size: context.responsiveIconSize(
                                small: AppTheme.iconSize16,
                                medium: AppTheme.iconSize20,
                                large: AppTheme.iconSize24,
                                extraLarge: AppTheme.iconSize24,
                              ),
                            ),
                            SizedBox(width: AppTheme.spacing12),
                            Text(
                              'Dispatch Time: ${dispatch.createdAt != null ? DateFormat('MMM d, y • h:mm a').format(dispatch.createdAt!) : 'N/A'}',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing20),
                        Text(
                          'Incident Details',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing8),
                        Text(
                          dispatch.details,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        if (dispatch.photoUrl != null &&
                            dispatch.photoUrl!.isNotEmpty) ...[
                          SizedBox(height: AppTheme.spacing16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius12,
                            ),
                            child: Image.network(
                              dispatch.photoUrl!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: AppTheme.surfaceGrey,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppTheme.primaryRed,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (_, __, ___) => Container(
                                height: 180,
                                width: double.infinity,
                                color: AppTheme.surfaceGrey,
                                alignment: Alignment.center,
                                child: Text(
                                  'Unable to load photo',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: AppTheme.spacing20),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppTheme.errorRed,
                              size: context.responsiveIconSize(
                                small: AppTheme.iconSize16,
                                medium: AppTheme.iconSize20,
                                large: AppTheme.iconSize24,
                                extraLarge: AppTheme.iconSize24,
                              ),
                            ),
                            SizedBox(width: AppTheme.spacing8),
                            Expanded(
                              child: Text(
                                dispatch.address,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.errorRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing20),
                      ],
                    ),
                  ),
                ),

                // ── Pinned button (always visible at bottom) ─────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(dispatchProvider.notifier)
                          .acceptDispatch(incidentId: dispatch.incidentId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: AppTheme.textWhite,
                      padding: EdgeInsets.symmetric(
                        vertical: AppTheme.spacing14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: context.responsiveIconSize(
                            small: AppTheme.iconSize16,
                            medium: AppTheme.iconSize20,
                            large: AppTheme.iconSize24,
                            extraLarge: AppTheme.iconSize24,
                          ),
                        ),
                        SizedBox(width: AppTheme.spacing8),
                        Text(
                          'Continue',
                          style: AppTheme.buttonMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
