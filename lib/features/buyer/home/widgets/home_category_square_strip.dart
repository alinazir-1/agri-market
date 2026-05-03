import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/home/buyer_category_strip_catalog.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Horizontal category row: circular image + name, hover opens cart-style popover below.
class HomeCategorySquareStrip extends StatelessWidget {
  const HomeCategorySquareStrip({super.key});

  /// Fixed-width rails so chevrons stay outside the carousel; tiles must not paint over them.
  static const double _navRailWidth = AppSize.space48;

  static const double _navToCarouselGap = AppSize.space12;

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();
    const side = HomeCon.categoryStripTileSide;
    final entries = BuyerCategoryStripCatalog.entries;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSize.space32,
        right: AppSize.space32,
        bottom: AppSize.space16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: con.categoryStripScrollPrevious,
              child: AppContainer(
                width: _navRailWidth,
                height: HomeCon.categoryStripColumnHeight,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: AppSize.icon20,
                  color: AppColors.iconSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: _navToCarouselGap),
          Expanded(
            child: SingleChildScrollView(
              // Default was Clip.none: scroll content painted after the left rail, so circles
              // drew on top of the chevrons. Clip the viewport so tiles stay inside the lane.
              clipBehavior: Clip.hardEdge,
              controller: con.categoryStripScrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: List.generate(entries.length, (i) {
                  final e = entries[i];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i == entries.length - 1
                          ? 0
                          : HomeCon.categoryStripTileGap,
                    ),
                    child: _HomeCategoryStripItem(
                      index: i,
                      name: e.name,
                      imagePath: e.imagePath,
                      diameter: side,
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: _navToCarouselGap),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: con.categoryStripScrollNext,
              child: AppContainer(
                width: _navRailWidth,
                height: HomeCon.categoryStripColumnHeight,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: AppSize.icon20,
                  color: AppColors.iconSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One catalog column (renamed from [_CategoryCircleColumn] for clearer hot-restart / identity).
class _HomeCategoryStripItem extends StatelessWidget {
  const _HomeCategoryStripItem({
    required this.index,
    required this.name,
    required this.imagePath,
    required this.diameter,
  });

  final int index;
  final String name;
  final String imagePath;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => con.onCategoryStripColumnEnter(index),
      onExit: (_) => con.onCategoryStripColumnExit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space4,
          vertical: AppSize.space8,
        ),
        child: AppContainer(
          key: con.categoryStripColumnKeyAt(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppContainer(
                width: diameter,
                height: diameter,
                shape: BoxShape.circle,
                clipBehavior: Clip.antiAlias,
                border: Border.all(color: AppColors.borderLight),
                backgroundColor: AppColors.backGroundWhite,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.category_outlined,
                      color: AppColors.iconSecondary,
                      size: AppSize.icon24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.space8),
              SizedBox(
                width: diameter,
                height: HomeCon.categoryStripLabelBlockHeight,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AppText(
                    text: name,
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
