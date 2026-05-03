import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/shipping_model.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import 'package:agri_market/features/seller/shipping/shipping_con.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:agri_market/features/seller/shipping/widgets/shipping_widgets.dart';

import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';

class ShippingScr extends StatelessWidget {
  final ShippingCon ctrlShipping = Get.put(ShippingCon(), permanent: true);

  ShippingScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            ScreenTopBar(
              title: 'Shipping & Logistics',
              subtitle: 'Manage shipments and delivery partners',
              searchController: ctrlShipping.searchController,
              onSearch: ctrlShipping.onSearch,
              searchHint: 'Search orders, tracking...',
              searchWidth: 300,
            ),
            _TabBar(ctrlShipping: ctrlShipping),
            Expanded(
              child: Obx(() =>
                  ctrlShipping.activeTab.value == ShippingTab.shipments
                      ? _ShipmentsTab(ctrlShipping: ctrlShipping)
                      : _PartnersTab(ctrlShipping: ctrlShipping)),
            ),
          ],
        ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TAB BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final ShippingCon ctrlShipping;
  const _TabBar({required this.ctrlShipping});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      border: Border(bottom: BorderSide(color: context.borderClr)),
      padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
      child: Obx(
        () => Row(
          children: [
            _tabItem('📦  Shipments', ShippingTab.shipments, context),
            _tabItem('🚚  Delivery Partners', ShippingTab.deliveryPartners,
                context),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String label, ShippingTab tab, BuildContext context) {
    final isActive = ctrlShipping.activeTab.value == tab;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ctrlShipping.setTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8,
              vertical: AppSize.space12), // mapped 4 to 8
          margin: const EdgeInsets.only(right: AppSize.space20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? AppColors.borderEmeraldGreen
                    : AppColors.backGroundTransparent,
                width: AppSize.borderWidth2,
              ),
            ),
          ),
          child: AppText(
            text: label,
            fontSize: AppSize.font12, // mapped 13 to 12
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.textEmeraldGreen : context.txtSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHIPMENTS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _ShipmentsTab extends StatelessWidget {
  final ShippingCon ctrlShipping;
  const _ShipmentsTab({required this.ctrlShipping});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }

  Widget _summaryCards(BuildContext context) {
    return Obx(
      () => SellerMetricStatRow(
        items: [
          SellerMetricStatItem(
            label: 'TOTAL SHIPMENTS',
            value: '${ctrlShipping.totalShipments}',
            badge: 'All time',
            icon: Icons.local_shipping_outlined,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.badgeSuccessText,
          ),
          SellerMetricStatItem(
            label: 'IN TRANSIT',
            value: '${ctrlShipping.inTransitCount}',
            badge: 'On the way',
            icon: Icons.directions_bus_outlined,
            iconBg: AppColors.badgeInfoBg,
            iconColor: AppColors.badgeInfoText,
            valueColor: AppColors.badgeInfoText,
          ),
          SellerMetricStatItem(
            label: 'DELIVERED',
            value: '${ctrlShipping.deliveredCount}',
            badge: 'Completed',
            icon: Icons.check_circle_outline_rounded,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.iconEmeraldGreen,
          ),
          SellerMetricStatItem(
            label: 'DELAYED',
            value: '${ctrlShipping.delayedCount}',
            badge: 'Needs attention',
            icon: Icons.schedule_rounded,
            iconBg: AppColors.badgeWarningBg,
            iconColor: AppColors.badgeWarningText,
            valueColor: AppColors.badgeWarningText,
          ),
        ],
      ),
    );
  }

  Widget _tableSection(BuildContext context) {
    return AppContainer(
      border: Border(right: BorderSide(color: context.borderClr)),
      child: Column(
        children: [
          _tableHeader(context),
          Expanded(child: _tableBody(context)),
        ],
      ),
    );
  }

  Widget _tableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSize.space20, AppSize.space12,
          AppSize.space20, AppSize.space12), // mapped 14 to 12
      child: Row(
        children: [
          Obx(() => Wrap(
                spacing: AppSize.space4, // mapped 5 to 4
                children: [
                  ShipFilterChip(
                      label: 'All',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.all,
                      onTap: () => ctrlShipping.setFilter(ShippingFilter.all)),
                  ShipFilterChip(
                      label: 'Pending',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.pending,
                      onTap: () =>
                          ctrlShipping.setFilter(ShippingFilter.pending),
                      activeColor:
                          AppColors.textWarning, // mapped backGroundOrange
                      activeBorder: AppColors.textWarning,
                      inactiveBorder:
                          AppColors.badgeWarningBg, // mapped 0xFFFED7AA
                      inactiveText: AppColors.textWarning),
                  ShipFilterChip(
                      label: 'Processing',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.processing,
                      onTap: () =>
                          ctrlShipping.setFilter(ShippingFilter.processing),
                      activeColor: AppColors.textInfo, // mapped 0xFF1D4ED8
                      activeBorder: AppColors.textInfo,
                      inactiveBorder:
                          AppColors.badgeInfoBg, // mapped 0xFFDBEAFE
                      inactiveText: AppColors.textInfo),
                  ShipFilterChip(
                      label: 'Shipped',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.shipped,
                      onTap: () =>
                          ctrlShipping.setFilter(ShippingFilter.shipped),
                      activeColor: AppColors.textPurple, // mapped 0xFFCA8A04
                      activeBorder: AppColors.textPurple,
                      inactiveBorder:
                          AppColors.badgePurpleBg, // mapped 0xFFFEF9C3
                      inactiveText: AppColors.textPurple),
                  ShipFilterChip(
                      label: 'In Transit',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.inTransit,
                      onTap: () =>
                          ctrlShipping.setFilter(ShippingFilter.inTransit),
                      activeColor: AppColors.textInfo, // mapped 0xFF0369A1
                      activeBorder: AppColors.textInfo,
                      inactiveBorder:
                          AppColors.badgeInfoBg, // mapped 0xFFE0F2FE
                      inactiveText: AppColors.textInfo),
                  ShipFilterChip(
                      label: 'Delivered',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.delivered,
                      onTap: () =>
                          ctrlShipping.setFilter(ShippingFilter.delivered)),
                  ShipFilterChip(
                      label: 'Cancelled',
                      isActive: ctrlShipping.selectedFilter.value ==
                          ShippingFilter.cancelled,
                      onTap: () =>
                          ctrlShipping.setFilter(ShippingFilter.cancelled),
                      activeColor: AppColors.borderError,
                      activeBorder: AppColors.borderError,
                      inactiveBorder:
                          AppColors.badgeErrorBg, // mapped 0xFFFCA5A5
                      inactiveText: AppColors.textRichRed),
                ],
              )),
          const Spacer(),
          Obx(() => AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space12,
                    vertical: AppSize.space4), // mapped 5 to 4
                backgroundColor: context.cardBg,
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
                border: Border.all(color: context.borderClr),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ShippingSort>(
                    value: ctrlShipping.selectedSort.value,
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
                          value: ShippingSort.latest,
                          child: AppText(text: 'Latest')),
                      DropdownMenuItem(
                          value: ShippingSort.oldest,
                          child: AppText(text: 'Oldest')),
                      DropdownMenuItem(
                          value: ShippingSort.deliverySoon,
                          child: AppText(text: 'Delivery: Soonest')),
                      DropdownMenuItem(
                          value: ShippingSort.deliveryLate,
                          child: AppText(text: 'Delivery: Latest')),
                    ],
                    onChanged: (val) =>
                        ctrlShipping.setSort(val ?? ShippingSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  static const Map<int, TableColumnWidth> _colWidths = {
    0: FlexColumnWidth(1.4),
    1: FlexColumnWidth(1.8),
    2: FlexColumnWidth(2),
    3: FlexColumnWidth(1.6),
    4: FlexColumnWidth(1.4),
    5: FlexColumnWidth(2.4),
    6: FlexColumnWidth(1.2),
    7: FlexColumnWidth(1.4),
    8: FlexColumnWidth(1.8),
  };

  static const List<String> _headers = [
    'Order',
    'Buyer',
    'Product',
    'Partner',
    'Tracking',
    'Progress',
    'Status',
    'Est. Delivery',
    'Actions',
  ];

  Widget _tableBody(BuildContext context) {
    return Obx(() {
      if (ctrlShipping.isLoading.value) {
        return const AppSkeletonListColumn();
      }
      final list = ctrlShipping.filteredShipments;
      if (list.isEmpty) {
        return const AppEmptyListState(
          message: 'No shipments found',
          icon: Icons.local_shipping_outlined,
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
        child: Table(
          columnWidths: _colWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(color: context.cardBg2),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12), // mapped 10 to 12
                        child: AppText(
                            text: h.toUpperCase(),
                            fontSize: AppSize.font8, // mapped 9 to 8
                            fontWeight: FontWeight.w800,
                            color: context.txtSecondary,
                            letterSpacing: 0.5),
                      ))
                  .toList(),
            ),
            ...list.map((s) => _buildRow(s, context)),
          ],
        ),
      );
    });
  }

  TableRow _buildRow(ShipmentModel s, BuildContext context) {
    final bool isDelayed = s.isDelayed && s.estimatedDelivery != null;
    return TableRow(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: context.dividerClr, width: AppSize.borderWidth05))),
      children: [
        // Order
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppText(
                  text: '#${s.orderId}',
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary),
              AppText(
                  text: ctrlShipping.formatDate(s.orderDate),
                  fontSize: AppSize.font8,
                  color: context.txtSecondary),
            ])),

        // Buyer
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: Row(children: [
              ShipBuyerAvatar(initials: s.initials, avatarHex: s.avatarHex),
              const SizedBox(width: AppSize.space8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    AppText(
                        text: s.buyerName,
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    AppText(
                        text: s.buyerLocation,
                        fontSize: AppSize.font8,
                        color: context.txtSecondary), // mapped 9 to 8
                  ])),
            ])),

        // Product
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppText(
                  text: s.productName,
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: context.txtPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              AppText(
                  text: '${s.quantity} ${s.unit}',
                  fontSize: AppSize.font8,
                  color: context.txtSecondary),
            ])),

        // Partner
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: s.partnerName != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        AppText(
                            text: s.partnerName!,
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textEmeraldGreen,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        AppText(
                            text: ctrlShipping
                                .deliveryMethodLabel(s.deliveryMethod),
                            fontSize: AppSize.font8,
                            color: context.txtSecondary), // mapped 9 to 8
                      ])
                : AppText(
                    text: 'Not assigned',
                    fontSize: AppSize.font10,
                    color: context.txtSecondary)),

        // Tracking
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: s.trackingNumber != null
                ? AppText(
                    text: s.trackingNumber!,
                    fontSize: AppSize.font8, // mapped 9 to 8
                    fontWeight: FontWeight.w700,
                    color: AppColors.textEmeraldGreen)
                : AppText(
                    text: '—',
                    fontSize: AppSize.font10,
                    color: context.txtSecondary)),

        // Progress
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: ShipmentProgressBar(currentStep: s.progressStep)),

        // Status
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: ShipStatusPill(status: s.status)),

        // Est. Delivery
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: s.estimatedDelivery != null
                ? Row(children: [
                    AppText(
                        text: ctrlShipping.formatDate(s.estimatedDelivery!),
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w600,
                        color: isDelayed
                            ? AppColors.textWarning
                            : context.txtPrimary),
                    if (isDelayed) ...[
                      const SizedBox(width: AppSize.space4), // mapped 3 to 4
                      const Icon(Icons.warning_amber_rounded,
                          size: AppSize.icon12,
                          color: AppColors.textWarning), // mapped 11 to 12
                    ],
                  ])
                : AppText(
                    text: '—',
                    fontSize: AppSize.font10,
                    color: context.txtSecondary)),

        // Actions
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space12),
            child: Wrap(spacing: AppSize.space4, children: [
              if (s.status != ShipmentStatus.cancelled &&
                  s.status != ShipmentStatus.pending)
                Obx(
                  () => _actionBtn(
                    context,
                    label: 'Track',
                    textColor: AppColors.textEmeraldGreen,
                    borderColor: AppColors.badgeSuccessBg,
                    isLoading: ctrlShipping.isShipmentRowActionLoading(
                        s.id, 'track'),
                    onTap: () => ctrlShipping.trackShipmentRow(s.id),
                  ),
                ),
              if (s.status == ShipmentStatus.pending)
                Obx(
                  () => _actionBtn(
                    context,
                    label: 'Dispatch',
                    textColor: AppColors.textEmeraldGreen,
                    borderColor: AppColors.badgeSuccessBg,
                    isLoading: ctrlShipping.isShipmentRowActionLoading(
                        s.id, 'dispatch'),
                    onTap: () => ctrlShipping.dispatchShipmentRow(s.id),
                  ),
                ),
              if (s.status != ShipmentStatus.delivered &&
                  s.status != ShipmentStatus.cancelled)
                Obx(
                  () => _actionBtn(
                    context,
                    label: 'Update',
                    textColor: context.txtSecondary,
                    borderColor: AppColors.borderLight,
                    isLoading: ctrlShipping.isShipmentRowActionLoading(
                        s.id, 'update'),
                    onTap: () => ctrlShipping.updateShipmentRowStub(s.id),
                  ),
                ),
            ])),
      ],
    );
  }

  Widget _actionBtn(
    BuildContext context, {
    required String label,
    required Color textColor,
    required Color borderColor,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AppContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space4),
          backgroundColor: context.cardBg,
          borderRadius: BorderRadius.circular(AppSize.radius4), // mapped 5 to 4
          border: Border.all(color: borderColor, width: AppSize.borderWidth1),
          alignment: Alignment.center,
          child: isLoading
              ? const AppInlineProgress()
              : AppText(
                  text: label,
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: textColor),
        ),
      ),
    );
  }

  Widget _sidebar(BuildContext context) {
    return SizedBox(
      width: 280.0, // Fixed Sidebar width mapping
      child: Obx(() {
        if (ctrlShipping.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(AppSize.space16),
            child: AppSkeletonListColumn(itemCount: 3),
          );
        }
        final delayed = ctrlShipping.delayedShipments;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSize.space16), // mapped 14 to 16
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.access_time_rounded,
                  size: AppSize.icon16, color: AppColors.textWarning),
              const SizedBox(width: AppSize.space4), // mapped 5 to 4
              AppText(
                  text: 'Delayed Shipments',
                  fontSize: AppSize.font12, // mapped 11 to 12
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary),
              const SizedBox(width: AppSize.space4),
              if (delayed.isNotEmpty)
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8, vertical: 2),
                  backgroundColor:
                      AppColors.badgeWarningBg, // mapped 0xFFFFF7ED
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: AppText(
                      text: '${delayed.length}',
                      fontSize: AppSize.font8, // mapped 9 to 8
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWarning), // mapped 0xFF9A3412
                ),
            ]),
            const SizedBox(height: AppSize.space12), // mapped 10 to 12
            if (delayed.isEmpty)
              AppContainer(
                padding: const EdgeInsets.all(AppSize.space12),
                backgroundColor:
                    AppColors.badgeSuccessBg, // mapped backgroundEmerald100
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
                child: const Row(children: [
                  Icon(Icons.check_circle_outline,
                      size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
                  SizedBox(width: AppSize.space8),
                  AppText(
                      text: 'All shipments on time!',
                      fontSize: AppSize.font10,
                      color: AppColors.textEmeraldGreen,
                      fontWeight: FontWeight.w600),
                ]),
              )
            else
              ...delayed.map(
                (s) => Obx(
                  () => DelayedShipCard(
                    shipment: s,
                    isActionLoading: ctrlShipping.isShipmentRowActionLoading(
                        s.id, 'delayed'),
                    onAction: () =>
                        ctrlShipping.delayedSidebarShipmentAction(s),
                  ),
                ),
              ),
          ]),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PARTNERS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _PartnersTab extends StatelessWidget {
  final ShippingCon ctrlShipping;
  const _PartnersTab({required this.ctrlShipping});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrlShipping.isLoading.value) {
        return const SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.space20),
          child: AppCardGridSkeleton(
            crossAxisCount: 3,
            childAspectRatio: 1.3,
            itemCount: 6,
          ),
        );
      }
      return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSize.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                          text: 'Delivery Partners',
                          fontSize: AppSize.font16,
                          fontWeight: FontWeight.w800,
                          color: context.txtPrimary),
                      const SizedBox(height: AppSize.space4), // mapped 2 to 4
                      AppText(
                          text: 'Manage your courier and logistics partners',
                          fontSize: AppSize.font10,
                          color: context.txtSecondary),
                    ],
                  ),
                  const Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: ctrlShipping.addPartner,
                      child: AppContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space16,
                            vertical: AppSize.space8), // mapped 14 to 16
                        backgroundColor: AppColors.emeraldGreen,
                        borderRadius: BorderRadius.circular(
                            AppSize.radius12), // mapped 10 to 12
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add_rounded,
                                  size: AppSize.icon16,
                                  color: AppColors.iconWhite),
                              SizedBox(width: AppSize.space4), // mapped 5 to 4
                              AppText(
                                  text: 'Add Partner',
                                  fontSize: AppSize.font10, // mapped 11 to 10
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textWhite),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSize.space16),

              // Partners grid
              if (ctrlShipping.partners.isEmpty)
                const AppEmptyListState(
                  message: 'No delivery partners',
                  icon: Icons.local_shipping_outlined,
                )
              else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ctrlShipping.partners.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSize.space16, // mapped 14 to 16
                  mainAxisSpacing: AppSize.space16,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final partner = ctrlShipping.partners[index];
                  return DeliveryPartnerCard(
                    partner: partner,
                    onAssign: () => ctrlShipping.assignPartnerToOrder(partner),
                    onViewDetails: () =>
                        ctrlShipping.viewPartnerDetails(partner),
                    onToggleStatus: () =>
                        ctrlShipping.togglePartnerStatus(partner.id),
                  );
                },
              ),
            ],
          ),
        );
    });
  }
}
