import 'package:agri_market/features/seller/reviews/widgets/star_row.dart';
import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/review_model.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class PendingReplyCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback onReply;

  const PendingReplyCard(
      {super.key, required this.review, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space12), // mapped 10 to 12
      backgroundColor:
          AppColors.badgeErrorBg.withValues(alpha: 0.3), // mapped 0xFFFFF8F6
      borderRadius: BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
      border: Border.all(
          color: AppColors.textWarning.withValues(alpha: 0.3),
          width: AppSize.borderWidth1), // mapped 0xFFFED7AA
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: review.buyerName,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
          const SizedBox(height: 2),
          AppText(
            text: review.reviewText,
            fontSize: AppSize.font8, // mapped 9 to 8
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space4),
          StarRow(
              rating: review.rating, size: AppSize.icon12), // mapped 11 to 12
          const SizedBox(height: AppSize.space4), // mapped 5 to 4
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onReply,
              child: AppContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: AppSize.space4), // mapped 5 to 4
                backgroundColor:
                    AppColors.textWarning, // mapped backGroundOrange
                borderRadius:
                    BorderRadius.circular(AppSize.radius4), // mapped 5 to 4
                child: const Center(
                  child: AppText(
                      text: 'Reply Now',
                      fontSize: AppSize.font8, // mapped 9 to 8
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
