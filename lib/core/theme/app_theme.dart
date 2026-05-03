import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  // ─── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.emeraldGreen,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.emeraldGreen,
          onPrimary: AppColors.textWhite,
          surface: AppColors.backGroundWhite,
          onSurface: AppColors.textPrimary,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.borderLight,
          outlineVariant: AppColors.borderGray,
        ),
        scaffoldBackgroundColor: AppColors.backGroundLightGrey,
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        cardColor: AppColors.backGroundWhite,
        dividerColor: AppColors.backgroundDivider,
        dividerTheme: const DividerThemeData(
          color: AppColors.backgroundDivider,
          thickness: 1,
        ),
        cardTheme: CardThemeData(
          color: AppColors.backGroundWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.borderLight),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.backGroundWhite,
          surfaceTintColor: AppColors.backGroundTransparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backGroundLightGrey,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.85),
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: GoogleFonts.inter(
            color: AppColors.emeraldGreen,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.borderEmeraldGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderError),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emeraldGreen,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.borderLight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.emeraldGreen
                : null,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.emeraldGreen.withValues(alpha: 0.35)
                : null,
          ),
        ),
      );

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.emeraldGreen,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.emeraldGreen,
          onPrimary: AppColors.textWhite,
          surface: AppColors.backGroundDarkCard,
          onSurface: AppColors.textDarkPrimary,
          onSurfaceVariant: AppColors.textDarkSecondary,
          outline: AppColors.borderDark,
          outlineVariant: AppColors.borderDark,
        ),
        scaffoldBackgroundColor: AppColors.backGroundDarkScaffold,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: AppColors.textDarkPrimary,
          displayColor: AppColors.textDarkPrimary,
        ),
        cardColor: AppColors.backGroundDarkCard,
        dividerColor: AppColors.dividerDark,
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerDark,
          thickness: 1,
        ),
        cardTheme: CardThemeData(
          color: AppColors.backGroundDarkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.borderDark),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.backGroundDarkCard,
          surfaceTintColor: AppColors.backGroundTransparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backGroundDarkCard2,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textDarkSecondary.withValues(alpha: 0.9),
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textDarkSecondary,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: GoogleFonts.inter(
            color: AppColors.freshGreen,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.borderEmeraldGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderError),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emeraldGreen,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textDarkSecondary,
            side: const BorderSide(color: AppColors.borderDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.emeraldGreen
                : null,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.emeraldGreen.withValues(alpha: 0.35)
                : null,
          ),
        ),
      );
}

// ─── Theme-aware color helpers ──────────────────────────────────────────────
extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get appBg =>
      isDark ? AppColors.backGroundDarkScaffold : AppColors.backGroundLightGrey;
  Color get cardBg =>
      isDark ? AppColors.backGroundDarkCard : AppColors.backGroundWhite;
  Color get cardBg2 =>
      isDark ? AppColors.backGroundDarkCard2 : AppColors.backgroundHover;
  Color get txtPrimary =>
      isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;
  Color get txtSecondary =>
      isDark ? AppColors.textDarkSecondary : AppColors.textSecondary;
  Color get txtHint =>
      txtSecondary.withValues(alpha: isDark ? 0.88 : 0.82);
  Color get txtDisabled =>
      txtSecondary.withValues(alpha: isDark ? 0.45 : 0.42);
  Color get borderClr => isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get inputFill =>
      isDark ? AppColors.backGroundDarkCard : AppColors.backGroundLightGrey;
  Color get hoverBg =>
      isDark ? AppColors.backGroundDarkHover : AppColors.backgroundHover;
  Color get dividerClr =>
      isDark ? AppColors.dividerDark : AppColors.backgroundDivider;
  Color get transparentBg => AppColors.backGroundTransparent;
}
