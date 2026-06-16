import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_theme.dart';

class EmptyDispatchWidget extends ConsumerWidget {
  const EmptyDispatchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: context.responsivePadding(
            small: EdgeInsets.all(AppTheme.spacing16),
            medium: EdgeInsets.all(AppTheme.spacing20),
            large: EdgeInsets.all(AppTheme.spacing24),
            extraLarge: EdgeInsets.all(AppTheme.spacing28),
          ),
          decoration: BoxDecoration(
            color: AppTheme.primaryRed,
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
                      Icons.inbox_outlined,
                      color: AppTheme.textWhite,
                      size: AppTheme.iconSize20,
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Text(
                    'NO ACTIVE DISPATCH',
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
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.spacing24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_off_outlined,
                    size: AppTheme.iconSize48,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: AppTheme.spacing24),
                Text(
                  'No Active Dispatch',
                  style: AppTheme.h5.copyWith(color: AppTheme.textPrimary),
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  'Waiting for dispatch from Fire Department Control Center',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: AppTheme.spacing32),
                Container(
                  padding: EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radius12),
                    border: Border.all(
                      color: AppTheme.primaryRed.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryRed,
                        size: AppTheme.iconSize20,
                      ),
                      SizedBox(width: AppTheme.spacing12),
                      Expanded(
                        child: Text(
                          'Waiting for dispatch from Fire Department Control Center',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
