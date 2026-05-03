import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class VerifiedSellerCard extends StatelessWidget {
  const VerifiedSellerCard({
    super.key,
    required this.seller,
  });

  final VerifiedSellerItem seller;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(AppSize.radius16),
      backgroundColor: AppColors.backGroundWhite,
      border: Border.all(color: AppColors.borderLight),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.04),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                size: AppSize.icon20,
                color: AppColors.iconEmeraldGreen,
              ),
              const SizedBox(width: AppSize.space8),
              Expanded(
                child: AppText(
                  text: seller.name,
                  fontSize: AppSize.font18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (seller.isTopPerformer)
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  borderRadius: BorderRadius.circular(AppSize.radiusCircular),
                  backgroundColor: AppColors.badgeSuccessBg,
                  child: const AppText(
                    text: 'Top Performer',
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.badgeSuccessText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: '${seller.city} • ${seller.specialty}',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space16),
          Wrap(
            spacing: AppSize.space8,
            runSpacing: AppSize.space8,
            children: [
              _SellerInfoChip(
                icon: Icons.schedule_rounded,
                label: 'Response ${seller.responseRate}',
              ),
              _SellerInfoChip(
                icon: Icons.shopping_bag_outlined,
                label: '${seller.fulfilledOrders} fulfilled orders',
              ),
              _SellerInfoChip(
                icon: Icons.star_rounded,
                label: '${seller.rating.toStringAsFixed(1)} rating',
              ),
            ],
          ),
          const SizedBox(height: AppSize.space16),
          Row(
            children: [
              Expanded(
                child: AppElevatedButton(
                  text: 'View Profile',
                  onPressed: () {},
                  height: 42,
                  backgroundColor: AppColors.emeraldGreen,
                  textColor: AppColors.textWhite,
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSize.space12),
              Expanded(
                child: AppElevatedButton(
                  text: 'Request Quote',
                  onPressed: () {},
                  height: 42,
                  backgroundColor: AppColors.backGroundWhite,
                  textColor: AppColors.textPrimary,
                  border: const BorderSide(color: AppColors.borderLight),
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SellerInfoChip extends StatelessWidget {
  const _SellerInfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      borderRadius: BorderRadius.circular(AppSize.radiusCircular),
      backgroundColor: AppColors.backgroundSurface,
      border: Border.all(color: AppColors.borderLight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSize.icon12,
            color: AppColors.iconSecondary,
          ),
          const SizedBox(width: AppSize.space4),
          AppText(
            text: label,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
