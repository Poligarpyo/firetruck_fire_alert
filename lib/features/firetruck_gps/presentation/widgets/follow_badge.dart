import 'package:flutter/material.dart';
import '../controller/state.dart';
import '../../../../shared/theme/app_theme.dart';

class FollowBadge extends StatelessWidget {
  final FireTruckState truckState;
  final VoidCallback onTap;
  final double edgeInset;
  final double bottomInset;
  final double badgePaddingH;
  final double badgePaddingV;
  final double badgeIconSize;
  final double badgeFontSize;
  final bool isSmallScreen;

  const FollowBadge({
    super.key,
    required this.truckState,
    required this.onTap,
    required this.edgeInset,
    required this.bottomInset,
    required this.badgePaddingH,
    required this.badgePaddingV,
    required this.badgeIconSize,
    required this.badgeFontSize,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: edgeInset,
      bottom: bottomInset,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: badgePaddingH,
            vertical: badgePaddingV,
          ),
          decoration: BoxDecoration(
            color: truckState.followTruck
                ? AppTheme.primaryRed
                : AppTheme.textSecondary,
            borderRadius: BorderRadius.circular(AppTheme.radius20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.textPrimary.withValues(alpha: 0.2),
                blurRadius: AppTheme.radius6,
                offset: Offset(0, AppTheme.spacing2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                truckState.followTruck
                    ? Icons.navigation
                    : Icons.navigation_outlined,
                color: AppTheme.textWhite,
                size: badgeIconSize,
              ),
              SizedBox(
                width: isSmallScreen ? AppTheme.spacing4 : AppTheme.spacing6,
              ),
              Text(
                truckState.followTruck ? 'Following' : 'Double Tap to follow',
                style: AppTheme.buttonSmall.copyWith(
                  color: AppTheme.textWhite,
                  fontSize: badgeFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
