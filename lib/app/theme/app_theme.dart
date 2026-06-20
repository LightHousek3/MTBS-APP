import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFFE11D48);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      surface: const Color(0xFF111318),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF090A0D),
      cardTheme: const CardThemeData(
        color: Color(0xFF16181E),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF111318),
        indicatorColor: scheme.primaryContainer,
      ),
    );
  }
}
