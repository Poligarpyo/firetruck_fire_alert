import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryRedDark = Color(0xFFB91C1C);
  static const Color primaryRedLight = Color(0xFFEF4444);

  static const Color secondaryOrange = Color(0xFFFFA726);
  static const Color secondaryOrangeDark = Color(0xFFFB8C00);
  static const Color secondaryOrangeLight = Color(0xFFFFB74D);

  static const Color successGreen = Color(0xFF10B981);
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF9FAFB);
  static const Color surfaceGrey = Color(0xFFF3F4F6);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color shadowColor = Color(0x00000000);

  static const double smallScreenBreakpoint = 360;
  static const double tabletBreakpoint = 600;
  static const double largeTabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing14 = 14.0;
  static const double spacing16 = 16.0;
  static const double spacing18 = 18.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0;
  static const double spacing36 = 36.0;
  static const double spacing40 = 40.0;
  static const double spacing44 = 44.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // ======Border Radius Values====
  static const double radius4 = 4.0;
  static const double radius6 = 6.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;

  // ======Font Sizes====
  static const double fontSize10 = 10.0;
  static const double fontSize11 = 11.0;
  static const double fontSize12 = 12.0;
  static const double fontSize13 = 13.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize22 = 22.0;
  static const double fontSize24 = 24.0;
  static const double fontSize26 = 26.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize40 = 40.0;
  static const double fontSize48 = 48.0;
  static const double fontSize56 = 56.0;
  static const double fontSize60 = 60.0;

  // ======Icon Sizes====
  static const double iconSize12 = 12.0;
  static const double iconSize14 = 14.0;
  static const double iconSize16 = 16.0;
  static const double iconSize18 = 18.0;
  static const double iconSize20 = 20.0;
  static const double iconSize22 = 22.0;
  static const double iconSize24 = 24.0;
  static const double iconSize26 = 26.0;
  static const double iconSize32 = 32.0;
  static const double iconSize36 = 36.0;
  static const double iconSize40 = 40.0;
  static const double iconSize48 = 48.0;
  static const double iconSize60 = 60.0;

  static const TextStyle _baseTextStyle = TextStyle(
    // ======Text Styles====
    fontFamily: 'Nunito',
    color: textPrimary,
  );

  // ======Heading Text Styles====
  static TextStyle get h1 => _baseTextStyle.copyWith(
    fontSize: fontSize32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h2 => _baseTextStyle.copyWith(
    fontSize: fontSize28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h3 => _baseTextStyle.copyWith(
    fontSize: fontSize24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h4 => _baseTextStyle.copyWith(
    fontSize: fontSize20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h5 => _baseTextStyle.copyWith(
    fontSize: fontSize18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h6 => _baseTextStyle.copyWith(
    fontSize: fontSize16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ======Body Text Styles====
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
    fontSize: fontSize16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
    fontSize: fontSize14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
    fontSize: fontSize12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // ======Caption and Label Styles====
  static TextStyle get caption => _baseTextStyle.copyWith(
    fontSize: fontSize12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle get overline => _baseTextStyle.copyWith(
    fontSize: fontSize10,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 1.5,
    height: 1.4,
  );

  // ======Button Text Styles====
  static TextStyle get buttonLarge => _baseTextStyle.copyWith(
    fontSize: fontSize16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get buttonMedium => _baseTextStyle.copyWith(
    fontSize: fontSize14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get buttonSmall => _baseTextStyle.copyWith(
    fontSize: fontSize12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ======Input Text Styles====
  static TextStyle get inputLarge => _baseTextStyle.copyWith(
    fontSize: fontSize16,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get inputMedium => _baseTextStyle.copyWith(
    fontSize: fontSize14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get inputSmall => _baseTextStyle.copyWith(
    fontSize: fontSize12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // ======Status Text Styles====
  static TextStyle get successText =>
      bodyMedium.copyWith(color: successGreen, fontWeight: FontWeight.w500);

  static TextStyle get errorText =>
      bodyMedium.copyWith(color: errorRed, fontWeight: FontWeight.w500);

  static TextStyle get warningText =>
      bodyMedium.copyWith(color: warningYellow, fontWeight: FontWeight.w500);

  static TextStyle get infoText =>
      bodyMedium.copyWith(color: infoBlue, fontWeight: FontWeight.w500);

  // ======Responsive Text Style Helper====
  static TextStyle responsiveTextStyle({
    required TextStyle baseStyle,
    required double fontSizeSmall,
    required double fontSizeMedium,
    required double fontSizeLarge,
    double? fontSizeExtraLarge,
  }) {
    return baseStyle.copyWith(fontSize: fontSizeSmall);
  }

  static ThemeData get lightTheme {
    // ======Material Design 3 Theme Data====
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: secondaryOrange,
        surface: surfaceGrey,
        background: backgroundWhite,
        error: errorRed,
        onPrimary: textWhite,
        onSecondary: textWhite,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textWhite,
      ),
      scaffoldBackgroundColor: backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: textWhite,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius8),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppTheme.backgroundWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppTheme.radius12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed),
        ),
        filled: true,
        fillColor: backgroundWhite,
      ),
      fontFamily: 'Nunito',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w300),
        labelLarge: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

// ======Build Context Extensions====
extension BuildContextExtensions on BuildContext {
  // ======Screen Size Utilities====
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isSmallScreen => screenWidth < AppTheme.smallScreenBreakpoint;
  bool get isTablet =>
      screenWidth >= AppTheme.smallScreenBreakpoint &&
      screenWidth < AppTheme.largeTabletBreakpoint;
  bool get isLargeTablet =>
      screenWidth >= AppTheme.largeTabletBreakpoint &&
      screenWidth < AppTheme.desktopBreakpoint;
  bool get isDesktop => screenWidth >= AppTheme.desktopBreakpoint;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  // ======Responsive Sizing Methods====
  double responsiveValue({
    required double small,
    required double medium,
    required double large,
    double? extraLarge,
  }) {
    if (isDesktop && extraLarge != null) return extraLarge;
    if (isLargeTablet) return large;
    if (isTablet) return medium;
    return small;
  }

  double responsiveFontSize({
    required double small,
    required double medium,
    required double large,
    double? extraLarge,
  }) {
    return responsiveValue(
      small: small,
      medium: medium,
      large: large,
      extraLarge: extraLarge,
    );
  }

  double responsiveSpacing({
    required double small,
    required double medium,
    required double large,
    double? extraLarge,
  }) {
    return responsiveValue(
      small: small,
      medium: medium,
      large: large,
      extraLarge: extraLarge,
    );
  }

  double responsiveIconSize({
    required double small,
    required double medium,
    required double large,
    double? extraLarge,
  }) {
    return responsiveValue(
      small: small,
      medium: medium,
      large: large,
      extraLarge: extraLarge,
    );
  }

  // ======Responsive Text Style Methods====
  TextStyle responsiveTextStyle({
    required TextStyle baseStyle,
    required double fontSizeSmall,
    required double fontSizeMedium,
    required double fontSizeLarge,
    double? fontSizeExtraLarge,
  }) {
    final fontSize = responsiveValue(
      small: fontSizeSmall,
      medium: fontSizeMedium,
      large: fontSizeLarge,
      extraLarge: fontSizeExtraLarge,
    );
    return baseStyle.copyWith(fontSize: fontSize);
  }

  TextStyle responsiveH1({
    double? fontSizeSmall,
    double? fontSizeMedium,
    double? fontSizeLarge,
    double? fontSizeExtraLarge,
  }) {
    return responsiveTextStyle(
      baseStyle: AppTheme.h1,
      fontSizeSmall: fontSizeSmall ?? AppTheme.fontSize28,
      fontSizeMedium: fontSizeMedium ?? AppTheme.fontSize32,
      fontSizeLarge: fontSizeLarge ?? AppTheme.fontSize36,
      fontSizeExtraLarge: fontSizeExtraLarge ?? AppTheme.fontSize40,
    );
  }

  TextStyle responsiveH2({
    double? fontSizeSmall,
    double? fontSizeMedium,
    double? fontSizeLarge,
    double? fontSizeExtraLarge,
  }) {
    return responsiveTextStyle(
      baseStyle: AppTheme.h2,
      fontSizeSmall: fontSizeSmall ?? AppTheme.fontSize24,
      fontSizeMedium: fontSizeMedium ?? AppTheme.fontSize28,
      fontSizeLarge: fontSizeLarge ?? AppTheme.fontSize32,
      fontSizeExtraLarge: fontSizeExtraLarge ?? AppTheme.fontSize36,
    );
  }

  TextStyle responsiveH3({
    double? fontSizeSmall,
    double? fontSizeMedium,
    double? fontSizeLarge,
    double? fontSizeExtraLarge,
  }) {
    return responsiveTextStyle(
      baseStyle: AppTheme.h3,
      fontSizeSmall: fontSizeSmall ?? AppTheme.fontSize20,
      fontSizeMedium: fontSizeMedium ?? AppTheme.fontSize24,
      fontSizeLarge: fontSizeLarge ?? AppTheme.fontSize28,
      fontSizeExtraLarge: fontSizeExtraLarge ?? AppTheme.fontSize32,
    );
  }

  TextStyle responsiveBodyText({
    required double fontSizeSmall,
    required double fontSizeMedium,
    required double fontSizeLarge,
    double? fontSizeExtraLarge,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return responsiveTextStyle(
      baseStyle: AppTheme.bodyMedium.copyWith(
        fontWeight: fontWeight,
        color: color,
      ),
      fontSizeSmall: fontSizeSmall,
      fontSizeMedium: fontSizeMedium,
      fontSizeLarge: fontSizeLarge,
      fontSizeExtraLarge: fontSizeExtraLarge,
    );
  }

  TextStyle responsiveButtonText({
    required double fontSizeSmall,
    required double fontSizeMedium,
    required double fontSizeLarge,
    double? fontSizeExtraLarge,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return responsiveTextStyle(
      baseStyle: AppTheme.buttonMedium.copyWith(
        fontWeight: fontWeight,
        color: color,
      ),
      fontSizeSmall: fontSizeSmall,
      fontSizeMedium: fontSizeMedium,
      fontSizeLarge: fontSizeLarge,
      fontSizeExtraLarge: fontSizeExtraLarge,
    );
  }

  EdgeInsets responsivePadding({
    required EdgeInsets small,
    required EdgeInsets medium,
    required EdgeInsets large,
    EdgeInsets? extraLarge,
  }) {
    if (isDesktop && extraLarge != null) return extraLarge;
    if (isLargeTablet) return large;
    if (isTablet) return medium;
    return small;
  }

  // ======Theme Shortcuts====
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ======Color Shortcuts====
  Color get primaryColor => AppTheme.primaryRed;
  Color get secondaryColor => AppTheme.secondaryOrange;
  Color get backgroundColor => AppTheme.backgroundWhite;
  Color get surfaceColor => AppTheme.surfaceGrey;
  Color get errorColor => AppTheme.errorRed;
  Color get successColor => AppTheme.successGreen;
  Color get warningColor => AppTheme.warningYellow;
  Color get infoColor => AppTheme.infoBlue;

  Color get textPrimaryColor => AppTheme.textPrimary;
  Color get textSecondaryColor => AppTheme.textSecondary;
  Color get textTertiaryColor => AppTheme.textTertiary;
  Color get textWhiteColor => AppTheme.textWhite;
}

class ResponsiveHelper {
  static Widget buildResponsive({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    required BuildContext context,
  }) {
    if (context.isDesktop && desktop != null) return desktop;
    if (context.isTablet && tablet != null) return tablet;
    return mobile;
  }

  static int crossAxisCount({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
  }) {
    if (context.isDesktop && desktop != null) return desktop;
    if (context.isTablet && tablet != null) return tablet;
    return mobile;
  }

  static double aspectRatio({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (context.isDesktop && desktop != null) return desktop;
    if (context.isTablet && tablet != null) return tablet;
    return mobile;
  }
}
