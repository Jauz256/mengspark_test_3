import 'package:flutter/material.dart';

/// MengSpark Brand Theme
/// "Experience Before You Invest"
/// Premium but accessible. Not corporate. Not playful/childish.
/// Serious game for ambitious people.

class AppColors {
  // Primary Purple Palette (STRICT - NO GRADIENTS)
  static const Color purple = Color(0xFF8A2BE2); // Electric violet
  static const Color purpleSecondary = Color(0xFF9370DB); // Medium purple - accents only
  static const Color purpleDark = Color(0xFF5B21B6); // Deep violet - pressed states

  // Gold Accent
  static const Color gold = Color(0xFFFCD34D); // Warm gold - highlights, success, premium

  // Background Colors (DARK MODE ONLY)
  static const Color bgDeep = Color(0xFF1A1A2E); // Near-black with blue undertone
  static const Color bgDarker = Color(0xFF12121F); // Cards, elevated surfaces
  static Color bgCard = const Color(0xFF8A2BE2).withValues(alpha: 0.06); // Subtle purple tint

  // Text Colors
  static const Color textBright = Color(0xFFFFFFFF);
  static Color textMid = Colors.white.withValues(alpha: 0.7);
  static Color textDim = Colors.white.withValues(alpha: 0.4);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Red

  // Border
  static Color border = const Color(0xFF8A2BE2).withValues(alpha: 0.15);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppBorderRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double round = 100;
}

class AppShadows {
  // Subtle shadow - NOT colored glow shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  static List<BoxShadow> purpleButtonShadow = [
    BoxShadow(
      color: AppColors.purple.withValues(alpha: 0.3),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
  ];
}

class AppTextStyles {
  // Headlines: Bold/Extra-bold, tight letter-spacing (-0.02em)
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textBright,
    letterSpacing: -0.56, // -0.02em
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textBright,
    letterSpacing: -0.48,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textBright,
    letterSpacing: -0.4,
  );

  // Body: Regular weight, 1.5-1.6 line height
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBright,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textBright,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textBright,
    height: 1.5,
  );

  // Numbers/Stats: Extra-bold, slightly larger
  static const TextStyle stat = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textBright,
  );

  static const TextStyle statLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textBright,
  );

  // Tags/Labels: All caps, letter-spacing 0.1em, small size
  static const TextStyle tag = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0, // 0.1em
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textBright,
  );

  // Subtitle
  static const TextStyle subtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.purple,
  );

  // Dim text
  static TextStyle dimText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDim,
    fontStyle: FontStyle.italic,
  );
}

/// App Theme Data for Material App
ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bgDeep,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.purple,
    secondary: AppColors.gold,
    surface: AppColors.bgDarker,
    error: AppColors.danger,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bgDeep,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headline3,
  ),
  cardTheme: CardThemeData(
    color: AppColors.bgDarker,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      side: BorderSide(color: AppColors.border),
    ),
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.purple,
      foregroundColor: AppColors.textBright,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: AppTextStyles.button,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textBright,
      side: BorderSide(color: AppColors.purple.withValues(alpha: 0.3)),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: AppTextStyles.button,
    ),
  ),
);
