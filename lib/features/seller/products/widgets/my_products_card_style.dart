// lib/features/seller/products/widgets/my_products_card_style.dart
//
// My Products — grid & data-table surfaces (8pt grid, 12dp corners, subtle
// elevation). Matches common B2B marketplace / admin patterns (Material 3–adjacent).

import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';

/// Corner radius for product grid cards (12dp — ISO/Material card default band).
BorderRadius myProductsGridRadius() =>
    BorderRadius.circular(AppSize.radius12);

/// Top-only radius for media / header bands inside a grid card.
BorderRadius myProductsGridRadiusTop() => const BorderRadius.vertical(
      top: Radius.circular(AppSize.radius12),
    );

class MyProductsGridCardShell extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  const MyProductsGridCardShell({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final shadows = dark
        ? const <BoxShadow>[]
        : [
            BoxShadow(
              color: AppColors.shadowBase.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.shadowBase.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: myProductsGridRadius(),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: myProductsGridRadius(),
        child: child,
      ),
    );
  }
}

/// Outer frame for scrollable product tables (list view).
class MyProductsDataTableFrame extends StatelessWidget {
  final Widget child;

  const MyProductsDataTableFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final shadows = dark
        ? const <BoxShadow>[]
        : [
            BoxShadow(
              color: AppColors.shadowBase.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        border: Border.all(color: context.borderClr),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.radius12),
        child: child,
      ),
    );
  }
}
