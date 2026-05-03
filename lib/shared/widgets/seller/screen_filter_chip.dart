import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../common/app_text.dart';

class ScreenFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? activeBorder;
  final Color? inactiveBorder;
  final Color? inactiveText;

  const ScreenFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.activeBorder,
    this.inactiveBorder,
    this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isActive
        ? (activeColor ?? AppColors.emeraldGreen)
        : AppColors.backGroundWhite;

    final Color border = isActive
        ? (activeBorder ?? AppColors.borderEmeraldGreen)
        : (inactiveBorder ?? AppColors.borderLight);

    final Color text = isActive
        ? AppColors.textWhite
        : (inactiveText ?? AppColors.textSecondary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space12,
          vertical: AppSize.space4,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSize.radius20),
          border: Border.all(color: border),
        ),
        child: AppText(
          text: label,
          fontSize: AppSize.font10,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
