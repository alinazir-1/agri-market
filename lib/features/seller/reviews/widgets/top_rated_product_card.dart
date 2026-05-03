import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/review_model.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class TopRatedProductCard extends StatelessWidget {
  final TopRatedProduct product;

  const TopRatedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space12), // mapped 10 to 12
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
      border: Border.all(
          color: AppColors.borderLight,
          width: AppSize.borderWidth1), // mapped 0xFFE2E8F0
      child: Row(
        children: [
          AppContainer(
            width: AppSize.icon32,
            height: AppSize.icon32,
            backgroundColor:
                AppColors.badgeSuccessBg, // mapped backgroundEmerald100
            borderRadius:
                BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
            child: Center(
                child: AppText(text: product.emoji, fontSize: AppSize.font16)),
          ),
          const SizedBox(width: AppSize.space12), // mapped 10 to 12
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                    text: product.productName,
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                AppText(
                    text: '${product.reviewCount} reviews',
                    fontSize: AppSize.font8, // mapped 9 to 8
                    color: AppColors.textSecondary),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: AppSize.icon12,
                  color: AppColors
                      .textWarning), // mapped 13 to 12, 0xFFFBBF24 to textWarning
              const SizedBox(width: 2),
              AppText(
                  text: product.avgRating.toStringAsFixed(1),
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ],
          ),
        ],
      ),
    );
  }
}
