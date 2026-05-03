import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Product title + rating / reviews / sold row (below breadcrumb on buyer product detail).
class BuyerProductDetailTitleSection extends StatelessWidget {
  const BuyerProductDetailTitleSection({super.key, required this.controller});

  final BuyerProductDetailCon controller;

  static List<Widget> _starIcons(double rating) {
    final out = <Widget>[];
    for (var i = 0; i < 5; i++) {
      final idx = i + 1;
      late IconData icon;
      late Color color;
      if (rating >= idx) {
        icon = Icons.star_rounded;
        color = AppColors.textWarning;
      } else if (rating > i) {
        icon = Icons.star_half_rounded;
        color = AppColors.textWarning;
      } else {
        icon = Icons.star_outline_rounded;
        color = AppColors.borderGray;
      }
      out.add(
        Icon(
          icon,
          size: AppSize.icon16,
          color: color,
        ),
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final rating = controller.displayRating;
    final reviews = controller.displayReviewCount;
    final sold = controller.displaySoldLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: controller.displayProductTitle,
          fontSize: AppSize.font24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSize.space8,
          runSpacing: AppSize.space4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _starIcons(rating),
            ),
            AppText(
              text: rating.toStringAsFixed(1),
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            AppText(
              text: '($reviews Reviews)',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              width: AppSize.space4,
              height: AppSize.space4,
              decoration: const BoxDecoration(
                color: AppColors.borderGray,
                shape: BoxShape.circle,
              ),
            ),
            AppText(
              text: sold,
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w400,
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
