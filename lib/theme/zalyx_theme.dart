import 'package:flutter/material.dart';

class ZalyxTheme {
  static const bg = Color(0xFFF0F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFBAE6FD);
  static const accent = Color(0xFF0284C7);
  static const accentLight = Color(0xFF38BDF8);
  static const ink = Color(0xFF082F49);
  static const muted = Color(0xFF64748B);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: ink,
        iconTheme: IconThemeData(color: ink),
      ),
    );
  }
}
