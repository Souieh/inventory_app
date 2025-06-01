import 'package:flutter/material.dart';
import 'package:inventory_app/core/themes/color.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.lightPrimaryText,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.lightPrimaryText),
    bodyMedium: TextStyle(color: AppColors.lightSecondaryText),
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.lightBackground,
    onPrimary: Colors.white,
    onSurface: AppColors.lightPrimaryText,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightBorder),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  cardColor: AppColors.lightSurface,
);
