import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final DecorationImage? backgroundImage;
  final List<BoxShadow>? boxShadows;
  final AlignmentGeometry? alignment;
  final Gradient? gradient;
  final Clip? clipBehavior;
  final BoxShape? shape; // ✅ NEW: shape support (circle, rectangle)

  const AppContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.constraints,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.backgroundImage,
    this.boxShadows,
    this.alignment,
    this.gradient,
    this.clipBehavior,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    // Keep explicit [height]/[width] on [Container]; avoid stacking unconstrained
    // [MouseRegion]/[Row] in scrollables without a bounded ancestor (web).
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      constraints: constraints,
      alignment: alignment,
      clipBehavior: clipBehavior ?? Clip.none,
      decoration: _buildDecoration(),
      child: child,
    );
  }

  Decoration? _buildDecoration() {
    if (backgroundColor == null &&
        backgroundImage == null &&
        borderRadius == null &&
        border == null &&
        boxShadows == null &&
        gradient == null &&
        shape == null) {
      return null;
    }

    return BoxDecoration(
      color: backgroundColor,
      gradient: gradient,
      image: backgroundImage,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadows,
      shape: shape ?? BoxShape.rectangle, // ✅ NEW: shape support
    );
  }
}
