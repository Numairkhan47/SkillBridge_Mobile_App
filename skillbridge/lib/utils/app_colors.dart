import 'package:flutter/material.dart';

/// Centralised color palette for SkillBridge.
///
/// Keeping colors in one place demonstrates good Flutter practice
/// (theming/design tokens) instead of hard-coding colors across widgets.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5B4FE9); // indigo / violet
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color secondary = Color(0xFF00C2A8); // teal accent
  static const Color accentOrange = Color(0xFFFF9F43);

  static const Color background = Color(0xFFF7F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121218);
  static const Color darkSurface = Color(0xFF1E1E27);

  static const Color textPrimary = Color(0xFF1E1E2D);
  static const Color textSecondary = Color(0xFF73737F);
  static const Color textOnDark = Color(0xFFF1F1F6);

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE74C3C);

  static const List<Color> avatarPalette = [
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFE17055),
    Color(0xFF0984E3),
    Color(0xFFD63031),
    Color(0xFFE84393),
    Color(0xFF00CEC9),
    Color(0xFFFDCB6E),
  ];
}
