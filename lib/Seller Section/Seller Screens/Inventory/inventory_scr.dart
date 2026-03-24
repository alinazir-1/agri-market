import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Shared/Screens Common Widgets/grade_pill.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import '../../../Shared/Screens Common Widgets/status_pill.dart';
import 'Inventory Widgets/inv_activity_item.dart';
import 'Inventory Widgets/inv_alert_card.dart';
import 'Inventory Widgets/inv_filter_chip.dart';
import 'Inventory Widgets/inv_restock_button.dart';
import 'Inventory Widgets/inv_restock_dialog.dart';
import 'Inventory Widgets/inv_stat_card.dart';
import 'Inventory Widgets/inv_stock_bar.dart';
import 'Inventory Widgets/inv_type_badge.dart';
import 'inventory_con.dart';

class InventoryScr extends StatelessWidget {
  final InventoryCon c = Get.put(InventoryCon());

  InventoryScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenTopBar(
              title: 'Inventory & Stock',
              subtitle: 'Monitor and manage your product stock levels',
              searchController: c.searchController,
              onSearch: c.onSearch,
              searchHint: 'Search products...',
            ),
            _summaryCards(context),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _tableSection(context)),
                  _sidebar(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  SUMMARY CARDS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _summaryCards(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space20, vertical: CSize.space14),
          color: context.appBg,
          child: Row(
            children: [
              Expanded(
                  child: InvStatCard(
                label: 'Total Products',
                value: '${c.totalProducts}',
                badge: 'All listings',
                icon: Icons.inventory_2_outlined,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
                badgeBg: CColors.backgroundEmerald100,
                badgeTextColor: CColors.textEmeraldGreen,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: InvStatCard(
                label: 'In Stock',
                value: '${c.inStockCount}',
                badge: 'Healthy',
                icon: Icons.trending_up_rounded,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
                badgeBg: CColors.backgroundEmerald100,
                badgeTextColor: CColors.textEmeraldGreen,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: InvStatCard(
                label: 'Low Stock',
                value: '${c.lowStockCount}',
                badge: 'Needs restock',
                icon: Icons.warning_amber_rounded,
                iconBg: const Color(0xFFFFF7ED),
                iconColor: CColors.backGroundOrange,
                badgeBg: const Color(0xFFFFF7ED),
                badgeTextColor: CColors.textOrange,
                valueColor: CColors.backGroundOrange,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: InvStatCard(
                label: 'Out of Stock',
                value: '${c.outOfStockCount}',
                badge: 'Action needed',
                icon: Icons.remove_circle_outline_rounded,
                iconBg: const Color(0xFFFEE2E2),
                iconColor: CColors.iconError,
                badgeBg: const Color(0xFFFEE2E2),
                badgeTextColor: CColors.textError,
                valueColor: CColors.textError,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: InvStatCard(
                label: 'Total Value',
                value: '\$${(c.totalValue / 1000).toStringAsFixed(0)}k',
                badge: 'All products',
                icon: Icons.attach_money_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF3B82F6),
                badgeBg: const Color(0xFFEFF6FF),
                badgeTextColor: const Color(0xFF1D4ED8),
                valueColor: const Color(0xFF1D4ED8),
              )),
            ],
          ),
        ));
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  TABLE SECTION
  // ════════════════════════════════════════════════════════════════════════════

  Widget _tableSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: context.borderClr))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tableHeader(context),
          Expanded(child: _table(context)),
        ],
      ),
    );
  }

  Widget _tableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          CSize.space20, CSize.space14, CSize.space20, CSize.space12),
      child: Row(
        children: [
          Text('Stock Overview',
              style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary)),
          const Spacer(),
          Obx(() => Wrap(
                spacing: CSize.space5,
                children: [
                  InvFilterChip(
                      label: 'All',
                      isActive: c.selectedFilter.value == InventoryFilter.all,
                      onTap: () => c.setFilter(InventoryFilter.all)),
                  InvFilterChip(
                      label: 'Marketplace',
                      isActive:
                          c.selectedFilter.value == InventoryFilter.marketplace,
                      onTap: () => c.setFilter(InventoryFilter.marketplace)),
                  InvFilterChip(
                      label: 'Live Auction',
                      isActive:
                          c.selectedFilter.value == InventoryFilter.liveAuction,
                      onTap: () => c.setFilter(InventoryFilter.liveAuction)),
                  InvFilterChip(
                      label: 'Adv. Booking',
                      isActive: c.selectedFilter.value ==
                          InventoryFilter.advanceBooking,
                      onTap: () => c.setFilter(InventoryFilter.advanceBooking)),
                  InvFilterChip(
                    label: 'Low Stock',
                    isActive:
                        c.selectedFilter.value == InventoryFilter.lowStock,
                    onTap: () => c.setFilter(InventoryFilter.lowStock),
                    activeColor: CColors.backGroundOrange,
                    activeBorder: CColors.backGroundOrange,
                    inactiveBorder: const Color(0xFFFED7AA),
                    inactiveText: CColors.textOrange,
                  ),
                  InvFilterChip(
                    label: 'Out of Stock',
                    isActive:
                        c.selectedFilter.value == InventoryFilter.outOfStock,
                    onTap: () => c.setFilter(InventoryFilter.outOfStock),
                    activeColor: CColors.borderError,
                    activeBorder: CColors.borderError,
                    inactiveBorder: const Color(0xFFFCA5A5),
                    inactiveText: CColors.textRichRed,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _table(BuildContext context) {
    return Obx(() {
      final list = c.filteredItems;
      if (list.isEmpty) {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.inventory_2_outlined,
                size: CSize.icon36XLarge, color: context.txtSecondary),
            const SizedBox(height: CSize.space12),
            Text('No products found',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: context.txtSecondary)),
          ]),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(1.5),
            7: FlexColumnWidth(2.5),
          },
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(color: context.cardBg2),
              children: [
                _th('Product', context),
                _th('Type', context),
                _th('Grade', context),
                _th('Status', context),
                _th('Stock Level', context),
                _th('Sold / Booked', context),
                _th('Unit Price', context),
                _th('Actions', context),
              ],
            ),
            // Data rows
            ...list.map((item) => _tableRow(item, context)),
          ],
        ),
      );
    });
  }

  Widget _th(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space8, vertical: CSize.space10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: context.txtSecondary,
            letterSpacing: 0.5),
      ),
    );
  }

  TableRow _tableRow(InventoryItem item, BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: context.dividerClr, width: 0.5))),
      children: [
        // Product
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                child: Image.asset(
                  item.image,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      width: 36,
                      height: 36,
                      color: CColors.backgroundEmerald100,
                      child: const Icon(Icons.image_outlined,
                          size: CSize.icon16Small,
                          color: CColors.iconEmeraldGreen)),
                ),
              ),
              const SizedBox(width: CSize.space8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(item.name,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(item.category,
                        style: TextStyle(
                            fontSize: 9, color: context.txtSecondary)),
                  ])),
            ],
          ),
        ),

        // Type
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: InvTypeBadge(type: item.productType)),

        // Grade
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: GradePill(grade: item.grade)),

        // Status
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: Obx(() =>
                StatusPill(isOut: item.isOutOfStock, isLow: item.isLowStock))),

        // Stock Level
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: Obx(() => InvStockBar(
                  current: item.currentStock.value,
                  total: item.totalStock,
                  unit: item.unit,
                  isLow: item.isLowStock,
                  isOut: item.isOutOfStock,
                ))),

        // Sold / Booked
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Obx(() {
            final pct = (item.progressValue * 100).toStringAsFixed(0);
            final color = item.isOutOfStock
                ? CColors.textError
                : item.isLowStock
                    ? CColors.textOrange
                    : CColors.textEmeraldGreen;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.soldQty.value.toInt()} ${item.unit}',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color)),
                  Text('$pct% sold',
                      style: TextStyle(
                          fontSize: 9, color: context.txtSecondary)),
                ]);
          }),
        ),

        // Unit Price
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text('\$${item.price.toStringAsFixed(0)}/${item.unit}',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary)),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Obx(() => Row(
                children: [
                  // Edit
                  _iconBtn(Icons.edit_outlined, CColors.iconEmeraldGreen,
                      CColors.backgroundEmerald100, () => c.editItem(item)),
                  const SizedBox(width: CSize.space4),
                  // Delete
                  _iconBtn(Icons.delete_outline_rounded, CColors.iconError,
                      const Color(0xFFFEE2E2), () {
                    Get.dialog(AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CSize.radius20Large)),
                      title: const Text('Delete Product',
                          style: TextStyle(
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w800)),
                      content: Text(
                          'Are you sure you want to remove ${item.name} from inventory?',
                          style: const TextStyle(
                              fontSize: CSize.font13Small,
                              color: CColors.textSecondary)),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            c.deleteItem(item.id);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CColors.borderError,
                              elevation: 0),
                          child: const Text('Delete',
                              style: TextStyle(color: CColors.textWhite)),
                        ),
                      ],
                    ));
                  }),
                  const SizedBox(width: CSize.space4),
                  // Restock
                  InvRestockButton(
                    isOut: item.isOutOfStock,
                    isLow: item.isLowStock,
                    onTap: () => Get.dialog(InvRestockDialog(
                      productName: item.name,
                      unit: item.unit,
                      controller: c.restockController,
                      onConfirm: () => c.restockItem(item.id),
                    )),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _iconBtn(
      IconData icon, Color iconColor, Color bg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CSize.radius5Small),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(CSize.radius5Small),
            border: Border.all(
                color: CColors.borderGray, width: CSize.borderWidth05)),
        child: Icon(icon, size: CSize.icon16Small, color: iconColor),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  SIDEBAR
  // ════════════════════════════════════════════════════════════════════════════

  Widget _sidebar(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sidebarAlerts(context),
            const SizedBox(height: CSize.space20),
            _sidebarActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _sidebarAlerts(BuildContext context) {
    return Obx(() {
      final alerts = c.alerts;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.warning_amber_rounded,
                size: CSize.icon16Small, color: CColors.textError),
            const SizedBox(width: CSize.space5),
            Text('Stock Alerts',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: context.txtPrimary)),
            const SizedBox(width: CSize.space5),
            if (alerts.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space8, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(CSize.radius20Large)),
                child: Text('${alerts.length}',
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: CColors.textError)),
              ),
          ]),
          const SizedBox(height: CSize.space10),
          if (alerts.isEmpty)
            Container(
              padding: const EdgeInsets.all(CSize.space12),
              decoration: BoxDecoration(
                  color: CColors.backgroundEmerald100,
                  borderRadius: BorderRadius.circular(CSize.radius10Medium)),
              child: const Row(children: [
                Icon(Icons.check_circle_outline,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                SizedBox(width: CSize.space8),
                Text('All stock levels healthy',
                    style: TextStyle(
                        fontSize: 10,
                        color: CColors.textEmeraldGreen,
                        fontWeight: FontWeight.w600)),
              ]),
            )
          else
            ...alerts.map((item) => InvAlertCard(
                  name: item.name,
                  detail: '${item.category} · ${item.productType.name}',
                  stockText:
                      '${item.currentStock.value} / ${item.totalStock} ${item.unit} — ${item.isOutOfStock ? "Out of Stock" : "Low Stock"}',
                  isOut: item.isOutOfStock,
                )),
        ],
      );
    });
  }

  Widget _sidebarActivity(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.timeline_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
              const SizedBox(width: CSize.space5),
              Text('Recent Activity',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: context.txtPrimary)),
            ]),
            const SizedBox(height: CSize.space10),
            ...c.activityLog.map((entry) => InvActivityItem(entry: entry)),
          ],
        ));
  }
}
