// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/common/app_safe_text_editing_controller.dart';

/// A customizable text input field for AgriMarket.
///
/// **Lifecycle:** Pass a [controller] owned by a parent [GetxController] (or [State]) — do not
/// create or dispose [TextEditingController] inside this widget.
///
/// Use this everywhere instead of raw TextField or TextFormField.
class AppTextField extends StatelessWidget {
  // Core
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;

  // Dimensions
  final double? height;
  final double? width;
  final int? maxLines;
  /// When set with [maxLines] > 1, passed to [TextFormField.minLines] (omit for default).
  final int? minLines;
  final int? maxLength;
  final bool isDense;

  // Icons
  final IconData? prefixIcon;
  final Widget?
      suffixWidget; // ✅ Changed from IconData to Widget for flexibility
  final Widget? prefixWidget; // ✅ NEW: full widget prefix support
  final Widget? prefix; // Inline prefix (no icon-size constraints)
  final double? iconSize;
  final Color? iconColor;
  final Color? prefixIconColor;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;

  // Styling
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  /// Input text style (hint uses [hintStyle]).
  final TextStyle? inputTextStyle;
  final Color? fillColor; // ✅ NEW: themed fill background
  final bool filled; // ✅ NEW
  final OutlineInputBorder? customBorder;
  final OutlineInputBorder? customFocusedBorder;

  final FocusNode? focusNode;

  // Callbacks
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator; // ✅ NEW: Form validation support

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.height,
    this.width,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.isDense = false,
    this.prefixIcon,
    this.suffixWidget,
    this.prefixWidget,
    this.prefix,
    this.iconSize = AppSize.icon20,
    this.iconColor,
    this.prefixIconColor,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.borderRadius,
    this.contentPadding,
    this.labelStyle,
    this.hintStyle,
    this.inputTextStyle,
    this.fillColor,
    this.filled = false,
    this.customBorder,
    this.customFocusedBorder,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController? effectiveController =
        _effectiveController(controller);

    // Route pop / Get.offAllNamed can dispose the controller one frame before this widget unmounts.
    // Never pass a disposed controller into [TextFormField] (see [AppSafeTextEditingController]).
    if (controller != null && effectiveController == null) {
      if (height == null && width == null) {
        return const SizedBox.shrink();
      }
      return SizedBox(height: height, width: width);
    }

    final fs = inputTextStyle?.fontSize ?? 14;
    final lineCount = maxLines ?? 1;
    final singleLine = lineCount == 1;
    final field = TextFormField(
        focusNode: focusNode,
        controller: effectiveController,
        style: inputTextStyle,
        strutStyle: singleLine
            ? StrutStyle(
                fontSize: fs,
                height: 1.0,
                leading: 0,
                forceStrutHeight: true,
              )
            : null,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        minLines: singleLine ? 1 : minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textAlignVertical:
            singleLine ? TextAlignVertical.center : TextAlignVertical.top,
        onChanged: onChanged,
        onTap: onTap,
        onEditingComplete: onEditingComplete,
        onSaved: onSaved,
        validator: validator,
        decoration: _buildDecoration(context),
      );
    if (height == null && width == null) {
      return field;
    }
    return SizedBox(
      height: height,
      width: width,
      child: field,
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    return InputDecoration(
      isDense: isDense,
      errorText: errorText,
      labelText: labelText,
      labelStyle: labelStyle,
      hintText: hintText,
      hintStyle: hintStyle,
      filled: filled,
      fillColor: fillColor,
      prefix: prefix,
      prefixIcon: _buildPrefixIcon(),
      suffixIcon: _buildSuffixIcon(),
      border: customBorder ?? _defaultBorder(context),
      focusedBorder: customFocusedBorder ?? _defaultFocusedBorder(context),
      enabledBorder: customBorder ?? _defaultBorder(context),
      errorBorder: _errorBorder(),
      contentPadding: _resolveContentPadding(),
    );
  }

  /// When [isDense] + fixed [height] are set (common on forms), avoid tall default
  /// vertical padding so outer [SizedBox] height matches without passing [contentPadding].
  EdgeInsetsGeometry _resolveContentPadding() {
    if (contentPadding != null) return contentPadding!;
    if (isDense && height != null) {
      if ((maxLines ?? 1) > 1) {
        return const EdgeInsets.symmetric(
          horizontal: AppSize.space12,
          vertical: AppSize.space8,
        );
      }
      return const EdgeInsets.symmetric(horizontal: AppSize.space12);
    }
    return _defaultPadding();
  }

  Widget? _buildPrefixIcon() {
    // Use prefixWidget if provided, otherwise build from IconData
    if (prefixWidget != null) return prefixWidget;
    if (prefixIcon == null) return null;
    return GestureDetector(
      onTap: onPrefixIconTap,
      child: Icon(
        prefixIcon,
        color: prefixIconColor ?? iconColor,
        size: iconSize,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (suffixWidget != null) return suffixWidget;
    return null;
  }

  OutlineInputBorder _defaultBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSize.radius12,
      ),
      borderSide: BorderSide(
        color: context.borderClr,
        width: AppSize.borderWidth1,
      ),
    );
  }

  // ✅ Fixed: BuildContext passed correctly — no more crash
  OutlineInputBorder _defaultFocusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSize.radius12,
      ),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: AppSize.borderWidth2,
      ),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSize.radius12,
      ),
      borderSide: const BorderSide(
        color: AppColors.borderError,
        width: AppSize.borderWidth1,
      ),
    );
  }

  EdgeInsets _defaultPadding() {
    return EdgeInsets.symmetric(
      horizontal: AppSize.space16,
      vertical: isDense ? AppSize.space12 : AppSize.space12,
    );
  }

  /// Returns [controller] unless it is an [AppSafeTextEditingController] that was already disposed.
  static TextEditingController? _effectiveController(TextEditingController? c) {
    if (c == null) return null;
    if (c is AppSafeTextEditingController && c.isDisposed) return null;
    return c;
  }
}
