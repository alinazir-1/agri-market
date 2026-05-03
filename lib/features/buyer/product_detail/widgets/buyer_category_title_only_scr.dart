import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Placeholder screen: category name only, centered (opened from product-detail breadcrumb).
class BuyerCategoryTitleOnlyScr extends StatelessWidget {
  const BuyerCategoryTitleOnlyScr({super.key, required this.categoryLabel});

  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final label =
        categoryLabel.trim().isEmpty ? 'Category' : categoryLabel.trim();

    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: Get.back<void>,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: AppSize.icon24,
                  color: AppColors.textPrimary,
                ),
                tooltip: 'Back',
                padding: const EdgeInsets.all(AppSize.space16),
                constraints: const BoxConstraints(
                  minWidth: AppSize.space48,
                  minHeight: AppSize.space48,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.space32),
                child: AppText(
                  text: label,
                  fontSize: AppSize.font24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
