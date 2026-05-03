import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Horizontal "More listings" band (dummy products + assets).
class BuyerProductDetailMoreListings extends StatelessWidget {
  const BuyerProductDetailMoreListings({super.key});

  static final List<_MoreListing> _items = [
    const _MoreListing(
      title: 'Barley Grains - Grade 2',
      imagePath: AppImages.p2,
      qtyLine: 'QTY: 40 tons',
      moq: 'MOQ: 10 tons',
      price: 'KES 38 / KG',
    ),
    const _MoreListing(
      title: 'Rye Grain - Grade 1',
      imagePath: AppImages.p3,
      qtyLine: 'QTY: 30 tons',
      moq: 'MOQ: 5 tons',
      price: 'KES 45 / KG',
    ),
  ];

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
            text: 'More Listings from ${BuyerProductDetailCon.kSellerName}',
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space16),
          LayoutBuilder(
            builder: (context, c) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: c.maxWidth),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _items.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSize.space12),
                        SizedBox(
                          width: 220,
                          child: _MoreListingCard(item: _items[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSize.space12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: AppText(
                text: 'Visit ${BuyerProductDetailCon.kSellerName}',
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                color: AppColors.textInfo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreListing {
  const _MoreListing({
    required this.title,
    required this.imagePath,
    required this.qtyLine,
    required this.moq,
    required this.price,
  });
  final String title;
  final String imagePath;
  final String qtyLine;
  final String moq;
  final String price;
}

class _MoreListingCard extends StatelessWidget {
  const _MoreListingCard({required this.item});

  final _MoreListing item;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      borderRadius: BorderRadius.circular(AppSize.radius8),
      backgroundColor: AppColors.backGroundLightGrey,
      border: Border.all(color: AppColors.borderLight),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: AppColors.backGroundLightGrey,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: AppSize.icon24,
                    color: AppColors.iconSecondary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSize.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: item.title,
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space4),
                AppText(
                  text: item.qtyLine,
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText(
                  text: item.moq,
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space4),
                AppText(
                  text: item.price,
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textEmeraldGreen,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space8),
                AppText(
                  text: BuyerProductDetailCon.kSellerName,
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText(
                  text: 'Kitale, Kenya',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
