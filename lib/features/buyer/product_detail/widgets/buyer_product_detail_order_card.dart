import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Pricing tiers, location, stock, qty stepper, subtotal, action grid (reference).
class BuyerProductDetailOrderCard extends StatelessWidget {
  const BuyerProductDetailOrderCard({super.key, required this.controller});

  final BuyerProductDetailCon controller;

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
          color: AppColors.shadowBase.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TierRow(
            label: BuyerProductDetailCon.kTier1RangeLabel,
            priceText:
                'KES ${BuyerProductDetailCon.kPriceTier1PerKg} per KGs',
          ),
          const SizedBox(height: AppSize.space8),
          _TierRow(
            label: BuyerProductDetailCon.kTier2RangeLabel,
            priceText:
                'KES ${BuyerProductDetailCon.kPriceTier2PerKg} per KGs',
          ),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: controller.locationLine,
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          AppText(
            text: BuyerProductDetailCon.kStockLabel,
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: 'Order Qty',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space8),
          Obx(() {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RoundIconButton(
                  icon: Icons.remove_rounded,
                  onTap: controller.decrementQty,
                ),
                Expanded(
                  child: Center(
                    child: AppText(
                      text: controller.formattedOrderQtyField(),
                      fontSize: AppSize.font16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                _RoundIconButton(
                  icon: Icons.add_rounded,
                  onTap: controller.incrementQty,
                ),
                const SizedBox(width: AppSize.space12),
                AppText(
                  text: controller.unitLabel,
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }),
          const SizedBox(height: AppSize.space16),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text:
                      'QTY Selected: ${controller.formattedQtySelected()}',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space4),
                AppText(
                  text:
                      'Item Subtotal: ${controller.formattedSubtotal()}',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }),
          const SizedBox(height: AppSize.space16),
          const _ActionGrid(),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.label, required this.priceText});

  final String label;
  final String priceText;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space12,
        vertical: AppSize.space8,
      ),
      borderRadius: BorderRadius.circular(AppSize.radius8),
      backgroundColor: AppColors.primaryLight,
      border: Border.all(color: AppColors.borderLight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AppText(
              text: label,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSize.space8),
          Flexible(
            child: AppText(
              text: priceText,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w700,
              color: AppColors.textEmeraldGreen,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          width: 40,
          height: 40,
          shape: BoxShape.circle,
          backgroundColor: AppColors.backGroundLightGrey,
          border: Border.all(color: AppColors.borderLight),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: AppSize.icon20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: 'Order Now',
                onPressed: () {},
                height: 44,
                backgroundColor: AppColors.emeraldGreen,
                textColor: AppColors.textWhite,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                borderRadius: AppSize.radius8,
              ),
            ),
            const SizedBox(width: AppSize.space8),
            Expanded(
              child: AppElevatedButton(
                text: 'Add to Cart',
                onPressed: () {},
                height: 44,
                backgroundColor: AppColors.textPrimary,
                textColor: AppColors.textWhite,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                borderRadius: AppSize.radius8,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.space8),
        Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: 'Send Query',
                onPressed: () {},
                height: 44,
                backgroundColor: AppColors.emerald100,
                textColor: AppColors.textEmeraldGreen,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                borderRadius: AppSize.radius8,
                elevation: 0,
                border: const BorderSide(color: AppColors.emeraldGreen),
              ),
            ),
            const SizedBox(width: AppSize.space8),
            Expanded(
              child: AppElevatedButton(
                text: 'Chat Now',
                onPressed: () {},
                height: 44,
                backgroundColor: AppColors.freshGreen,
                textColor: AppColors.textWhite,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                borderRadius: AppSize.radius8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
