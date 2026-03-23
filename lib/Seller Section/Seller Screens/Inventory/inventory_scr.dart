import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Shared/Screens Common Widgets/grade_pill.dart';
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _summaryCards(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _tableSection()),
                  _sidebar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ════════════════════════════════════════════════════════════════════════════

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space20, vertical: CSize.space12),
      decoration: const BoxDecoration(
          color: CColors.backGroundWhite,
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Inventory & Stock',
                  style: TextStyle(
                      fontSize: CSize.font24Large,
                      fontWeight: FontWeight.w900,
                      color: CColors.textPrimary)),
              SizedBox(height: CSize.space2),
              Text('Monitor and manage your product stock levels',
                  style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      color: CColors.textSecondary)),
            ],
          ),
          const SizedBox(width: CSize.space20),
          SizedBox(
            width: 280,
            height: 36,
            child: TextField(
              controller: c.searchController,
              onChanged: c.onSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle:
                    const TextStyle(fontSize: 11, color: CColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: CSize.space10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    borderSide: const BorderSide(
                        color: CColors.borderEmeraldGreen,
                        width: CSize.borderWidth1)),
              ),
            ),
          ),
          const Spacer(),
          Stack(children: [
            Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: CColors.backGroundWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0))),
                child: const Icon(Icons.notifications_none_rounded,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen)),
            Positioned(
                top: 4,
                right: 4,
                child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        color: CColors.notificationDot,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: CColors.backGroundWhite, width: 1.5)))),
          ]),
          const SizedBox(width: CSize.space8),
          Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: CColors.backGroundWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0))),
              child: const Icon(Icons.messenger_outline_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen)),
          const SizedBox(width: CSize.space8),
          const CircleAvatar(
              radius: 17,
              backgroundColor: CColors.backGroundEmeraldGreen,
              child: Text('AS',
                  style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w800,
                      color: CColors.textWhite))),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  SUMMARY CARDS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _summaryCards() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space20, vertical: CSize.space14),
          color: const Color(0xFFF8FAFC),
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

  Widget _tableSection() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFE2E8F0)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tableHeader(),
          Expanded(child: _table()),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          CSize.space20, CSize.space14, CSize.space20, CSize.space12),
      child: Row(
        children: [
          const Text('Stock Overview',
              style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w800,
                  color: CColors.textPrimary)),
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

  Widget _table() {
    return Obx(() {
      final list = c.filteredItems;
      if (list.isEmpty) {
        return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.inventory_2_outlined,
                size: CSize.icon36XLarge, color: CColors.textSecondary),
            SizedBox(height: CSize.space12),
            Text('No products found',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
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
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
              children: [
                _th('Product'),
                _th('Type'),
                _th('Grade'),
                _th('Status'),
                _th('Stock Level'),
                _th('Sold / Booked'),
                _th('Unit Price'),
                _th('Actions'),
              ],
            ),
            // Data rows
            ...list.map((item) => _tableRow(item)),
          ],
        ),
      );
    });
  }

  Widget _th(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space8, vertical: CSize.space10),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: CColors.textSecondary,
            letterSpacing: 0.5),
      ),
    );
  }

  TableRow _tableRow(InventoryItem item) {
    return TableRow(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5))),
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
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: CColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(item.category,
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary)),
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
                      style: const TextStyle(
                          fontSize: 9, color: CColors.textSecondary)),
                ]);
          }),
        ),

        // Unit Price
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text('\$${item.price.toStringAsFixed(0)}/${item.unit}',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CColors.textPrimary)),
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

  Widget _sidebar() {
    return SizedBox(
      width: 280,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sidebarAlerts(),
            const SizedBox(height: CSize.space20),
            _sidebarActivity(),
          ],
        ),
      ),
    );
  }

  Widget _sidebarAlerts() {
    return Obx(() {
      final alerts = c.alerts;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.warning_amber_rounded,
                size: CSize.icon16Small, color: CColors.textError),
            const SizedBox(width: CSize.space5),
            const Text('Stock Alerts',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: CColors.textPrimary)),
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

  Widget _sidebarActivity() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.timeline_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
              SizedBox(width: CSize.space5),
              Text('Recent Activity',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: CColors.textPrimary)),
            ]),
            const SizedBox(height: CSize.space10),
            ...c.activityLog.map((entry) => InvActivityItem(entry: entry)),
          ],
        ));
  }
}
