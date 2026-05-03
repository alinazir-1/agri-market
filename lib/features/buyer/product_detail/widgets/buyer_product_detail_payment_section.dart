import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Payment options card — dollar icons instead of brand logos (per product brief).
class BuyerProductDetailPaymentSection extends StatelessWidget {
  const BuyerProductDetailPaymentSection({super.key});

  static const int _iconSlots = 8;

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
            text: 'International & card payments',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          _DollarIconRow(count: _iconSlots),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: 'Local payment options',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          _DollarIconRow(count: 4),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: 'Buy now, pay later',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          _DollarIconRow(count: 3),
        ],
      ),
    );
  }
}

class _DollarIconRow extends StatelessWidget {
  const _DollarIconRow({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSize.space8,
      runSpacing: AppSize.space8,
      children: List.generate(
        count,
        (_) => AppContainer(
          width: 44,
          height: 44,
          borderRadius: BorderRadius.circular(AppSize.space8),
          backgroundColor: AppColors.badgeInfoBg,
          border: Border.all(color: AppColors.borderLight),
          alignment: Alignment.center,
          child: Icon(
            Icons.attach_money_rounded,
            size: AppSize.icon24,
            color: AppColors.textInfo,
          ),
        ),
      ),
    );
  }
}
