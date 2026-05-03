import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Price, sample bar, payment/shipping, optional discover freight (wide: discover moves to bottom row).
class BuyerProductDetailInfoPanel extends StatelessWidget {
  const BuyerProductDetailInfoPanel({
    super.key,
    required this.controller,
    this.showDiscoverFreight = true,
  });

  final BuyerProductDetailCon controller;

  /// When false (wide layout), [BuyerProductDetailDiscoverFreightButton] is placed beside supplier.
  final bool showDiscoverFreight;

  @override
  Widget build(BuildContext context) {
    final priceLine =
        '${controller.formattedMainPricePkr()} per ${controller.unitLabel}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Product price',
          fontSize: AppSize.font12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space4),
        AppText(
          text: priceLine,
          fontSize: AppSize.font24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space16),
        _SamplePriceBar(controller: controller),
        const SizedBox(height: AppSize.space24),
        AppText(
          text: 'Payment and shipping information',
          fontSize: AppSize.font16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space12),
        _InfoLine(
          label: 'Payment method',
          value: BuyerProductDetailCon.kPaymentMethods,
        ),
        const SizedBox(height: AppSize.space8),
        _InfoLine(
          label: 'Trading areas',
          value: BuyerProductDetailCon.kTradingAreas,
        ),
        const SizedBox(height: AppSize.space8),
        _InfoLine(
          label: 'Shipping information',
          value: BuyerProductDetailCon.kShippingInfo,
        ),
        if (showDiscoverFreight) ...[
          const SizedBox(height: AppSize.space20),
          const BuyerProductDetailDiscoverFreightButton(),
        ],
      ],
    );
  }
}

/// Outlined discover action — reused on wide layout beside [BuyerProductDetailSupplierCard].
class BuyerProductDetailDiscoverFreightButton extends StatelessWidget {
  const BuyerProductDetailDiscoverFreightButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      text: 'Discover freight cost',
      onPressed: () {},
      width: 280,
      height: 44,
      backgroundColor: AppColors.backGroundWhite,
      textColor: AppColors.textPrimary,
      fontSize: AppSize.font14,
      fontWeight: FontWeight.w600,
      borderRadius: AppSize.radius8,
      elevation: 0,
      border: const BorderSide(color: AppColors.textPrimary, width: 1),
    );
  }
}

class _SamplePriceBar extends StatelessWidget {
  const _SamplePriceBar({required this.controller});

  final BuyerProductDetailCon controller;

  @override
  Widget build(BuildContext context) {
    final sample = controller.formattedSamplePricePkr();

    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space16,
        vertical: AppSize.space12,
      ),
      borderRadius: BorderRadius.circular(AppSize.radius8),
      backgroundColor: AppColors.backGroundLightGrey,
      border: Border.all(color: AppColors.borderLight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: AppSize.icon20,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: AppSize.space12),
          Expanded(child: _SamplePriceText(sample: sample)),
          const SizedBox(width: AppSize.space12),
          _GetSampleButton(onPressed: () {}),
        ],
      ),
    );
  }
}

class _SamplePriceText extends StatelessWidget {
  const _SamplePriceText({required this.sample});

  final String sample;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          fontSize: AppSize.font14,
          color: AppColors.textPrimary,
          height: 1.35,
        ),
        children: [
          const TextSpan(
            text: 'Sample price: ',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: sample,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _GetSampleButton extends StatelessWidget {
  const _GetSampleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AppContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space16,
            vertical: AppSize.space8,
          ),
          borderRadius: BorderRadius.circular(AppSize.radiusCircular),
          backgroundColor: AppColors.backGroundWhite,
          border: Border.all(color: AppColors.textPrimary),
          child: const AppText(
            text: 'Get sample',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          fontSize: AppSize.font14,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
