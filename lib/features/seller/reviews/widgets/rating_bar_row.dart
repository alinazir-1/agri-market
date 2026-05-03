import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../../../../shared/widgets/common/app_text.dart';

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
          width: 40.0, // Fixed width mapping
          child: AppText(
            text: '$star ★',
            textAlign: TextAlign.right,
            fontSize: AppSize.font10, // mapped 11 to 10
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSize.space12), // mapped 10 to 12
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.radius24),
            child: LinearProgressIndicator(
              value: fillFraction,
              minHeight: 6.0,
              backgroundColor: AppColors.backgroundDivider, // mapped 0xFFF1F5F9
              valueColor: AlwaysStoppedAnimation<Color>(
                star <= 2
                    ? AppColors.borderError
                    : AppColors.textWarning, // mapped 0xFFFBBF24
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSize.space12), // mapped 10 to 12
        SizedBox(
          width: 28.0, // Fixed width
          child: AppText(
            text: '$count',
            textAlign: TextAlign.right,
            fontSize: AppSize.font10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
