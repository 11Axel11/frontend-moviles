import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.softWhite,
    primaryColor: AppColors.goldPremium,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.goldPremium,
      primary: AppColors.goldPremium,
      secondary: AppColors.blackElegant,
      surface: AppColors.softWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blackElegant,
      foregroundColor: AppColors.softWhite,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.blackElegant,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.blackElegant,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: AppColors.darkGray,
        fontSize: 16,
      ),
    ),
  );
}