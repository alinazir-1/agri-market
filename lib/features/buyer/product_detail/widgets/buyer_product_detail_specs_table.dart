import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Key attributes / specifications table (reference two-column table).
class BuyerProductDetailSpecsTable extends StatelessWidget {
  const BuyerProductDetailSpecsTable({super.key, required this.controller});

  final BuyerProductDetailCon controller;

  static const int _collapsedRows = 3;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.space16),
      borderRadius: BorderRadius.circular(AppSize.radius12),
      backgroundColor: AppColors.backGroundWhite,
      border: Border.all(color: AppColors.borderLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Key attributes',
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          Obx(() {
            final all = BuyerProductDetailCon.kSpecRows;
            final showAll = controller.specsExpanded.value;
            final rows =
                showAll ? all : all.take(_collapsedRows).toList(growable: false);
            return Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  _SpecRow(
                    attribute: rows[i].$1,
                    value: rows[i].$2,
                    stripe: i.isOdd,
                  ),
              ],
            );
          }),
          const SizedBox(height: AppSize.space8),
          Obx(() {
            final expandable =
                BuyerProductDetailCon.kSpecRows.length > _collapsedRows;
            if (!expandable) return const SizedBox.shrink();
            final expanded = controller.specsExpanded.value;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () =>
                    controller.specsExpanded.value = !controller.specsExpanded.value,
                child: AppText(
                  text: expanded ? 'Show less' : 'Show more',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textInfo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.attribute,
    required this.value,
    required this.stripe,
  });

  final String attribute;
  final String value;
  final bool stripe;

  @override
  Widget build(BuildContext context) {
    final bg = stripe
        ? AppColors.primaryLight.withValues(alpha: 0.45)
        : AppColors.backGroundWhite;
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space12,
        vertical: AppSize.space8,
      ),
      backgroundColor: bg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 45,
            child: AppText(
              text: attribute,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 55,
            child: AppText(
              text: value,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
