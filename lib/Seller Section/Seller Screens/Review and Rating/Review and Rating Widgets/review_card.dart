// ── 5. Review Card ───────────────────────────────────────────────────────────

import 'package:agri_market/Seller%20Section/Seller%20Screens/Review%20and%20Rating/Review%20and%20Rating%20Widgets/star_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/review_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space10),
      padding: const EdgeInsets.all(CSize.space14),
      decoration: BoxDecoration(
        color: review.isFlagged
            ? const Color(0xFFFFF8F6)
            : CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: review.isFlagged
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE2E8F0),
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row — avatar + name + stars
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: review.avatarColor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  review.initials,
                  style: const TextStyle(
                      fontSize: CSize.font13Small,
                      fontWeight: FontWeight.w800,
                      color: CColors.textWhite),
                ),
              ),
              const SizedBox(width: CSize.space10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.buyerName,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CColors.textPrimary)),
                  Text('${review.buyerLocation} · $dateText',
                      style: const TextStyle(
                          fontSize: 9, color: CColors.textSecondary)),
                ],
              ),
              const Spacer(),
              StarRow(rating: review.rating),
            ],
          ),

          const SizedBox(height: CSize.space10),

          // Product reference bar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space5),
            decoration: BoxDecoration(
              color: CColors.backGroundLightGrey,
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              border: Border.all(
                  color: const Color(0xFFE2E8F0), width: CSize.borderWidth05),
            ),
            child: Row(
              children: [
                Text(review.productEmoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: CSize.space8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.productName,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: CColors.textPrimary)),
                    Text('${review.productCategory} · ${review.productType}',
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: CSize.space10),

          // Review text
          Text(
            review.reviewText,
            style: const TextStyle(
                fontSize: 11, color: CColors.textPrimary, height: 1.5),
          ),

          // Seller reply
          if (review.hasReply) ...[
            const SizedBox(height: CSize.space8),
            Container(
              padding: const EdgeInsets.all(CSize.space10),
              decoration: BoxDecoration(
                color: CColors.backgroundEmerald100,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Reply',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: CColors.textEmeraldGreen),
                  ),
                  const SizedBox(height: CSize.space4),
                  Text(review.sellerReply!,
                      style: const TextStyle(
                          fontSize: 10,
                          color: CColors.textPrimary,
                          height: 1.4)),
                ],
              ),
            ),
          ],

          const SizedBox(height: CSize.space8),

          // Bottom row — tags + actions
          Row(
            children: [
              Text(dateText,
                  style: const TextStyle(
                      fontSize: 9, color: CColors.textSecondary)),
              const SizedBox(width: CSize.space8),

              if (review.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8, vertical: 2),
                  decoration: BoxDecoration(
                    color: CColors.backgroundEmerald100,
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                  ),
                  child: const Text('Verified Purchase',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: CColors.textEmeraldGreen)),
                ),

              if (review.hasReply) ...[
                const SizedBox(width: CSize.space5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                  ),
                  child: const Text('Replied',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E40AF))),
                ),
              ],

              if (review.isFlagged) ...[
                const SizedBox(width: CSize.space5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                  ),
                  child: const Text('Flagged',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF991B1B))),
                ),
              ],

              const Spacer(),

              // Actions
              if (!review.hasReply)
                _actionBtn(
                  label: 'Reply',
                  icon: Icons.reply_rounded,
                  borderColor: const Color(0xFFBBF7D0),
                  textColor: CColors.textEmeraldGreen,
                  onTap: onReply,
                ),

              if (!review.hasReply) const SizedBox(width: CSize.space5),

              _actionBtn(
                label: review.isFlagged ? 'Unflag' : 'Flag',
                icon: Icons.flag_outlined,
                borderColor: const Color(0xFFFCA5A5),
                textColor: CColors.textRichRed,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space10, vertical: CSize.space4),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(color: borderColor, width: CSize.borderWidth1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: CSize.font10XSmall, color: textColor),
            const SizedBox(width: CSize.space4),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ],
        ),
      ),
    );
  }
}
