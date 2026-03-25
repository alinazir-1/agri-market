import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Data/Models/advance_booking_product_model.dart';
import '../../../Data/Models/live_auction_product_model.dart';
import '../../../Data/Models/marketplace_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'all widgets/widgets.dart';
import 'my_products_con.dart';

class MyProductsScr extends StatelessWidget {
  final MyProductsCon myProductsController = Get.put(MyProductsCon());
  MyProductsScr({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.appBg,
        body: SafeArea(
            child: Column(children: [
          ScreenTopBar(
            title: 'My Products',
            subtitle: 'Manage all your listings in one place',
            searchController: myProductsController.searchController,
            onSearch: myProductsController.onSearch,
            searchHint: 'Search products...',
          ),
          _TabBar(c: myProductsController),
          _CategoryBar(c: myProductsController),
          _FilterBar(c: myProductsController),
          Expanded(child: _ProductList(c: myProductsController)),
        ])),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_tab_bar.dart
// ─────────────────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final MyProductsCon c;
  const _TabBar({required this.c});

  @override
  Widget build(BuildContext context) => Obx(() => Container(
        decoration: BoxDecoration(
            color: context.cardBg,
            border: Border(bottom: BorderSide(color: context.borderClr))),
        padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
        child: Row(children: [
          _tab('Marketplace', Icons.storefront_outlined,
              MyProductsTab.marketplace, c.filteredMp.length, context),
          _tab('Advance Booking', Icons.calendar_month_outlined,
              MyProductsTab.advanceBooking, c.filteredAb.length, context),
          _tab('Live Auctions', Icons.show_chart_rounded,
              MyProductsTab.liveAuctions, c.filteredLa.length, context),
        ]),
      ));

  Widget _tab(String label, IconData icon, MyProductsTab tab, int count,
      BuildContext context) {
    final active = c.activeTab.value == tab;
    return GestureDetector(
      onTap: () => c.setTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space4, vertical: CSize.space12),
        margin: const EdgeInsets.only(right: CSize.space20),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: active
                        ? CColors.borderEmeraldGreen
                        : Colors.transparent,
                    width: 2))),
        child: Row(children: [
          Icon(icon,
              size: 13,
              color:
                  active ? CColors.iconEmeraldGreen : context.txtSecondary),
          const SizedBox(width: CSize.space5),
          Text(label,
              style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? CColors.textEmeraldGreen
                      : context.txtSecondary)),
          const SizedBox(width: CSize.space5),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: 1),
            decoration: BoxDecoration(
                color: active
                    ? CColors.backgroundEmerald100
                    : context.cardBg2,
                borderRadius: BorderRadius.circular(CSize.radius20Large)),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? CColors.textEmeraldGreen
                        : context.txtSecondary)),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_category_bar.dart
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryBar extends StatelessWidget {
  final MyProductsCon c;
  const _CategoryBar({required this.c});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: context.cardBg,
            border: Border(bottom: BorderSide(color: context.borderClr))),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20, vertical: CSize.space10),
        child: Row(children: [
          Obx(() => GestureDetector(
                onTap: c.selectedCategoryIndex.value > 0
                    ? c.scrollCategoryPrev
                    : null,
                child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: context.cardBg2,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.borderClr)),
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        size: CSize.font10XSmall,
                        color: c.selectedCategoryIndex.value > 0
                            ? CColors.iconEmeraldGreen
                            : CColors.textSecondary)),
              )),
          const SizedBox(width: CSize.space8),
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                controller: c.categoryScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: c.categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: CSize.space8),
                itemBuilder: (context, index) => Obx(() {
                  final active = c.selectedCategoryIndex.value == index;
                  return GestureDetector(
                    onTap: () => c.selectCategory(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space14, vertical: CSize.space4),
                      decoration: BoxDecoration(
                        color: active
                            ? CColors.backGroundEmeraldGreen
                            : context.cardBg2,
                        borderRadius:
                            BorderRadius.circular(CSize.radius20Large),
                        border: Border.all(
                            color: active
                                ? CColors.borderEmeraldGreen
                                : context.borderClr,
                            width: CSize.borderWidth1),
                      ),
                      child: Text(c.categories[index].name,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? CColors.textWhite
                                  : CColors.textSecondary)),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: CSize.space8),
          Obx(() => GestureDetector(
                onTap: c.selectedCategoryIndex.value < c.categories.length - 1
                    ? c.scrollCategoryNext
                    : null,
                child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: context.cardBg2,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.borderClr)),
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        size: CSize.font10XSmall,
                        color: c.selectedCategoryIndex.value <
                                c.categories.length - 1
                            ? CColors.iconEmeraldGreen
                            : CColors.textSecondary)),
              )),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_filter_bar.dart
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final MyProductsCon c;
  const _FilterBar({required this.c});

  @override
  Widget build(BuildContext context) => Obx(() => Container(
        decoration: BoxDecoration(
            color: context.cardBg2,
            border: Border(bottom: BorderSide(color: context.borderClr))),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20, vertical: CSize.space8),
        child: Row(children: [
          Text('Status:',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary)),
          const SizedBox(width: CSize.space8),
          if (c.activeTab.value == MyProductsTab.marketplace) ..._mpFilters(context),
          if (c.activeTab.value == MyProductsTab.advanceBooking)
            ..._abFilters(context),
          if (c.activeTab.value == MyProductsTab.liveAuctions) ..._laFilters(context),
          const Spacer(),
          Text(
            '${c.activeTab.value == MyProductsTab.marketplace ? c.filteredMp.length : c.activeTab.value == MyProductsTab.advanceBooking ? c.filteredAb.length : c.filteredLa.length} products',
            style: TextStyle(
                fontSize: 10,
                color: context.txtSecondary,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: CSize.space8),
          // Sort dropdown
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space12, vertical: CSize.space5),
            decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(color: context.borderClr)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<MyProductsSort>(
              value: c.activeTab.value == MyProductsTab.marketplace
                  ? c.mpSort.value
                  : c.activeTab.value == MyProductsTab.advanceBooking
                      ? c.abSort.value
                      : c.laSort.value,
              isDense: true,
              style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  fontWeight: FontWeight.w600,
                  color: context.txtPrimary),
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
              items: const [
                DropdownMenuItem(
                    value: MyProductsSort.latest, child: Text('Sort: Latest')),
                DropdownMenuItem(
                    value: MyProductsSort.oldest, child: Text('Sort: Oldest')),
                DropdownMenuItem(
                    value: MyProductsSort.highestStock,
                    child: Text('Highest Stock')),
                DropdownMenuItem(
                    value: MyProductsSort.lowestStock,
                    child: Text('Lowest Stock')),
              ],
              onChanged: (val) {
                if (val == null) return;
                if (c.activeTab.value == MyProductsTab.marketplace)
                  c.setMpSort(val);
                if (c.activeTab.value == MyProductsTab.advanceBooking)
                  c.setAbSort(val);
                if (c.activeTab.value == MyProductsTab.liveAuctions)
                  c.setLaSort(val);
              },
            )),
          ),
          const SizedBox(width: CSize.space8),
          // Grid / List toggle
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: context.cardBg2,
                borderRadius: BorderRadius.circular(CSize.radius10Medium)),
            child: Row(children: [
              _toggleBtn(context, Icons.view_list_rounded, ViewMode.list),
              const SizedBox(width: 2),
              _toggleBtn(context, Icons.grid_view_rounded, ViewMode.grid),
            ]),
          ),
        ]),
      ));

  Widget _toggleBtn(BuildContext context, IconData icon, ViewMode mode) {
    final active = c.viewMode.value == mode;
    return GestureDetector(
      onTap: () => c.setViewMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: active ? context.cardBg : Colors.transparent,
          borderRadius: BorderRadius.circular(CSize.radius5Small),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07), blurRadius: 3)
                ]
              : [],
        ),
        child: Icon(icon,
            size: 14,
            color: active ? CColors.iconEmeraldGreen : CColors.textSecondary),
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
      width: 1,
      height: 16,
      color: context.borderClr,
      margin: const EdgeInsets.symmetric(horizontal: CSize.space10));

  List<Widget> _mpFilters(BuildContext context) => [
        MpFilterChip(
            label: 'All',
            isActive: c.mpFilter.value == MarketplaceFilter.all,
            onTap: () => c.setMpFilter(MarketplaceFilter.all)),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Active',
            isActive: c.mpFilter.value == MarketplaceFilter.active,
            onTap: () => c.setMpFilter(MarketplaceFilter.active)),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Pending',
            isActive: c.mpFilter.value == MarketplaceFilter.pending,
            onTap: () => c.setMpFilter(MarketplaceFilter.pending)),
        _divider(context),
        Text('Stock:',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary)),
        const SizedBox(width: CSize.space8),
        MpFilterChip(
            label: 'Low Stock',
            isActive: c.mpFilter.value == MarketplaceFilter.lowStock,
            onTap: () => c.setMpFilter(MarketplaceFilter.lowStock),
            activeColor: CColors.backGroundOrange,
            activeBorder: CColors.backGroundOrange,
            inactiveBorder: const Color(0xFFFED7AA),
            inactiveText: CColors.textOrange),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Out of Stock',
            isActive: c.mpFilter.value == MarketplaceFilter.outOfStock,
            onTap: () => c.setMpFilter(MarketplaceFilter.outOfStock),
            activeColor: CColors.borderError,
            activeBorder: CColors.borderError,
            inactiveBorder: const Color(0xFFFCA5A5),
            inactiveText: CColors.textRichRed),
      ];

  List<Widget> _abFilters(BuildContext context) => [
        MpFilterChip(
            label: 'All',
            isActive: c.abFilter.value == AdvanceBookingFilter2.all,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.all)),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Active',
            isActive: c.abFilter.value == AdvanceBookingFilter2.active,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.active)),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Inactive',
            isActive: c.abFilter.value == AdvanceBookingFilter2.inactive,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.inactive)),
        _divider(context),
        Text('Booking:',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary)),
        const SizedBox(width: CSize.space8),
        MpFilterChip(
            label: 'Almost Full',
            isActive: c.abFilter.value == AdvanceBookingFilter2.almostFull,
            onTap: () => c.setAbFilter(AdvanceBookingFilter2.almostFull),
            activeColor: CColors.backGroundOrange,
            activeBorder: CColors.backGroundOrange,
            inactiveBorder: const Color(0xFFFED7AA),
            inactiveText: CColors.textOrange),
      ];

  List<Widget> _laFilters(BuildContext context) => [
        MpFilterChip(
            label: 'All',
            isActive: c.laFilter.value == LiveAuctionFilter2.all,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.all)),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Active',
            isActive: c.laFilter.value == LiveAuctionFilter2.active,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.active)),
        const SizedBox(width: CSize.space5),
        MpFilterChip(
            label: 'Ended',
            isActive: c.laFilter.value == LiveAuctionFilter2.ended,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.ended),
            activeColor: CColors.borderError,
            activeBorder: CColors.borderError,
            inactiveBorder: const Color(0xFFFCA5A5),
            inactiveText: CColors.textRichRed),
        _divider(context),
        Text('Bids:',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary)),
        const SizedBox(width: CSize.space8),
        MpFilterChip(
            label: 'High Bids',
            isActive: c.laFilter.value == LiveAuctionFilter2.highBids,
            onTap: () => c.setLaFilter(LiveAuctionFilter2.highBids),
            activeColor: const Color(0xFFFBBF24),
            activeBorder: const Color(0xFFFBBF24),
            inactiveBorder: const Color(0xFFFDE68A),
            inactiveText: const Color(0xFF92400E)),
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_list.dart
// ─────────────────────────────────────────────────────────────────────────────

class _ProductList extends StatelessWidget {
  final MyProductsCon c;
  const _ProductList({required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final tab = c.activeTab.value;
        final mode = c.viewMode.value;
        if (tab == MyProductsTab.marketplace) {
          final list = c.filteredMp;
          if (list.isEmpty) return _empty('No marketplace products found');
          return mode == ViewMode.list
              ? _MpTable(c: c, list: list)
              : _MpGrid(c: c, list: list);
        }
        if (tab == MyProductsTab.advanceBooking) {
          final list = c.filteredAb;
          if (list.isEmpty) return _empty('No advance booking products found');
          return mode == ViewMode.list
              ? _AbTable(c: c, list: list)
              : _AbGrid(c: c, list: list);
        }
        final list = c.filteredLa;
        if (list.isEmpty) return _empty('No live auction products found');
        return mode == ViewMode.list
            ? _LaTable(c: c, list: list)
            : _LaGrid(c: c, list: list);
      });

  Widget _empty(String msg) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.inventory_2_outlined,
            size: CSize.icon36XLarge, color: CColors.textSecondary),
        const SizedBox(height: CSize.space12),
        Text(msg,
            style: const TextStyle(
                fontSize: CSize.font13Small, color: CColors.textSecondary)),
      ]));
}

// ─────────────────────────────────────────────────────────────────────────────
//  TABLE WIDGETS (list view)
// ─────────────────────────────────────────────────────────────────────────────

// ── Marketplace Table ─────────────────────────────────────────────────────────

class _MpTable extends StatelessWidget {
  final MyProductsCon c;
  final List<MarketplaceProductModel> list;
  const _MpTable({required this.c, required this.list});

  static const Map<int, TableColumnWidth> _cols = {
    0: FlexColumnWidth(2.8), // Product
    1: FlexColumnWidth(1.6), // Location
    2: FlexColumnWidth(1.4), // Price
    3: FlexColumnWidth(1.4), // Total Stock
    4: FlexColumnWidth(1.2), // Sold
    5: FlexColumnWidth(1.2), // Status
    6: FlexColumnWidth(0.9), // Actions
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(CSize.space16),
      child: Container(
        decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            border: Border.all(
                color: context.borderClr, width: CSize.borderWidth1)),
        child: Table(columnWidths: _cols, children: [
          _header([
            'Product',
            'Location',
            'Price',
            'Total Stock',
            'Sold',
            'Status',
            'Actions'
          ], context),
          ...list.map((p) {
            final sold = c.mpSoldQty(p);
            final isLow = c.mpIsLow(p);
            final isOut = c.mpIsOut(p);
            final statusLabel =
                p.status == ProductStatus.active ? 'Active' : 'Pending';
            final statusBg = p.status == ProductStatus.active
                ? CColors.backgroundEmerald100
                : const Color(0xFFFEE2E2);
            final statusText = p.status == ProductStatus.active
                ? CColors.textEmeraldGreen
                : CColors.textRichRed;
            final priceColor =
                isLow ? CColors.backGroundOrange : CColors.textEmeraldGreen;
            final soldColor =
                isLow ? CColors.backGroundOrange : CColors.textEmeraldGreen;

            return TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: context.dividerClr, width: 0.5))),
              children: [
                _cell(
                    child: ProductImageCell(
                        imagePath: p.images.first,
                        name: p.name,
                        category: p.category,
                        grade: p.grade)),
                _cell(
                    child: Text(
                        p.origin.isNotEmpty
                            ? '${p.origin}, ${p.location}'
                            : p.location,
                        style: TextStyle(
                            fontSize: 11, color: context.txtPrimary))),
                _cell(
                    child: RichText(
                        text: TextSpan(children: [
                  TextSpan(
                      text: '\$${p.price}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: priceColor)),
                  TextSpan(
                      text: '/${p.unit}',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: context.txtSecondary)),
                ]))),
                _cell(
                    child: Text('${p.stock} ${p.unit}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary))),
                _cell(
                    child: Text('${sold.toInt()} ${p.unit}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: soldColor))),
                _cell(
                    child: isOut
                        ? StatusPill(
                            label: 'Out of Stock',
                            bg: const Color(0xFFFEE2E2),
                            text: const Color(0xFFB91C1C))
                        : StatusPill(
                            label: statusLabel,
                            bg: statusBg,
                            text: statusText)),
                _cell(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  TableEditBtn(onTap: () => c.editProduct(p.id)),
                  const SizedBox(width: CSize.space5),
                  TableDeleteBtn(onTap: () => c.deleteMp(p.id)),
                ])),
              ],
            );
          }),
        ]),
      ),
    );
  }
}

// ── Advance Booking Table ─────────────────────────────────────────────────────

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(CSize.space16),
      child: Container(
        decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            border: Border.all(
                color: context.borderClr, width: CSize.borderWidth1)),
        child: Table(columnWidths: _cols, children: [
          _header([
            'Product',
            'Location',
            'Booking Price',
            'Total Stock',
            'Booked',
            'Harvest Date',
            'Status',
            'Actions'
          ], context),
          ...list.map((p) {
            final booked = c.abBookedQty(p);
            final almostFull = c.abIsAlmostFull(p);
            final priceColor = almostFull
                ? CColors.backGroundOrange
                : CColors.textEmeraldGreen;
            final bookedColor = almostFull
                ? CColors.backGroundOrange
                : CColors.textEmeraldGreen;
            final statusLabel =
                p.status == ProductStatus.active ? 'Active' : 'Inactive';
            final statusBg = p.status == ProductStatus.active
                ? CColors.backgroundEmerald100
                : const Color(0xFFF3F4F6);
            final statusText = p.status == ProductStatus.active
                ? CColors.textEmeraldGreen
                : CColors.textSecondary;

            return TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: context.dividerClr, width: 0.5))),
              children: [
                _cell(
                    child: ProductImageCell(
                        imagePath: p.images.first,
                        name: p.name,
                        category: p.category,
                        grade: p.grade)),
                _cell(
                    child: Text(
                        p.origin.isNotEmpty
                            ? '${p.origin}, ${p.location}'
                            : p.location,
                        style: TextStyle(
                            fontSize: 11, color: context.txtPrimary))),
                _cell(
                    child: RichText(
                        text: TextSpan(children: [
                  TextSpan(
                      text: '\$${p.bookingPrice}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: priceColor)),
                  TextSpan(
                      text: '/${p.unit}',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: context.txtSecondary)),
                ]))),
                _cell(
                    child: Text('${p.stock} ${p.unit}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary))),
                _cell(
                    child: Text('${booked.toInt()} ${p.unit}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: bookedColor))),
                _cell(
                    child: HarvestBadge(
                        date: p.harvestDate, isAlmostFull: almostFull)),
                _cell(
                    child: StatusPill(
                        label: statusLabel, bg: statusBg, text: statusText)),
                _cell(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  TableEditBtn(onTap: () => c.editProduct(p.id)),
                  const SizedBox(width: CSize.space5),
                  TableDeleteBtn(onTap: () => c.deleteAb(p.id)),
                ])),
              ],
            );
          }),
        ]),
      ),
    );
  }
}

// ── Live Auctions Table ───────────────────────────────────────────────────────

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(CSize.space16),
      child: Container(
        decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            border: Border.all(
                color: context.borderClr, width: CSize.borderWidth1)),
        child: Table(columnWidths: _cols, children: [
          _header([
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
          ...list.map((p) {
            final ended = c.laIsEnded(p);
            final soon = c.laIsEndingSoon(p);
            final timer = c.laTimerText(p);
            final bidColor = soon || ended
                ? CColors.backGroundOrange
                : CColors.textEmeraldGreen;
            final statusLabel = ended
                ? 'Ended'
                : soon
                    ? 'Ending Soon'
                    : 'Active';
            final statusBg = ended
                ? const Color(0xFFF3F4F6)
                : soon
                    ? const Color(0xFFFEF9C3)
                    : CColors.backgroundEmerald100;
            final statusText = ended
                ? CColors.textSecondary
                : soon
                    ? const Color(0xFF854D0E)
                    : CColors.textEmeraldGreen;

            return TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: context.dividerClr, width: 0.5))),
              children: [
                _cell(
                    child: ProductImageCell(
                        imagePath: p.images.first,
                        name: p.name,
                        category: p.category,
                        grade: p.grade)),
                _cell(
                    child: Text(
                        p.origin.isNotEmpty
                            ? '${p.origin}, ${p.location}'
                            : p.location,
                        style: TextStyle(
                            fontSize: 11, color: context.txtPrimary))),
                _cell(
                    child: Text('${p.stock} ${p.unit}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary))),
                _cell(
                    child: Text('\$${p.startingBid}/${p.unit}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.txtSecondary))),
                _cell(
                    child: RichText(
                        text: TextSpan(children: [
                  TextSpan(
                      text: '\$${p.currentBid}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: bidColor)),
                  TextSpan(
                      text: '/${p.unit}',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: context.txtSecondary)),
                ]))),
                _cell(
                    child: Text('${p.totalBids}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB)))),
                _cell(
                    child: TimerBadge(
                        text: timer, isEnded: ended, isEndingSoon: soon)),
                _cell(
                    child: StatusPill(
                        label: statusLabel, bg: statusBg, text: statusText)),
                _cell(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  TableEditBtn(onTap: () => c.editProduct(p.id)),
                  const SizedBox(width: CSize.space5),
                  TableDeleteBtn(onTap: () => c.deleteLa(p.id)),
                ])),
              ],
            );
          }),
        ]),
      ),
    );
  }
}

// ── Shared Table Helpers ──────────────────────────────────────────────────────

TableRow _header(List<String> cols, BuildContext context) => TableRow(
      decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          border: Border(bottom: BorderSide(color: context.borderClr))),
      children: cols
          .map((col) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space14, vertical: CSize.space10),
                child: Text(col.toUpperCase(),
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: context.txtSecondary,
                        letterSpacing: 0.5)),
              ))
          .toList(),
    );

Widget _cell({required Widget child}) => Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space14, vertical: CSize.space12),
      child: child,
    );

// ─────────────────────────────────────────────────────────────────────────────
//  GRID WIDGETS (grid view) — same cards as marketplace/ab/la screens
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_mp_grid.dart  — Marketplace Grid (exact card from MarketplaceScr)
// ─────────────────────────────────────────────────────────────────────────────

class _MpGrid extends StatelessWidget {
  final MyProductsCon c;
  final List<MarketplaceProductModel> list;
  const _MpGrid({required this.c, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.inventory_2_outlined,
              size: CSize.icon36XLarge, color: CColors.textSecondary),
          SizedBox(height: CSize.space12),
          Text("No products found",
              style: TextStyle(
                  fontSize: CSize.font13Small, color: CColors.textSecondary)),
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(CSize.space16),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: CSize.space12,
        mainAxisSpacing: CSize.space12,
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, index) => _buildCard(list[index], context),
    );
  }

  Widget _buildCard(MarketplaceProductModel product, BuildContext context) {
    final double prog = c.mpProgress(product);
    final bool lowStock = c.mpIsLow(product);
    final bool outOfStock = c.mpIsOut(product);

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: lowStock ? const Color(0xFFFED7AA) : context.borderClr,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── IMAGE ──────────────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 1.65,
            child: Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(CSize.radius20Large)),
                child: Image.asset(
                  product.images.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: CColors.backgroundEmerald100,
                    child: const Center(
                        child: Icon(Icons.broken_image,
                            size: CSize.icon36XLarge, color: Colors.grey)),
                  ),
                ),
              ),
              // Gradient
              Positioned.fill(
                  child: Container(
                      decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent
                    ]),
              ))),
              // Status badge
              Positioned(
                top: CSize.space8,
                left: CSize.space8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8, vertical: CSize.space2),
                  decoration: BoxDecoration(
                    color: product.status == ProductStatus.active
                        ? CColors.backgroundEmerald100.withOpacity(0.95)
                        : const Color(0xFFFEE2E2).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                  ),
                  child: Text(
                    product.status == ProductStatus.active
                        ? "Active"
                        : "Pending",
                    style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w700,
                      color: product.status == ProductStatus.active
                          ? CColors.textEmeraldGreen
                          : CColors.textRichRed,
                    ),
                  ),
                ),
              ),
              // Name + location + grade
              Positioned(
                left: CSize.space8,
                bottom: CSize.space8,
                right: CSize.space8,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(product.name,
                          style: const TextStyle(
                              fontSize: CSize.font13Small,
                              fontWeight: FontWeight.w800,
                              color: CColors.textWhite),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: CSize.space2),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: CSize.font10XSmall, color: CColors.iconWhite),
                        const SizedBox(width: CSize.space2),
                        Expanded(
                            child: Text(
                                "${product.origin}, ${product.location}",
                                style: TextStyle(
                                    fontSize: CSize.font10XSmall,
                                    color: CColors.textWhite.withOpacity(0.78)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: CSize.space4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: CSize.space5, vertical: 2),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius:
                                  BorderRadius.circular(CSize.radius20Large)),
                          child: Text("GRADE ${product.grade}",
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF78350F))),
                        ),
                      ]),
                    ]),
              ),
            ]),
          ),
          // ── INFO ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(CSize.space10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: context.txtSecondary)),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("\$${product.price}",
                              style: const TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w700,
                                  color: CColors.textEmeraldGreen),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text("/${product.unit}",
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: context.txtPrimary)),
                        ]),
                      ]),
                  // Total Stock
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Stock",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: context.txtSecondary)),
                        Text("${product.stock} ${product.unit}",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: context.txtPrimary)),
                      ]),
                  const SizedBox(height: CSize.space2),
                  // MOQ
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("MOQ",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: context.txtSecondary)),
                        Text("${product.minOrderQty?.toInt()} ${product.unit}",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: context.txtPrimary)),
                      ]),
                  Divider(
                      height: CSize.space12,
                      thickness: CSize.borderWidth05,
                      color: context.dividerClr),
                  // Stock Sold
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("STOCK SOLD",
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: context.txtSecondary,
                                letterSpacing: 0.3)),
                        Text(
                          "${c.mpSoldQty(product).toInt()} / ${product.stock} ${product.unit}",
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: lowStock
                                  ? CColors.textOrange
                                  : CColors.textEmeraldGreen),
                        ),
                      ]),
                  const SizedBox(height: CSize.space4),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    child: LinearProgressIndicator(
                      value: prog,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(lowStock
                          ? CColors.backGroundOrange
                          : CColors.backGroundEmeraldGreen),
                    ),
                  ),
                  const SizedBox(height: CSize.space8),
                  // Buttons
                  Row(children: [
                    Expanded(
                        child: OutlinedButton.icon(
                      onPressed: () => c.editProduct(product.id),
                      icon: const Icon(Icons.edit_outlined,
                          size: CSize.font10XSmall,
                          color: CColors.iconEmeraldGreen),
                      label: const Text("Edit",
                          style: TextStyle(
                              fontSize: CSize.font10XSmall,
                              fontWeight: FontWeight.w600,
                              color: CColors.textEmeraldGreen)),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: CSize.space4),
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(CSize.radius10Medium)),
                      ),
                    )),
                    const SizedBox(width: CSize.space8),
                    SizedBox(
                      width: CSize.space32,
                      height: CSize.space32,
                      child: OutlinedButton(
                        onPressed: () => c.deleteMp(product.id),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: Color(0xFFFCA5A5)),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CSize.radius10Medium)),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            size: CSize.icon16Small, color: CColors.iconError),
                      ),
                    ),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_ab_grid.dart  — Advance Booking Grid (exact card from AbScr)
// ─────────────────────────────────────────────────────────────────────────────

class _AbGrid extends StatelessWidget {
  final MyProductsCon c;
  final List<AdvanceBookingProductModel> list;
  const _AbGrid({required this.c, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.inventory_2_outlined,
              size: CSize.icon36XLarge, color: CColors.textSecondary),
          SizedBox(height: CSize.space12),
          Text("No products found",
              style: TextStyle(
                  fontSize: CSize.font13Small, color: CColors.textSecondary)),
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(CSize.space16),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: CSize.space12,
        mainAxisSpacing: CSize.space12,
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, index) => _buildCard(list[index], context),
    );
  }

  Widget _buildCard(AdvanceBookingProductModel product, BuildContext context) {
    final double prog = c.abProgress(product);
    final bool almostFull = c.abIsAlmostFull(product);
    final double booked = c.abBookedQty(product);

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: almostFull ? const Color(0xFFFED7AA) : context.borderClr,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── HARVEST DATE HEADER BAR ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space12, vertical: CSize.space5),
            decoration: BoxDecoration(
              color: almostFull
                  ? const Color(0xFFB45309)
                  : CColors.backGroundEmeraldGreen,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(CSize.radius20Large)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.calendar_today_outlined,
                        size: CSize.icon16Small, color: CColors.iconWhite),
                    SizedBox(width: CSize.space4),
                    Text("Harvest Date",
                        style: TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w500,
                            color: CColors.textWhite)),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space8, vertical: CSize.space2),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius:
                            BorderRadius.circular(CSize.radius20Large)),
                    child: Text(product.harvestDate,
                        style: const TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w700,
                            color: CColors.textWhite)),
                  ),
                ]),
          ),
          // ── IMAGE ──────────────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 1.7,
            child: Stack(children: [
              ClipRRect(
                  child: Image.asset(
                product.images.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image,
                        size: CSize.icon36XLarge, color: Colors.grey)),
              )),
              Positioned.fill(
                  child: Container(
                      decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent
                    ]),
              ))),
              if (product.status != null)
                Positioned(
                  top: CSize.space8,
                  left: CSize.space8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space8, vertical: CSize.space4),
                    decoration: BoxDecoration(
                      color: product.status == ProductStatus.active
                          ? CColors.backgroundEmerald100.withOpacity(0.95)
                          : CColors.backGroundOrange.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(CSize.radius5Small),
                    ),
                    child: Text(product.status?.name ?? "",
                        style: TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w700,
                            color: product.status == ProductStatus.active
                                ? CColors.textEmeraldGreen
                                : CColors.textWhite)),
                  ),
                ),
              Positioned(
                left: CSize.space10,
                bottom: CSize.space8,
                right: CSize.space10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(product.name,
                          style: const TextStyle(
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w700,
                              color: CColors.textWhite),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: CSize.space2),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: CSize.icon16Small, color: CColors.iconWhite),
                        const SizedBox(width: CSize.space2),
                        Expanded(
                            child: Text("${product.origin} ${product.location}",
                                style: TextStyle(
                                    fontSize: CSize.font10XSmall,
                                    color: CColors.textWhite.withOpacity(0.78)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: CSize.space4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: CSize.space5, vertical: CSize.space2),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius:
                                  BorderRadius.circular(CSize.radius5Small)),
                          child: Text("GRADE ${product.grade}",
                              style: const TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF78350F))),
                        ),
                      ]),
                    ]),
              ),
            ]),
          ),
          // ── INFO ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(CSize.space8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Booking Price
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Booking Price",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w900,
                                color: context.txtPrimary)),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("\$${product.bookingPrice}",
                              style: const TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w700,
                                  color: CColors.textEmeraldGreen),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text("/${product.unit}",
                              style: TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w600,
                                  color: context.txtSecondary)),
                        ]),
                      ]),
                  const SizedBox(height: CSize.space2),
                  // MOQ
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("MOQ",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w900,
                                color: context.txtPrimary)),
                        Text("${product.minOrderQty?.toInt()} ${product.unit}",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w600,
                                color: context.txtSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                  const SizedBox(height: CSize.space2),
                  // Booked
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Booked",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w900,
                                color: context.txtPrimary)),
                        Text(
                            "${booked.toInt()} / ${product.stock} ${product.unit}",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w700,
                                color: almostFull
                                    ? CColors.textOrange
                                    : CColors.textEmeraldGreen)),
                      ]),
                  const SizedBox(height: CSize.space4),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    child: LinearProgressIndicator(
                      value: prog,
                      minHeight: CSize.space8 - CSize.space2,
                      backgroundColor: CColors.borderGray.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(almostFull
                          ? CColors.backGroundOrange
                          : CColors.backGroundEmeraldGreen),
                    ),
                  ),
                  const SizedBox(height: CSize.space4),
                  // Buttons
                  Row(children: [
                    Expanded(
                        child: OutlinedButton.icon(
                      onPressed: () => c.editProduct(product.id),
                      icon: const Icon(Icons.edit_outlined,
                          size: CSize.icon16Small,
                          color: CColors.iconEmeraldGreen),
                      label: const Text("Edit",
                          style: TextStyle(
                              fontSize: CSize.font13Small,
                              fontWeight: FontWeight.w500,
                              color: CColors.textEmeraldGreen)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: CSize.borderWidth1,
                            color: CColors.borderDarkGray),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(CSize.radius10Medium)),
                        padding:
                            const EdgeInsets.symmetric(vertical: CSize.space4),
                      ),
                    )),
                    const SizedBox(width: CSize.space8),
                    SizedBox(
                      height: CSize.space32,
                      width: CSize.space32,
                      child: OutlinedButton(
                        onPressed: () => c.deleteAb(product.id),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(
                              width: CSize.borderWidth1,
                              color: CColors.borderError),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CSize.radius10Medium)),
                        ),
                        child: const Icon(Icons.delete_outline_outlined,
                            size: CSize.icon20Medium, color: CColors.iconError),
                      ),
                    ),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: my_products_la_grid.dart  — Live Auctions Grid (exact card from LaScr)
// ─────────────────────────────────────────────────────────────────────────────

class _LaGrid extends StatelessWidget {
  final MyProductsCon c;
  final List<LiveAuctionProductModel> list;
  const _LaGrid({required this.c, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.gavel_outlined,
              size: CSize.icon36XLarge, color: CColors.textSecondary),
          SizedBox(height: CSize.space12),
          Text("No auctions found",
              style: TextStyle(
                  fontSize: CSize.font13Small, color: CColors.textSecondary)),
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(CSize.space16),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: CSize.space12,
        mainAxisSpacing: CSize.space12,
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, index) => _buildCard(list[index], context),
    );
  }

  Widget _buildCard(LiveAuctionProductModel product, BuildContext context) {
    final bool ended = c.laIsEnded(product);
    final bool endingSoon = c.laIsEndingSoon(product);
    final String timer = c.laTimerText(product);

    final Color headerColor = ended
        ? CColors.backGroundOrange
        : endingSoon
            ? const Color(0xFFB45309)
            : CColors.backGroundEmeraldGreen;

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: endingSoon && !ended
              ? const Color(0xFFFED7AA)
              : context.borderClr,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── TIMER HEADER BAR ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space10, vertical: CSize.space5),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(CSize.radius20Large)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Clock + label
                  Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.access_time_rounded,
                        size: CSize.icon16Small, color: CColors.iconWhite),
                    SizedBox(width: CSize.space4),
                    Text("Time Left",
                        style: TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w500,
                            color: CColors.textWhite)),
                  ]),
                  // Right: Blinking dot + timer
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    if (!ended)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 0.15),
                        duration: const Duration(milliseconds: 900),
                        builder: (context, value, child) =>
                            Opacity(opacity: value, child: child),
                        onEnd: () {},
                        child: Container(
                          width: CSize.space8,
                          height: CSize.space8,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),
                    if (!ended) const SizedBox(width: CSize.space5),
                    Text(timer,
                        style: const TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w700,
                            color: CColors.textWhite)),
                  ]),
                ]),
          ),
          // ── IMAGE ──────────────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 1.7,
            child: Stack(children: [
              ClipRRect(
                  child: Image.asset(
                product.images.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image,
                        size: CSize.icon36XLarge, color: Colors.grey)),
              )),
              Positioned.fill(
                  child: Container(
                      decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.62),
                      Colors.transparent
                    ]),
              ))),
              // Status badge
              Positioned(
                top: CSize.space8,
                left: CSize.space8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8, vertical: CSize.space4),
                  decoration: BoxDecoration(
                    color: product.status == ProductStatus.active
                        ? CColors.backgroundEmerald100.withOpacity(0.95)
                        : CColors.backGroundOrange.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(CSize.radius5Small),
                  ),
                  child: Text(product.status?.name ?? "",
                      style: TextStyle(
                          fontSize: CSize.font10XSmall,
                          fontWeight: FontWeight.w700,
                          color: product.status == ProductStatus.active
                              ? CColors.textEmeraldGreen
                              : CColors.textWhite)),
                ),
              ),
              // Name + location + grade
              Positioned(
                left: CSize.space10,
                bottom: CSize.space8,
                right: CSize.space10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(product.name,
                          style: const TextStyle(
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w700,
                              color: CColors.textWhite),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: CSize.space2),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: CSize.icon16Small, color: CColors.iconWhite),
                        const SizedBox(width: CSize.space2),
                        Expanded(
                            child: Text("${product.origin} ${product.location}",
                                style: TextStyle(
                                    fontSize: CSize.font10XSmall,
                                    color: CColors.textWhite.withOpacity(0.78)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: CSize.space4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: CSize.space5, vertical: CSize.space2),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius:
                                  BorderRadius.circular(CSize.radius5Small)),
                          child: Text("GRADE ${product.grade}",
                              style: const TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF78350F))),
                        ),
                      ]),
                    ]),
              ),
            ]),
          ),
          // ── INFO ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(CSize.space8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Starting Price
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("STARTING PRICE",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w900,
                                color: context.txtPrimary)),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("\$${product.startingBid}",
                              style: const TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w700,
                                  color: CColors.textEmeraldGreen),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text("/${product.unit}",
                              style: TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w600,
                                  color: context.txtSecondary)),
                        ]),
                      ]),
                  const SizedBox(height: CSize.space2),
                  // Current Bid
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CURRENT BID",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w900,
                                color: context.txtPrimary)),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("\$${product.currentBid}",
                              style: const TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w700,
                                  color: CColors.textEmeraldGreen),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text("/${product.unit}",
                              style: TextStyle(
                                  fontSize: CSize.font10XSmall,
                                  fontWeight: FontWeight.w600,
                                  color: context.txtSecondary)),
                        ]),
                      ]),
                  const SizedBox(height: CSize.space2),
                  Divider(
                      height: CSize.space8,
                      thickness: CSize.borderWidth05,
                      color: context.dividerClr),
                  const SizedBox(height: CSize.space2),
                  // Total Bids
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL BIDS",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w900,
                                color: context.txtPrimary)),
                        Text("${product.totalBids}",
                            style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w600,
                                color: context.txtSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                  const SizedBox(height: CSize.space5),
                  // Buttons
                  Row(children: [
                    Expanded(
                        child: OutlinedButton.icon(
                      onPressed: () => c.editProduct(product.id),
                      icon: const Icon(Icons.edit_outlined,
                          size: CSize.icon16Small,
                          color: CColors.iconEmeraldGreen),
                      label: const Text("Edit",
                          style: TextStyle(
                              fontSize: CSize.font13Small,
                              fontWeight: FontWeight.w500,
                              color: CColors.textEmeraldGreen)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: CColors.borderDarkGray,
                            width: CSize.borderWidth1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(CSize.radius10Medium)),
                        padding:
                            const EdgeInsets.symmetric(vertical: CSize.space4),
                      ),
                    )),
                    const SizedBox(width: CSize.space8),
                    SizedBox(
                      height: CSize.space32,
                      width: CSize.space32,
                      child: OutlinedButton(
                        onPressed: () => c.deleteLa(product.id),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(
                              color: CColors.borderError,
                              width: CSize.borderWidth1),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CSize.radius10Medium)),
                        ),
                        child: const Icon(Icons.delete_outline_outlined,
                            size: CSize.icon20Medium, color: CColors.iconError),
                      ),
                    ),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}
