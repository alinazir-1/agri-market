import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_product_card.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Buyer home: top-ranked grid (15), logistics strip, then 20 more cards.
class HomeFeaturedProducts extends StatelessWidget {
  const HomeFeaturedProducts({super.key});

  static const double _cardHeight = 268;
  static const double _logisticsBannerHeight = 250;
  static const int _cardsPerRow = 4;
  static const int _countBeforeBanner = 15;
  static const int _countAfterBanner = 20;

  static List<DummyProduct> _topRankedPool() {
    final pool = <DummyProduct>[
      ...HomeCon.marketplaceProducts,
      ...HomeCon.advanceBookingProducts,
    ];
    return List<DummyProduct>.generate(
      _countBeforeBanner + _countAfterBanner,
      (i) => pool[i % pool.length],
    );
  }

  static Widget _productGrid(List<DummyProduct> products) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const spacing = AppSize.space12;
        final cardWidth =
            (constraints.maxWidth - (spacing * (_cardsPerRow - 1))) /
                _cardsPerRow;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cardsPerRow,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: cardWidth / _cardHeight,
          ),
          itemBuilder: (_, i) => SizedBox(
            height: _cardHeight,
            child: BuyerProductGridCard(
              product: products[i],
              sectionType: 0,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _topRankedPool();
    final before = all.sublist(0, _countBeforeBanner);
    final after = all.sublist(_countBeforeBanner);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.space32,
            AppSize.space16,
            AppSize.space32,
            AppSize.space16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  AppText(
                    text: 'Top Ranked Products',
                    fontSize: AppSize.font20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space16),
              _productGrid(before),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.space32,
            AppSize.space8,
            AppSize.space32,
            AppSize.space8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.radius12),
            child: SizedBox(
              height: _logisticsBannerHeight,
              width: double.infinity,
              child: Image.asset(
                AppImages.modeLogisticBanner,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: AppColors.backGroundLightGrey,
                  child: Center(
                    child: AppText(
                      text: 'Logistics',
                      fontSize: AppSize.font16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.space32,
            0,
            AppSize.space32,
            AppSize.space16,
          ),
          child: _productGrid(after),
        ),
      ],
    );
  }
}
