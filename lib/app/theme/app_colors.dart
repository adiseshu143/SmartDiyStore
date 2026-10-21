import 'package:flutter/material.dart';

/// Semantic and modern design tokens for SmartDiyStore (SDS) matching the logo aesthetics.
abstract final class AppColors {
  // Brand Colors (Matching Lightbulb Circuit Logo)
  static const Color primary = Color(0xFF00A6FF); // Electric Cyan Blue
  static const Color primaryLight = Color(0xFF38BDF8); // Light Cyan
  static const Color primaryContainer = Color(0xFFE0F4FF); // Soft Cyan Tint
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary Accent
  static const Color secondary = Color(0xFFFF9900); // Vibrant Warm Gold / Amber
  static const Color secondaryLight = Color(0xFFFBBF24); // Amber Light
  static const Color secondaryContainer = Color(0xFFFFF3E0); // Soft Amber Tint
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color accent = secondary; // Alias for backward compatibility
  static const Color accentLight = secondaryLight;

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFF8FAFC); // Clean Cool Slate
  static const Color surface = Color(0xFFFFFFFF); // Clean White Cards/Containers
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate Tint
  static const Color card = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF0F172A); // Admin/Dark Deep Navy
  static const Color darkNavy = Color(0xFF0F172A); // Deep Navy (#0F172A)

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0); // Crisp Slate Border
  static const Color borderSubtle = Color(0xFFCBD5E1);

  // Text & Typography
  static const Color textPrimary = Color(0xFF0F172A); // Deep Navy Primary Text
  static const Color textSecondary = Color(0xFF64748B); // Slate Muted Text
  static const Color textTertiary = Color(0xFF94A3B8); // Slate Subtle Text
  static const Color textInverse = Color(0xFFFFFFFF);

  // Status & Feedback
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF00A6FF);
}
