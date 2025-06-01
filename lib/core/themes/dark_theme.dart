import 'package:flutter/material.dart';
import 'package:inventory_app/core/themes/color.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.darkPrimaryText,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkPrimaryText),
    bodyMedium: TextStyle(color: AppColors.darkSecondaryText),
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.darkBackground,
    onPrimary: Colors.white,
    onSurface: AppColors.darkPrimaryText,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkBorder),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
