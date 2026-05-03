import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';

/// Theme-aware shimmer colors (light / dark).
class AppShimmerTheme {
  AppShimmerTheme._();

  static (Color base, Color highlight) of(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return (
        AppColors.backGroundDarkCard2,
        AppColors.backGroundDarkHover,
      );
    }
    return (AppColors.shimmerBase, AppColors.shimmerHighlight);
  }
}

/// Wraps [child] with [Shimmer.fromColors] using project tokens.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (base, highlight) = AppShimmerTheme.of(context);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1100),
      child: child,
    );
  }
}

/// Rounded skeleton block (lists, tables, cards).
class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final r = borderRadius ?? BorderRadius.circular(AppSize.radius8);
    return AppShimmer(
      child: AppContainer(
        width: width,
        height: height,
        borderRadius: r,
        backgroundColor: context.cardBg2,
      ),
    );
  }
}

/// Centered loading placeholder (full-screen or inline).
class AppShimmerLoading extends StatelessWidget {
  const AppShimmerLoading({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  static double _resolveSize(double maxW, double maxH) {
    double m;
    if (maxW.isFinite && maxW > 0 && maxH.isFinite && maxH > 0) {
      m = maxW < maxH ? maxW : maxH;
    } else if (maxW.isFinite && maxW > 0) {
      m = maxW;
    } else if (maxH.isFinite && maxH > 0) {
      m = maxH;
    } else {
      m = 120;
    }
    final scaled = m * 0.42;
    if (scaled < 40) return 40;
    if (scaled > 160) return 160;
    return scaled;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = width ?? _resolveSize(constraints.maxWidth, constraints.maxHeight);
        final h = height ?? w;
        return AppContainer(
          width: w,
          height: h,
          alignment: Alignment.center,
          child: AppShimmer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppContainer(
                  width: w * 0.55,
                  height: h * 0.12,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  backgroundColor: context.cardBg2,
                ),
                SizedBox(height: h * 0.08),
                AppContainer(
                  width: w * 0.85,
                  height: h * 0.1,
                  borderRadius: BorderRadius.circular(AppSize.radius4),
                  backgroundColor: context.cardBg2,
                ),
                SizedBox(height: h * 0.06),
                AppContainer(
                  width: w * 0.7,
                  height: h * 0.1,
                  borderRadius: BorderRadius.circular(AppSize.radius4),
                  backgroundColor: context.cardBg2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Square thumb while bytes decode (product / cert images).
class AppThumbSkeleton extends StatelessWidget {
  const AppThumbSkeleton({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundSurface,
      child: Center(
        child: AppSkeletonBox(
          width: size * 0.72,
          height: size * 0.72,
          borderRadius: BorderRadius.circular(AppSize.radius8),
        ),
      ),
    );
  }
}

/// Full-page skeleton: top title row + stacked content rows (lists / dashboards).
class AppPageSkeleton extends StatelessWidget {
  const AppPageSkeleton({
    super.key,
    this.showSearchBar = true,
    this.rowCount = 6,
  });

  final bool showSearchBar;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppShimmer(
              child: Row(
                children: [
                  AppContainer(
                    width: 180,
                    height: AppSize.font24 + 4,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    backgroundColor: context.cardBg2,
                  ),
                  const Spacer(),
                  AppContainer(
                    width: 100,
                    height: AppSize.font12 + 8,
                    borderRadius: BorderRadius.circular(AppSize.radius4),
                    backgroundColor: context.cardBg2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSize.space16),
            if (showSearchBar) ...[
              AppSkeletonBox(
                width: double.infinity,
                height: 40,
                borderRadius: BorderRadius.circular(AppSize.radius8),
              ),
              const SizedBox(height: AppSize.space16),
            ],
            ...List.generate(rowCount, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: i == rowCount - 1 ? 0 : AppSize.space12),
                child: AppSkeletonBox(
                  width: double.infinity,
                  height: 56,
                  borderRadius: BorderRadius.circular(AppSize.radius12),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Horizontal row placeholders (table-style).
class AppListSkeleton extends StatelessWidget {
  const AppListSkeleton({
    super.key,
    this.itemCount = 8,
    this.itemHeight = 52,
  });

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        itemCount,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: i == itemCount - 1 ? 0 : AppSize.space8),
          child: AppSkeletonBox(
            width: double.infinity,
            height: itemHeight,
            borderRadius: BorderRadius.circular(AppSize.radius8),
          ),
        ),
      ),
    );
  }
}

/// Grid of card-sized skeletons (product grids).
class AppCardGridSkeleton extends StatelessWidget {
  const AppCardGridSkeleton({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.72,
    this.itemCount = 6,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSize.space16,
        crossAxisSpacing: AppSize.space16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return AppShimmer(
          child: AppContainer(
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            backgroundColor: context.cardBg2,
          ),
        );
      },
    );
  }
}
