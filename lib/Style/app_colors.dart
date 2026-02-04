import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Warm and hopeful
  static const Color primary = Color(
    0xFF6366F1,
  ); // Indigo - represents trust and hope
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors - Compassion and care
  static const Color secondary = Color(
    0xFFEC4899,
  ); // Pink - represents care and compassion
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color secondaryDark = Color(0xFFDB2777);

  // Service Category Colors
  static const Color supplies = Color(0xFF10B981); // Green - School supplies
  static const Color uniform = Color(0xFF3B82F6); // Blue - Uniforms
  static const Color tutoring = Color(0xFFF59E0B); // Amber - Tutoring
  static const Color meals = Color(0xFFEF4444); // Red - Meals
  static const Color support = Color(
    0xFF8B5CF6,
  ); // Purple - Psychological support

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFED7AA), Color(0xFFFCA5A5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
