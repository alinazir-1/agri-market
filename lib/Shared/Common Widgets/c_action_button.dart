import 'package:flutter/material.dart';
import '../../Core/Constant/colors.dart';
import 'c_container.dart';
import 'c_text.dart';

class CActionButton extends StatelessWidget {
  final String? text;
  final IconData? icon;

  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;
  final double? iconSize;
  final EdgeInsetsGeometry? margin;
  final MainAxisSize mainAxisSize;

  const CActionButton({
    super.key,
    this.text,
    this.icon,
    required this.backgroundColor,
    required this.padding,
    this.textColor = CColors.textWhite,
    this.iconColor = CColors.iconWhite,
    this.height,
    this.margin,
    this.mainAxisSize = MainAxisSize.max,
    this.width,
    this.iconSize,
    this.fontWeight,
    this.fontSize,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return CContainer(
      margin: margin,
      height: height,
      width: width ?? double.infinity,
      padding: padding,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(24),
      child: Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          SizedBox(height: 5),
          CText(
            text: text!,
            textAlign: TextAlign.center,
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.w900,
            maxLines: maxLines ?? 1,
            overflow: overflow ?? TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
