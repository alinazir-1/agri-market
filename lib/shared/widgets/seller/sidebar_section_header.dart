import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../common/app_container.dart';
import '../common/app_text.dart';

class SidebarSectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int? count;
  final Color countBg;
  final Color countTextColor;

  const SidebarSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = AppColors.textError,
    this.count,
    this.countBg = AppColors.badgeErrorBg,
    this.countTextColor = AppColors.textError,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSize.icon16,
          color: iconColor,
        ),
        const SizedBox(width: AppSize.space4), // Closest to 5
        AppText(
          text: title,
          fontSize: AppSize.font10, // Closest to 11
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        if (count != null && count! > 0) ...[
          const SizedBox(width: AppSize.space4),
          AppContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8,
              vertical: AppSize.space2,
            ),
            backgroundColor: countBg,
            borderRadius: BorderRadius.circular(AppSize.radius20),
            child: AppText(
              text: '$count',
              fontSize: AppSize.font8,
              fontWeight: FontWeight.w700,
              color: countTextColor,
            ),
          ),
        ],
      ],
    );
  }
}

class AllClearBanner extends StatelessWidget {
  final String message;

  const AllClearBanner({
    super.key,
    this.message = 'Everything looks good',
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: AppColors.emerald100,
      borderRadius: BorderRadius.circular(AppSize.radius8), // Closest to 10
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: AppSize.icon16,
            color: AppColors.iconEmeraldGreen,
          ),
          const SizedBox(width: AppSize.space8),
          AppText(
            text: message,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w600,
            color: AppColors.textEmeraldGreen,
          ),
        ],
      ),
    );
  }
}
