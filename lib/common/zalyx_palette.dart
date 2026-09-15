import 'package:flutter/material.dart';

class ZalyxPalette {
  ZalyxPalette._();

  static const Color deepOcean = Color(0xFF0C2444);
  static const Color azureBlue = Color(0xFF0284C7);
  static const Color freshCyan = Color(0xFF06B6D4);
  static const Color aquaGlow = Color(0xFF38BDF8);
  static const Color iceBackground = Color(0xFFF0F9FF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFBAE6FD);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color successTeal = Color(0xFF10B981);

  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: iceBackground,
      colorScheme: const ColorScheme.light(
        primary: azureBlue,
        secondary: freshCyan,
        surface: cardSurface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: iceBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: deepOcean,
        ),
        iconTheme: IconThemeData(color: deepOcean),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderLight),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardSurface,
        indicatorColor: azureBlue.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: azureBlue,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: azureBlue);
          }
          return const IconThemeData(color: textMuted);
        }),
      ),
    );
  }
}
