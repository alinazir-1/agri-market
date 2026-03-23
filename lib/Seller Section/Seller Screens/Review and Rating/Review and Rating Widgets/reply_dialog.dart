// ── 8. Reply Dialog ──────────────────────────────────────────────────────────

import 'package:agri_market/Seller%20Section/Seller%20Screens/Review%20and%20Rating/Review%20and%20Rating%20Widgets/star_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/review_model.dart';

class ReviewReplyDialog extends StatelessWidget {
  final ReviewModel review;
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const ReviewReplyDialog({
    super.key,
    required this.review,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Padding(
        padding: const EdgeInsets.all(CSize.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reply to Review',
                style: TextStyle(
                    fontSize: CSize.font16Medium,
                    fontWeight: FontWeight.w800,
                    color: CColors.textPrimary)),
            const SizedBox(height: CSize.space4),
            Text('${review.buyerName} — ${review.productName}',
                style: const TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
            const SizedBox(height: CSize.space10),

            // Original review
            Container(
              padding: const EdgeInsets.all(CSize.space10),
              decoration: BoxDecoration(
                color: CColors.backGroundLightGrey,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StarRow(rating: review.rating, size: 12),
                  const SizedBox(height: CSize.space4),
                  Text(review.reviewText,
                      style: const TextStyle(
                          fontSize: 11,
                          color: CColors.textPrimary,
                          height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),

            const SizedBox(height: CSize.space16),

            TextField(
              controller: controller,
              maxLines: 4,
              style: const TextStyle(
                  fontSize: CSize.font13Small, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                hintStyle: const TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary),
                filled: true,
                fillColor: CColors.backGroundLightGrey,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    borderSide: const BorderSide(
                        color: CColors.borderEmeraldGreen,
                        width: CSize.borderWidth1)),
              ),
            ),

            const SizedBox(height: CSize.space16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CSize.radius10Medium)),
                      padding:
                          const EdgeInsets.symmetric(vertical: CSize.space12),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            color: CColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: CSize.space12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmit();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CColors.backGroundEmeraldGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CSize.radius10Medium)),
                      padding:
                          const EdgeInsets.symmetric(vertical: CSize.space12),
                      elevation: 0,
                    ),
                    child: const Text('Submit Reply',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w700,
                            color: CColors.textWhite)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
