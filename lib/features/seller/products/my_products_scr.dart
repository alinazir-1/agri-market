// lib/features/seller/products/my_products_scr.dart

import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/utils/product_image_storage.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/advance_booking_product_model.dart';
import 'package:agri_market/data/models/live_auction_product_model.dart';
import 'package:agri_market/data/models/marketplace_product_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/features/seller/products/my_products_con.dart';
import 'package:agri_market/features/seller/products/widgets/my_products_components.dart';
import 'package:agri_market/features/seller/products/widgets/my_products_card_style.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/shared/widgets/seller/status_pill.dart';
import 'package:agri_market/shared/widgets/seller/grade_pill.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_outlined_button.dart';
import '../../../shared/widgets/common/app_text.dart';
import '../../../shared/widgets/common/app_url_or_asset_image.dart';

class MyProductsScr extends StatelessWidget {
  MyProductsScr({super.key});

  final MyProductsCon c = Get.find<MyProductsCon>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
        children: [
          ScreenTopBar(
            title: 'My Products',
            subtitle: 'Manage all your listings in one place',
            searchController: c.searchController,
            onSearch: c.onSearch,
            searchHint: 'Search products...',
          ),
          _TabBar(c: c),
          _CategoryBar(c: c),
          _FilterBar(c: c),
          Expanded(child: _ProductList(c: c)),
        ],
      ),
    );
  }
}

// ─── TAB BAR ─────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final MyProductsCon c;
  const _TabBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      border: Border(bottom: BorderSide(color: context.borderClr)),
      padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
      child: Row(
        children: [
          Obx(
            () => _tab(
              context,
              label: 'Marketplace',
              icon: Icons.storefront_outlined,
              tab: MyProductsTab.marketplace,
              count: c.filteredMp.length,
            ),
          ),
          Obx(
            () => _tab(
              context,
              label: 'Advance Booking',
              icon: Icons.calendar_month_outlined,
              tab: MyProductsTab.advanceBooking,
              count: c.filteredAb.length,
            ),
          ),
          Obx(
            () => _tab(
              context,
              label: 'Live Auctions',
              icon: Icons.show_chart_rounded,
              tab: MyProductsTab.liveAuctions,
              count: c.filteredLa.length,
            ),
          ),
          const Spacer(),
          Obx(
            () => c.hasAnyProduct
                ? AppContainer(
                    margin: const EdgeInsets.only(left: AppSize.space8),
                    child: GestureDetector(
                      onTap: c.openCreateProduct,
                      child: AppContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space12,
                            vertical: AppSize.space8),
                        backgroundColor: AppColors.emeraldGreen,
                        borderRadius: BorderRadius.circular(AppSize.radius8),
                        child: const AppText(
                          text: 'Add New Product',
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context,
      {required String label,
      required IconData icon,
      required MyProductsTab tab,
      required int count}) {
    final active = c.activeTab.value == tab;
    return GestureDetector(
      onTap: () => c.setTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space4, vertical: AppSize.space12),
        margin: const EdgeInsets.only(right: AppSize.space20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active
                  ? AppColors.borderEmeraldGreen
                  : AppColors.backGroundTransparent,
              width: AppSize.borderWidth2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: AppSize.icon12,
                color:
                    active ? AppColors.iconEmeraldGreen : context.txtSecondary),
            const SizedBox(width: AppSize.space4),
            AppText(
                text: label,
                fontSize: AppSize.font12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color:
                    active ? AppColors.textEmeraldGreen : context.txtSecondary),
            const SizedBox(width: AppSize.space4),
            AppContainer(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space8, vertical: AppSize.space2),
              backgroundColor:
                  active ? AppColors.badgeSuccessBg : context.cardBg2,
              borderRadius: BorderRadius.circular(AppSize.radius20),
              child: AppText(
                  text: '$count',
                  fontSize: AppSize.font8,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.textEmeraldGreen
                      : context.txtSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── CATEGORY BAR ─────────────────────────────────────────────────────────────
class _CategoryBar extends StatelessWidget {
  final MyProductsCon c;
  const _CategoryBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      border: Border(bottom: BorderSide(color: context.borderClr)),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space20, vertical: AppSize.space8),
      child: Row(
        children: [
          Obx(() => GestureDetector(
                onTap: c.selectedCategoryIndex.value > 0
                    ? c.scrollCategoryPrev
                    : null,
                child: AppContainer(
                  width: 28,
                  height: 28,
                  backgroundColor: context.cardBg2,
                  borderRadius: BorderRadius.circular(AppSize.radius16),
                  border: Border.all(color: context.borderClr),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: AppSize.font10,
                    color: c.selectedCategoryIndex.value > 0
                        ? AppColors.iconEmeraldGreen
                        : AppColors.textSecondary,
                  ),
                ),
              )),
          const SizedBox(width: AppSize.space8),
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                controller: c.categoryScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: c.categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSize.space8),
                itemBuilder: (context, index) => Obx(() {
                  final active = c.selectedCategoryIndex.value == index;
                  return GestureDetector(
                    onTap: () => c.selectCategory(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space16,
                          vertical: AppSize.space4),
                      decoration: BoxDecoration(
                        color:
                            active ? AppColors.emeraldGreen : context.cardBg2,
                        borderRadius: BorderRadius.circular(AppSize.radius20),
                        border: Border.all(
                          color: active
                              ? AppColors.borderEmeraldGreen
                              : context.borderClr,
                          width: AppSize.borderWidth1,
                        ),
                      ),
                      child: AppText(
                        text: c.categories[index].name,
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        color: active
                            ? AppColors.textWhite
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: AppSize.space8),
          Obx(() => GestureDetector(
                onTap: c.selectedCategoryIndex.value < c.categories.length - 1
                    ? c.scrollCategoryNext
                    : null,
                child: AppContainer(
                  width: 28,
                  height: 28,
                  backgroundColor: context.cardBg2,
                  borderRadius: BorderRadius.circular(AppSize.radius16),
                  border: Border.all(color: context.borderClr),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppSize.font10,
                    color:
                        c.selectedCategoryIndex.value < c.categories.length - 1
                            ? AppColors.iconEmeraldGreen
                            : AppColors.textSecondary,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ─── FILTER BAR ───────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  final MyProductsCon c;
  const _FilterBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg2,
      border: Border(bottom: BorderSide(color: context.borderClr)),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space20, vertical: AppSize.space8),
      child: Obx(
        () => Row(
          children: [
            AppText(
                text: 'Status:',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary),
            const SizedBox(width: AppSize.space8),
            if (c.activeTab.value == MyProductsTab.marketplace)
              ..._mpFilters(context),
            if (c.activeTab.value == MyProductsTab.advanceBooking)
              ..._abFilters(context),
            if (c.activeTab.value == MyProductsTab.liveAuctions)
              ..._laFilters(context),
            const Spacer(),
            AppText(
              text:
                  '${c.activeTab.value == MyProductsTab.marketplace ? c.filteredMp.length : c.activeTab.value == MyProductsTab.advanceBooking ? c.filteredAb.length : c.filteredLa.length} products',
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: context.txtSecondary,
            ),
            const SizedBox(width: AppSize.space8),
            AppContainer(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12, vertical: AppSize.space4),
              backgroundColor: context.cardBg,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              border: Border.all(color: context.borderClr),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MyProductsSort>(
                  value: c.activeTab.value == MyProductsTab.marketplace
                      ? c.mpSort.value
                      : c.activeTab.value == MyProductsTab.advanceBooking
                          ? c.abSort.value
                          : c.laSort.value,
                  isDense: true,
                  style: TextStyle(
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w600,
                      color: context.txtPrimary),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      size: AppSize.icon16,
                      color: AppColors.iconEmeraldGreen),
                  items: const [
                    DropdownMenuItem(
                        value: MyProductsSort.latest,
                        child: Text('Sort: Latest')),
                    DropdownMenuItem(
                        value: MyProductsSort.oldest,
                        child: Text('Sort: Oldest')),
                    DropdownMenuItem(
                        value: MyProductsSort.highestStock,
                        child: Text('Highest Stock')),
                    DropdownMenuItem(
                        value: MyProductsSort.lowestStock,
                        child: Text('Lowest Stock')),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    if (c.activeTab.value == MyProductsTab.marketplace) {
                      c.setMpSort(val);
                    } else if (c.activeTab.value ==
                        MyProductsTab.advanceBooking) {
                      c.setAbSort(val);
                    } else {
                      c.setLaSort(val);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: AppSize.space8),
            AppContainer(
              padding: const EdgeInsets.all(AppSize.space4),
              backgroundColor: context.cardBg2,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: Row(
                children: [
                  _toggleBtn(context, Icons.view_list_rounded, ViewMode.list),
                  const SizedBox(width: AppSize.space2),
                  _toggleBtn(context, Icons.grid_view_rounded, ViewMode.grid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(BuildContext context, IconData icon, ViewMode mode) {
    final active = c.viewMode.value == mode;
    return GestureDetector(
      onTap: () => c.setViewMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: active ? context.cardBg : AppColors.backGroundTransparent,
          borderRadius: BorderRadius.circular(AppSize.radius4),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: AppColors.shadowBase.withValues(alpha: 0.07),
                      blurRadius: AppSize.space4)
                ]
              : [],
        ),
        child: Icon(icon,
            size: AppSize.icon16,
            color:
                active ? AppColors.iconEmeraldGreen : AppColors.textSecondary),
      ),
    );
  }

  Widget _divider(BuildContext context) => AppContainer(
        width: AppSize.borderWidth1,
        height: AppSize.space16,
        backgroundColor: context.borderClr,
        margin: const EdgeInsets.symmetric(horizontal: AppSize.space8),
      );

  List<Widget> _mpFilters(BuildContext context) => [
        MpFilterChip(
            label: 'All',
            isActive: c.mpFilter.value == MarketplaceFilter.all,
            onTap: () => c.setMpFilter(MarketplaceFilter.all)),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Active',
            isActive: c.mpFilter.value == MarketplaceFilter.active,
            onTap: () => c.setMpFilter(MarketplaceFilter.active)),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Pending',
            isActive: c.mpFilter.value == MarketplaceFilter.pending,
            onTap: () => c.setMpFilter(MarketplaceFilter.pending)),
        _divider(context),
        AppText(
            text: 'Stock:',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w700,
            color: context.txtPrimary),
        const SizedBox(width: AppSize.space8),
        MpFilterChip(
            label: 'Low Stock',
            isActive: c.mpFilter.value == MarketplaceFilter.lowStock,
            onTap: () => c.setMpFilter(MarketplaceFilter.lowStock),
            activeColor: AppColors.badgeWarningText,
            activeBorder: AppColors.badgeWarningText,
            inactiveBorder: AppColors.badgeWarningBg,
            inactiveText: AppColors.badgeWarningText),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Out of Stock',
            isActive: c.mpFilter.value == MarketplaceFilter.outOfStock,
            onTap: () => c.setMpFilter(MarketplaceFilter.outOfStock),
            activeColor: AppColors.badgeErrorText,
            activeBorder: AppColors.badgeErrorText,
            inactiveBorder: AppColors.badgeErrorBg,
            inactiveText: AppColors.badgeErrorText),
      ];

  List<Widget> _abFilters(BuildContext context) => [
        MpFilterChip(
            label: 'All',
            isActive: c.abFilter.value == AdvanceBookingFilter2.all,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.all)),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Active',
            isActive: c.abFilter.value == AdvanceBookingFilter2.active,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.active)),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Inactive',
            isActive: c.abFilter.value == AdvanceBookingFilter2.inactive,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.inactive)),
        _divider(context),
        AppText(
            text: 'Booking:',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w700,
            color: context.txtPrimary),
        const SizedBox(width: AppSize.space8),
        MpFilterChip(
            label: 'Almost Full',
            isActive: c.abFilter.value == AdvanceBookingFilter2.almostFull,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.almostFull),
            activeColor: AppColors.badgeWarningText,
            activeBorder: AppColors.badgeWarningText,
            inactiveBorder: AppColors.badgeWarningBg,
            inactiveText: AppColors.badgeWarningText),
      ];

  List<Widget> _laFilters(BuildContext context) => [
        MpFilterChip(
            label: 'All',
            isActive: c.laFilter.value == LiveAuctionFilter2.all,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.all)),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Active',
            isActive: c.laFilter.value == LiveAuctionFilter2.active,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.active)),
        const SizedBox(width: AppSize.space4),
        MpFilterChip(
            label: 'Ended',
            isActive: c.laFilter.value == LiveAuctionFilter2.ended,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.ended),
            activeColor: AppColors.badgeErrorText,
            activeBorder: AppColors.badgeErrorText,
            inactiveBorder: AppColors.badgeErrorBg,
            inactiveText: AppColors.badgeErrorText),
        _divider(context),
        AppText(
            text: 'Bids:',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w700,
            color: context.txtPrimary),
        const SizedBox(width: AppSize.space8),
        MpFilterChip(
            label: 'High Bids',
            isActive: c.laFilter.value == LiveAuctionFilter2.highBids,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.highBids),
            activeColor: AppColors.badgeWarningText,
            activeBorder: AppColors.badgeWarningText,
            inactiveBorder: AppColors.badgeWarningBg,
            inactiveText: AppColors.badgeWarningText),
      ];
}

// ─── PRODUCT LIST (dispatcher) ────────────────────────────────────────────────
class _ProductList extends StatelessWidget {
  final MyProductsCon c;
  const _ProductList({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasAny = c.hasAnyProduct;
      final tab = c.activeTab.value;
      final mode = c.viewMode.value;

      if (c.isBackendLoading.value) {
        return Padding(
          padding: const EdgeInsets.all(AppSize.space20),
          child: SingleChildScrollView(
            child: mode == ViewMode.list
                ? const AppListSkeleton(itemCount: 10, itemHeight: 56)
                : const AppCardGridSkeleton(crossAxisCount: 3, itemCount: 9),
          ),
        );
      }

      if (tab == MyProductsTab.marketplace) {
        final list = c.filteredMp;
        if (list.isEmpty) {
          return _emptyState('No marketplace products found', c, hasAny);
        }
        return mode == ViewMode.list
            ? _MpTable(c: c, list: list)
            : _MpGrid(c: c, list: list);
      }

      if (tab == MyProductsTab.advanceBooking) {
        final list = c.filteredAb;
        if (list.isEmpty) {
          return _emptyState('No advance booking products found', c, hasAny);
        }
        return mode == ViewMode.list
            ? _AbTable(c: c, list: list)
            : _AbGrid(c: c, list: list);
      }

      final list = c.filteredLa;
      if (list.isEmpty) {
        return _emptyState('No live auction products found', c, hasAny);
      }
      return mode == ViewMode.list
          ? _LaTable(c: c, list: list)
          : _LaGrid(c: c, list: list);
    });
  }

  Widget _emptyState(String msg, MyProductsCon c, bool hasAnyProduct) =>
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined,
                size: AppSize.icon40, color: AppColors.textSecondary),
            const SizedBox(height: AppSize.space12),
            AppText(
                text: msg,
                fontSize: AppSize.font12,
                color: AppColors.textSecondary),
            if (!hasAnyProduct)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSize.space12),
                  GestureDetector(
                    onTap: c.openCreateProduct,
                    child: AppContainer(
                      width: 38,
                      height: 38,
                      backgroundColor: AppColors.emeraldGreen,
                      borderRadius: BorderRadius.circular(AppSize.radius20),
                      child: const Icon(Icons.add_rounded,
                          size: AppSize.icon20, color: AppColors.iconWhite),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
}

// ─── TABLE HELPERS ────────────────────────────────────────────────────────────
TableRow _tableHeader(List<String> cols, BuildContext context) {
  return TableRow(
    decoration: BoxDecoration(
      color: context.isDark
          ? AppColors.backGroundDarkCard2
          : AppColors.backgroundSurface,
      border: Border(bottom: BorderSide(color: context.borderClr)),
    ),
    children: cols
        .map((col) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space16, vertical: AppSize.space12),
              child: AppText(
                  text: col.toUpperCase(),
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w700,
                  color: context.txtSecondary,
                  letterSpacing: 0.85),
            ))
        .toList(),
  );
}

Widget _tableCell({required Widget child}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space12, vertical: AppSize.space8),
    child: child,
  );
}

Color? _myProductsTableRowBg(BuildContext context, int? hoverRow, int index) {
  if (hoverRow == index) {
    return context.isDark
        ? AppColors.backGroundDarkHover
        : AppColors.backgroundHover;
  }
  if (index.isOdd) return context.hoverBg;
  return null;
}

Widget _mpTableHoverCell(MyProductsCon c, int rowIndex, Widget child) {
  return MouseRegion(
    onEnter: (_) => c.onMpTableRowEnter(rowIndex),
    onExit: (_) => c.onMpTableRowExit(rowIndex),
    child: child,
  );
}

Widget _abTableHoverCell(MyProductsCon c, int rowIndex, Widget child) {
  return MouseRegion(
    onEnter: (_) => c.onAbTableRowEnter(rowIndex),
    onExit: (_) => c.onAbTableRowExit(rowIndex),
    child: child,
  );
}

Widget _laTableHoverCell(MyProductsCon c, int rowIndex, Widget child) {
  return MouseRegion(
    onEnter: (_) => c.onLaTableRowEnter(rowIndex),
    onExit: (_) => c.onLaTableRowExit(rowIndex),
    child: child,
  );
}

// ─── MARKETPLACE TABLE ────────────────────────────────────────────────────────
class _MpTable extends StatelessWidget {
  final MyProductsCon c;
  final List<MarketplaceProductModel> list;
  const _MpTable({required this.c, required this.list});

  static const Map<int, TableColumnWidth> _cols = {
    0: FlexColumnWidth(2.8),
    1: FlexColumnWidth(1.6),
    2: FlexColumnWidth(1.4),
    3: FlexColumnWidth(1.4),
    4: FlexColumnWidth(1.2),
    5: FlexColumnWidth(1.2),
    6: FlexColumnWidth(0.9),
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hoverRow = c.mpHoverRow.value;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: MyProductsDataTableFrame(
          child: Table(
            columnWidths: _MpTable._cols,
            children: [
              _tableHeader([
                'Product',
                'Location',
                'Price',
                'Total Stock',
                'Sold',
                'Status',
                'Actions'
              ], context),
              ...list.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                final sold = c.mpSoldQty(p);
                final isLow = c.mpIsLow(p);
                final isOut = c.mpIsOut(p);
                final isActive = p.status == ProductStatus.active;
                final priceColor = isLow
                    ? AppColors.badgeWarningText
                    : AppColors.textEmeraldGreen;

                return TableRow(
                  decoration: BoxDecoration(
                      color: _myProductsTableRowBg(context, hoverRow, index),
                      border: Border(
                          bottom: BorderSide(
                              color: context.dividerClr,
                              width: AppSize.borderWidth05))),
                  children: [
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ProductImageCell(
                            imagePath:
                                ProductImageStorage.firstOrEmpty(p.images),
                            name: p.name,
                            category: p.category,
                            grade: p.grade,
                            onTap: () => c.openMarketplaceDetail(p)),
                      )),
                    ),
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: _stateCountryText(
                                location: p.location,
                                origin: p.origin,
                              ),
                              fontSize: AppSize.font12,
                              height: 1.35,
                              color: context.txtPrimary)),
                    ),
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '\$${p.price}',
                                style: TextStyle(
                                    fontSize: AppSize.font12,
                                    fontWeight: FontWeight.w800,
                                    height: 1.35,
                                    color: priceColor)),
                            TextSpan(
                                text: '/${p.unit}',
                                style: TextStyle(
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                    color: context.txtSecondary)),
                          ]),
                        ),
                      ),
                    ),
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '${p.stock} ${p.unit}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: context.txtPrimary)),
                    ),
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '${sold.toInt()} ${p.unit}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                              color: isLow
                                  ? AppColors.badgeWarningText
                                  : AppColors.textEmeraldGreen)),
                    ),
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: isOut
                              ? const StatusPill(
                                  label: 'Out of Stock',
                                  bg: AppColors.badgeErrorBg,
                                  text: AppColors.badgeErrorText)
                              : StatusPill(
                                  label: isActive ? 'Active' : 'Pending',
                                  bg: isActive
                                      ? AppColors.badgeSuccessBg
                                      : AppColors.badgeErrorBg,
                                  text: isActive
                                      ? AppColors.badgeSuccessText
                                      : AppColors.badgeErrorText),
                        ),
                      ),
                    ),
                    _mpTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          TableEditBtn(onTap: () => c.editProduct(p.id)),
                          const SizedBox(width: AppSize.space4),
                          TableDeleteBtn(onTap: () => c.deleteMp(p.id))
                        ]),
                      )),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

String _stateCountryText({
  required String location,
  required String origin,
}) {
  final parts = location
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  final state = parts.length >= 2 ? parts[1] : '';
  final country = parts.length >= 3 ? parts[2] : origin.trim();
  final out = [state, country].where((e) => e.isNotEmpty).join(', ');
  if (out.isNotEmpty) return out;
  return origin.trim().isEmpty ? 'N/A' : origin.trim();
}

// ─── ADVANCE BOOKING TABLE ────────────────────────────────────────────────────
class _AbTable extends StatelessWidget {
  final MyProductsCon c;
  final List<AdvanceBookingProductModel> list;
  const _AbTable({required this.c, required this.list});

  static const Map<int, TableColumnWidth> _cols = {
    0: FlexColumnWidth(2.8),
    1: FlexColumnWidth(1.4),
    2: FlexColumnWidth(1.4),
    3: FlexColumnWidth(1.3),
    4: FlexColumnWidth(1.2),
    5: FlexColumnWidth(1.6),
    6: FlexColumnWidth(1.2),
    7: FlexColumnWidth(0.9),
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hoverRow = c.abHoverRow.value;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: MyProductsDataTableFrame(
          child: Table(
            columnWidths: _AbTable._cols,
            children: [
              _tableHeader([
                'Product',
                'Location',
                'Booking Price',
                'Total Stock',
                'Booked',
                'Harvest Date',
                'Status',
                'Actions'
              ], context),
              ...list.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                final booked = c.abBookedQty(p);
                final almostFull = c.abIsAlmostFull(p);
                final isActive = p.status == ProductStatus.active;
                final priceColor = almostFull
                    ? AppColors.badgeWarningText
                    : AppColors.textEmeraldGreen;

                return TableRow(
                  decoration: BoxDecoration(
                      color: _myProductsTableRowBg(context, hoverRow, index),
                      border: Border(
                          bottom: BorderSide(
                              color: context.dividerClr,
                              width: AppSize.borderWidth05))),
                  children: [
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ProductImageCell(
                            imagePath:
                                ProductImageStorage.firstOrEmpty(p.images),
                            name: p.name,
                            category: p.category,
                            grade: p.grade,
                            onTap: () => c.openAdvanceBookingDetail(p)),
                      )),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: _stateCountryText(
                                location: p.location,
                                origin: p.origin,
                              ),
                              fontSize: AppSize.font12,
                              height: 1.35,
                              color: context.txtPrimary)),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '\$${p.bookingPrice}',
                                style: TextStyle(
                                    fontSize: AppSize.font12,
                                    fontWeight: FontWeight.w800,
                                    height: 1.35,
                                    color: priceColor)),
                            TextSpan(
                                text: '/${p.unit}',
                                style: TextStyle(
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                    color: context.txtSecondary)),
                          ]),
                        ),
                      ),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '${p.stock} ${p.unit}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: context.txtPrimary)),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '${booked.toInt()} ${p.unit}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                              color: almostFull
                                  ? AppColors.badgeWarningText
                                  : AppColors.textEmeraldGreen)),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: HarvestBadge(
                              date: p.harvestDate, isAlmostFull: almostFull)),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatusPill(
                              label: isActive ? 'Active' : 'Inactive',
                              bg: isActive
                                  ? AppColors.badgeSuccessBg
                                  : AppColors.backgroundSurface,
                              text: isActive
                                  ? AppColors.badgeSuccessText
                                  : AppColors.textSecondary),
                        ),
                      ),
                    ),
                    _abTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          TableEditBtn(onTap: () => c.editProduct(p.id)),
                          const SizedBox(width: AppSize.space4),
                          TableDeleteBtn(onTap: () => c.deleteAb(p.id))
                        ]),
                      )),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

// ─── LIVE AUCTIONS TABLE ──────────────────────────────────────────────────────
class _LaTable extends StatelessWidget {
  final MyProductsCon c;
  final List<LiveAuctionProductModel> list;
  const _LaTable({required this.c, required this.list});

  static const Map<int, TableColumnWidth> _cols = {
    0: FlexColumnWidth(2.8),
    1: FlexColumnWidth(1.4),
    2: FlexColumnWidth(1.2),
    3: FlexColumnWidth(1.2),
    4: FlexColumnWidth(1.3),
    5: FlexColumnWidth(0.9),
    6: FlexColumnWidth(1.4),
    7: FlexColumnWidth(1.2),
    8: FlexColumnWidth(0.9),
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hoverRow = c.laHoverRow.value;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: MyProductsDataTableFrame(
          child: Table(
            columnWidths: _LaTable._cols,
            children: [
              _tableHeader([
                'Product',
                'Location',
                'Total Stock',
                'Start Bid',
                'Current Bid',
                'Bids',
                'Timer',
                'Status',
                'Actions'
              ], context),
              ...list.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                final ended = c.laIsEnded(p);
                final soon = c.laIsEndingSoon(p);
                final timer = c.laTimerText(p);
                final bidColor = soon || ended
                    ? AppColors.badgeWarningText
                    : AppColors.textEmeraldGreen;
                final statusLabel = ended
                    ? 'Ended'
                    : soon
                        ? 'Ending Soon'
                        : 'Active';
                final statusBg = ended
                    ? AppColors.backgroundSurface
                    : soon
                        ? AppColors.badgeWarningBg
                        : AppColors.badgeSuccessBg;
                final statusText = ended
                    ? AppColors.textSecondary
                    : soon
                        ? AppColors.badgeWarningText
                        : AppColors.badgeSuccessText;

                return TableRow(
                  decoration: BoxDecoration(
                      color: _myProductsTableRowBg(context, hoverRow, index),
                      border: Border(
                          bottom: BorderSide(
                              color: context.dividerClr,
                              width: AppSize.borderWidth05))),
                  children: [
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ProductImageCell(
                            imagePath:
                                ProductImageStorage.firstOrEmpty(p.images),
                            name: p.name,
                            category: p.category,
                            grade: p.grade,
                            onTap: () => c.openLiveAuctionDetail(p)),
                      )),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: _stateCountryText(
                                location: p.location,
                                origin: p.origin,
                              ),
                              fontSize: AppSize.font12,
                              height: 1.35,
                              color: context.txtPrimary)),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '${p.stock} ${p.unit}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: context.txtPrimary)),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '\$${p.startingBid}/${p.unit}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: context.txtSecondary)),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '\$${p.currentBid}',
                                style: TextStyle(
                                    fontSize: AppSize.font12,
                                    fontWeight: FontWeight.w800,
                                    height: 1.35,
                                    color: bidColor)),
                            TextSpan(
                                text: '/${p.unit}',
                                style: TextStyle(
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                    color: context.txtSecondary)),
                          ]),
                        ),
                      ),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: AppText(
                              text: '${p.totalBids}',
                              fontSize: AppSize.font12,
                              height: 1.35,
                              fontWeight: FontWeight.w800,
                              color: AppColors.badgeInfoText)),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: TimerBadge(
                              text: timer,
                              isEnded: ended,
                              isEndingSoon: soon)),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatusPill(
                              label: statusLabel,
                              bg: statusBg,
                              text: statusText),
                        ),
                      ),
                    ),
                    _laTableHoverCell(
                      c,
                      index,
                      _tableCell(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          TableEditBtn(onTap: () => c.editProduct(p.id)),
                          const SizedBox(width: AppSize.space4),
                          TableDeleteBtn(onTap: () => c.deleteLa(p.id))
                        ]),
                      )),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

// ─── GRID VIEWS ───────────────────────────────────────────────────────────────
int _gridCrossAxisCount(double width) {
  if (width < 600) return 2;
  if (width < 900) return 3;
  return 5;
}

// ─── MARKETPLACE GRID ─────────────────────────────────────────────────────────
class _MpGrid extends StatelessWidget {
  final MyProductsCon c;
  final List<MarketplaceProductModel> list;
  const _MpGrid({required this.c, required this.list});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Obx(() {
        final hoverKey = c.hoveredGridCardKey.value;
        return GridView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(AppSize.space16),
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridCrossAxisCount(constraints.maxWidth),
            crossAxisSpacing: AppSize.space12,
            mainAxisSpacing: AppSize.space12,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final p = list[index];
            final id = 'mp_${p.id}';
            final hover = hoverKey == id;
            return GestureDetector(
              onTap: () => c.openMarketplaceDetail(p),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => c.hoveredGridCardKey.value = id,
                onExit: (_) {
                  if (c.hoveredGridCardKey.value == id) {
                    c.hoveredGridCardKey.value = null;
                  }
                },
                child: AnimatedScale(
                  scale: hover ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.radius12),
                      boxShadow: hover
                          ? [
                              BoxShadow(
                                color: AppColors.shadowBase
                                    .withValues(alpha: 0.14),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : const [],
                    ),
                    child: _MpGridCard(product: p, c: c),
                  ),
                ),
              ),
            );
          },
        );
      });
    });
  }
}

class _MpGridCard extends StatelessWidget {
  final MarketplaceProductModel product;
  final MyProductsCon c;
  const _MpGridCard({required this.product, required this.c});

  @override
  Widget build(BuildContext context) {
    final double prog = c.mpProgress(product);
    final bool lowStock = c.mpIsLow(product);
    final isActive = product.status == ProductStatus.active;

    return MyProductsGridCardShell(
      backgroundColor: context.cardBg,
      borderColor:
          lowStock ? AppColors.badgeWarningBg.withValues(alpha: 0.85) : context.borderClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 13,
            child: ClipRRect(
              borderRadius: myProductsGridRadiusTop(),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: AppUrlOrAssetImage(
                      path: ProductImageStorage.firstOrEmpty(product.images),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Positioned.fill(
                      child: AppContainer(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                        AppColors.mediaImageScrimDark,
                        AppColors.backGroundTransparent
                      ]))),
                  Positioned(
                    top: AppSize.space8,
                    left: AppSize.space8,
                    child: AppContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space8, vertical: AppSize.space2),
                      backgroundColor: isActive
                          ? AppColors.badgeSuccessBg.withValues(alpha: 0.95)
                          : AppColors.badgeErrorBg.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(AppSize.radius20),
                      child: AppText(
                          text: isActive ? 'Active' : 'Pending',
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? AppColors.badgeSuccessText
                              : AppColors.badgeErrorText),
                    ),
                  ),
                  Positioned(
                    left: AppSize.space8,
                    bottom: AppSize.space8,
                    right: AppSize.space8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                            text: product.name,
                            fontSize: AppSize.font14,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: AppColors.textWhite,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: AppSize.space2),
                        Row(children: [
                          const Icon(Icons.location_on_outlined,
                              size: AppSize.font10, color: AppColors.iconWhite),
                          const SizedBox(width: AppSize.space2),
                          Expanded(
                              child: AppText(
                                  text: _stateCountryText(
                                    location: product.location,
                                    origin: product.origin,
                                  ),
                                  fontSize: AppSize.font10,
                                  height: 1.2,
                                  color: AppColors.textWhite,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: AppSize.space4),
                          GradePill(grade: product.grade),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSize.space12, AppSize.space8, AppSize.space12, AppSize.space8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _infoRow(
                        context, 'Price', '\$${product.price}/${product.unit}'),
                    const SizedBox(height: AppSize.space4),
                    _infoRow(context, 'Total Stock',
                        '${product.stock} ${product.unit}'),
                    const SizedBox(height: AppSize.space4),
                    _infoRow(context, 'MOQ',
                        '${product.minOrderQty?.toInt()} ${product.unit}'),
                    AppContainer(
                        height: AppSize.borderWidth05,
                        width: double.infinity,
                        backgroundColor: context.dividerClr,
                        margin: const EdgeInsets.symmetric(
                            vertical: AppSize.space4)),
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                              text: 'Stock sold',
                              fontSize: AppSize.font10,
                              fontWeight: FontWeight.w700,
                              color: context.txtSecondary,
                              letterSpacing: 0.2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: AppText(
                              text:
                                  '${c.mpSoldQty(product).toInt()} / ${product.stock} ${product.unit}',
                              fontSize: AppSize.font10,
                              fontWeight: FontWeight.w700,
                              color: lowStock
                                  ? AppColors.badgeWarningText
                                  : AppColors.textEmeraldGreen,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSize.space4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      child: LinearProgressIndicator(
                          value: prog,
                          minHeight: AppSize.space4,
                          backgroundColor: AppColors.borderGray,
                          valueColor: AlwaysStoppedAnimation<Color>(lowStock
                              ? AppColors.badgeWarningText
                              : AppColors.emeraldGreen)),
                    ),
                    const SizedBox(height: AppSize.space8),
                    Row(
                      children: [
                        Expanded(
                            child: AppOutlinedButton(
                                onPressed: () => c.editProduct(product.id),
                                icon: Icons.edit_outlined,
                                text: 'Edit',
                                fontSize: AppSize.font10,
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.textEmeraldGreen,
                                iconColor: AppColors.iconEmeraldGreen,
                                iconSize: AppSize.font10,
                                border: const BorderSide(
                                    color: AppColors.borderGray),
                                borderRadius: AppSize.radius8,
                                height: 28)),
                        const SizedBox(width: AppSize.space8),
                        AppOutlinedButton(
                            onPressed: () => c.deleteMp(product.id),
                            compact: true,
                            padding: EdgeInsets.zero,
                            minSize: const Size(0, 0),
                            icon: Icons.delete_outline_outlined,
                            iconColor: AppColors.iconError,
                            iconSize: AppSize.icon16,
                            border:
                                const BorderSide(color: AppColors.borderError),
                            borderRadius: AppSize.radius8,
                            height: 28,
                            width: 28),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) =>
      Row(children: [
        Expanded(
          child: AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: context.txtSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: AppSize.space8),
        Expanded(
          child: AppText(
              text: value,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
              color: context.txtPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end),
        ),
      ]);
}

// ─── ADVANCE BOOKING GRID ─────────────────────────────────────────────────────
class _AbGrid extends StatelessWidget {
  final MyProductsCon c;
  final List<AdvanceBookingProductModel> list;
  const _AbGrid({required this.c, required this.list});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Obx(() {
        final hoverKey = c.hoveredGridCardKey.value;
        return GridView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(AppSize.space16),
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridCrossAxisCount(constraints.maxWidth),
            crossAxisSpacing: AppSize.space12,
            mainAxisSpacing: AppSize.space12,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final p = list[index];
            final id = 'ab_${p.id}';
            final hover = hoverKey == id;
            return GestureDetector(
              onTap: () => c.openAdvanceBookingDetail(p),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => c.hoveredGridCardKey.value = id,
                onExit: (_) {
                  if (c.hoveredGridCardKey.value == id) {
                    c.hoveredGridCardKey.value = null;
                  }
                },
                child: AnimatedScale(
                  scale: hover ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.radius12),
                      boxShadow: hover
                          ? [
                              BoxShadow(
                                color: AppColors.shadowBase
                                    .withValues(alpha: 0.14),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : const [],
                    ),
                    child: _AbGridCard(product: p, c: c),
                  ),
                ),
              ),
            );
          },
        );
      });
    });
  }
}

class _AbGridCard extends StatelessWidget {
  final AdvanceBookingProductModel product;
  final MyProductsCon c;
  const _AbGridCard({required this.product, required this.c});

  @override
  Widget build(BuildContext context) {
    final double prog = c.abProgress(product);
    final bool almostFull = c.abIsAlmostFull(product);
    final double booked = c.abBookedQty(product);
    final isActive = product.status == ProductStatus.active;
    final headerColor =
        almostFull ? AppColors.badgeWarningText : AppColors.emeraldGreen;

    return MyProductsGridCardShell(
      backgroundColor: context.cardBg,
      borderColor: almostFull
          ? AppColors.badgeWarningBg.withValues(alpha: 0.85)
          : context.borderClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space12, vertical: AppSize.space4),
            backgroundColor: headerColor,
            borderRadius: myProductsGridRadiusTop(),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: AppSize.icon12, color: AppColors.iconWhite),
                const SizedBox(width: AppSize.space4),
                const Expanded(
                  child: AppText(
                      text: 'Harvest Date',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: AppSize.space8),
                Flexible(
                  child: AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.space8, vertical: AppSize.space2),
                    backgroundColor:
                        AppColors.textWhite.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppSize.radius20),
                    child: AppText(
                        text: product.harvestDate,
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: AppUrlOrAssetImage(
                    path: ProductImageStorage.firstOrEmpty(product.images),
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned.fill(
                  child: AppContainer(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        AppColors.mediaImageScrimDark,
                        AppColors.backGroundTransparent
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.space8,
                  left: AppSize.space8,
                  child: AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.space8, vertical: AppSize.space4),
                    backgroundColor: isActive
                        ? AppColors.badgeSuccessBg.withValues(alpha: 0.95)
                        : AppColors.badgeWarningBg.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(AppSize.radius4),
                    child: AppText(
                        text: product.status?.name ?? '',
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? AppColors.badgeSuccessText
                            : AppColors.badgeWarningText),
                  ),
                ),
                Positioned(
                  left: AppSize.space8,
                  bottom: AppSize.space8,
                  right: AppSize.space8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                          text: product.name,
                          fontSize: AppSize.font14,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.textWhite,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AppSize.space2),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: AppSize.icon12, color: AppColors.iconWhite),
                        const SizedBox(width: AppSize.space2),
                        Expanded(
                            child: AppText(
                                text: _stateCountryText(
                                  location: product.location,
                                  origin: product.origin,
                                ),
                                fontSize: AppSize.font10,
                                height: 1.2,
                                color: AppColors.textWhite,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: AppSize.space4),
                        GradePill(grade: product.grade),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppSize.space12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _abInfoRow(
                        context,
                        'Booking price',
                        '\$${product.bookingPrice}/${product.unit}',
                        AppColors.textEmeraldGreen),
                    const SizedBox(height: AppSize.space4),
                    _abInfoRow(
                        context,
                        'MOQ',
                        '${product.minOrderQty?.toInt()} ${product.unit}',
                        context.txtSecondary),
                    const SizedBox(height: AppSize.space4),
                    _abInfoRow(
                        context,
                        'Booked',
                        '${booked.toInt()} / ${product.stock} ${product.unit}',
                        almostFull
                            ? AppColors.badgeWarningText
                            : AppColors.textEmeraldGreen),
                    const SizedBox(height: AppSize.space8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      child: LinearProgressIndicator(
                          value: prog,
                          minHeight: AppSize.space4,
                          backgroundColor:
                              AppColors.borderGray.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(almostFull
                              ? AppColors.badgeWarningText
                              : AppColors.emeraldGreen)),
                    ),
                    const SizedBox(height: AppSize.space4),
                    Row(
                      children: [
                        Expanded(
                            child: AppOutlinedButton(
                                onPressed: () => c.editProduct(product.id),
                                icon: Icons.edit_outlined,
                                text: 'Edit',
                                fontSize: AppSize.font12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.textEmeraldGreen,
                                iconColor: AppColors.iconEmeraldGreen,
                                iconSize: AppSize.icon16,
                                border: const BorderSide(
                                    width: AppSize.borderWidth1,
                                    color: AppColors.borderDarkGray),
                                borderRadius: AppSize.radius8,
                                height: 32)),
                        const SizedBox(width: AppSize.space8),
                        AppOutlinedButton(
                            onPressed: () => c.deleteAb(product.id),
                            compact: true,
                            padding: EdgeInsets.zero,
                            minSize: const Size(0, 0),
                            icon: Icons.delete_outline_outlined,
                            iconColor: AppColors.iconError,
                            iconSize: 18,
                            border: const BorderSide(
                                width: AppSize.borderWidth1,
                                color: AppColors.borderError),
                            borderRadius: AppSize.radius8,
                            height: 32,
                            width: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _abInfoRow(
          BuildContext context, String label, String value, Color valueColor) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: context.txtSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
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
              textAlign: TextAlign.end),
        ),
      ]);
}

// ─── LIVE AUCTION GRID ────────────────────────────────────────────────────────
class _LaGrid extends StatelessWidget {
  final MyProductsCon c;
  final List<LiveAuctionProductModel> list;
  const _LaGrid({required this.c, required this.list});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Obx(() {
        final hoverKey = c.hoveredGridCardKey.value;
        return GridView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(AppSize.space16),
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridCrossAxisCount(constraints.maxWidth),
            crossAxisSpacing: AppSize.space12,
            mainAxisSpacing: AppSize.space12,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final p = list[index];
            final id = 'la_${p.id}';
            final hover = hoverKey == id;
            return GestureDetector(
              onTap: () => c.openLiveAuctionDetail(p),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => c.hoveredGridCardKey.value = id,
                onExit: (_) {
                  if (c.hoveredGridCardKey.value == id) {
                    c.hoveredGridCardKey.value = null;
                  }
                },
                child: AnimatedScale(
                  scale: hover ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.radius12),
                      boxShadow: hover
                          ? [
                              BoxShadow(
                                color: AppColors.shadowBase
                                    .withValues(alpha: 0.14),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : const [],
                    ),
                    child: _LaGridCard(product: p, c: c),
                  ),
                ),
              ),
            );
          },
        );
      });
    });
  }
}

class _LaGridCard extends StatelessWidget {
  final LiveAuctionProductModel product;
  final MyProductsCon c;
  const _LaGridCard({required this.product, required this.c});

  @override
  Widget build(BuildContext context) {
    final bool ended = c.laIsEnded(product);
    final bool endingSoon = c.laIsEndingSoon(product);
    final String timer = c.laTimerText(product);
    final Color headerColor = ended
        ? AppColors.badgeErrorText
        : endingSoon
            ? AppColors.badgeWarningText
            : AppColors.emeraldGreen;
    final isActive = product.status == ProductStatus.active;

    return MyProductsGridCardShell(
      backgroundColor: context.cardBg,
      borderColor: endingSoon && !ended
          ? AppColors.badgeWarningBg.withValues(alpha: 0.85)
          : context.borderClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space12, vertical: AppSize.space4),
            backgroundColor: headerColor,
            borderRadius: myProductsGridRadiusTop(),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: AppSize.icon12, color: AppColors.iconWhite),
                const SizedBox(width: AppSize.space4),
                const Expanded(
                  flex: 2,
                  child: AppText(
                      text: 'Time Left',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                if (!ended) ...[
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 0.15),
                    duration: const Duration(milliseconds: 900),
                    builder: (context, value, child) =>
                        Opacity(opacity: value, child: child),
                    onEnd: () {},
                    child: AppContainer(
                        width: AppSize.space8,
                        height: AppSize.space8,
                        backgroundColor: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(AppSize.space4)),
                  ),
                  const SizedBox(width: AppSize.space4),
                ],
                Expanded(
                  flex: 3,
                  child: AppText(
                      text: timer,
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: AppUrlOrAssetImage(
                    path: ProductImageStorage.firstOrEmpty(product.images),
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned.fill(
                  child: AppContainer(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        AppColors.mediaImageScrimDarkAlt,
                        AppColors.backGroundTransparent
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.space8,
                  left: AppSize.space8,
                  child: AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.space8, vertical: AppSize.space4),
                    backgroundColor: isActive
                        ? AppColors.badgeSuccessBg.withValues(alpha: 0.95)
                        : AppColors.badgeWarningBg.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(AppSize.radius4),
                    child: AppText(
                        text: product.status?.name ?? '',
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? AppColors.badgeSuccessText
                            : AppColors.badgeWarningText),
                  ),
                ),
                Positioned(
                  left: AppSize.space8,
                  bottom: AppSize.space8,
                  right: AppSize.space8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                          text: product.name,
                          fontSize: AppSize.font14,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.textWhite,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AppSize.space2),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: AppSize.icon12, color: AppColors.iconWhite),
                        const SizedBox(width: AppSize.space2),
                        Expanded(
                            child: AppText(
                                text: _stateCountryText(
                                  location: product.location,
                                  origin: product.origin,
                                ),
                                fontSize: AppSize.font10,
                                height: 1.2,
                                color: AppColors.textWhite,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: AppSize.space4),
                        GradePill(grade: product.grade),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppSize.space12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _laInfoRow(
                        context,
                        'Starting price',
                        '\$${product.startingBid}/${product.unit}',
                        AppColors.textEmeraldGreen),
                    const SizedBox(height: AppSize.space4),
                    _laInfoRow(
                        context,
                        'Current bid',
                        '\$${product.currentBid}/${product.unit}',
                        AppColors.textEmeraldGreen),
                    const SizedBox(height: AppSize.space8),
                    AppContainer(
                        height: AppSize.borderWidth05,
                        width: double.infinity,
                        backgroundColor: context.dividerClr,
                        margin: const EdgeInsets.symmetric(
                            vertical: AppSize.space4)),
                    _laInfoRow(context, 'Total bids', '${product.totalBids}',
                        context.txtSecondary),
                    const SizedBox(height: AppSize.space8),
                    Row(
                      children: [
                        Expanded(
                            child: AppOutlinedButton(
                                onPressed: () => c.editProduct(product.id),
                                icon: Icons.edit_outlined,
                                text: 'Edit',
                                fontSize: AppSize.font12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.textEmeraldGreen,
                                iconColor: AppColors.iconEmeraldGreen,
                                iconSize: AppSize.icon16,
                                border: const BorderSide(
                                    color: AppColors.borderDarkGray,
                                    width: AppSize.borderWidth1),
                                borderRadius: AppSize.radius8,
                                height: 32)),
                        const SizedBox(width: AppSize.space8),
                        AppOutlinedButton(
                            onPressed: () => c.deleteLa(product.id),
                            compact: true,
                            padding: EdgeInsets.zero,
                            minSize: const Size(0, 0),
                            icon: Icons.delete_outline_outlined,
                            iconColor: AppColors.iconError,
                            iconSize: 18,
                            border: const BorderSide(
                                color: AppColors.borderError,
                                width: AppSize.borderWidth1),
                            borderRadius: AppSize.radius8,
                            height: 32,
                            width: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _laInfoRow(
          BuildContext context, String label, String value, Color valueColor) =>
      Row(children: [
        Expanded(
          child: AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: context.txtSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: AppSize.space8),
        Expanded(
          child: AppText(
              text: value,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: valueColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end),
        ),
      ]);
}
