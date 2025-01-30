// lib/constants/app_fonts.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  // Ukuran font
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;

  // Gaya font
  static const TextStyle heading1 = TextStyle(
    fontSize: extraLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: large,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: medium,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: small,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
