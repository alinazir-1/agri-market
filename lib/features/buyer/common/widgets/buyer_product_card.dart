import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/home/home_ticker_con.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_scr.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class BuyerProductGridCard extends StatelessWidget {
  const BuyerProductGridCard({
    super.key,
    required this.product,
    required this.sectionType,
  });

  final DummyProduct product;
  final int sectionType;

  @override
  Widget build(BuildContext context) {
    if (sectionType == 1) {
      return _BuyerAdvanceBookingCard(product: product);
    }
    if (sectionType == 2) {
      return _BuyerLiveAuctionCard(product: product);
    }
    return _BuyerMarketplaceCard(product: product);
  }
}

void _resumeHomeMotionAfterProductDetail(String scopeTag) {
  try {
    Get.delete<BuyerProductDetailCon>(tag: scopeTag, force: true);
  } catch (_) {
    if (Get.isRegistered<BuyerProductDetailCon>()) {
      Get.delete<BuyerProductDetailCon>(force: true);
    }
  }
  // Resume after the frame where the underlying [HomeScr] is laid in again — synchronous
  // resume from [Get.to]'.then runs too early on web and the marquee stays stopped.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.isRegistered<HomeCon>()) {
      Get.find<HomeCon>().resumeHomeMotionAfterRouteOverlay();
    }
    if (Get.isRegistered<HomeTickerCon>()) {
      Get.find<HomeTickerCon>().resumeAfterRouteOverlay();
    }
  });
}

void openBuyerProductDetail(DummyProduct product, int sectionType) {
  HomeBinding.ensureHomeCon();
  HomeBinding.ensureHomeTickerCon();
  Get.find<HomeCon>().dismissBuyerHomeOverlaysNow();
  Get.find<HomeCon>().pauseHomeMotionForRouteOverlay();
  Get.find<HomeTickerCon>().pauseForRouteOverlay();

  // Unique scope per open — route builders on web can rerun; passing [BuyerProductDetailCon]
  // by reference led to null / stale closures. Tag-based [Get.find] is reliable.
  final scopeTag =
      'buyer_pd_${product.id}_${sectionType}_${DateTime.now().microsecondsSinceEpoch}';

  Get.put<BuyerProductDetailCon>(
    BuyerProductDetailCon(
      product: product,
      sectionType: sectionType,
    ),
    tag: scopeTag,
  );

  final nav = Get.to<void>(
    () => BuyerProductDetailScr(scopeTag: scopeTag),
    transition: Transition.rightToLeft,
    duration: const Duration(milliseconds: 240),
  );
  (nav ?? Future<void>.value())
      .then((_) => _resumeHomeMotionAfterProductDetail(scopeTag));
}

class BuyerProductCardUiCon extends GetxController {
  final RxSet<String> favouriteProductIds = <String>{}.obs;
  final RxnString hoveredMarketplaceImageId = RxnString();
  final RxnString hoveredAdvanceBookingImageId = RxnString();
  final RxnString hoveredLiveAuctionImageId = RxnString();
  final RxnString hoveredProductCardId = RxnString();

  bool isFavourite(String productId) => favouriteProductIds.contains(productId);

  void toggleFavourite(String productId) {
    if (favouriteProductIds.contains(productId)) {
      favouriteProductIds.remove(productId);
      return;
    }
    favouriteProductIds.add(productId);
  }

  void setMarketplaceImageHover(String productId) {
    hoveredMarketplaceImageId.value = productId;
  }

  void clearMarketplaceImageHover(String productId) {
    if (hoveredMarketplaceImageId.value == productId) {
      hoveredMarketplaceImageId.value = null;
    }
  }

  void setAdvanceBookingImageHover(String productId) {
    hoveredAdvanceBookingImageId.value = productId;
  }

  void clearAdvanceBookingImageHover(String productId) {
    if (hoveredAdvanceBookingImageId.value == productId) {
      hoveredAdvanceBookingImageId.value = null;
    }
  }

  void setLiveAuctionImageHover(String productId) {
    hoveredLiveAuctionImageId.value = productId;
  }

  void clearLiveAuctionImageHover(String productId) {
    if (hoveredLiveAuctionImageId.value == productId) {
      hoveredLiveAuctionImageId.value = null;
    }
  }

  void setProductCardShellHover(String productId) {
    hoveredProductCardId.value = productId;
  }

  void clearProductCardShellHover(String productId) {
    if (hoveredProductCardId.value == productId) {
      hoveredProductCardId.value = null;
    }
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.productId, required this.child});

  final String productId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final con = _buyerProductCardUiCon();
    return MouseRegion(
      onEnter: (_) => con.setProductCardShellHover(productId),
      onExit: (_) => con.clearProductCardShellHover(productId),
      child: Obx(
        () {
          final hovered = con.hoveredProductCardId.value == productId;
          return AppContainer(
            backgroundColor: hovered
                ? AppColors.backGroundWhite
                : AppColors.backGroundTransparent,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            border: Border.all(
              color: hovered
                  ? AppColors.borderLight
                  : AppColors.borderLight.withValues(alpha: 0),
            ),
            boxShadows: hovered
                ? [
                    BoxShadow(
                      color: AppColors.shadowBase.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.shadowBase.withValues(alpha: 0.04),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : const [],
            clipBehavior: Clip.hardEdge,
            child: child,
          );
        },
      ),
    );
  }
}

class _BuyerMarketplaceCard extends StatelessWidget {
  const _BuyerMarketplaceCard({required this.product});

  final DummyProduct product;

  @override
  Widget build(BuildContext context) {
    final favCon = _buyerProductCardUiCon();
    final showVerifiedBadge = product.id.hashCode.isEven;
    return _CardShell(
      productId: product.id,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 16,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: MouseRegion(
                onEnter: (_) => favCon.setMarketplaceImageHover(product.id),
                onExit: (_) => favCon.clearMarketplaceImageHover(product.id),
                child: GestureDetector(
                  onTap: () => openBuyerProductDetail(product, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Obx(
                          () {
                            final isHovered =
                                favCon.hoveredMarketplaceImageId.value ==
                                    product.id;
                            return AnimatedScale(
                              scale: isHovered ? 1.12 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              child: _CardImage(path: product.imagePath),
                            );
                          },
                        ),
                        const Positioned.fill(
                          child: AppContainer(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                AppColors.mediaImageScrimDark,
                                AppColors.backGroundTransparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: AppSize.space8,
                          right: AppSize.space8,
                          child: Obx(
                            () {
                              final isFav = favCon.isFavourite(product.id);
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () =>
                                      favCon.toggleFavourite(product.id),
                                  child: AppContainer(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.radiusCircular),
                                    backgroundColor: AppColors.backGroundWhite
                                        .withValues(alpha: 0.92),
                                    border: Border.all(
                                        color: AppColors.borderLight),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: AppSize.icon16,
                                      color: isFav
                                          ? AppColors.emeraldGreen
                                          : AppColors.iconSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderMeta(
                        name: product.name,
                        location: product.location,
                        grade: product.grade,
                        showGradeBadge: false,
                      ),
                      const SizedBox(height: AppSize.space2),
                      AppText(
                        text:
                            'PKR ${product.price.toStringAsFixed(0)}/${product.unit}',
                        fontSize: AppSize.font16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textEmeraldGreen,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSize.space2),
                      AppText(
                        text: 'MOQ 20 ${product.unit}',
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (showVerifiedBadge)
                  Positioned(
                    top: -24,
                    left: 20,
                    child: AppContainer(
                      width: 28,
                      height: 28,
                      borderRadius:
                          BorderRadius.circular(AppSize.radiusCircular),
                      backgroundColor: AppColors.backGroundWhite,
                      border: Border.all(color: AppColors.borderLight),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/logo/verified-account.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerAdvanceBookingCard extends StatelessWidget {
  const _BuyerAdvanceBookingCard({required this.product});

  final DummyProduct product;

  @override
  Widget build(BuildContext context) {
    final favCon = _buyerProductCardUiCon();
    final showVerifiedBadge = product.id.hashCode.isEven;
    return _CardShell(
      productId: product.id,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 16,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: MouseRegion(
                onEnter: (_) => favCon.setAdvanceBookingImageHover(product.id),
                onExit: (_) => favCon.clearAdvanceBookingImageHover(product.id),
                child: GestureDetector(
                  onTap: () => openBuyerProductDetail(product, 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Obx(
                          () {
                            final isHovered =
                                favCon.hoveredAdvanceBookingImageId.value ==
                                    product.id;
                            return AnimatedScale(
                              scale: isHovered ? 1.12 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              child: _CardImage(path: product.imagePath),
                            );
                          },
                        ),
                        const Positioned.fill(
                          child: AppContainer(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                AppColors.mediaImageScrimDark,
                                AppColors.backGroundTransparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            backgroundColor: AppColors.emeraldGreen,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: AppSize.icon12,
                                  color: AppColors.iconWhite,
                                ),
                                const SizedBox(width: AppSize.space4),
                                const AppText(
                                  text: 'Harvest Date',
                                  fontSize: AppSize.font10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textWhite,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: AppSize.space8),
                                Expanded(
                                  child: AppText(
                                    text: product.bookingDate ?? 'Coming soon',
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 26,
                          right: AppSize.space8,
                          child: Obx(
                            () {
                              final isFav = favCon.isFavourite(product.id);
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () =>
                                      favCon.toggleFavourite(product.id),
                                  child: AppContainer(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.radiusCircular),
                                    backgroundColor: AppColors.backGroundWhite
                                        .withValues(alpha: 0.92),
                                    border: Border.all(
                                        color: AppColors.borderLight),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: AppSize.icon16,
                                      color: isFav
                                          ? AppColors.emeraldGreen
                                          : AppColors.iconSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderMeta(
                        name: product.name,
                        location: product.location,
                        grade: product.grade,
                        showGradeBadge: false,
                      ),
                      const SizedBox(height: AppSize.space2),
                      Row(
                        children: [
                          const AppText(
                            text: 'Booking price ',
                            fontSize: AppSize.font14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(
                            child: AppText(
                              text:
                                  'PKR ${product.price.toStringAsFixed(0)}/${product.unit}',
                              fontSize: AppSize.font14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textEmeraldGreen,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.space2),
                      AppText(
                        text: 'MOQ 20 ${product.unit}',
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (showVerifiedBadge)
                  Positioned(
                    top: -24,
                    left: 20,
                    child: AppContainer(
                      width: 28,
                      height: 28,
                      borderRadius:
                          BorderRadius.circular(AppSize.radiusCircular),
                      backgroundColor: AppColors.backGroundWhite,
                      border: Border.all(color: AppColors.borderLight),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/logo/verified-account.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerLiveAuctionCard extends StatelessWidget {
  const _BuyerLiveAuctionCard({required this.product});

  final DummyProduct product;

  @override
  Widget build(BuildContext context) {
    final favCon = _buyerProductCardUiCon();
    final showVerifiedBadge = product.id.hashCode.isEven;
    final bool endingSoon = (product.currentBid ?? product.price) % 2 == 0;
    final timer = product.auctionTimeLeft ?? '2h 00m';
    return _CardShell(
      productId: product.id,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 16,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: MouseRegion(
                onEnter: (_) => favCon.setLiveAuctionImageHover(product.id),
                onExit: (_) => favCon.clearLiveAuctionImageHover(product.id),
                child: GestureDetector(
                  onTap: () => openBuyerProductDetail(product, 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Obx(
                          () {
                            final isHovered =
                                favCon.hoveredLiveAuctionImageId.value ==
                                    product.id;
                            return AnimatedScale(
                              scale: isHovered ? 1.12 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              child: _CardImage(path: product.imagePath),
                            );
                          },
                        ),
                        const Positioned.fill(
                          child: AppContainer(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                AppColors.mediaImageScrimDarkAlt,
                                AppColors.backGroundTransparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            backgroundColor: endingSoon
                                ? AppColors.badgeWarningText
                                : AppColors.emeraldGreen,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: AppSize.icon12,
                                  color: AppColors.iconWhite,
                                ),
                                const SizedBox(width: AppSize.space4),
                                const Expanded(
                                  child: AppText(
                                    text: 'Time Left',
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textWhite,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (endingSoon) ...[
                                  AppContainer(
                                    width: AppSize.space8,
                                    height: AppSize.space8,
                                    borderRadius:
                                        BorderRadius.circular(AppSize.space4),
                                    backgroundColor: AppColors.textWhite,
                                  ),
                                  const SizedBox(width: AppSize.space4),
                                ],
                                AppText(
                                  text: timer,
                                  fontSize: AppSize.font10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textWhite,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 26,
                          left: AppSize.space8,
                          child: _StatusPill(
                            text: 'Live',
                            bg: AppColors.badgeSuccessBg
                                .withValues(alpha: 0.95),
                            fg: AppColors.badgeSuccessText,
                          ),
                        ),
                        Positioned(
                          top: 26,
                          right: AppSize.space8,
                          child: Obx(
                            () {
                              final isFav = favCon.isFavourite(product.id);
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () =>
                                      favCon.toggleFavourite(product.id),
                                  child: AppContainer(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.radiusCircular),
                                    backgroundColor: AppColors.backGroundWhite
                                        .withValues(alpha: 0.92),
                                    border: Border.all(
                                        color: AppColors.borderLight),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: AppSize.icon16,
                                      color: isFav
                                          ? AppColors.emeraldGreen
                                          : AppColors.iconSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderMeta(
                        name: product.name,
                        location: product.location,
                        grade: product.grade,
                        showGradeBadge: false,
                      ),
                      const SizedBox(height: AppSize.space2),
                      AppText(
                        text:
                            'Starting bid price PKR ${product.price.toStringAsFixed(0)}/${product.unit}',
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSize.space2),
                      AppText(
                        text:
                            'Current bid price PKR ${(product.currentBid ?? product.price).toStringAsFixed(0)}/${product.unit}',
                        fontSize: AppSize.font16,
                        fontWeight: FontWeight.w700,
                        color: endingSoon
                            ? AppColors.badgeWarningText
                            : AppColors.textEmeraldGreen,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (showVerifiedBadge)
                  Positioned(
                    top: -24,
                    left: 20,
                    child: AppContainer(
                      width: 28,
                      height: 28,
                      borderRadius:
                          BorderRadius.circular(AppSize.radiusCircular),
                      backgroundColor: AppColors.backGroundWhite,
                      border: Border.all(color: AppColors.borderLight),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/logo/verified-account.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(
          Icons.eco_outlined,
          color: AppColors.iconEmeraldGreen,
          size: AppSize.icon32,
        ),
      ),
    );
  }
}

class _ImageMeta extends StatelessWidget {
  const _ImageMeta({
    required this.name,
    required this.location,
    required this.grade,
  });

  final String name;
  final String location;
  final String grade;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          text: name,
          fontSize: AppSize.font14,
          fontWeight: FontWeight.w700,
          color: AppColors.textWhite,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space2),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: AppSize.font10,
              color: AppColors.iconWhite,
            ),
            const SizedBox(width: AppSize.space2),
            Expanded(
              child: AppText(
                text: location,
                fontSize: AppSize.font10,
                color: AppColors.textWhite,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSize.space4),
            _StatusPill(
              text: grade,
              bg: AppColors.badgeInfoBg.withValues(alpha: 0.92),
              fg: AppColors.badgeInfoText,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderMeta extends StatelessWidget {
  const _HeaderMeta({
    required this.name,
    required this.location,
    required this.grade,
    this.showGradeBadge = true,
  });

  final String name;
  final String location;
  final String grade;
  final bool showGradeBadge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: name,
          fontSize: AppSize.font16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space2),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: AppSize.font10,
              color: AppColors.iconSecondary,
            ),
            const SizedBox(width: AppSize.space2),
            Expanded(
              child: AppText(
                text: location,
                fontSize: AppSize.font10,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showGradeBadge) ...[
              const SizedBox(width: AppSize.space2),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _StatusPill(
                    text: 'Grade $grade',
                    bg: AppColors.badgeInfoBg.withValues(alpha: 0.92),
                    fg: AppColors.badgeInfoText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.text,
    required this.bg,
    required this.fg,
  });

  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(AppSize.radius20),
      backgroundColor: bg,
      child: AppText(
        text: text,
        fontSize: AppSize.font10,
        fontWeight: FontWeight.w700,
        color: fg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            text: label,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSize.space8),
        Expanded(
          child: AppText(
            text: value,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w700,
            color: valueColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

BuyerProductCardUiCon _buyerProductCardUiCon() {
  if (!Get.isRegistered<BuyerProductCardUiCon>()) {
    Get.put(BuyerProductCardUiCon(), permanent: true);
  }
  return Get.find<BuyerProductCardUiCon>();
}
