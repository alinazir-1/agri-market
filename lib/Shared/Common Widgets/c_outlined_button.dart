import 'package:flutter/material.dart';

class COutlineButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  final double? width;
  final double? height;

  final Color? foregroundColor;
  final Color? textColor;
  final Color? hoverBackgroundColor;
  final Color? hoverBorderColor;

  final double? borderRadius;
  final BorderSide? border;

  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  /// Icon
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  const COutlineButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          /// Shape
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
          ),

          /// Border color change on hover/focus
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused)) {
              return BorderSide(
                color: hoverBorderColor ?? Colors.black,
                width: border?.width ?? 1,
              );
            }
            return border ?? const BorderSide(color: Colors.black, width: 1);
          }),

          /// Background on hover/focus
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused)) {
              return hoverBackgroundColor ?? Colors.transparent;
            }
            return Colors.transparent;
          }),

          /// Foreground color
          foregroundColor: MaterialStatePropertyAll(foregroundColor),

          /// ✅ IMPORTANT: Padding zero karo
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
        ),

        /// ✅ FIX: Agar sirf icon hai to direct icon, agar text hai to Row
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    // Agar sirf icon hai
    if (icon != null && text == null) {
      return Icon(icon, size: iconSize, color: iconColor);
    }

    // Agar sirf text hai
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

    // Agar dono hain (icon + text)
    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(width: 6),
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
