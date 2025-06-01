// colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Common colors
  static const Color primary = Color(0xFFFF9500); // Tangerine
  static const Color accent = Color(0xFFFF6A00); // Burnt Orange

  // Light Mode
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF1C1C1E);
  static const Color lightSecondary = Color.fromARGB(255, 228, 228, 228);
  static const Color lightSurface = Color.fromARGB(255, 236, 235, 235);
  static const Color lightPrimaryText = Color(0xFF1C1C1E);
  static const Color lightSecondaryText = Color(0xFF8E8E93);
  static const Color lightBorder = Color(0xFFE5E5EA);

  // Dark Mode
  static const Color darkBackground = Color(0xFF1C1C1E);
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFFA1A1A6);
  static const Color darkSurface = Color.fromARGB(255, 70, 70, 77);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFA1A1A6);
  static const Color darkBorder = Color(0xFF2C2C2E);
}
