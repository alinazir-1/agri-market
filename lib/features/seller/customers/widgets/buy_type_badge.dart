import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class BuyTypeBadge extends StatelessWidget {
  final ProductType type;

  const BuyTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;

    switch (type) {
      case ProductType.marketplace:
        bg = AppColors.badgeInfoBg;
        text = AppColors.textInfo;
        label = 'Marketplace';
        break;
      case ProductType.liveAuction:
        bg = AppColors.badgeWarningBg;
        text = AppColors.textWarning;
        label = 'Live Auction';
        break;
      case ProductType.advanceBooking:
        bg = AppColors.badgePurpleBg;
        text = AppColors.badgePurpleText;
        label = 'Adv. Booking';
        break;
      default:
        bg = AppColors.backgroundHover;
        text = AppColors.textSecondary;
        label = type.name;
    }

    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space4,
        vertical: 2,
      ),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius4),
      child: AppText(
        text: label,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: text,
      ),
    );
  }
}
