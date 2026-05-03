import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class BuyerProductDetailAboutSellerCard extends StatelessWidget {
  const BuyerProductDetailAboutSellerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.space16),
      borderRadius: BorderRadius.circular(AppSize.radius12),
      backgroundColor: AppColors.backGroundWhite,
      border: Border.all(color: AppColors.borderLight),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'About ${BuyerProductDetailCon.kSellerName}',
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          AppText(
            text: BuyerProductDetailCon.kAboutSellerParagraph1,
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          AppText(
            text: BuyerProductDetailCon.kAboutSellerParagraph2,
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
