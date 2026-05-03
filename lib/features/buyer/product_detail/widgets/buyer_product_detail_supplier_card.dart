import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Right-column contact supplier card + Send message.
class BuyerProductDetailSupplierCard extends StatelessWidget {
  const BuyerProductDetailSupplierCard({
    super.key,
    required this.controller,
    this.edgeAttached = false,
  });

  final BuyerProductDetailCon controller;

  /// Flush to viewport right: flat right edge, rounded left + stronger shadow (wide layout).
  final bool edgeAttached;

  @override
  Widget build(BuildContext context) {
    final chipRadius = BorderRadius.circular(AppSize.radius12);
    final attachedRadius = BorderRadius.only(
      topLeft: Radius.circular(AppSize.radius12),
      bottomLeft: Radius.circular(AppSize.radius12),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          text: 'Contact supplier',
          fontSize: AppSize.font16,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space8),
        AppContainer(
          padding: const EdgeInsets.all(AppSize.space16),
          borderRadius: edgeAttached ? attachedRadius : chipRadius,
          backgroundColor: AppColors.backGroundWhite,
          border: edgeAttached
              ? Border(
                  left: BorderSide(color: AppColors.borderLight),
                  top: BorderSide(color: AppColors.borderLight),
                  bottom: BorderSide(color: AppColors.borderLight),
                )
              : Border.all(color: AppColors.borderLight),
          clipBehavior: Clip.hardEdge,
          boxShadows: edgeAttached
              ? [
                  BoxShadow(
                    color: AppColors.shadowBase.withValues(alpha: 0.14),
                    blurRadius: 28,
                    offset: const Offset(-10, 14),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: AppColors.shadowBase.withValues(alpha: 0.08),
                    blurRadius: 22,
                    offset: const Offset(0, 18),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.shadowBase.withValues(alpha: 0.08),
                    blurRadius: AppSize.space16,
                    offset: const Offset(0, AppSize.space8),
                  ),
                ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppContainer(
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    backgroundColor: AppColors.backGroundLightGrey,
                    border: Border.all(color: AppColors.borderLight),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.storefront_outlined,
                      size: AppSize.icon24,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: AppText(
                      text: controller.displaySupplierName,
                      fontSize: AppSize.font16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space16),
              AppElevatedButton(
                text: 'Send message',
                onPressed: () {},
                width: double.infinity,
                height: 44,
                backgroundColor: AppColors.textInfo,
                textColor: AppColors.textWhite,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                borderRadius: AppSize.radius8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
