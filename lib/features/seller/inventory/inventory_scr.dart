import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:agri_market/features/seller/inventory/widgets/inventory_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/shared/widgets/seller/grade_pill.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import 'package:agri_market/shared/widgets/seller/status_pill.dart';
import 'package:agri_market/features/seller/inventory/inventory_con.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_elevated_button.dart';
import '../../../shared/widgets/common/app_text.dart';
import '../../../shared/widgets/common/app_url_or_asset_image.dart';

class InventoryScr extends StatelessWidget {
  final InventoryCon ctrlInventory = Get.put(InventoryCon(), permanent: true);

  InventoryScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            ScreenTopBar(
              title: 'Inventory & Stock',
              subtitle: 'Monitor and manage your product stock levels',
              searchController: ctrlInventory.searchController,
              onSearch: ctrlInventory.onSearch,
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
    );
  }

  Widget _summaryCards(BuildContext context) {
    return Obx(
      () => SellerMetricStatRow(
        items: [
          SellerMetricStatItem(
            label: 'TOTAL PRODUCTS',
            value: '${ctrlInventory.totalProducts}',
            badge: '${ctrlInventory.totalBatches} batches',
            icon: Icons.inventory_2_outlined,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.badgeSuccessText,
          ),
          SellerMetricStatItem(
            label: 'IN STOCK',
            value: '${ctrlInventory.inStockCount}',
            badge: 'Healthy',
            icon: Icons.trending_up_rounded,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.iconEmeraldGreen,
          ),
          SellerMetricStatItem(
            label: 'LOW STOCK',
            value: '${ctrlInventory.lowStockCount}',
            badge: 'Restock soon',
            icon: Icons.warning_amber_rounded,
            iconBg: AppColors.badgeWarningBg,
            iconColor: AppColors.badgeWarningText,
            valueColor: AppColors.badgeWarningText,
          ),
          SellerMetricStatItem(
            label: 'OUT OF STOCK',
            value: '${ctrlInventory.outOfStockCount}',
            badge: 'Action needed',
            icon: Icons.remove_circle_outline_rounded,
            iconBg: AppColors.badgeErrorBg,
            iconColor: AppColors.badgeErrorText,
            valueColor: AppColors.badgeErrorText,
          ),
        ],
      ),
    );
  }

  Widget _tableSection(BuildContext context) {
    return AppContainer(
      border: Border(right: BorderSide(color: context.borderClr)),
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
    /// 💀🔥 ---------------- Inventory Filter Header ----------------
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSize.space20, AppSize.space16, AppSize.space20, AppSize.space12),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Wrap(
                  spacing: AppSize.space4,
                  runSpacing: AppSize.space4,
                  children: [
                    InvFilterChip(
                        label: 'All',
                        isActive: ctrlInventory.selectedFilter.value ==
                            InventoryFilter.all,
                        onTap: () =>
                            ctrlInventory.setFilter(InventoryFilter.all)),
                    InvFilterChip(
                        label: 'Marketplace',
                        isActive: ctrlInventory.selectedFilter.value ==
                            InventoryFilter.marketplace,
                        onTap: () =>
                            ctrlInventory.setFilter(InventoryFilter.marketplace)),
                    InvFilterChip(
                        label: 'Live Auction',
                        isActive: ctrlInventory.selectedFilter.value ==
                            InventoryFilter.liveAuction,
                        onTap: () =>
                            ctrlInventory.setFilter(InventoryFilter.liveAuction)),
                    InvFilterChip(
                        label: 'Adv. Booking',
                        isActive: ctrlInventory.selectedFilter.value ==
                            InventoryFilter.advanceBooking,
                        onTap: () => ctrlInventory
                            .setFilter(InventoryFilter.advanceBooking)),
                    InvFilterChip(
                        label: 'Low Stock',
                        isActive: ctrlInventory.selectedFilter.value ==
                            InventoryFilter.lowStock,
                        onTap: () =>
                            ctrlInventory.setFilter(InventoryFilter.lowStock),
                        activeColor: AppColors.textWarning,
                        activeBorder: AppColors.textWarning,
                        inactiveBorder: AppColors.badgeWarningBg,
                        inactiveText: AppColors.textWarning),
                    InvFilterChip(
                        label: 'Out of Stock',
                        isActive: ctrlInventory.selectedFilter.value ==
                            InventoryFilter.outOfStock,
                        onTap: () =>
                            ctrlInventory.setFilter(InventoryFilter.outOfStock),
                        activeColor: AppColors.borderError,
                        activeBorder: AppColors.borderError,
                        inactiveBorder: AppColors.badgeErrorBg,
                        inactiveText: AppColors.textError),
                  ],
                )),
          ),
          const SizedBox(width: AppSize.space12),
          /// 💀🔥 ---------------- Add Product Action ----------------
          AppElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.productForm),
            icon: Icons.add_rounded,
            iconSize: AppSize.icon16,
            iconColor: AppColors.textWhite,
            text: 'Add New Product',
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w700,
            textColor: AppColors.textWhite,
            backgroundColor: AppColors.emeraldGreen,
            borderRadius: AppSize.radius12,
            height: 32,
          ),
        ],
      ),
    );
  }

  Widget _table(BuildContext context) {
    return Obx(() {
      if (ctrlInventory.isBackendLoading.value) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space20, vertical: AppSize.space8),
          child: const AppListSkeleton(itemCount: 10, itemHeight: 56),
        );
      }
      final list = ctrlInventory.filteredItems;
      if (list.isEmpty) {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.inventory_2_outlined,
                size: AppSize.icon40, color: context.txtSecondary),
            const SizedBox(height: AppSize.space12),
            AppText(
                text: 'No products found',
                fontSize: AppSize.font14,
                color: context.txtSecondary),
          ]),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
        child: Column(
          children: [
            Table(
              columnWidths: _columnWidths,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: context.cardBg2),
                  children: [
                    _th('', context),
                    _th('Product', context),
                    _th('Channels', context),
                    _th('Grade', context),
                    _th('Status', context),
                    _th('Stock Level', context),
                    _th('Sold', context),
                    _th('Sell Price', context),
                    _th('Actions', context)
                  ],
                ),
              ],
            ),
            ...list.map((item) => _productRow(item, context)),
          ],
        ),
      );
    });
  }

  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(32),
    1: FlexColumnWidth(3),
    2: FlexColumnWidth(2),
    3: FlexColumnWidth(1.5),
    4: FlexColumnWidth(1.8),
    5: FlexColumnWidth(2),
    6: FlexColumnWidth(1.5),
    7: FlexColumnWidth(1.5),
    8: FlexColumnWidth(2),
  };

  Widget _productRow(InventoryItem item, BuildContext context) {
    /// 💀🔥 ---------------- Product Row Alignment ----------------
    return Obx(() {
      final expanded = item.isExpanded.value;
      return Column(
        children: [
          InkWell(
            onTap: () => ctrlInventory.toggleExpanded(item.id),
            child: Table(
              columnWidths: _columnWidths,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: expanded ? context.hoverBg : null,
                      border: Border(
                          bottom: BorderSide(
                              color: context.dividerClr, width: 0.5))),
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space4,
                            vertical: AppSize.space12),
                        child: AnimatedRotation(
                            turns: expanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(Icons.chevron_right_rounded,
                                size: AppSize.icon16,
                                color: context.txtSecondary))),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space8,
                          vertical: AppSize.space12),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppSize.radius4),
                              child: AppUrlOrAssetImage(
                                path: item.image,
                                width: 34.0,
                                height: 34.0,
                                fit: BoxFit.cover,
                              )),
                          const SizedBox(width: AppSize.space8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    text: item.name,
                                    fontSize: AppSize.font12,
                                    fontWeight: FontWeight.w700,
                                    color: context.txtPrimary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                /// 💀🔥 ---------------- Product Meta Overflow ----------------
                                Row(children: [
                                  Expanded(
                                    child: AppText(
                                        text: item.category,
                                        fontSize: AppSize.font10,
                                        color: context.txtSecondary,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(width: AppSize.space4),
                                  AppText(
                                      text: '·',
                                      fontSize: AppSize.font10,
                                      color: context.txtSecondary),
                                  const SizedBox(width: AppSize.space4),
                                  Flexible(
                                    child: AppText(
                                        text:
                                            '${item.activeBatchCount} batch${item.activeBatchCount == 1 ? '' : 'es'}',
                                        fontSize: AppSize.font10,
                                        color: AppColors.textEmeraldGreen,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: Wrap(
                            spacing: AppSize.space4,
                            runSpacing: AppSize.space4,
                            children: item.listedIn
                                .map((t) => InvTypeBadge(type: t))
                                .toList())),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GradePill(grade: item.topGrade),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatusPill(
                              label: item.isOutOfStock
                                  ? 'Out of Stock'
                                  : item.isLowStock
                                      ? 'Low Stock'
                                      : 'In Stock',
                              bg: item.isOutOfStock
                                  ? AppColors.badgeErrorBg
                                  : item.isLowStock
                                      ? AppColors.badgeWarningBg
                                      : AppColors.badgeSuccessBg,
                              text: item.isOutOfStock
                                  ? AppColors.badgeErrorText
                                  : item.isLowStock
                                      ? AppColors.textWarning
                                      : AppColors.textEmeraldGreen),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: InvStockBar(
                            current: item.currentStock.toInt(),
                            total: item.totalInitialStock.toInt(),
                            unit: item.unit,
                            isLow: item.isLowStock,
                            isOut: item.isOutOfStock)),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: _soldBreakdown(context, item)),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: AppText(
                            text:
                                '\$${item.sellingPrice.value.toStringAsFixed(0)}/${item.unit}',
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space8,
                          vertical: AppSize.space12),
                      child: Obx(() {
                        final delLoading = ctrlInventory
                            .isInventoryRowActionLoading(item.id, 'delete');
                        return Row(children: [
                          _iconBtn(
                              Icons.edit_outlined,
                              AppColors.iconEmeraldGreen,
                              AppColors.badgeSuccessBg,
                              () {},
                              tooltip: 'Edit'),
                          const SizedBox(width: AppSize.space4),
                          delLoading
                              ? AppContainer(
                                  width: 26.0,
                                  height: 26.0,
                                  alignment: Alignment.center,
                                  backgroundColor: AppColors.badgeErrorBg,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.radius4),
                                  border: Border.all(
                                      color: AppColors.borderGray,
                                      width: AppSize.borderWidth05),
                                  child: const AppInlineProgress(),
                                )
                              : _iconBtn(
                                  Icons.delete_outline_rounded,
                                  AppColors.iconError,
                                  AppColors.badgeErrorBg,
                                  () => _confirmDelete(context, item),
                                  tooltip: 'Delete'),
                        ]);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (expanded)
            /// 💀🔥 ---------------- Batch Expanded Highlight ----------------
            AppContainer(
              backgroundColor: _expandedBatchBg(item),
              border: Border(
                left: BorderSide(
                    color: _expandedBatchAccent(item), width: AppSize.borderWidth1),
                bottom: BorderSide(color: context.dividerClr),
              ),
              padding: const EdgeInsets.fromLTRB(
                  32.0, // Fixed Size
                  AppSize.space12,
                  AppSize.space16,
                  AppSize.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 💀🔥 ---------------- Batch List Header ----------------
                  Row(children: [
                    const Icon(Icons.layers_outlined,
                        size: AppSize.icon16,
                        color: AppColors.iconEmeraldGreen),
                    const SizedBox(width: AppSize.space8),
                    AppText(
                        text: 'Batches (${item.batches.length})',
                        fontSize: AppSize.font14,
                        fontWeight: FontWeight.w700,
                        color: context.txtPrimary),
                    const SizedBox(width: AppSize.space8),
                    if (item.soldMarketplace.value > 0)
                      _channelSoldBadge(
                          context,
                          'MKT',
                          item.soldMarketplace.value,
                          item.unit,
                          AppColors.badgeInfoBg,
                          AppColors.textInfo),
                    if (item.soldAuction.value > 0)
                      _channelSoldBadge(
                          context,
                          'AUC',
                          item.soldAuction.value,
                          item.unit,
                          AppColors.badgeWarningBg,
                          AppColors.textWarning),
                    if (item.soldBooking.value > 0)
                      _channelSoldBadge(
                          context,
                          'BKG',
                          item.soldBooking.value,
                          item.unit,
                          AppColors.badgeSuccessBg,
                          AppColors.textEmeraldGreen),
                  ]),
                  const SizedBox(height: AppSize.space12),
                  ...item.batches.map((batch) {
                    final lt = item.listedIn.isEmpty
                        ? null
                        : item.listedIn.first;
                    return InvBatchCard(
                        batch: batch, item: item, listingType: lt);
                  }),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _soldBreakdown(BuildContext context, InventoryItem item) {
    return Obx(() {
      final total = item.soldQty;
      final color = item.isOutOfStock
          ? AppColors.textError
          : item.isLowStock
              ? AppColors.textWarning
              : AppColors.textEmeraldGreen;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: '${total.toStringAsFixed(0)} ${item.unit}',
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: color),
          if (item.listedIn.length > 1)
            AppText(
                text: _channelShortBreakdown(item),
                fontSize: AppSize.font10,
                color: context.txtSecondary)
          else
            AppText(
                text: '${(item.progressValue * 100).toStringAsFixed(0)}% sold',
                fontSize: AppSize.font10,
                color: context.txtSecondary),
        ],
      );
    });
  }

  String _channelShortBreakdown(InventoryItem item) {
    final parts = <String>[];
    if (item.soldMarketplace.value > 0)
      parts.add('MKT: ${item.soldMarketplace.value.toStringAsFixed(0)}');
    if (item.soldAuction.value > 0)
      parts.add('AUC: ${item.soldAuction.value.toStringAsFixed(0)}');
    if (item.soldBooking.value > 0)
      parts.add('BKG: ${item.soldBooking.value.toStringAsFixed(0)}');
    return parts.join(' · ');
  }

  Widget _channelSoldBadge(BuildContext context, String channel, double qty,
      String unit, Color bg, Color textColor) {
    return AppContainer(
      margin: const EdgeInsets.only(left: AppSize.space4),
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.space8, vertical: 2),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
          text: '$channel: ${qty.toStringAsFixed(0)} $unit',
          fontSize: AppSize.font10,
          fontWeight: FontWeight.w600,
          color: textColor),
    );
  }

  Widget _th(String label, BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space8, vertical: AppSize.space12),
      child: AppText(
          text: label.toUpperCase(),
          fontSize: AppSize.font10,
          fontWeight: FontWeight.w800,
          color: context.txtSecondary,
          letterSpacing: 0.5));

  Widget _iconBtn(IconData icon, Color iconColor, Color bg, VoidCallback onTap,
      {String? tooltip}) {
    final btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radius4),
      child: AppContainer(
          width: 26.0, // Fixed Size
          height: 26.0, // Fixed Size
          backgroundColor: bg,
          borderRadius: BorderRadius.circular(AppSize.radius4),
          border: Border.all(
              color: AppColors.borderGray, width: AppSize.borderWidth05),
          child: Icon(icon, size: AppSize.icon16, color: iconColor)),
    );
    if (tooltip != null) return Tooltip(message: tooltip, child: btn);
    return btn;
  }

  void _confirmDelete(BuildContext context, InventoryItem item) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radius20)),
      title: const AppText(
          text: 'Remove Product',
          fontSize: AppSize.font16,
          fontWeight: FontWeight.w800),
      content: AppText(
          text:
              'Remove ${item.name} and all its batches from inventory? This cannot be undone.',
          fontSize: AppSize.font14,
          color: AppColors.textSecondary),
      actions: [
        TextButton(
            onPressed: () => Get.back(), child: const AppText(text: 'Cancel')),
        AppElevatedButton(
            onPressed: () async {
              await ctrlInventory.deleteItemWithLoading(item.id);
              Get.back();
            },
            text: 'Remove',
            textColor: AppColors.textWhite,
            backgroundColor: AppColors.borderError,
            elevation: 0),
      ],
    ));
  }

  Widget _sidebar(BuildContext context) {
    return SizedBox(
      width: 280.0, // Used fixed direct value for sidebar layout
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sidebarAlerts(context),
            const SizedBox(height: AppSize.space20),
            _sidebarActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _sidebarAlerts(BuildContext context) {
    return Obx(() {
      final alerts = ctrlInventory.alerts;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.warning_amber_rounded,
                size: AppSize.icon16, color: AppColors.textError),
            const SizedBox(width: AppSize.space4),
            AppText(
                text: 'Stock Alerts',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w800,
                color: context.txtPrimary),
            const SizedBox(width: AppSize.space4),
            if (alerts.isNotEmpty)
              AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8, vertical: 2),
                  backgroundColor: AppColors.badgeErrorBg,
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: AppText(
                      text: '${alerts.length}',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textError)),
          ]),
          const SizedBox(height: AppSize.space12),
          if (alerts.isEmpty)
            AppContainer(
              padding: const EdgeInsets.all(AppSize.space12),
              backgroundColor: AppColors.badgeSuccessBg,
              borderRadius: BorderRadius.circular(AppSize.radius12),
              child: const Row(children: [
                Icon(Icons.check_circle_outline,
                    size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
                SizedBox(width: AppSize.space8),
                AppText(
                    text: 'All stock levels healthy',
                    fontSize: AppSize.font10,
                    color: AppColors.textEmeraldGreen,
                    fontWeight: FontWeight.w600)
              ]),
            )
          else
            ...alerts.map((item) {
              final extraDetail = item.hasExpiringBatches &&
                      !item.isOutOfStock &&
                      !item.isLowStock
                  ? 'Batch expiring soon'
                  : '${item.currentStock.toStringAsFixed(0)} / ${item.totalInitialStock.toStringAsFixed(0)} ${item.unit}';
              return InvAlertCard(
                  name: item.name,
                  detail:
                      '${item.category} · ${item.activeBatchCount} active batch${item.activeBatchCount == 1 ? '' : 'es'}',
                  stockText:
                      '$extraDetail — ${item.isOutOfStock ? "Out of Stock" : item.isLowStock ? "Low Stock" : "Near Expiry"}',
                  isOut: item.isOutOfStock);
            }),
        ],
      );
    });
  }

  Widget _sidebarActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.timeline_rounded,
              size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
          const SizedBox(width: AppSize.space4),
          AppText(
              text: 'Recent Activity',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w800,
              color: context.txtPrimary),
        ]),
        const SizedBox(height: AppSize.space12),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ctrlInventory.activityLog
                .take(8)
                .map((entry) => InvActivityItem(entry: entry))
                .toList(),
          ),
        ),
      ],
    );
  }

  /// 💀🔥 ---------------- Product Type Highlight Colors ----------------
  Color _expandedBatchAccent(InventoryItem item) {
    if (item.listedIn.contains(ProductType.liveAuction) ||
        item.listedIn.contains(ProductType.auction)) {
      return AppColors.textPurple;
    }
    if (item.listedIn.contains(ProductType.advanceBooking) ||
        item.listedIn.contains(ProductType.booking)) {
      return AppColors.textInfo;
    }
    if (item.listedIn.contains(ProductType.marketplace)) {
      return AppColors.emeraldGreen;
    }
    return AppColors.textWarning;
  }

  /// 💀🔥 ---------------- Product Type Highlight Background ----------------
  Color _expandedBatchBg(InventoryItem item) =>
      _expandedBatchAccent(item).withValues(alpha: 0.06);
}
