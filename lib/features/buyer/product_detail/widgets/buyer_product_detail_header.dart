import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Product title + seller, tenure, flag, rating, transactions (reference layout).
class BuyerProductDetailHeader extends StatelessWidget {
  const BuyerProductDetailHeader({super.key, required this.controller});

  final BuyerProductDetailCon controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: controller.detailHeading,
          fontSize: AppSize.font24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSize.space8,
          runSpacing: AppSize.space8,
          children: [
            AppText(
              text: BuyerProductDetailCon.kSellerName,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            _TenurePill(
              text: BuyerProductDetailCon.kSellerTenure,
            ),
            Icon(
              Icons.flag_outlined,
              size: AppSize.icon20,
              color: AppColors.iconEmeraldGreen,
            ),
            _StarRow(rating: controller.displayRating),
            AppText(
              text: BuyerProductDetailCon.kTransactionLabel,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}

class _TenurePill extends StatelessWidget {
  const _TenurePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space4,
      ),
      decoration: BoxDecoration(
        color: AppColors.backGroundLightGrey,
        borderRadius: BorderRadius.circular(AppSize.radiusCircular),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: AppText(
        text: text,
        fontSize: AppSize.font12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final half = (rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < full
                ? Icons.star_rounded
                : (half && i == full)
                    ? Icons.star_half_rounded
                    : Icons.star_border_rounded,
            size: AppSize.icon20,
            color: AppColors.iconEmeraldGreen,
          ),
        const SizedBox(width: AppSize.space4),
        AppText(
          text: rating.toStringAsFixed(1),
          fontSize: AppSize.font14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
