import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.responsiveValue(
        small: 40.0,
        medium: 48.0,
        large: 56.0,
        extraLarge: 64.0,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryRed,
          foregroundColor: textColor ?? AppTheme.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: context.responsiveIconSize(
                  small: AppTheme.iconSize16,
                  medium: AppTheme.iconSize20,
                  large: AppTheme.iconSize24,
                  extraLarge: AppTheme.iconSize24,
                ),
                width: context.responsiveIconSize(
                  small: AppTheme.iconSize16,
                  medium: AppTheme.iconSize20,
                  large: AppTheme.iconSize24,
                  extraLarge: AppTheme.iconSize24,
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppTheme.textWhite,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: context.responsiveIconSize(
                        small: AppTheme.iconSize16,
                        medium: AppTheme.iconSize20,
                        large: AppTheme.iconSize24,
                        extraLarge: AppTheme.iconSize24,
                      ),
                    ),
                    SizedBox(
                      width: context.responsiveValue(
                        small: AppTheme.spacing8,
                        medium: AppTheme.spacing10,
                        large: AppTheme.spacing12,
                        extraLarge: AppTheme.spacing12,
                      ),
                    ),
                  ],
                  Text(
                    text,
                    style: context
                        .responsiveButtonText(
                          fontSizeSmall: AppTheme.fontSize14,
                          fontSizeMedium: AppTheme.fontSize16,
                          fontSizeLarge: AppTheme.fontSize18,
                          fontSizeExtraLarge: AppTheme.fontSize18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        )
                        .copyWith(letterSpacing: 0.5),
                  ),
                ],
              ),
      ),
    );
  }
}
