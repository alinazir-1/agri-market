import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/customer_model.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class CustomerStatusPill extends StatelessWidget {
  final CustomerStatus status;

  const CustomerStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;

    switch (status) {
      case CustomerStatus.active:
        bg = AppColors.badgeSuccessBg;
        text = AppColors.textEmeraldGreen;
        label = 'Active';
        break;
      case CustomerStatus.vip:
        bg = AppColors.badgeWarningBg;
        text = AppColors.textWarning;
        label = 'VIP';
        break;
      case CustomerStatus.inactive:
        bg = AppColors.backgroundHover;
        text = AppColors.textSecondary;
        label = 'Inactive';
        break;
    }

    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space2,
      ),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
        text: label,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: text,
      ),
    );
  }
}
