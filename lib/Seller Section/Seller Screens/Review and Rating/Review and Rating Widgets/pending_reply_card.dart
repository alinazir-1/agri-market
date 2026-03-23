// ── 7. Pending Reply Card ────────────────────────────────────────────────────

import 'package:agri_market/Seller%20Section/Seller%20Screens/Review%20and%20Rating/Review%20and%20Rating%20Widgets/star_row.dart';
import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/review_model.dart';

class PendingReplyCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback onReply;

  const PendingReplyCard(
      {super.key, required this.review, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F6),
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
            color: const Color(0xFFFED7AA), width: CSize.borderWidth1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review.buyerName,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: CColors.textPrimary)),
          const SizedBox(height: 2),
          Text(
            review.reviewText,
            style: const TextStyle(fontSize: 9, color: CColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: CSize.space4),
          StarRow(rating: review.rating, size: 11),
          const SizedBox(height: CSize.space5),
          GestureDetector(
            onTap: onReply,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: CSize.space5),
              decoration: BoxDecoration(
                color: CColors.backGroundOrange,
                borderRadius: BorderRadius.circular(CSize.radius5Small),
              ),
              alignment: Alignment.center,
              child: const Text('Reply Now',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: CColors.textWhite)),
            ),
          ),
        ],
      ),
    );
  }
}
