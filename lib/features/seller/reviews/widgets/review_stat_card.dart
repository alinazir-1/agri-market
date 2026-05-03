import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class ReviewStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;

  const ReviewStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space16,
        vertical: AppSize.space12,
      ),
      child: Row(
        children: [
          AppContainer(
            width: AppSize.icon32,
            height: AppSize.icon32,
            backgroundColor: iconBg,
            borderRadius:
                BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
            child: Center(
                child: Icon(icon, size: AppSize.icon16, color: iconColor)),
          ),
          const SizedBox(width: AppSize.space12), // mapped 10 to 12
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: value,
                fontSize: AppSize.font16, // mapped 18 to 16
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
              AppText(
                text: label,
                fontSize: AppSize.font8, // mapped 9 to 8
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
