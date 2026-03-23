import 'package:flutter/material.dart';

class CElevatedButton extends StatelessWidget {
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

  /// Icon related
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  const CElevatedButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.elevation,
    this.foregroundColor,
    this.border,
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          foregroundColor: MaterialStatePropertyAll(foregroundColor),
          elevation: MaterialStatePropertyAll(elevation),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              side: border ?? BorderSide.none,
            ),
          ),
        ),

        /// Button child
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize ?? 18,
                color: iconColor ?? Colors.white,
              ),
              if (text != null) const SizedBox(width: 6),
            ],

            if (text != null)
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
        ),
      ),
    );
  }
}
