import 'package:flutter/material.dart';

class RawShieldColors {
  // Primary colors - RAWShield AI brand
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFE5C158);
  static const goldDark = Color(0xFFB8962E);

  // Background
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF0A0A0A);
  static const surfaceElevated = Color(0xFF111111);
  static const surfaceLight = Color(0xFF1A1A1A);

  // Text
  static const text = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA0A0A0);
  static const textMuted = Color(0xFF666666);

  // Status
  static const success = Color(0xFF00C853);
  static const warning = Color(0xFFFFB300);
  static const error = Color(0xFFFF3D00);
  static const info = Color(0xFF2196F3);

  // Borders
  static const border = Color.fromRGBO(255, 255, 255, 0.10);
  static const borderLight = Color.fromRGBO(255, 255, 255, 0.05);
  static const borderGold = Color.fromRGBO(212, 175, 55, 0.30);
}

class RawShieldRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 9999.0;
}

class RawShieldSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

ThemeData rawShieldDarkTheme() {
  const base = Typography.whiteMountainView;
  final colorScheme = const ColorScheme.dark().copyWith(
    primary: RawShieldColors.gold,
    secondary: RawShieldColors.goldLight,
    surface: RawShieldColors.surface,
    error: RawShieldColors.error,
  );

  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: RawShieldColors.background,
    useMaterial3: true,
    fontFamily: 'Montserrat',
    textTheme: base.merge(
      const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: RawShieldColors.text,
    ),
    cardTheme: CardThemeData(
      color: RawShieldColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.lg)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RawShieldColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RawShieldRadii.md),
        borderSide: const BorderSide(color: RawShieldColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RawShieldRadii.md),
        borderSide: const BorderSide(color: RawShieldColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RawShieldRadii.md),
        borderSide: const BorderSide(color: RawShieldColors.gold),
      ),
    ),
  );
}

