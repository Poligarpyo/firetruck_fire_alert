import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

double _fabIconSize(BuildContext context) {
  return context.responsiveIconSize(
    small: AppTheme.iconSize16,
    medium: AppTheme.iconSize20,
    large: AppTheme.iconSize24,
    extraLarge: AppTheme.iconSize24,
  );
}

double _fabSize(BuildContext context) {
  return context.responsiveValue(
    small: 32.0,
    medium: AppTheme.iconSize40,
    large: AppTheme.iconSize40,
    extraLarge: AppTheme.iconSize40,
  );
}

Widget mapButton(
  BuildContext context,
  IconData icon,
  VoidCallback onPressed,
  String tag, {
  Color? color,
}) {
  return SizedBox(
    width: _fabSize(context),
    height: _fabSize(context),
    child: FloatingActionButton(
      heroTag: tag,
      onPressed: onPressed,
      backgroundColor: color ?? AppTheme.surfaceGrey,
      mini: true,
      elevation: 2,
      child: Icon(
        icon,
        color: color != null ? AppTheme.textWhite : AppTheme.textPrimary,
        size: _fabIconSize(context),
      ),
    ),
  );
}
