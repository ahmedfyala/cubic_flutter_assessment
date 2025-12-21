import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.fieldBgLight, 
        onSurface: AppColors.textPrimaryLight,
        outline: AppColors.textSecondary,
        error: Colors.red,
      ),
      elevatedButtonTheme: _buttonTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.fieldBgDark, 
        onSurface: AppColors.textPrimaryDark,
        outline: AppColors.textGrey,
        error: Colors.red,
      ),
      elevatedButtonTheme: _buttonTheme,
    );
  }

  static final _buttonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: Size(double.infinity, 56.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 0,
    ),
  );
}
