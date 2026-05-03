import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/customer_activity_model.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class CustomerActivityItem extends StatelessWidget {
  final CustomerActivity entry;

  const CustomerActivityItem({super.key, required this.entry});

  // Helper to fix the dotColor error
  Color _getDotColor(CustomerActivityType type) {
    switch (type) {
      case CustomerActivityType.newOrder:
        return AppColors.emeraldGreen;
      case CustomerActivityType.auctionWon:
        return AppColors.badgePurpleText;
      case CustomerActivityType.booking:
        return AppColors.textWarning;
      case CustomerActivityType.inactive:
        return AppColors.textSecondary;
      default:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
      border: const Border(
        bottom: BorderSide(color: AppColors.backgroundDivider, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            margin: const EdgeInsets.only(top: 3),
            width: AppSize.space8,
            height: AppSize.space8,
            backgroundColor: _getDotColor(entry.type),
            shape: BoxShape.circle,
          ),
          const SizedBox(width: AppSize.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: entry.message,
                  fontSize: AppSize.font10,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                const SizedBox(height: AppSize.space2),
                AppText(
                  text: entry.timeAgo,
                  fontSize: AppSize.font8,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
