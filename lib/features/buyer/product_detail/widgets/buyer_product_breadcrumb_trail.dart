import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/home/home_ticker_con.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_category_title_only_scr.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Buyer main shell with hero — same route as login → buyer. Clears stacked pages (detail, etc.).
void buyerBreadcrumbNavigateHome() {
  // Tear down buyer overlays *before* nuking the route stack. Otherwise [OverlayEntry]s tied to
  // the old subtree can still run layout/finalizers during [Get.offAllNamed], triggering
  // framework assertions ("check that it really is our descendant") from GetMaterialApp's overlay.
  FocusManager.instance.primaryFocus?.unfocus();
  if (Get.isRegistered<HomeCon>()) {
    Get.find<HomeCon>().dismissBuyerHomeOverlaysNow();
  }
  // [HomeTickerCon] is permanent — never delete here; only [resumeAfterRouteOverlay] after landing.
  Get.offAllNamed(AppRoutes.buyerDashboard);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    HomeBinding.ensureBuyerShellSearchCon();
    HomeBinding.ensureHomeCon();
    HomeBinding.ensureHomeTickerCon();
    if (Get.isRegistered<HomeCon>()) {
      Get.find<HomeCon>().resumeHomeMotionAfterRouteOverlay();
    }
    if (Get.isRegistered<HomeTickerCon>()) {
      Get.find<HomeTickerCon>().resumeAfterRouteOverlay();
    }
  });
}

/// Breadcrumb row: **Agrikrop** (home) › category (simple screen) › product name (plain text).
/// Matches compact B2B-style trails: small uppercase, `>` separators, dark gray.
class BuyerProductBreadcrumbTrail extends StatelessWidget {
  const BuyerProductBreadcrumbTrail({
    super.key,
    required this.categoryLabel,
    required this.productName,
  });

  final String categoryLabel;
  final String productName;

  static const String _rootLabel = 'Agrikrop';

  @override
  Widget build(BuildContext context) {
    final catRaw =
        categoryLabel.trim().isEmpty ? 'General' : categoryLabel.trim();
    final catTrail = catRaw.toUpperCase();
    final name = productName.trim().isEmpty
        ? 'PRODUCT'
        : productName.trim().toUpperCase();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSize.space4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BreadcrumbLink(
              label: _rootLabel,
              onTap: buyerBreadcrumbNavigateHome,
            ),
            _trailSeparator(),
            _BreadcrumbLink(
              label: catTrail,
              onTap: () => Get.to<void>(
                () => BuyerCategoryTitleOnlyScr(categoryLabel: catRaw),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 220),
              ),
            ),
            _trailSeparator(),
            AppText(
              text: name,
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _trailSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.space8),
      child: AppText(
        text: '>',
        fontSize: AppSize.font12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _BreadcrumbLink extends StatelessWidget {
  const _BreadcrumbLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppText(
          text: label,
          fontSize: AppSize.font12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
