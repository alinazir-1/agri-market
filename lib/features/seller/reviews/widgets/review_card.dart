import 'package:agri_market/features/seller/reviews/widgets/star_row.dart';
import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/review_model.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String dateText;
  final VoidCallback onReply;
  final VoidCallback onToggleFlag;

  const ReviewCard({
    super.key,
    required this.review,
    required this.dateText,
    required this.onReply,
    required this.onToggleFlag,
  });

  // Hex to Color parser for Avatar
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.emeraldGreen;
    try {
      final hexCode = hex.replaceAll('#', '').replaceAll('0xFF', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (_) {
      return AppColors.emeraldGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space12), // mapped 10 to 12
      padding: const EdgeInsets.all(AppSize.space16), // mapped 14 to 16
      backgroundColor: review.isFlagged
          ? AppColors.badgeErrorBg.withValues(alpha: 0.5) // mapped 0xFFFFF8F6
          : AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(
        color: review.isFlagged
            ? AppColors.borderError.withValues(alpha: 0.3) // mapped 0xFFFCA5A5
            : AppColors.borderLight, // mapped 0xFFE2E8F0
        width: AppSize.borderWidth1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row — avatar + name + stars
          Row(
            children: [
              AppContainer(
                width: AppSize.icon40, // mapped 36 to 40
                height: AppSize.icon40,
                backgroundColor:
                    _parseColor(review.avatarHex), // Uses hex safely
                shape: BoxShape.circle,
                child: Center(
                  child: AppText(
                    text: review.initials,
                    fontSize: AppSize.font12, // mapped 13 to 12
                    fontWeight: FontWeight.w800,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
              const SizedBox(width: AppSize.space12), // mapped 10 to 12
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                      text: review.buyerName,
                      fontSize: AppSize.font10, // mapped 11 to 10
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  AppText(
                      text: '${review.buyerLocation} · $dateText',
                      fontSize: AppSize.font8, // mapped 9 to 8
                      color: AppColors.textSecondary),
                ],
              ),
              const Spacer(),
              StarRow(rating: review.rating),
            ],
          ),

          const SizedBox(height: AppSize.space12), // mapped 10 to 12

          // Product reference bar
          AppContainer(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8,
                vertical: AppSize.space4), // mapped 5 to 4
            backgroundColor: AppColors.backgroundHover, // mapped 0xFFF3F4F6
            borderRadius:
                BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
            border: Border.all(
                color: AppColors.borderLight, width: AppSize.borderWidth05),
            child: Row(
              children: [
                AppText(
                    text: review.productEmoji,
                    fontSize: AppSize.font16), // mapped 18 to 16
                const SizedBox(width: AppSize.space8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        text: review.productName,
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    AppText(
                        text:
                            '${review.productCategory} · ${review.productType}',
                        fontSize: AppSize.font8, // mapped 9 to 8
                        color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSize.space12),

          // Review text
          AppText(
            text: review.reviewText,
            fontSize: AppSize.font10, // mapped 11 to 10
            color: AppColors.textPrimary,
            height: 1.5,
          ),

          // Seller reply
          if (review.hasReply) ...[
            const SizedBox(height: AppSize.space8),
            AppContainer(
              padding: const EdgeInsets.all(AppSize.space12), // mapped 10 to 12
              backgroundColor:
                  AppColors.badgeSuccessBg, // mapped backgroundEmerald100
              borderRadius:
                  BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
              border: Border.all(
                  color: AppColors.borderEmeraldGreen
                      .withValues(alpha: 0.3)), // mapped 0xFFBBF7D0
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Your Reply',
                    fontSize: AppSize.font8, // mapped 9 to 8
                    fontWeight: FontWeight.w700,
                    color: AppColors.textEmeraldGreen,
                  ),
                  const SizedBox(height: AppSize.space4),
                  AppText(
                      text: review.sellerReply!,
                      fontSize: AppSize.font10,
                      color: AppColors.textPrimary,
                      height: 1.4),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSize.space8),

          // Bottom row — tags + actions
          Row(
            children: [
              AppText(
                  text: dateText,
                  fontSize: AppSize.font8, // mapped 9 to 8
                  color: AppColors.textSecondary),
              const SizedBox(width: AppSize.space8),

              if (review.isVerified)
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8, vertical: 2),
                  backgroundColor:
                      AppColors.badgeSuccessBg, // mapped backgroundEmerald100
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: const AppText(
                      text: 'Verified Purchase',
                      fontSize: AppSize.font8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textEmeraldGreen),
                ),

              if (review.hasReply) ...[
                const SizedBox(width: AppSize.space4), // mapped 5 to 4
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8, vertical: 2),
                  backgroundColor: AppColors.badgeInfoBg, // mapped 0xFFDBEAFE
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: const AppText(
                      text: 'Replied',
                      fontSize: AppSize.font8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textInfo), // mapped 0xFF1E40AF
                ),
              ],

              if (review.isFlagged) ...[
                const SizedBox(width: AppSize.space4), // mapped 5 to 4
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8, vertical: 2),
                  backgroundColor: AppColors.badgeErrorBg, // mapped 0xFFFEE2E2
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: const AppText(
                      text: 'Flagged',
                      fontSize: AppSize.font8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textError), // mapped 0xFF991B1B
                ),
              ],

              const Spacer(),

              // Actions
              if (!review.hasReply)
                _actionBtn(
                  label: 'Reply',
                  icon: Icons.reply_rounded,
                  borderColor: AppColors.borderEmeraldGreen
                      .withValues(alpha: 0.3), // mapped 0xFFBBF7D0
                  textColor: AppColors.textEmeraldGreen,
                  onTap: onReply,
                ),

              if (!review.hasReply)
                const SizedBox(width: AppSize.space4), // mapped 5 to 4

              _actionBtn(
                label: review.isFlagged ? 'Unflag' : 'Flag',
                icon: Icons.flag_outlined,
                borderColor: AppColors.borderError
                    .withValues(alpha: 0.3), // mapped 0xFFFCA5A5
                textColor: AppColors.textError, // mapped textRichRed
                onTap: onToggleFlag,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12,
              vertical: AppSize.space4), // mapped 10 to 12
          backgroundColor: AppColors.backGroundWhite,
          borderRadius:
              BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
          border: Border.all(color: borderColor, width: AppSize.borderWidth1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSize.font10, color: textColor),
              const SizedBox(width: AppSize.space4),
              AppText(
                  text: label,
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
