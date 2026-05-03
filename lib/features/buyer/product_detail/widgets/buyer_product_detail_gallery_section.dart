import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Thumbnail column + main image + chevrons. Single image: main only, no rail / arrows.
class BuyerProductDetailGallerySection extends StatelessWidget {
  const BuyerProductDetailGallerySection({super.key, required this.controller});

  final BuyerProductDetailCon controller;

  /// Main image box height — thumbnails scale to match this rail height.
  static const double _mainH = 300;

  /// Main image max width (height stays [_mainH]); heading sits to the right of this box.
  static const double _mainMaxW = 400;

  static const double _headingGap = AppSize.space16;
  static const double _headingMinReserve = 100;

  /// Vertical gap between thumbs when they fill main image height exactly.
  static const double _thumbGap = AppSize.space8;

  /// Below this height per thumb, use fixed-size scroll rail instead.
  static const double _minThumbFill = 44;

  /// Scroll fallback thumb size (many images).
  static const double _thumbScroll = 56;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final paths = controller.galleryAssetPaths();
      if (paths.isEmpty) {
        return const SizedBox.shrink();
      }
      final idx = controller.selectedGalleryIndex.value.clamp(0, paths.length - 1);
      final single = paths.length == 1;
      final mainPath = paths[idx];

      // Match left pane + [BoxFit.cover] so no light “letterbox” or white border ring.
      final main = AppContainer(
        height: _mainH,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        backgroundColor: AppColors.backgroundProductDetailLeft,
        clipBehavior: Clip.antiAlias,
        boxShadows: [
          BoxShadow(
            color: AppColors.shadowBase.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              mainPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: AppSize.icon24,
                  color: AppColors.textWhite,
                ),
              ),
            ),
            Positioned(
              top: AppSize.space12,
              right: AppSize.space12,
              child: Obx(
                () => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: controller.toggleWishlist,
                    child: AppContainer(
                      width: 40,
                      height: 40,
                      shape: BoxShape.circle,
                      backgroundColor:
                          AppColors.backGroundWhite.withValues(alpha: 0.95),
                      border: Border.all(color: AppColors.borderLight),
                      alignment: Alignment.center,
                      child: Icon(
                        controller.wishlisted.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: AppSize.icon20,
                        color: controller.wishlisted.value
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!single) ...[
              Positioned(
                left: AppSize.space12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _CircleNavIcon(
                    icon: Icons.chevron_left_rounded,
                    onTap: controller.galleryPrevious,
                  ),
                ),
              ),
              Positioned(
                right: AppSize.space12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _CircleNavIcon(
                    icon: Icons.chevron_right_rounded,
                    onTap: controller.galleryNext,
                  ),
                ),
              ),
            ],
          ],
        ),
      );

      if (single) {
        return LayoutBuilder(
          builder: (context, c) {
            final avail = c.maxWidth;
            final mainW = math.min(
              _mainMaxW,
              math.max(
                120.0,
                avail - _headingGap - _headingMinReserve,
              ),
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: mainW, height: _mainH, child: main),
                const SizedBox(width: _headingGap),
                const Expanded(
                  child: AppText(
                    text: 'Product price',
                    fontSize: AppSize.font20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        );
      }

      final n = paths.length;
      final fillThumb =
          (_mainH - (n - 1) * _thumbGap) / n;
      final useFillRail = fillThumb >= _minThumbFill;

      final Widget rail = useFillRail
          ? _ThumbRailFillHeight(
              paths: paths,
              selectedIndex: idx,
              thumbSize: fillThumb,
              gap: _thumbGap,
              height: _mainH,
              onSelect: controller.setGalleryIndex,
            )
          : _ThumbRailScroll(
              paths: paths,
              selectedIndex: idx,
              thumbSize: _thumbScroll,
              height: _mainH,
              onSelect: controller.setGalleryIndex,
            );

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rail,
          const SizedBox(width: AppSize.space12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final avail = c.maxWidth;
                final mainW = math.min(
                  _mainMaxW,
                  math.max(
                    120.0,
                    avail - _headingGap - _headingMinReserve,
                  ),
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: mainW, height: _mainH, child: main),
                    const SizedBox(width: _headingGap),
                    const Expanded(
                      child: AppText(
                        text: 'Product price',
                        fontSize: AppSize.font20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

/// Thumbs scale so [n] × size + gaps = [height] — top/bottom align with main image (reference).
class _ThumbRailFillHeight extends StatelessWidget {
  const _ThumbRailFillHeight({
    required this.paths,
    required this.selectedIndex,
    required this.thumbSize,
    required this.gap,
    required this.height,
    required this.onSelect,
  });

  final List<String> paths;
  final int selectedIndex;
  final double thumbSize;
  final double gap;
  final double height;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: thumbSize + AppSize.space8,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (var i = 0; i < paths.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            _GalleryThumb(
              path: paths[i],
              active: i == selectedIndex,
              thumbSize: thumbSize,
              onTap: () => onSelect(i),
            ),
          ],
        ],
      ),
    );
  }
}

/// Many thumbnails: fixed size inside [height], scroll (same bounds as main image).
class _ThumbRailScroll extends StatelessWidget {
  const _ThumbRailScroll({
    required this.paths,
    required this.selectedIndex,
    required this.thumbSize,
    required this.height,
    required this.onSelect,
  });

  final List<String> paths;
  final int selectedIndex;
  final double thumbSize;
  final double height;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: thumbSize + AppSize.space8,
      height: height,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < paths.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSize.space8),
              _GalleryThumb(
                path: paths[i],
                active: i == selectedIndex,
                thumbSize: thumbSize,
                onTap: () => onSelect(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({
    required this.path,
    required this.active,
    required this.thumbSize,
    required this.onTap,
  });

  final String path;
  final bool active;
  final double thumbSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSz = (thumbSize * 0.36).clamp(14.0, AppSize.icon24);
    final radius = (thumbSize * 0.11).clamp(4.0, AppSize.space8);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          width: thumbSize,
          height: thumbSize,
          borderRadius: BorderRadius.circular(radius),
          backgroundColor: AppColors.backgroundProductDetailLeft,
          border: active
              ? Border.all(
                  color: AppColors.freshGreen,
                  width: AppSize.borderWidth2,
                )
              : null,
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => AppContainer(
              backgroundColor: AppColors.backgroundProductDetailLeft,
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                size: iconSz,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleNavIcon extends StatelessWidget {
  const _CircleNavIcon({required this.icon, required this.onTap});

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
          backgroundColor: AppColors.backGroundWhite.withValues(alpha: 0.95),
          border: Border.all(color: AppColors.borderLight),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: AppSize.icon24,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
