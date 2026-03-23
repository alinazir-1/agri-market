import 'package:flutter/material.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/sizes.dart';

class CTextField extends StatelessWidget {
  final double? height;
  final double? width;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final IconData? suffixIcon;
  final double suffixIconSize;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextEditingController? controller;
  final Color? iconColor;
  final Color? prefixIconColor;
  final double? borderRadius;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onPrefixTap;
  final void Function(String)? onChanged;
  final String? errorText;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool isDense;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focusedBorder;
  final EdgeInsets? contentPadding;

  const CTextField({
    super.key,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    required this.suffixIconSize,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.controller,
    this.iconColor,
    this.prefixIconColor,
    this.borderRadius,
    this.onSuffixTap,
    this.onPrefixTap,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.height,
    this.width,
    this.onTap,
    this.readOnly = false,
    required this.isDense,
    this.border,
    this.focusedBorder,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        onTap: onTap,
        readOnly: readOnly,
        controller: controller,
        obscureText: obscureText,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onChanged: onChanged,
        enabled: enabled ?? true,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          isDense: isDense,
          errorText: errorText,

          /// Label
          labelText: labelText,
          labelStyle: labelStyle,

          /// Hint
          hintText: hintText,
          hintStyle: hintStyle,

          /// Prefix Icon
          prefixIcon: prefixIcon != null
              ? GestureDetector(
                  onTap: onPrefixTap,
                  child: Icon(
                    prefixIcon,
                    color: prefixIconColor ?? iconColor,
                    size: suffixIconSize,
                  ),
                )
              : null,

          /// Suffix Icon
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    suffixIcon,
                    color: iconColor,
                    size: suffixIconSize,
                  ),
                )
              : null,

          /// Border
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? CSize.radius10Medium,
                ),
                borderSide: BorderSide(
                  color: CColors.borderGray,
                  width: CSize.borderWidth1,
                ),
              ),

          /// Focused Border
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? CSize.radius10Medium,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: CSize.borderWidth2,
                ),
              ),

          /// Content Padding
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                horizontal: CSize.space16,
                vertical: isDense ? CSize.space12 : CSize.space14,
              ),
        ),
      ),
    );
  }
}
