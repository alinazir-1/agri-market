// home_con.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/home/buyer_category_strip_catalog.dart';
import 'package:agri_market/features/seller/add_product/product_catalog_data.dart';
import 'package:agri_market/features/buyer/home/widgets/home_category_hover_popover.dart';
import 'package:agri_market/features/buyer/home/buyer_shell_search_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class TickerItem {
  final String name;
  final String price;
  final double change;
  const TickerItem({required this.name, required this.price, required this.change});
}

class DummyProduct {
  final String id;
  final String name;
  final String imagePath;
  final String category;
  final String grade;
  final double price;
  final String unit;
  final String location;
  final String variety;
  final String? bookingDate;
  final double? currentBid;
  final String? auctionTimeLeft;

  const DummyProduct({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.grade,
    required this.price,
    required this.unit,
    required this.location,
    required this.variety,
    this.bookingDate,
    this.currentBid,
    this.auctionTimeLeft,
  });
}

/// One row for minimal category PLP: product + which trade section it belongs to.
class DummyProductSection {
  const DummyProductSection({
    required this.product,
    required this.sectionType,
  });

  final DummyProduct product;
  /// `0` marketplace, `1` advance booking, `2` live auction.
  final int sectionType;
}

class HomeCon extends GetxController {
  /// Hero trade-mode scroll target (heading + first grid when a mode is revealed).
  final GlobalKey heroTradeProductBlockKey =
      GlobalKey(debugLabel: 'heroTradeProductBlock');

  /// `-1` = Top-Ranked only; `0` Marketplace, `1` Advance Booking, `2` Live Auctions.
  final RxInt homeRevealedTradeSection = (-1).obs;

  /// Hero + top-bar search — owned by [BuyerShellSearchCon] (not disposed when [HomeCon] closes).
  TextEditingController get searchCtrl =>
      Get.find<BuyerShellSearchCon>().searchCtrl;

  /// Top-bar compact search — only while hero [_HeroSearchRow] is fully scrolled off-screen.
  final RxBool showCompactTopBarSearch = false.obs;

  /// Anchors hero banner search for viewport overlap checks ([KeyedSubtree] in [HomeHeroSourcingBanner]).
  final GlobalKey heroBannerSearchKey =
      GlobalKey(debugLabel: 'heroBannerSearch');

  /// Match [BuyerTopBar] fixed bar height (`SizedBox` — padding + logo).
  static const double kBuyerTopBarHeight =
      AppSize.space8 + AppSize.space40 + AppSize.space8;

  /// Shows compact top search only when [heroBannerSearchKey] does **not** overlap the visible body below the top bar.
  void syncCompactTopBarSearchVisibility(BuildContext context) {
    final heroCtx = heroBannerSearchKey.currentContext;
    if (heroCtx == null || !heroCtx.mounted) {
      if (showCompactTopBarSearch.value) showCompactTopBarSearch.value = false;
      return;
    }
    final box = heroCtx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;

    final topLeft = box.localToGlobal(Offset.zero);
    final searchRect = Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      box.size.width,
      box.size.height,
    );

    final mq = MediaQuery.of(context);
    final viewTop = mq.padding.top + kBuyerTopBarHeight;
    final viewRect = Rect.fromLTWH(
      0,
      viewTop,
      mq.size.width,
      mq.size.height - viewTop,
    );

    final heroSearchStillVisible = searchRect.overlaps(viewRect);
    final next = !heroSearchStillVisible;
    if (showCompactTopBarSearch.value != next) {
      showCompactTopBarSearch.value = next;
    }
  }

  final RxBool isMessageOpen = false.obs;
  final RxBool isCartOpen    = false.obs;
  final RxBool isOrderOpen   = false.obs;
  final RxBool isProfileOpen = false.obs;

  // ── Home category strip (one tile per arrow tap) ────────────────────────────
  final ScrollController categoryStripScrollController = ScrollController();

  /// Circle diameter — keep in sync with [HomeCategorySquareStrip].
  static const double categoryStripTileSide =
      AppSize.space64 + AppSize.space56 + AppSize.space20; // 140

  static const double categoryStripTileGap = AppSize.space12;

  /// Label area under circle (two lines max).
  static const double categoryStripLabelBlockHeight = AppSize.space40;

  /// Full column height for arrow hit targets (circle + gap + label).
  static double get categoryStripColumnHeight =>
      categoryStripTileSide + AppSize.space8 + categoryStripLabelBlockHeight;

  /// One column + trailing gap (horizontal scroll step).
  static double get categoryStripScrollStep =>
      categoryStripTileSide + categoryStripTileGap;

  void categoryStripScrollNext() => _categoryStripScrollBy(1);

  void categoryStripScrollPrevious() => _categoryStripScrollBy(-1);

  void _categoryStripScrollBy(int direction) {
    final c = categoryStripScrollController;
    if (!c.hasClients) return;
    final maxExtent = c.position.maxScrollExtent;
    final next = (c.offset + direction * categoryStripScrollStep)
        .clamp(0.0, maxExtent)
        .toDouble();
    c.animateTo(
      next,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  // ── Category strip: hover lift + dropdown under column ─────────────────────
  /// Hovered column index (web-safe: fixed [GlobalKey] list, no [Map.putIfAbsent]).
  final Rxn<int> categoryStripHoverIndex = Rxn<int>();

  List<GlobalKey> _categoryStripColumnKeys = <GlobalKey>[];

  void _ensureCategoryStripKeys() {
    final n = BuyerCategoryStripCatalog.entries.length;
    if (_categoryStripColumnKeys.length == n) return;
    _categoryStripColumnKeys =
        List<GlobalKey>.generate(n, (_) => GlobalKey());
  }

  GlobalKey categoryStripColumnKeyAt(int index) {
    if (index < 0 || index >= _categoryStripColumnKeys.length) {
      return GlobalKey();
    }
    return _categoryStripColumnKeys[index];
  }

  Timer? _categoryStripDropdownTimer;
  OverlayEntry? _categoryStripProductOverlayEntry;
  static const Duration _categoryStripDropdownHideDelay =
      Duration(milliseconds: 160);

  void onCategoryStripColumnEnter(int index) {
    _categoryStripDropdownTimer?.cancel();
    categoryStripHoverIndex.value = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (categoryStripHoverIndex.value != index) return;
      if (index < 0 || index >= _categoryStripColumnKeys.length) return;
      final ctx = _categoryStripColumnKeys[index].currentContext;
      if (ctx == null || !ctx.mounted) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize || !box.attached) return;
      if (Overlay.maybeOf(ctx) == null) return;
      final title = BuyerCategoryStripCatalog.entries[index].name;
      _insertCategoryStripProductOverlay(ctx, box, title);
    });
  }

  void onCategoryStripColumnExit() {
    _categoryStripDropdownTimer?.cancel();
    _categoryStripDropdownTimer =
        Timer(_categoryStripDropdownHideDelay, () {
      categoryStripHoverIndex.value = null;
      _removeCategoryStripProductOverlay();
    });
  }

  void onCategoryStripProductOverlayPointerEnter() {
    _categoryStripDropdownTimer?.cancel();
  }

  void _removeCategoryStripProductOverlay() {
    _categoryStripProductOverlayEntry?.remove();
    _categoryStripProductOverlayEntry = null;
  }

  /// Removes category / strip overlays immediately (e.g. before [Get.to]) so
  /// overlay rebuilds do not race route pushes on web ("wrong build scope").
  void dismissBuyerHomeOverlaysNow() {
    _allCategoriesMenuTimer?.cancel();
    _categoryStripDropdownTimer?.cancel();
    showAllCategoriesMenu.value = false;
    categoryStripHoverIndex.value = null;
    _removeAllCategoriesOverlay();
    _removeCategoryStripProductOverlay();
  }

  void _insertCategoryStripProductOverlay(
    BuildContext itemContext,
    RenderBox columnBox,
    String categoryTitle,
  ) {
    final overlayState = Overlay.maybeOf(itemContext);
    if (overlayState == null) return;

    _categoryStripProductOverlayEntry?.remove();

    final topLeft = columnBox.localToGlobal(Offset.zero);
    final bottomY = topLeft.dy + columnBox.size.height;
    final screenW = MediaQuery.sizeOf(itemContext).width;
    final panelW = (screenW * 0.9).clamp(760.0, 1080.0);
    final rawLeft = topLeft.dx - (panelW - columnBox.size.width) / 2;
    final left = rawLeft.clamp(
      AppSize.space8,
      screenW - panelW - AppSize.space8,
    );

    _categoryStripProductOverlayEntry = OverlayEntry(
      builder: (overlayCtx) {
        return Stack(
          children: [
            Positioned(
              top: bottomY,
              left: left,
              child: MouseRegion(
                onEnter: (_) => onCategoryStripProductOverlayPointerEnter(),
                onExit: (_) => onCategoryStripColumnExit(),
                child: HomeCategoryHoverPopover(
                  width: panelW,
                  categoryTitle: categoryTitle,
                  onCtaTap: _removeCategoryStripProductOverlay,
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_categoryStripProductOverlayEntry!);
  }

  // ── Buyer top bar: All Categories anchor + hover menu (full-width overlay) ─
  final GlobalKey buyerSecondaryNavBarKey =
      GlobalKey(debugLabel: 'buyerSecondaryNavBar');

  /// Overlay positions under this key; set in [onAllCategoriesMenuEnter]. Avoids duplicate
  /// [GlobalKey] when multiple [BuyerTopBar]s exist (e.g. home + pushed detail route).
  GlobalKey? _categoriesMenuAnchorOverride;
  final RxBool showAllCategoriesMenu = false.obs;
  /// Left-column selection in the all-categories overlay (GetX — no [StatefulBuilder]).
  final RxInt allCategoriesMenuSelectedIndex = 0.obs;
  Timer? _allCategoriesMenuTimer;
  OverlayEntry? _allCategoriesOverlayEntry;
  ScrollController? _allCategoriesLeftListScrollController;
  static const Duration _allCategoriesMenuHideDelay = Duration(milliseconds: 160);

  void selectAllCategoriesMenuItem(int index, int nameCount) {
    if (nameCount <= 0) return;
    final maxI = nameCount - 1;
    final clamped = index < 0 ? 0 : (index > maxI ? maxI : index);
    allCategoriesMenuSelectedIndex.value = clamped;
  }

  /// [anchorKey] — key on the "All categories" control that opened the menu (unique per top bar).
  /// Omit to use [buyerSecondaryNavBarKey] (e.g. secondary nav row).
  void onAllCategoriesMenuEnter([GlobalKey? anchorKey]) {
    _allCategoriesMenuTimer?.cancel();
    _categoriesMenuAnchorOverride = anchorKey;
    showAllCategoriesMenu.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!showAllCategoriesMenu.value) return;
      _insertAllCategoriesOverlay();
    });
  }

  /// Keeps the menu open while the pointer moves from the trigger into the overlay.
  void onAllCategoriesOverlayPointerEnter() {
    _allCategoriesMenuTimer?.cancel();
  }

  void onAllCategoriesMenuExit() {
    _allCategoriesMenuTimer?.cancel();
    _allCategoriesMenuTimer = Timer(_allCategoriesMenuHideDelay, () {
      showAllCategoriesMenu.value = false;
      _categoriesMenuAnchorOverride = null;
      _removeAllCategoriesOverlay();
    });
  }

  void _removeAllCategoriesOverlay() {
    _allCategoriesOverlayEntry?.remove();
    _allCategoriesOverlayEntry = null;
    _allCategoriesLeftListScrollController?.dispose();
    _allCategoriesLeftListScrollController = null;
  }

  void _insertAllCategoriesOverlay() {
    final anchor =
        _categoriesMenuAnchorOverride ?? buyerSecondaryNavBarKey;
    final ctx = anchor.currentContext;
    if (ctx == null || !showAllCategoriesMenu.value) return;

    final overlayState = Overlay.maybeOf(ctx);
    if (overlayState == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final topY = box.localToGlobal(Offset.zero).dy + box.size.height;
    final categoryNames = List<String>.from(ProductCatalogData.catalog.keys)
      ..sort();
    categoryNames.remove('Animal Protein Sources');
    categoryNames.insert(0, 'Animal Protein Sources');
    final Map<String, List<String>> productsByCategory = {
      for (final name in categoryNames)
        name: ProductCatalogData.catalog[name]
                ?.values
                .expand((products) => products)
                .toList() ??
            const <String>[],
    };

    _allCategoriesLeftListScrollController?.dispose();
    _allCategoriesLeftListScrollController = ScrollController();
    allCategoriesMenuSelectedIndex.value = 0;

    _allCategoriesOverlayEntry?.remove();
    _allCategoriesOverlayEntry = OverlayEntry(
      builder: (overlayCtx) {
        final screenW = MediaQuery.sizeOf(overlayCtx).width;
        final maxH = (MediaQuery.sizeOf(overlayCtx).height * 0.45)
            .clamp(240.0, 420.0);
        final panelOuterH = maxH + AppSize.space16 + AppSize.space12;
        return Stack(
          children: [
            Positioned(
              top: topY,
              left: 0,
              width: screenW,
              height: panelOuterH,
              child: ClipRect(
                child: MouseRegion(
                  onEnter: (_) => onAllCategoriesOverlayPointerEnter(),
                  onExit: (_) => onAllCategoriesMenuExit(),
                  child: Material(
                    color: AppColors.backGroundTransparent,
                    elevation: AppSize.space8,
                    child: Obx(() {
                      if (categoryNames.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final last = categoryNames.length - 1;
                      var idx = allCategoriesMenuSelectedIndex.value;
                      if (idx < 0) idx = 0;
                      if (idx > last) idx = last;
                      final selectedName = categoryNames[idx];
                      final selectedProducts =
                          productsByCategory[selectedName] ?? const <String>[];

                      return AppContainer(
                        width: screenW,
                        height: panelOuterH,
                        padding: const EdgeInsets.fromLTRB(
                          AppSize.space20,
                          AppSize.space16,
                          AppSize.space20,
                          AppSize.space12,
                        ),
                        backgroundColor: AppColors.backGroundWhite,
                        border: const Border(
                          bottom: BorderSide(color: AppColors.borderLight),
                        ),
                        child: SizedBox(
                          height: maxH,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (screenW * 0.28).clamp(260.0, 340.0),
                                child: ListView.separated(
                                  controller:
                                      _allCategoriesLeftListScrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: categoryNames.length,
                                  separatorBuilder: (_, __) => const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColors.borderLight,
                                  ),
                                  itemBuilder: (context, i) {
                                    final label = categoryNames[i];
                                    final active = i == idx;
                                    return Material(
                                      color: active
                                          ? AppColors.backgroundHover
                                          : AppColors.backGroundTransparent,
                                      child: MouseRegion(
                                        onEnter: (_) =>
                                            selectAllCategoriesMenuItem(
                                          i,
                                          categoryNames.length,
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              selectAllCategoriesMenuItem(
                                            i,
                                            categoryNames.length,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 8,
                                            ),
                                            child: AppText(
                                              text: label,
                                              fontSize: AppSize.font14,
                                              fontWeight: active
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: AppColors.textPrimary,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              height: 1.35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSize.space24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: selectedName,
                                      fontSize: AppSize.font16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    const SizedBox(height: AppSize.space12),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          spacing: AppSize.space16,
                                          runSpacing: AppSize.space16,
                                          children: List<Widget>.generate(
                                            selectedProducts.length,
                                            (pIdx) {
                                              return SizedBox(
                                                width: 120,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    AppContainer(
                                                      width: AppSize.space64,
                                                      height: AppSize.space64,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            AppColors.borderGray,
                                                      ),
                                                      backgroundColor:
                                                          AppColors
                                                              .backGroundWhite,
                                                    ),
                                                    const SizedBox(
                                                      height: AppSize.space8,
                                                    ),
                                                    AppText(
                                                      text: selectedProducts[
                                                          pIdx],
                                                      fontSize: AppSize.font12,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.textPrimary,
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                      height: 1.3,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_allCategoriesOverlayEntry!);
  }

  // ── Campaign banner carousel (`assets/banner images/` only) ───────────────
  static const List<String> campaignBannerAssetPaths = <String>[
    AppImages.homeBanner1,
    AppImages.homeBanner2,
    AppImages.homeBanner3,
    AppImages.homeBanner4,
    AppImages.homeBanner5,
  ];

  /// Eager init — widgets may read this before [onInit] runs (GetX / web ordering).
  final PageController campaignBannerPageController = PageController();
  final RxInt campaignBannerIndex = 0.obs;

  int get campaignBannerCount => campaignBannerAssetPaths.length;

  void onCampaignBannerPageChanged(int i) {
    if (i >= 0 && i < campaignBannerCount) campaignBannerIndex.value = i;
  }

  void setCampaignBannerPage(int i) {
    if (campaignBannerCount <= 0 || i < 0 || i >= campaignBannerCount) return;
    campaignBannerIndex.value = i;
    void jump() {
      if (campaignBannerPageController.hasClients) {
        campaignBannerPageController.jumpToPage(i);
      }
    }

    jump();
    WidgetsBinding.instance.addPostFrameCallback((_) => jump());
  }

  // ── Banner ──────────────────────────────────────────────────────────────────
  final RxInt bannerIndex = 0.obs;
  Timer? _bannerTimer;

  static const int bannerCount = 5;

  static const List<Map<String, dynamic>> bannerData = [
    {'color': Color(0xFF4CAF50), 'tagBg': Color(0xFFECFDF5), 'tagColor': Color(0xFF16A34A), 'tag': 'NEW SEASON',       'title': 'Fresh Harvest Season is Here',          'sub': 'Direct from farms — freshest produce guaranteed',         'emoji': '🌾', 'btnColor': Color(0xFF4CAF50)},
    {'color': Color(0xFFD97706), 'tagBg': Color(0xFFFEF3C7), 'tagColor': Color(0xFFD97706), 'tag': 'BULK OFFER',        'title': '15% Off on Orders Above 100 Bags',       'sub': 'Premium grains direct from verified sellers',              'emoji': '📦', 'btnColor': Color(0xFFD97706)},
    {'color': Color(0xFFDC2626), 'tagBg': Color(0xFFFEE2E2), 'tagColor': Color(0xFFDC2626), 'tag': 'LIVE NOW',          'title': 'Live Auctions Running — Join & Bid Now', 'sub': 'Transparent real-time bidding on top-quality produce',      'emoji': '🔨', 'btnColor': Color(0xFFDC2626)},
    {'color': Color(0xFF1D4ED8), 'tagBg': Color(0xFFDBEAFE), 'tagColor': Color(0xFF1D4ED8), 'tag': 'ADVANCE BOOKING',  'title': 'Reserve Next Season\'s Harvest Now',     'sub': 'Lock prices before market fluctuations hit',               'emoji': '📅', 'btnColor': Color(0xFF1D4ED8)},
    {'color': Color(0xFF1B5E20), 'tagBg': Color(0xFFECFDF5), 'tagColor': Color(0xFF1B5E20), 'tag': 'TRUSTED',          'title': 'Pakistan\'s #1 B2B Agriculture Platform','sub': '10,000+ farmers and buyers connected nationwide',           'emoji': '🏆', 'btnColor': Color(0xFF1B5E20)},
  ];

  // ── Ticker ──────────────────────────────────────────────────────────────────
  static const List<TickerItem> tickerItems = [
    TickerItem(name: 'Wheat (Grade A)',  price: 'PKR 3,200/40kg',  change:  1.2),
    TickerItem(name: 'Basmati Rice',    price: 'PKR 4,800/40kg',  change: -0.5),
    TickerItem(name: 'Maize',           price: 'PKR 2,100/40kg',  change:  0.8),
    TickerItem(name: 'Sugarcane',       price: 'PKR 450/40kg',    change:  0.0),
    TickerItem(name: 'Cotton',          price: 'PKR 8,500/40kg',  change:  2.1),
    TickerItem(name: 'Sunflower Seeds', price: 'PKR 3,700/40kg',  change: -1.0),
    TickerItem(name: 'Chickpeas',       price: 'PKR 12,000/40kg', change:  3.5),
    TickerItem(name: 'Soybean',         price: 'PKR 5,600/40kg',  change: -0.3),
    TickerItem(name: 'Mustard',         price: 'PKR 7,200/40kg',  change:  0.9),
    TickerItem(name: 'Turmeric',        price: 'PKR 18,000/40kg', change: -1.4),
  ];

  // ── Categories ──────────────────────────────────────────────────────────────
  static const List<Map<String, String>> categories = [
    {'label': 'Grains & Cereals', 'image': 'assets/category images/grains.png'},
    {'label': 'Fresh Produce',    'image': 'assets/category images/fresh-produce.png'},
    {'label': 'Legumes',          'image': 'assets/category images/Legumes.png'},
    {'label': 'Animal Feeds',     'image': 'assets/category images/animalfeed.png'},
    {'label': 'By-Products',      'image': 'assets/category images/byproducts.png'},
    {'label': 'Fodder & Forage',  'image': 'assets/category images/fodder.png'},
    {'label': 'Livestock',        'image': 'assets/category images/livestock.png'},
    {'label': 'Oil Seeds',        'image': 'assets/category images/Oil Seeds.png'},
  ];

  // ── Products ─────────────────────────────────────────────────────────────────
  static const List<DummyProduct> marketplaceProducts = [
    DummyProduct(id: 'm1', name: 'Basmati Rice',    imagePath: 'assets/images/rice.png',          category: 'Grains',    grade: 'A',  price: 4800,  unit: '40kg', location: 'Lahore',     variety: '1121 Sella'),
    DummyProduct(id: 'm2', name: 'Yellow Maize',    imagePath: 'assets/images/buyermarket2.png',  category: 'Grains',    grade: 'B+', price: 2100,  unit: '40kg', location: 'Faisalabad', variety: 'Hybrid'),
    DummyProduct(id: 'm3', name: 'Desi Chickpeas',  imagePath: 'assets/images/buyermarket3.png',  category: 'Legumes',   grade: 'A',  price: 12000, unit: '40kg', location: 'Multan',     variety: 'Desi'),
    DummyProduct(id: 'm4', name: 'Sunflower Seeds', imagePath: 'assets/images/buyermarket4.png',  category: 'Oil Seeds', grade: 'A+', price: 3700,  unit: '40kg', location: 'Sahiwal',    variety: 'Hybrid'),
    DummyProduct(id: 'm5', name: 'Mustard Seeds',   imagePath: 'assets/images/buyermarket6.png',  category: 'Oil Seeds', grade: 'B+', price: 7200,  unit: '40kg', location: 'Gujranwala', variety: 'Toria'),
  ];

  static const List<DummyProduct> advanceBookingProducts = [
    DummyProduct(id: 'ab1', name: 'Wheat Harvest',  imagePath: 'assets/images/buyermarket5.png', category: 'Grains',        grade: 'A',  price: 3200, unit: '40kg', location: 'Sahiwal',      variety: 'Sargodha-2023', bookingDate: 'Apr 2026'),
    DummyProduct(id: 'ab2', name: 'Fresh Mangoes',  imagePath: 'assets/images/buyermarket6.png', category: 'Fresh Produce', grade: 'A+', price: 6000, unit: '40kg', location: 'Multan',       variety: 'Chaunsa',       bookingDate: 'Jun 2026'),
    DummyProduct(id: 'ab3', name: 'Kinnow Citrus',  imagePath: 'assets/images/buyermarket2.png', category: 'Fresh Produce', grade: 'B+', price: 2800, unit: '40kg', location: 'Sargodha',     variety: 'Sweet Kinnow',  bookingDate: 'Dec 2026'),
    DummyProduct(id: 'ab4', name: 'Sugarcane',      imagePath: 'assets/images/buyermarket3.png', category: 'Grains',        grade: 'A',  price: 450,  unit: '40kg', location: 'Rahim Yar Khan',variety: 'CPF-246',       bookingDate: 'Feb 2027'),
    DummyProduct(id: 'ab5', name: 'Cotton Bales',   imagePath: 'assets/images/buyermarket4.png', category: 'Cash Crops',    grade: 'A',  price: 8500, unit: '40kg', location: 'Bahawalpur',   variety: 'NIAB-2023',     bookingDate: 'Oct 2026'),
  ];

  static const List<DummyProduct> liveAuctionProducts = [
    DummyProduct(id: 'la1', name: 'Premium Cotton',    imagePath: 'assets/images/buyermarket4.png', category: 'Cash Crops', grade: 'A+', price: 8500,  unit: '40kg', location: 'Bahawalpur', variety: 'NIAB-2023',    currentBid: 9200,  auctionTimeLeft: '2h 14m'),
    DummyProduct(id: 'la2', name: 'Buffalo Ghee',      imagePath: 'assets/images/buyermarket5.png', category: 'Livestock',  grade: 'A',  price: 22000, unit: '1kg',  location: 'Quetta',     variety: 'Pure Buffalo', currentBid: 24000, auctionTimeLeft: '45m'),
    DummyProduct(id: 'la3', name: 'Red Chilli',        imagePath: 'assets/images/buyermarket6.png', category: 'Spices',     grade: 'B+', price: 5400,  unit: '40kg', location: 'Kunri',      variety: 'Teja',         currentBid: 5900,  auctionTimeLeft: '3h 30m'),
    DummyProduct(id: 'la4', name: 'Mung Beans',        imagePath: 'assets/images/rice.png',         category: 'Legumes',    grade: 'A',  price: 9800,  unit: '40kg', location: 'Jhang',      variety: 'NM-2011',      currentBid: 10200, auctionTimeLeft: '1h 05m'),
    DummyProduct(id: 'la5', name: 'Organic Turmeric',  imagePath: 'assets/images/buyermarket6.png', category: 'Spices',     grade: 'A+', price: 18000, unit: '40kg', location: 'Mirpur Khas',variety: 'Lakadong',     currentBid: 19500, auctionTimeLeft: '4h 20m'),
  ];

  static List<DummyProduct> productsForSection(int section) {
    switch (section) {
      case 0: return marketplaceProducts;
      case 1: return advanceBookingProducts;
      case 2: return liveAuctionProducts;
      default: return marketplaceProducts;
    }
  }

  /// All dummy products whose [DummyProduct.category] equals [category] (first wins per id).
  static List<DummyProductSection> plpEntriesForCategory(String category) {
    final out = <DummyProductSection>[];
    final seen = <String>{};
    void addAll(List<DummyProduct> list, int section) {
      for (final p in list) {
        if (p.category == category && seen.add(p.id)) {
          out.add(DummyProductSection(product: p, sectionType: section));
        }
      }
    }
    addAll(marketplaceProducts, 0);
    addAll(advanceBookingProducts, 1);
    addAll(liveAuctionProducts, 2);
    return out;
  }

  /// Exactly 20 cards per mode on home (10 above + 10 below campaign banner).
  static const int homeTradeModeFeaturedCount = 20;

  static List<DummyProduct> get marketplaceHomeFeatured20 {
    final m = marketplaceProducts;
    if (m.isEmpty) return const <DummyProduct>[];
    return List<DummyProduct>.generate(
      homeTradeModeFeaturedCount,
      (i) => m[i % m.length],
    );
  }

  static List<DummyProduct> get advanceBookingHomeFeatured20 {
    final list = advanceBookingProducts;
    if (list.isEmpty) return const <DummyProduct>[];
    return List<DummyProduct>.generate(
      homeTradeModeFeaturedCount,
      (i) => list[i % list.length],
    );
  }

  static List<DummyProduct> get liveAuctionHomeFeatured20 {
    final list = liveAuctionProducts;
    if (list.isEmpty) return const <DummyProduct>[];
    return List<DummyProduct>.generate(
      homeTradeModeFeaturedCount,
      (i) => list[i % list.length],
    );
  }

  void scrollToHeroTradeProductBlock() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = heroTradeProductBlockKey.currentContext;
      if (ctx != null && ctx.mounted) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.06,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  /// Hero Marketplace / Advance Booking / Live Auctions: reveal that block on home + scroll.
  void revealHomeTradeSectionAndScroll(int sectionIndex) {
    homeRevealedTradeSection.value = sectionIndex;
    scrollToHeroTradeProductBlock();
  }

  // ── Banner logic ─────────────────────────────────────────────────────────────
  void setBanner(int i) => bannerIndex.value = i;
  void nextBanner()     => bannerIndex.value = (bannerIndex.value + 1) % bannerCount;
  void startBannerAutoPlay() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) => nextBanner());
  }
  void restartBannerAutoPlay() => startBannerAutoPlay();

  // ── Dropdown logic ────────────────────────────────────────────────────────────
  /// Called before pushing buyer product detail (and similar full-screen routes) so
  /// timers / [PageView] motion do not tick alongside GetX route transitions (web layout asserts).
  void pauseHomeMotionForRouteOverlay() {
    dismissBuyerHomeOverlaysNow();
    _bannerTimer?.cancel();
    _bannerTimer = null;
    final n = campaignBannerCount;
    if (n > 0 && campaignBannerPageController.hasClients) {
      final i = campaignBannerIndex.value.clamp(0, n - 1);
      campaignBannerPageController.jumpToPage(i);
    }
  }

  void resumeHomeMotionAfterRouteOverlay() {
    startBannerAutoPlay();
  }

  void closeAllDropdowns() {
    isMessageOpen.value = false;
    isCartOpen.value    = false;
    isOrderOpen.value   = false;
    isProfileOpen.value = false;
  }

  void toggleDropdown(String which) {
    final cur = _get(which);
    closeAllDropdowns();
    _set(which, !cur);
  }

  bool _get(String w) {
    if (w == 'message') return isMessageOpen.value;
    if (w == 'cart')    return isCartOpen.value;
    if (w == 'order')   return isOrderOpen.value;
    if (w == 'profile') return isProfileOpen.value;
    return false;
  }

  void _set(String w, bool v) {
    if (w == 'message') isMessageOpen.value = v;
    if (w == 'cart')    isCartOpen.value    = v;
    if (w == 'order')   isOrderOpen.value   = v;
    if (w == 'profile') isProfileOpen.value = v;
  }

  @override
  void onInit() {
    super.onInit();
    _ensureCategoryStripKeys();
    startBannerAutoPlay();
  }

  @override
  void onClose() {
    campaignBannerPageController.dispose();
    _bannerTimer?.cancel();
    _allCategoriesMenuTimer?.cancel();
    _removeAllCategoriesOverlay();
    _categoryStripDropdownTimer?.cancel();
    _removeCategoryStripProductOverlay();
    categoryStripScrollController.dispose();
    super.onClose();
  }
}
