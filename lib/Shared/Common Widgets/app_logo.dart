import 'package:flutter/material.dart';
import '../../Core/Constant/images.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final Alignment? alignment;

  const AppLogo({super.key, this.height, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topCenter,
      child: Image.asset(CImages.logo, height: height),
    );
  }
}
