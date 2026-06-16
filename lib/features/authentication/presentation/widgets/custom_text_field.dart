import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.obscureText = false,
    required this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: context.responsiveBodyText(
          fontSizeSmall: AppTheme.fontSize14,
          fontSizeMedium: AppTheme.fontSize16,
          fontSizeLarge: AppTheme.fontSize18,
          fontSizeExtraLarge: AppTheme.fontSize18,
          color: AppTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.responsiveBodyText(
            fontSizeSmall: AppTheme.fontSize14,
            fontSizeMedium: AppTheme.fontSize16,
            fontSizeLarge: AppTheme.fontSize18,
            fontSizeExtraLarge: AppTheme.fontSize18,
            color: AppTheme.textSecondary,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: AppTheme.textSecondary,
                  size: context.responsiveIconSize(
                    small: AppTheme.iconSize16,
                    medium: AppTheme.iconSize20,
                    large: AppTheme.iconSize24,
                    extraLarge: AppTheme.iconSize24,
                  ),
                )
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    suffixIcon,
                    color: AppTheme.textSecondary,
                    size: context.responsiveIconSize(
                      small: AppTheme.iconSize16,
                      medium: AppTheme.iconSize20,
                      large: AppTheme.iconSize24,
                      extraLarge: AppTheme.iconSize24,
                    ),
                  ),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          border: InputBorder.none,
          contentPadding: context.responsivePadding(
            small: EdgeInsets.all(AppTheme.spacing14),
            medium: EdgeInsets.all(AppTheme.spacing16),
            large: EdgeInsets.all(AppTheme.spacing18),
            extraLarge: EdgeInsets.all(AppTheme.spacing20),
          ),
        ),
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }
}
