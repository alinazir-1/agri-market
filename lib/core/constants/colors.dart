import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand / Primary Colors ─────────────────────────────────────────────────
  static const Color emeraldGreen = Color(0xFF0E7C66);
  static const Color freshGreen = Color(0xFF2ED47A);
  static const Color emerald100 = Color(0xFFD1FAE5);
  /// Light green tint for enabled primary-style cards (e.g. tier pricing toggle).
  static const Color primaryLight = Color(0xFFD1FAE5);
  /// Destructive actions (aligned with [textError] / [iconError]).
  static const Color error = Color(0xFFEF4444);

  // ─── Background Colors ──────────────────────────────────────────────────────
  static const Color backGroundWhite = Color(0xFFFFFFFF);
  static const Color backGroundLightGrey = Color(0xFFF7F7F7);
  static const Color backgroundPage = Color(0xFFF3F4F6);
  static const Color backgroundSurface = Color(0xFFF9FAFB);
  static const Color backgroundHover = Color(0xFFF8FAFC);
  /// Buyer product detail — left column (gallery / specs / more listings).
  static const Color backgroundProductDetailLeft = Color(0xFF991B1B);
  /// Buyer product detail — right column (order / payment / about / recent).
  static const Color backgroundProductDetailRight = Color(0xFF4F46E5);
  /// Fully transparent (avoid [Colors.transparent] outside this file).
  static const Color backGroundTransparent = Color(0x00000000);

  // ─── Media overlays (product images, hero scrims) ───────────────────────────
  static const Color mediaImageScrimDark = Color(0xA6000000);
  static const Color mediaImageScrimDarkAlt = Color(0x9E000000);

  // ─── Text Colors ────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);
  static const Color textEmeraldGreen = Color(0xFF0E7C66);
  static const Color textError = Color(0xFFEF4444);
  static const Color textWarning = Color(0xFFA16207);
  static const Color textInfo = Color(0xFF1E40AF);
  static const Color textPurple = Color(0xFF7C3AED);
  static const Color textRichRed = Color(0xFFB91C1C);

  // ─── Border & Divider Colors ────────────────────────────────────────────────
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderGray = Color(0xFFD1D5DB);
  static const Color borderDarkGray = Color(0xFF6B7280);
  static const Color borderEmeraldGreen = Color(0xFF0E7C66);
  static const Color borderError = Color(0xFFEF4444);
  static const Color backgroundDivider = Color(0xFFF1F5F9);

  // ─── Icon Colors ────────────────────────────────────────────────────────────
  static const Color iconEmeraldGreen = Color(0xFF0E7C66);
  static const Color iconBlack = Color(0xFF000000);
  static const Color iconWhite = Color(0xFFFFFFFF);
  static const Color iconSecondary = Color(0xFF6B7280); // Replace iconGrey
  static const Color iconError = Color(0xFFEF4444);

  // ─── Status / Badge Colors (Light Backgrounds & Text) ───────────────────────
  // Success / Active
  static const Color badgeSuccessBg = Color(0xFFD1FAE5);
  static const Color badgeSuccessText = Color(0xFF065F46);
  // Warning / Low Stock / Pending
  static const Color badgeWarningBg = Color(0xFFFFF7ED);
  static const Color badgeWarningText = Color(0xFF9A3412);
  // Error / Out of Stock
  static const Color badgeErrorBg = Color(0xFFFEE2E2);
  static const Color badgeErrorText = Color(0xFF991B1B);
  // Info / New
  static const Color badgeInfoBg = Color(0xFFDBEAFE);
  static const Color badgeInfoText = Color(0xFF1E40AF);

  static const Color badgePurpleBg = Color(0xFFF3E8FF);
  static const Color badgePurpleText = Color(0xFF6B21A8);

  // ─── UI Utilities ───────────────────────────────────────────────────────────
  static const Color shadowBase = Color(0xFF000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color notificationDot = Color(0xFFB91C1C);

  // ─── Dark Mode Colors ───────────────────────────────────────────────────────
  static const Color backGroundDarkScaffold = Color(0xFF0F172A);
  static const Color backGroundDarkCard = Color(0xFF1E293B);
  static const Color backGroundDarkCard2 = Color(0xFF243044);
  static const Color backGroundDarkHover = Color(0xFF2D3E54);

  static const Color textDarkPrimary = Color(0xFFF1F5F9);
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF2D3748);
}
