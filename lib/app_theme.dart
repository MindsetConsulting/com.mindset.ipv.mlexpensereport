import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF81B29A),
      onPrimary: const Color(0xFFffffff),
      primaryContainer: const Color(0xFF88f8c8),
      onPrimaryContainer: const Color(0xFF002115),
      secondary: const Color(0xFF4c57a9),
      onSecondary: const Color(0xFFffffff),
      secondaryContainer: const Color(0xFFdfe0ff),
      onSecondaryContainer: const Color(0xFF000b62),
      tertiary: const Color(0xFF9b432c),
      onTertiary: const Color(0xFFffffff),
      tertiaryContainer: const Color(0xFFffdbd2),
      onTertiaryContainer: const Color(0xFF3c0800),
      error: const Color(0xFFba1a1a),
      onError: const Color(0xFFffffff),
      errorContainer: const Color(0xFFffdad6),
      onErrorContainer: const Color(0xFF410002),
      background: const Color(0xFFF5EEE7),
      onBackground: const Color(0xFF3e0021),
      surface: const Color(0xFFfffbff),
      onSurface: const Color(0xFF3e0021),
      outline: const Color(0xFF777680),
      surfaceVariant: const Color(0xFFF5EEE7),
      onSurfaceVariant: const Color(0xFF46464f),
    ),
  );
}