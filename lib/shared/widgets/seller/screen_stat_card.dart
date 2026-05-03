import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import '../common/app_container.dart';
import '../common/app_text.dart';

class ScreenStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeTextColor;
  final Color? valueColor;

  const ScreenStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.badge,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeTextColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(
        color: AppColors.borderLight,
        width: AppSize.borderWidth1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            width: AppSize.icon32,
            height: AppSize.icon32,
            backgroundColor: iconBg,
            borderRadius:
                BorderRadius.circular(AppSize.radius8), // Closest to 10
            child: Icon(icon, size: AppSize.icon16, color: iconColor),
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: value,
            fontSize: AppSize.font24,
            fontWeight: FontWeight.w800,
            color: valueColor ?? context.txtPrimary,
          ),
          const SizedBox(height: AppSize.space2),
          AppText(
            text: label,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.4,
          ),
          const SizedBox(height: AppSize.space4), // Closest to 5
          AppContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8,
              vertical: AppSize.space2,
            ),
            backgroundColor: badgeBg,
            borderRadius: BorderRadius.circular(AppSize.radius20),
            child: AppText(
              text: badge,
              fontSize: AppSize.font10, // Closest to 11
              fontWeight: FontWeight.w700,
              color: badgeTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
