import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color darkOrange = Color(0xFFFF9800);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color primaryText = Color(0xFF212121);
  static const Color secondaryText = Color(0xFF616161);
  static const Color hintText = Color(0xFF9E9E9E);
  
  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    letterSpacing: 0.5,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.hintText,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
}

class AppBorderRadius {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
}