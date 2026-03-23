// ── 6. Top Rated Product Card ────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/review_model.dart';

class TopRatedProductCard extends StatelessWidget {
  final TopRatedProduct product;

  const TopRatedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space10),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
            color: const Color(0xFFE2E8F0), width: CSize.borderWidth1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: CColors.backgroundEmerald100,
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
            ),
            alignment: Alignment.center,
            child: Text(product.emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: CSize.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: CColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('${product.reviewCount} reviews',
                    style: const TextStyle(
                        fontSize: 9, color: CColors.textSecondary)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: 13, color: Color(0xFFFBBF24)),
              const SizedBox(width: 2),
              Text(product.avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: CColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}
