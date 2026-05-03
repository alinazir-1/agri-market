// lib/features/buyer/home/widgets/home_campaign_banner_band.dart
//
// Default: Top-Ranked (mixed modes). After hero taps: that mode’s heading +
// 10 + banner + 10. Assets from `assets/banner images/` via [HomeCon.campaignBannerAssetPaths].

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_product_card.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Matches `BuyerProductGridCard` grid aspect used across buyer home blocks.
const double _kHomeProductGridChildAspectRatio = 0.76;

class _SpotlightEntry {
  const _SpotlightEntry(this.product, this.sectionType);

  final DummyProduct product;
  final int sectionType;
}

/// Ten cards (2 rows × 5): cycles Marketplace → Advance Booking → Live Auctions.
List<_SpotlightEntry> _topRankedTenEntries() {
  final m = HomeCon.marketplaceProducts;
  final ab = HomeCon.advanceBookingProducts;
  final la = HomeCon.liveAuctionProducts;
  if (m.isEmpty || ab.isEmpty || la.isEmpty) return [];
  var mi = 0;
  var abi = 0;
  var lai = 0;
  final out = <_SpotlightEntry>[];
  for (var i = 0; i < 10; i++) {
    final mod = i % 3;
    if (mod == 0) {
      out.add(_SpotlightEntry(m[mi % m.length], 0));
      mi++;
    } else if (mod == 1) {
      out.add(_SpotlightEntry(ab[abi % ab.length], 1));
      abi++;
    } else {
      out.add(_SpotlightEntry(la[lai % la.length], 2));
      lai++;
    }
  }
  return out;
}

/// [BuyerProductGridCard] row strip (5 × 2).
class _TopRankedTenGrid extends StatelessWidget {
  const _TopRankedTenGrid();

  static const int _cols = 5;
  static const int _rows = 2;

  @override
  Widget build(BuildContext context) {
    final entries = _topRankedTenEntries();
    if (entries.length < 10) return const SizedBox.shrink();

    Widget cell(_SpotlightEntry e) {
      return AspectRatio(
        aspectRatio: _kHomeProductGridChildAspectRatio,
        child: BuyerProductGridCard(
          product: e.product,
          sectionType: e.sectionType,
        ),
      );
    }

    Widget rowOfFive(int startIndex) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var c = 0; c < _cols; c++) ...[
            if (c > 0) const SizedBox(width: AppSize.space12),
            Expanded(child: cell(entries[startIndex + c])),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var r = 0; r < _rows; r++) ...[
          if (r > 0) const SizedBox(height: AppSize.space12),
          rowOfFive(r * _cols),
        ],
      ],
    );
  }
}

List<DummyProduct> _featuredForRevealedSection(int section) {
  switch (section) {
    case 0:
      return HomeCon.marketplaceHomeFeatured20;
    case 1:
      return HomeCon.advanceBookingHomeFeatured20;
    case 2:
      return HomeCon.liveAuctionHomeFeatured20;
    default:
      return const <DummyProduct>[];
  }
}

String _headingForRevealedSection(int section) {
  switch (section) {
    case 0:
      return 'Marketplace';
    case 1:
      return 'Advance Booking';
    case 2:
      return 'Live Auctions';
    default:
      return '';
  }
}

/// [BuyerProductGridCard] row strip for one trade mode.
class _TradeSectionTenGrid extends StatelessWidget {
  const _TradeSectionTenGrid({
    required this.products,
    required this.sectionType,
  });

  final List<DummyProduct> products;
  final int sectionType;

  static const int _cols = 5;
  static const int _rows = 2;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    Widget cell(DummyProduct p) {
      return AspectRatio(
        aspectRatio: _kHomeProductGridChildAspectRatio,
        child: BuyerProductGridCard(
          product: p,
          sectionType: sectionType,
        ),
      );
    }

    Widget rowOfFive(int startIndex) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var c = 0; c < _cols; c++) ...[
            if (c > 0) const SizedBox(width: AppSize.space12),
            Expanded(child: cell(products[startIndex + c])),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var r = 0; r < _rows; r++) ...[
          if (r > 0) const SizedBox(height: AppSize.space12),
          rowOfFive(r * _cols),
        ],
      ],
    );
  }
}

/// Visual height — allowed band ~180–220px per layout brief.
class HomeCampaignBannerBand extends StatelessWidget {
  const HomeCampaignBannerBand({super.key});

  Widget _campaignCarousel(HomeCon con, List<String> paths) {
    if (paths.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.radius12),
          child: AppContainer(
            height: 200,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            backgroundColor: AppColors.backgroundSurface,
            child: paths.length == 1
                ? _CampaignBannerImage(assetPath: paths.single)
                : PageView.builder(
                    controller: con.campaignBannerPageController,
                    onPageChanged: con.onCampaignBannerPageChanged,
                    itemCount: paths.length,
                    itemBuilder: (context, i) =>
                        _CampaignBannerImage(assetPath: paths[i]),
                  ),
          ),
        ),
        if (paths.length > 1) ...[
          const SizedBox(height: AppSize.space12),
          Obx(() {
            final active = con.campaignBannerIndex.value;
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSize.space8,
              runSpacing: AppSize.space8,
              children: List<Widget>.generate(paths.length, (i) {
                final selected = i == active;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => con.setCampaignBannerPage(i),
                    child: AppContainer(
                      width: selected ? 10 : 8,
                      height: 8,
                      borderRadius: BorderRadius.circular(AppSize.radius4),
                      backgroundColor: selected
                          ? AppColors.emeraldGreen
                          : AppColors.borderGray,
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final paths = HomeCon.campaignBannerAssetPaths;
    final con = Get.find<HomeCon>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSize.space32,
        AppSize.space16,
        AppSize.space32,
        AppSize.space8,
      ),
      child: Obx(() {
        final revealed = con.homeRevealedTradeSection.value;
        final showTradeBlock = revealed >= 0 && revealed <= 2;
        final featured =
            showTradeBlock ? _featuredForRevealedSection(revealed) : const <DummyProduct>[];
        final first10 =
            featured.isEmpty ? <DummyProduct>[] : featured.sublist(0, 10);
        final second10 =
            featured.isEmpty ? <DummyProduct>[] : featured.sublist(10, 20);
        final heading = showTradeBlock ? _headingForRevealedSection(revealed) : '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!showTradeBlock)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppText(
                    text: 'Top-Ranked Products',
                    fontSize: AppSize.font20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSize.space12),
                  const _TopRankedTenGrid(),
                ],
              )
            else
              KeyedSubtree(
                key: con.heroTradeProductBlockKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      text: heading,
                      fontSize: AppSize.font20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSize.space12),
                    _TradeSectionTenGrid(
                      products: first10,
                      sectionType: revealed,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSize.space16),
            _campaignCarousel(con, paths),
            if (showTradeBlock) ...[
              const SizedBox(height: AppSize.space16),
              _TradeSectionTenGrid(
                products: second10,
                sectionType: revealed,
              ),
            ],
          ],
        );
      }),
    );
  }
}

class _CampaignBannerImage extends StatelessWidget {
  const _CampaignBannerImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => AppContainer(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        backgroundColor: AppColors.backgroundSurface,
        child: const AppText(
          text: 'Campaign banner unavailable',
          fontSize: AppSize.font14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
