import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Data/Models/Shipping & Logistics Model/shipping_model.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'Shipping & Logistics Widgets/all_widgets.dart';

class ShippingScr extends StatelessWidget {
  final ShippingCon shippingController = Get.put(ShippingCon());

  ShippingScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenTopBar(
              title: 'Shipping & Logistics',
              subtitle: 'Manage shipments and delivery partners',
              searchController: shippingController.searchController,
              onSearch: shippingController.onSearch,
              searchHint: 'Search orders, tracking...',
              searchWidth: 300,
            ),
            _TabBar(shippingController: shippingController),
            Expanded(
              child: Obx(() =>
                  shippingController.activeTab.value == ShippingTab.shipments
                      ? _ShipmentsTab(shippingController: shippingController)
                      : _PartnersTab(shippingController: shippingController)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: shipping_tab_bar.dart
// ─────────────────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final ShippingCon shippingController;
  const _TabBar({required this.shippingController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: context.cardBg,
            border: Border(bottom: BorderSide(color: context.borderClr)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
          child: Row(
            children: [
              _tabItem('📦  Shipments', ShippingTab.shipments, context),
              _tabItem('🚚  Delivery Partners', ShippingTab.deliveryPartners, context),
            ],
          ),
        ));
  }

  Widget _tabItem(String label, ShippingTab tab, BuildContext context) {
    final isActive = shippingController.activeTab.value == tab;
    return GestureDetector(
      onTap: () => shippingController.setTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space4, vertical: CSize.space12),
        margin: const EdgeInsets.only(right: CSize.space20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? CColors.borderEmeraldGreen : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: CSize.font13Small,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? CColors.textEmeraldGreen : context.txtSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: shipping_shipments_tab.dart
// ─────────────────────────────────────────────────────────────────────────────

class _ShipmentsTab extends StatelessWidget {
  final ShippingCon shippingController;
  const _ShipmentsTab({required this.shippingController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _summaryCards(context),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showSidebar = constraints.maxWidth >= 700;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _tableSection(context)),
                  if (showSidebar) _sidebar(context),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryCards(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: context.cardBg2,
            border: Border(bottom: BorderSide(color: context.borderClr)),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space20, vertical: CSize.space14),
          child: Row(children: [
            Expanded(
                child: ShipStatCard(
                    label: 'Total Shipments',
                    value: '${shippingController.totalShipments}',
                    badge: 'All time',
                    icon: Icons.local_shipping_outlined,
                    iconBg: CColors.backgroundEmerald100,
                    iconColor: CColors.iconEmeraldGreen,
                    badgeBg: CColors.backgroundEmerald100,
                    badgeText: CColors.textEmeraldGreen)),
            const SizedBox(width: CSize.space12),
            Expanded(
                child: ShipStatCard(
                    label: 'In Transit',
                    value: '${shippingController.inTransitCount}',
                    badge: 'On the way',
                    icon: Icons.directions_bus_outlined,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0369A1),
                    badgeBg: const Color(0xFFE0F2FE),
                    badgeText: const Color(0xFF0369A1),
                    valueColor: const Color(0xFF0369A1))),
            const SizedBox(width: CSize.space12),
            Expanded(
                child: ShipStatCard(
                    label: 'Delivered',
                    value: '${shippingController.deliveredCount}',
                    badge: 'Completed',
                    icon: Icons.check_circle_outline_rounded,
                    iconBg: CColors.backgroundEmerald100,
                    iconColor: CColors.iconEmeraldGreen,
                    badgeBg: CColors.backgroundEmerald100,
                    badgeText: CColors.textEmeraldGreen)),
            const SizedBox(width: CSize.space12),
            Expanded(
                child: ShipStatCard(
                    label: 'Delayed',
                    value: '${shippingController.delayedCount}',
                    badge: 'Needs attention',
                    icon: Icons.access_time_rounded,
                    iconBg: const Color(0xFFFFF7ED),
                    iconColor: CColors.backGroundOrange,
                    badgeBg: const Color(0xFFFFF7ED),
                    badgeText: CColors.textOrange,
                    valueColor: CColors.backGroundOrange)),
            const SizedBox(width: CSize.space12),
            Expanded(
                child: ShipStatCard(
                    label: 'Cancelled',
                    value: '${shippingController.cancelledCount}',
                    badge: 'Returned',
                    icon: Icons.cancel_outlined,
                    iconBg: const Color(0xFFFEE2E2),
                    iconColor: CColors.iconError,
                    badgeBg: const Color(0xFFFEE2E2),
                    badgeText: CColors.textError,
                    valueColor: CColors.textError)),
          ]),
        ));
  }

  Widget _tableSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: context.borderClr)),
      ),
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
      padding: const EdgeInsets.fromLTRB(
          CSize.space20, CSize.space14, CSize.space20, CSize.space12),
      child: Row(
        children: [
          Text('Shipments',
              style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary)),
          const SizedBox(width: CSize.space12),
          Obx(() => Wrap(
                spacing: CSize.space5,
                children: [
                  ShipFilterChip(
                      label: 'All',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.all,
                      onTap: () =>
                          shippingController.setFilter(ShippingFilter.all)),
                  ShipFilterChip(
                      label: 'Pending',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.pending,
                      onTap: () =>
                          shippingController.setFilter(ShippingFilter.pending),
                      activeColor: CColors.backGroundOrange,
                      activeBorder: CColors.backGroundOrange,
                      inactiveBorder: const Color(0xFFFED7AA),
                      inactiveText: CColors.textOrange),
                  ShipFilterChip(
                      label: 'Processing',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.processing,
                      onTap: () => shippingController
                          .setFilter(ShippingFilter.processing),
                      activeColor: const Color(0xFF1D4ED8),
                      activeBorder: const Color(0xFF1D4ED8),
                      inactiveBorder: const Color(0xFFDBEAFE),
                      inactiveText: const Color(0xFF1E40AF)),
                  ShipFilterChip(
                      label: 'Shipped',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.shipped,
                      onTap: () =>
                          shippingController.setFilter(ShippingFilter.shipped),
                      activeColor: const Color(0xFFCA8A04),
                      activeBorder: const Color(0xFFCA8A04),
                      inactiveBorder: const Color(0xFFFEF9C3),
                      inactiveText: const Color(0xFF854D0E)),
                  ShipFilterChip(
                      label: 'In Transit',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.inTransit,
                      onTap: () => shippingController
                          .setFilter(ShippingFilter.inTransit),
                      activeColor: const Color(0xFF0369A1),
                      activeBorder: const Color(0xFF0369A1),
                      inactiveBorder: const Color(0xFFE0F2FE),
                      inactiveText: const Color(0xFF0369A1)),
                  ShipFilterChip(
                      label: 'Delivered',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.delivered,
                      onTap: () => shippingController
                          .setFilter(ShippingFilter.delivered)),
                  ShipFilterChip(
                      label: 'Cancelled',
                      isActive: shippingController.selectedFilter.value ==
                          ShippingFilter.cancelled,
                      onTap: () => shippingController
                          .setFilter(ShippingFilter.cancelled),
                      activeColor: CColors.borderError,
                      activeBorder: CColors.borderError,
                      inactiveBorder: const Color(0xFFFCA5A5),
                      inactiveText: CColors.textRichRed),
                ],
              )),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space12, vertical: CSize.space5),
                decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    border: Border.all(color: context.borderClr)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ShippingSort>(
                    value: shippingController.selectedSort.value,
                    isDense: true,
                    style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        size: CSize.icon16Small,
                        color: CColors.iconEmeraldGreen),
                    items: const [
                      DropdownMenuItem(
                          value: ShippingSort.latest, child: Text('Latest')),
                      DropdownMenuItem(
                          value: ShippingSort.oldest, child: Text('Oldest')),
                      DropdownMenuItem(
                          value: ShippingSort.deliverySoon,
                          child: Text('Delivery: Soonest')),
                      DropdownMenuItem(
                          value: ShippingSort.deliveryLate,
                          child: Text('Delivery: Latest')),
                    ],
                    onChanged: (val) =>
                        shippingController.setSort(val ?? ShippingSort.latest),
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
      final list = shippingController.filteredShipments;
      if (list.isEmpty) {
        return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.local_shipping_outlined,
              size: CSize.icon36XLarge, color: context.txtSecondary),
          const SizedBox(height: CSize.space12),
          Text('No shipments found',
              style: TextStyle(
                  fontSize: CSize.font13Small, color: context.txtSecondary)),
        ]));
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
        child: Table(
          columnWidths: _colWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(color: context.cardBg2),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CSize.space8, vertical: CSize.space10),
                        child: Text(h.toUpperCase(),
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: context.txtSecondary,
                                letterSpacing: 0.5)),
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
              bottom: BorderSide(color: context.dividerClr, width: 0.5))),
      children: [
        // Order
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('#${s.orderId}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: context.txtPrimary)),
              Text(shippingController.formatDate(s.orderDate),
                  style: TextStyle(
                      fontSize: 9, color: context.txtSecondary)),
            ])),

        // Buyer
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: Row(children: [
              ShipBuyerAvatar(initials: s.initials, color: s.avatarColor),
              const SizedBox(width: CSize.space8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(s.buyerName,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(s.buyerLocation,
                        style: TextStyle(
                            fontSize: 9, color: context.txtSecondary)),
                  ])),
            ])),

        // Product
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.productName,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: context.txtPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text('${s.quantity} ${s.unit}',
                  style: TextStyle(
                      fontSize: 9, color: context.txtSecondary)),
            ])),

        // Partner
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: s.partnerName != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(s.partnerName!,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: CColors.textEmeraldGreen),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(
                            shippingController
                                .deliveryMethodLabel(s.deliveryMethod),
                            style: TextStyle(
                                fontSize: 9, color: context.txtSecondary)),
                      ])
                : Text('Not assigned',
                    style: TextStyle(
                        fontSize: 10, color: context.txtSecondary))),

        // Tracking
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: s.trackingNumber != null
                ? Text(s.trackingNumber!,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: CColors.textEmeraldGreen))
                : Text('—',
                    style: TextStyle(
                        fontSize: 10, color: context.txtSecondary))),

        // Progress
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space12),
            child: ShipmentProgressBar(currentStep: s.progressStep)),

        // Status
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: ShipStatusPill(status: s.status)),

        // Est. Delivery
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: s.estimatedDelivery != null
                ? Row(children: [
                    Text(shippingController.formatDate(s.estimatedDelivery!),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDelayed
                                ? CColors.backGroundOrange
                                : context.txtPrimary)),
                    if (isDelayed) ...[
                      const SizedBox(width: 3),
                      const Icon(Icons.warning_amber_rounded,
                          size: 11, color: CColors.backGroundOrange)
                    ],
                  ])
                : Text('—',
                    style: TextStyle(
                        fontSize: 10, color: context.txtSecondary))),

        // Actions
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space10),
            child: Wrap(spacing: CSize.space4, children: [
              if (s.status != ShipmentStatus.cancelled &&
                  s.status != ShipmentStatus.pending)
                _actionBtn(
                    'Track',
                    CColors.textEmeraldGreen,
                    const Color(0xFFBBF7D0),
                    () => shippingController.trackShipment(s),
                    context),
              if (s.status == ShipmentStatus.pending)
                _actionBtn(
                    'Dispatch',
                    CColors.textEmeraldGreen,
                    const Color(0xFFBBF7D0),
                    () => shippingController.markAsDispatched(s.id),
                    context),
              if (s.status != ShipmentStatus.delivered &&
                  s.status != ShipmentStatus.cancelled)
                _actionBtn('Update', context.txtSecondary,
                    const Color(0xFFE2E8F0), () {}, context),
            ])),
      ],
    );
  }

  Widget _actionBtn(
      String label, Color textColor, Color borderColor, VoidCallback onTap,
      BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space8, vertical: CSize.space4),
        decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(CSize.radius5Small),
            border: Border.all(color: borderColor, width: CSize.borderWidth1)),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
      ),
    );
  }

  Widget _sidebar(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Obx(() {
        final delayed = shippingController.delayedShipments;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(CSize.space14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.access_time_rounded,
                  size: CSize.icon16Small, color: CColors.backGroundOrange),
              const SizedBox(width: CSize.space5),
              Text('Delayed Shipments',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: context.txtPrimary)),
              const SizedBox(width: CSize.space5),
              if (delayed.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(CSize.radius20Large)),
                  child: Text('${delayed.length}',
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9A3412))),
                ),
            ]),
            const SizedBox(height: CSize.space10),
            if (delayed.isEmpty)
              Container(
                padding: const EdgeInsets.all(CSize.space12),
                decoration: BoxDecoration(
                    color: CColors.backgroundEmerald100,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium)),
                child: const Row(children: [
                  Icon(Icons.check_circle_outline,
                      size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                  SizedBox(width: CSize.space8),
                  Text('All shipments on time!',
                      style: TextStyle(
                          fontSize: 10,
                          color: CColors.textEmeraldGreen,
                          fontWeight: FontWeight.w600)),
                ]),
              )
            else
              ...delayed.map((s) => DelayedShipCard(
                    shipment: s,
                    onAction: () => s.status == ShipmentStatus.pending
                        ? shippingController.markAsDispatched(s.id)
                        : shippingController.trackShipment(s),
                  )),
          ]),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: shipping_partners_tab.dart
// ─────────────────────────────────────────────────────────────────────────────

class _PartnersTab extends StatelessWidget {
  final ShippingCon shippingController;
  const _PartnersTab({required this.shippingController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(CSize.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery Partners',
                          style: TextStyle(
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w800,
                              color: context.txtPrimary)),
                      const SizedBox(height: CSize.space2),
                      Text('Manage your courier and logistics partners',
                          style: TextStyle(
                              fontSize: CSize.font10XSmall,
                              color: context.txtSecondary)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: shippingController.addPartner,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space14, vertical: CSize.space8),
                      decoration: BoxDecoration(
                          color: CColors.backGroundEmeraldGreen,
                          borderRadius:
                              BorderRadius.circular(CSize.radius10Medium)),
                      child:
                          Row(mainAxisSize: MainAxisSize.min, children: const [
                        Icon(Icons.add_rounded,
                            size: CSize.icon16Small, color: CColors.iconWhite),
                        SizedBox(width: CSize.space5),
                        Text('Add Partner',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: CColors.textWhite)),
                      ]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: CSize.space16),

              // Partners grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shippingController.partners.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: CSize.space14,
                  mainAxisSpacing: CSize.space14,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final partner = shippingController.partners[index];
                  return DeliveryPartnerCard(
                    partner: partner,
                    onAssign: () =>
                        shippingController.assignPartnerToOrder(partner),
                    onViewDetails: () =>
                        shippingController.viewPartnerDetails(partner),
                    onToggleStatus: () =>
                        shippingController.togglePartnerStatus(partner.id),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
