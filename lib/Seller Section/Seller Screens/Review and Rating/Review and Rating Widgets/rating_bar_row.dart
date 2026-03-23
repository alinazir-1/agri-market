// ── 2. Rating Bar Row ────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class RatingBarRow extends StatelessWidget {
  final int star;
  final double fillFraction;
  final int count;

  const RatingBarRow({
    super.key,
    required this.star,
    required this.fillFraction,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            '$star ★',
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: CColors.textPrimary),
          ),
        ),
        const SizedBox(width: CSize.space10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(CSize.radius24XLarge),
            child: LinearProgressIndicator(
              value: fillFraction,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                star <= 2 ? CColors.borderError : const Color(0xFFFBBF24),
              ),
            ),
          ),
        ),
        const SizedBox(width: CSize.space10),
        SizedBox(
          width: 28,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 10, color: CColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
