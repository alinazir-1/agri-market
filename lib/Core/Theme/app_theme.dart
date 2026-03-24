import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const _emerald = Color(0xFF0E7C66);

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _emerald,
          brightness: Brightness.light,
        ).copyWith(primary: _emerald, onPrimary: Colors.white),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        textTheme: GoogleFonts.interTextTheme(),
        cardColor: Colors.white,
        dividerColor: const Color(0xFFE2E8F0),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? _emerald : null,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? _emerald.withOpacity(0.35)
                : null,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _emerald,
          brightness: Brightness.dark,
        ).copyWith(
          primary: _emerald,
          onPrimary: Colors.white,
          surface: const Color(0xFF1E293B),
          onSurface: const Color(0xFFF1F5F9),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        cardColor: const Color(0xFF1E293B),
        dividerColor: const Color(0xFF334155),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? _emerald : null,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? _emerald.withOpacity(0.35)
                : null,
          ),
        ),
      );
}

// ── Theme-aware color helpers ──────────────────────────────────────────────

extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get appBg =>
      isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F7F7);
  Color get cardBg =>
      isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get cardBg2 =>
      isDark ? const Color(0xFF243044) : const Color(0xFFF8FAFC);
  Color get txtPrimary =>
      isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1F2937);
  Color get txtSecondary =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
  Color get borderClr =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get inputFill =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFF7F7F7);
  Color get hoverBg =>
      isDark ? const Color(0xFF2D3E54) : const Color(0xFFF8FAFC);
  Color get dividerClr =>
      isDark ? const Color(0xFF2D3748) : const Color(0xFFF1F5F9);
}
