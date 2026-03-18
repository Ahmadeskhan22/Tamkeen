// lib/Style/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9C95FF);
  static const Color primaryDark = Color(0xFF4A44CC);

  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color secondaryDark = Color(0xFF00796B);

  // ─── Service colours ──────────────────────────────────────────────────────
  static const Color supplies = Color(0xFF5C6BC0); // school supplies — indigo
  static const Color uniform = Color(0xFF26A69A); // uniform — teal
  static const Color tutoring = Color(0xFFF57C00); // tutoring — orange
  static const Color meals = Color(0xFF43A047); // meals — green
  static const Color support = Color(0xFF8E24AA); // psychological — purple

  // ─── Status ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // ─── Neutral ──────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE2E8F0);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
