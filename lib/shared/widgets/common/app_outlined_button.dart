import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';

class AppOutlinedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  final bool compact; // 🔥 NEW

  final EdgeInsets? padding; // 🔥 NEW
  final Size? minSize; // 🔥 NEW

  final Color? foregroundColor;
  final Color? textColor;

  final Color? hoverBackgroundColor;
  final Color? hoverBorderColor;

  final double? borderRadius;
  final BorderSide? border;

  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  final MainAxisAlignment? mainAxisAlignment;

  const AppOutlinedButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.compact = false, // ✅ default normal

    this.padding,
    this.minSize,
    this.foregroundColor,
    this.textColor,
    this.hoverBackgroundColor,
    this.hoverBorderColor,
    this.borderRadius,
    this.border,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: _buildButtonStyle(),
        child: _buildChild(),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
      // ✅ SMART PADDING
      padding: WidgetStatePropertyAll(
        padding ??
            (compact
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
      ),

      // ✅ SMART SIZE
      minimumSize: WidgetStatePropertyAll(
        minSize ?? (compact ? const Size(0, 0) : const Size(64, 40)),
      ),

      tapTargetSize: compact
          ? MaterialTapTargetSize.shrinkWrap
          : MaterialTapTargetSize.padded,

      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSize.radius12,
          ),
        ),
      ),

      side: WidgetStateProperty.resolveWith(_resolveBorderSide),
      backgroundColor: WidgetStateProperty.resolveWith(_resolveBackgroundColor),
      foregroundColor: WidgetStatePropertyAll(foregroundColor),
    );
  }

  BorderSide _resolveBorderSide(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return BorderSide(
        color: hoverBorderColor ?? (border?.color ?? AppColors.borderDarkGray),
        width: border?.width ?? AppSize.borderWidth1,
      );
    }

    return border ??
        const BorderSide(
          color: AppColors.borderDarkGray,
          width: AppSize.borderWidth1,
        );
  }

  Color? _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return hoverBackgroundColor ?? AppColors.backGroundTransparent;
    }

    return AppColors.backGroundTransparent;
  }

  Widget _buildChild() {
    if (icon != null && text == null) {
      return Center(
        child: Icon(
          icon,
          size: iconSize ?? AppSize.icon20,
          color: iconColor,
        ),
      );
    }

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

    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize ?? AppSize.icon20, color: iconColor),
          const SizedBox(width: AppSize.space8),
          Text(
            text!,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
