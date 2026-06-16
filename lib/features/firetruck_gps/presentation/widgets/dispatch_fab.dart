import 'package:flutter/material.dart';
import 'unified_dispatch_modal.dart';
import '../../../../shared/theme/app_theme.dart';

class DispatchFab extends StatelessWidget {
  const DispatchFab({super.key});

  void _showIncidentModal(BuildContext context) {
    final double minChildSize = context.responsiveValue(
      small: 0.4,
      medium: 0.35,
      large: 0.3,
      extraLarge: 0.25,
    );

    final double maxChildSize = context.responsiveValue(
      small: 0.85,
      medium: 0.75,
      large: 0.65,
      extraLarge: 0.55,
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundWhite.withValues(alpha: 0),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: maxChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          snap: true,
          snapSizes: [minChildSize, maxChildSize],
          builder: (context, scrollController) =>
              UnifiedDispatchModal(scrollController: scrollController),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.responsiveValue(
        small: 50.0,
        medium: 60.0,
        large: 70.0,
        extraLarge: 80.0,
      ),
      right: context.responsiveValue(
        small: 16.0,
        medium: 20.0,
        large: 24.0,
        extraLarge: 28.0,
      ),
      child: FloatingActionButton(
        onPressed: () {
          _showIncidentModal(context);
        },
        backgroundColor: AppTheme.primaryRed,
        child: Icon(
          Icons.assignment,
          color: AppTheme.textWhite,
          size: context.responsiveIconSize(
            small: AppTheme.iconSize20,
            medium: AppTheme.iconSize24,
            large: AppTheme.iconSize24,
            extraLarge: AppTheme.iconSize24,
          ),
        ),
      ),
    );
  }
}
