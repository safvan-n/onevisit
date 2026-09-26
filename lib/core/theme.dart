import 'package:flutter/material.dart';

class AppColors {
  // Primary Branding from Official OneVisit Logo
  static const Color deepNavy = Color(0xFF0B2545);
  static const Color navyDark = Color(0xFF07182D);
  static const Color royalBlue = Color(0xFF1E6BFF);
  static const Color skyBlue = Color(0xFF0099FF);
  static const Color teal = Color(0xFF00B4B0);
  static const Color cyanAccent = Color(0xFF00D2C4);
  static const Color emeraldGreen = Color(0xFF00B074);
  static const Color lightGreen = Color(0xFF10B981);

  // Background & Surface Colors (Clean, Modern, Accessible - Not completely dark)
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardSurface = Colors.white;
  static const Color softGrey = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textLight = Colors.white;

  // Status & Utility Colors
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [royalBlue, teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [deepNavy, Color(0xFF133B6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [royalBlue, cyanAccent, emeraldGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentCardGradient = LinearGradient(
    colors: [Color(0xFF0F3B66), Color(0xFF09687E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData lightTheme({bool largeText = false, bool highContrast = false}) {
    final double textScale = largeText ? 1.18 : 1.0;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: highContrast ? Colors.white : AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.royalBlue,
        primary: highContrast ? AppColors.deepNavy : AppColors.royalBlue,
        secondary: AppColors.teal,
        tertiary: AppColors.emeraldGreen,
        surface: AppColors.cardSurface,
        onSurface: AppColors.textPrimary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Segoe UI',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.deepNavy),
        titleTextStyle: TextStyle(
          color: AppColors.deepNavy,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: highContrast ? 4 : 1.5,
        shadowColor: AppColors.deepNavy.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: highContrast 
              ? const BorderSide(color: AppColors.deepNavy, width: 1.5)
              : const BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: 16 * textScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepNavy,
          side: const BorderSide(color: AppColors.royalBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: 15 * textScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.royalBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28 * textScale,
          fontWeight: FontWeight.w800,
          color: AppColors.deepNavy,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22 * textScale,
          fontWeight: FontWeight.w700,
          color: AppColors.deepNavy,
        ),
        titleLarge: TextStyle(
          fontSize: 18 * textScale,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15 * textScale,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15 * textScale,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5 * textScale,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
    );
  }
}
