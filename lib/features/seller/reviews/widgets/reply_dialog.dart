import 'package:agri_market/features/seller/reviews/review_rating_con.dart';
import 'package:agri_market/features/seller/reviews/widgets/star_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/review_model.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';
import '../../../../shared/widgets/common/app_text_field.dart';
import '../../../../shared/widgets/common/app_elevated_button.dart';
import '../../../../shared/widgets/common/app_outlined_button.dart';

class ReviewReplyDialog extends StatelessWidget {
  final ReviewModel review;
  final TextEditingController controller;
  final ReviewsCon reviewsCon;

  const ReviewReplyDialog({
    super.key,
    required this.review,
    required this.controller,
    required this.reviewsCon,
  });

  @override
  Widget build(BuildContext context) {
    /// 💀🔥 ---------------- Reply dialog (compact SaaS layout) ----------------
    final maxH = MediaQuery.sizeOf(context).height * 0.88;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radius8),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSize.space20,
        vertical: AppSize.space24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: maxH),
        child: AppContainer(
          padding: const EdgeInsets.all(AppSize.space16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const AppText(
                text: 'Reply to Review',
                fontSize: AppSize.font16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSize.space4),
              AppText(
                text: '${review.buyerName} — ${review.productName}',
                fontSize: AppSize.font12,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSize.space12),
              AppContainer(
                padding: const EdgeInsets.all(AppSize.space12),
                backgroundColor: AppColors.backgroundHover,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StarRow(rating: review.rating, size: AppSize.icon12),
                    const SizedBox(height: AppSize.space4),
                    AppText(
                      text: review.reviewText,
                      fontSize: AppSize.font10,
                      color: AppColors.textPrimary,
                      height: 1.4,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSize.space12),
              AppTextField(
                controller: controller,
                maxLines: 3,
                hintText: 'Write your reply...',
                fillColor: AppColors.backgroundHover,
                filled: true,
                customBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  borderSide: BorderSide.none,
                ),
                customFocusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  borderSide: const BorderSide(
                    color: AppColors.borderEmeraldGreen,
                    width: AppSize.borderWidth1,
                  ),
                ),
              ),
              const SizedBox(height: AppSize.space12),
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      onPressed: () => Get.back(),
                      text: 'Cancel',
                      fontSize: AppSize.font12,
                      textColor: AppColors.textSecondary,
                      border: const BorderSide(color: AppColors.borderLight),
                      borderRadius: AppSize.radius8,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.space8,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.space8),
                  Expanded(
                    child: Obx(
                      () => AppElevatedButton(
                        onPressed: () =>
                            reviewsCon.submitReplyAndCloseDialog(review.id),
                        isLoading: reviewsCon.isReplySubmitting.value,
                        text: 'Submit Reply',
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.textWhite,
                        backgroundColor: AppColors.emeraldGreen,
                        borderRadius: AppSize.radius8,
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
