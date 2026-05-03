import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/seller/add_product/product_catalog_data.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Hover popover under "Source by category": same product tiles as All Categories mega menu.
class HomeCategoryHoverPopover extends StatelessWidget {
  const HomeCategoryHoverPopover({
    super.key,
    required this.width,
    required this.categoryTitle,
    this.onCtaTap,
  });

  final double width;
  final String categoryTitle;
  final VoidCallback? onCtaTap;

  static const double _tileW = 120;
  static const double _gridMaxH = 232;
  static const int _itemsPerRow = 6;

  List<String> _productsForCategory(String title) {
    final section = ProductCatalogData.catalog[title];
    if (section == null) return const <String>[];
    return section.values.expand((products) => products).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _productsForCategory(categoryTitle);

    return SizedBox(
      width: width,
      child: AppContainer(
        padding: const EdgeInsets.fromLTRB(
          AppSize.space12,
          AppSize.space12,
          AppSize.space12,
          AppSize.space8,
        ),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        border: Border.all(color: AppColors.borderLight),
        boxShadows: [
          BoxShadow(
            color: AppColors.shadowBase.withValues(alpha: 0.10),
            blurRadius: AppSize.space24,
            offset: const Offset(0, AppSize.space8),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: categoryTitle,
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppSize.space8),
            if (products.isEmpty) ...[
              const Center(
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: AppSize.space64,
                  color: AppColors.iconSecondary,
                ),
              ),
              const SizedBox(height: AppSize.space8),
              const Center(
                child: AppText(
                  text: 'product not found',
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
              ),
            ] else
              SizedBox(
                height: _gridMaxH,
                child: GridView.builder(
                  primary: false,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _itemsPerRow,
                    mainAxisSpacing: AppSize.space4,
                    crossAxisSpacing: AppSize.space4,
                    mainAxisExtent: 88,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final name = products[i];
                    return SizedBox(
                      width: _tileW,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppContainer(
                            width: AppSize.space56,
                            height: AppSize.space56,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.borderGray,
                            ),
                            backgroundColor: AppColors.backGroundWhite,
                          ),
                          const SizedBox(height: AppSize.space2),
                          AppText(
                            text: name,
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            height: 1.25,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
