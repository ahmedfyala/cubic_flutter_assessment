import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFF0A3D91),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A3D91),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A3D91)),
  );
}
