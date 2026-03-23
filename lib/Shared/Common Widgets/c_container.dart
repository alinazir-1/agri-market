import 'package:flutter/material.dart';

class CContainer extends StatelessWidget {
  final Widget? child;

  final double? height;
  final double? width;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;

  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final DecorationImage? image;

  final BoxShadow? boxShadow;

  final AlignmentGeometry? alignment;

  const CContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.alignment,
    this.image,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      alignment: alignment,
      padding: padding,
      constraints: constraints,
      decoration: BoxDecoration(
        color: backgroundColor,
        image: image,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: child,
    );
  }
}
