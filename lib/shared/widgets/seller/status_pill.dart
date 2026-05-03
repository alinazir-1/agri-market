import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../common/app_container.dart';
import '../common/app_text.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color text;

  const StatusPill({
    super.key,
    required this.label,
    required this.bg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space2,
      ),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
        text: label,
        fontSize: AppSize.font8, // Closest to 9
        fontWeight: FontWeight.w700,
        color: text,
      ),
    );
  }
}

class StockStatusPill extends StatelessWidget {
  final bool isOut;
  final bool isLow;

  const StockStatusPill({
    super.key,
    required this.isOut,
    required this.isLow,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isOut
        ? AppColors.badgeErrorBg
        : isLow
            ? AppColors.badgeWarningBg
            : AppColors.badgeSuccessBg;

    final Color text = isOut
        ? AppColors.badgeErrorText
        : isLow
            ? AppColors.badgeWarningText
            : AppColors.badgeSuccessText;

    final String label = isOut
        ? 'Out of Stock'
        : isLow
            ? 'Low Stock'
            : 'In Stock';

    return StatusPill(label: label, bg: bg, text: text);
  }
}
