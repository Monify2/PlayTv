import 'package:flutter/material.dart';

class PlayTvColors {
  static const background = Color(0xFF0D1110);
  static const surface = Color(0xFF151B19);
  static const surface2 = Color(0xFF202725);
  static const line = Color(0xFF34413D);
  static const green = Color(0xFF0B8F4A);
  static const greenDark = Color(0xFF075F32);
  static const text = Color(0xFFF2F7F5);
  static const muted = Color(0xFF9BA8A4);
  static const icon = Color(0xFFB5BFBB);
  static const danger = Color(0xFFFF5964);
}

class PlayTvTheme {
  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: PlayTvColors.green,
          brightness: Brightness.dark,
        ).copyWith(
          primary: PlayTvColors.green,
          onPrimary: Colors.black,
          surface: PlayTvColors.surface,
          onSurface: PlayTvColors.text,
        );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.black,
      splashColor: PlayTvColors.green.withValues(alpha: .08),
      highlightColor: PlayTvColors.green.withValues(alpha: .04),
      fontFamily: 'sans',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: PlayTvColors.text,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PlayTvColors.surface,
        hintStyle: const TextStyle(color: PlayTvColors.muted),
        labelStyle: const TextStyle(color: PlayTvColors.muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PlayTvColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PlayTvColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PlayTvColors.green),
        ),
      ),
      dividerColor: PlayTvColors.line,
      chipTheme: ChipThemeData(
        backgroundColor: PlayTvColors.surface2,
        selectedColor: PlayTvColors.green,
        labelStyle: const TextStyle(
          color: PlayTvColors.text,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
