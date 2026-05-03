// lib/core/widgets/app_text.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:agri_market/core/theme/app_theme.dart';

/// A customizable text widget with Google Fonts support.
/// Always use this instead of raw Text() to ensure consistency.
class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor; // ✅ NEW
  final double? decorationThickness; // ✅ NEW

  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontFamily,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: _buildTextStyle(context),
    );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    final effectiveColor = color ?? context.txtPrimary;
    // If a custom font family is requested, use GoogleFonts
    if (fontFamily != null) {
      return GoogleFonts.getFont(
        fontFamily!,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: effectiveColor,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );
    }

    // Default: use Inter from app theme
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor, // ✅ NEW
      decorationThickness: decorationThickness, // ✅ NEW
    );
  }
}
