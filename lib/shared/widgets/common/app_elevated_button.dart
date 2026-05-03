// lib/core/widgets/app_elevated_button.dart
import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';

/// Primary action button for AgriMarket.
/// Supports icon, text, icon+text, and loading state.
class AppElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? elevation;
  final BorderSide? border;
  final String? fontFamily;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final MainAxisAlignment? mainAxisAlignment;
  final bool isLoading; // ✅ NEW: loading state support

  const AppElevatedButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.elevation,
    this.border,
    this.fontFamily,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.mainAxisAlignment,
    this.isLoading = false, // ✅ NEW
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        // Disable button while loading
        onPressed: isLoading ? null : onPressed,
        style: _buildButtonStyle(),
        child: isLoading ? _buildLoadingIndicator() : _buildChild(),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(backgroundColor), // ✅ Fixed
      foregroundColor: WidgetStatePropertyAll(foregroundColor), // ✅ Fixed
      elevation: WidgetStatePropertyAll(elevation), // ✅ Fixed
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSize.radius12,
          ),
          side: border ?? BorderSide.none,
        ),
      ),
    );
  }

  // ✅ NEW: Loading indicator matches button foreground color
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: AppSize.borderWidth2,
        valueColor: AlwaysStoppedAnimation<Color>(
          textColor ?? AppColors.textWhite,
        ),
      ),
    );
  }

  Widget _buildChild() {
    // Icon only
    if (icon != null && text == null) {
      return Icon(icon, size: iconSize ?? AppSize.icon20, color: iconColor);
    }

    // Text only
    if (text != null && icon == null) {
      return Text(
        text!,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      );
    }

    // Icon + Text (FittedBox avoids Row overflow when parent width is tight)
    if (icon != null && text != null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize ?? AppSize.icon20, color: iconColor),
            const SizedBox(width: AppSize.space8),
            Text(
              text!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: fontFamily,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
