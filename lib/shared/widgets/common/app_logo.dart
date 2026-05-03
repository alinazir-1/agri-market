// lib/core/widgets/app_logo.dart
import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/images.dart'; // ✅ Fixed: agrikrop → agri_market

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width; // ✅ NEW: horizontal sizing support
  final Alignment? alignment;

  const AppLogo({
    super.key,
    this.height,
    this.width,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topCenter,
      child: Image.asset(
        AppImages.logo,
        height: height,
        width: width, // ✅ NEW
      ),
    );
  }
}
