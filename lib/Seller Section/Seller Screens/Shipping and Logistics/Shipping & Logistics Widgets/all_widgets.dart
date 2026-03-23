import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/Shipping & Logistics Model/delivery_partner_model.dart';
import '../../../../Data/Models/Shipping & Logistics Model/shipping_model.dart';

class ShippingCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<ShippingFilter> selectedFilter = ShippingFilter.all.obs;
  final Rx<ShippingSort> selectedSort = ShippingSort.latest.obs;
  final Rx<ShippingTab> activeTab = ShippingTab.shipments.obs;

  // ── Shipments ─────────────────────────────────────────────────────────────

  final RxList<ShipmentModel> shipments = <ShipmentModel>[
    ShipmentModel(
      id: 'S1',
      orderId: 'ORD-0892',
      buyerName: 'Sara Malik',
      buyerLocation: 'Lahore, PK',
      avatarColor: const Color(0xFF7C3AED),
      productName: 'Sella Basmati Rice',
      quantity: '200',
      unit: 'Ton',
      deliveryMethod: DeliveryMethod.self,
      partnerName: 'TCS Express',
      trackingNumber: 'TRK-8847291',
      status: ShipmentStatus.inTransit,
      orderDate: DateTime(2026, 3, 15),
      estimatedDelivery: DateTime(2026, 3, 22),
    ),
    ShipmentModel(
      id: 'S2',
      orderId: 'ORD-0889',
      buyerName: 'Ahmed Khan',
      buyerLocation: 'Karachi, PK',
      avatarColor: const Color(0xFF0E7C66),
      productName: 'Desiree Potato',
      quantity: '100',
      unit: 'Ton',
      deliveryMethod: DeliveryMethod.thirdParty,
      partnerName: 'Leopards',
      trackingNumber: 'TRK-7741023',
      status: ShipmentStatus.delivered,
      orderDate: DateTime(2026, 3, 10),
      estimatedDelivery: DateTime(2026, 3, 18),
    ),
    ShipmentModel(
      id: 'S3',
      orderId: 'ORD-0891',
      buyerName: 'Usman Tariq',
      buyerLocation: 'Multan, PK',
      avatarColor: const Color(0xFFD97706),
      productName: 'Premium Soybean',
      quantity: '150',
      unit: 'Ton',
      deliveryMethod: DeliveryMethod.self,
      partnerName: null,
      trackingNumber: null,
      status: ShipmentStatus.pending,
      orderDate: DateTime(2026, 3, 8),
      estimatedDelivery: DateTime(2026, 3, 22),
      isDelayed: true,
      delayReason: 'Dispatch overdue by 2 days',
    ),
    ShipmentModel(
      id: 'S4',
      orderId: 'ORD-0890',
      buyerName: 'Ali Hassan',
      buyerLocation: 'Dubai, UAE',
      avatarColor: const Color(0xFF0891B2),
      productName: 'Fresh Mangoes',
      quantity: '50',
      unit: 'box',
      deliveryMethod: DeliveryMethod.thirdParty,
      partnerName: 'DHL Logistics',
      trackingNumber: 'TRK-9923481',
      status: ShipmentStatus.shipped,
      orderDate: DateTime(2026, 3, 12),
      estimatedDelivery: DateTime(2026, 3, 24),
    ),
    ShipmentModel(
      id: 'S5',
      orderId: 'ORD-0886',
      buyerName: 'Zara Ahmed',
      buyerLocation: 'Faisalabad, PK',
      avatarColor: const Color(0xFF059669),
      productName: 'Apple',
      quantity: '30',
      unit: 'Ton',
      deliveryMethod: DeliveryMethod.thirdParty,
      partnerName: 'TCS Express',
      trackingNumber: 'TRK-6612093',
      status: ShipmentStatus.inTransit,
      orderDate: DateTime(2026, 2, 20),
      estimatedDelivery: DateTime(2026, 3, 19),
      isDelayed: true,
      delayReason: 'In transit — 1 day delayed',
    ),
    ShipmentModel(
      id: 'S6',
      orderId: 'ORD-0884',
      buyerName: 'Ali Hassan',
      buyerLocation: 'Dubai, UAE',
      avatarColor: const Color(0xFF0891B2),
      productName: 'Fresh Mangoes',
      quantity: '50',
      unit: 'box',
      deliveryMethod: DeliveryMethod.thirdParty,
      partnerName: 'DHL Logistics',
      trackingNumber: 'TRK-5519284',
      status: ShipmentStatus.inTransit,
      orderDate: DateTime(2026, 2, 15),
      estimatedDelivery: DateTime(2026, 2, 22),
      isDelayed: true,
      delayReason: 'Customs hold — 3 days',
    ),
    ShipmentModel(
      id: 'S7',
      orderId: 'ORD-0885',
      buyerName: 'Fatima Zahra',
      buyerLocation: 'Islamabad, PK',
      avatarColor: const Color(0xFFDC2626),
      productName: 'Desiree Potato',
      quantity: '20',
      unit: 'Ton',
      deliveryMethod: DeliveryMethod.buyerPickup,
      partnerName: null,
      trackingNumber: null,
      status: ShipmentStatus.cancelled,
      orderDate: DateTime(2026, 1, 10),
    ),
  ].obs;

  // ── Delivery Partners ─────────────────────────────────────────────────────

  final RxList<DeliveryPartnerModel> partners = <DeliveryPartnerModel>[
    DeliveryPartnerModel(
      id: 'P1',
      name: 'TCS Express',
      emoji: '🚚',
      logoBg: const Color(0xFFFFF3CD),
      type: PartnerType.domestic,
      status: PartnerStatus.active,
      totalShipments: 24,
      onTimePercent: 98,
      rating: 4.8,
      coverage: 'Pakistan · All cities',
    ),
    DeliveryPartnerModel(
      id: 'P2',
      name: 'Leopards Courier',
      emoji: '🐆',
      logoBg: const Color(0xFFFCE7F3),
      type: PartnerType.domestic,
      status: PartnerStatus.active,
      totalShipments: 18,
      onTimePercent: 94,
      rating: 4.5,
      coverage: 'Pakistan · Major cities',
    ),
    DeliveryPartnerModel(
      id: 'P3',
      name: 'DHL Logistics',
      emoji: '✈️',
      logoBg: const Color(0xFFFEF9C3),
      type: PartnerType.freight,
      status: PartnerStatus.active,
      totalShipments: 8,
      onTimePercent: 100,
      rating: 4.9,
      coverage: 'International · UAE, Kenya, UK',
    ),
    DeliveryPartnerModel(
      id: 'P4',
      name: 'M&P Courier',
      emoji: '📦',
      logoBg: const Color(0xFFF3F4F6),
      type: PartnerType.domestic,
      status: PartnerStatus.inactive,
      totalShipments: 6,
      onTimePercent: 88,
      rating: 3.9,
      coverage: 'Pakistan · Selected cities',
    ),
  ].obs;

  // ── Computed Stats ────────────────────────────────────────────────────────

  int get totalShipments => shipments.length;
  int get inTransitCount =>
      shipments.where((s) => s.status == ShipmentStatus.inTransit).length;
  int get deliveredCount =>
      shipments.where((s) => s.status == ShipmentStatus.delivered).length;
  int get delayedCount => shipments.where((s) => s.isDelayed).length;
  int get cancelledCount =>
      shipments.where((s) => s.status == ShipmentStatus.cancelled).length;

  List<ShipmentModel> get delayedShipments =>
      shipments.where((s) => s.isDelayed).toList();

  // ── Filtered Shipments ────────────────────────────────────────────────────

  List<ShipmentModel> get filteredShipments {
    List<ShipmentModel> list = List.from(shipments);

    switch (selectedFilter.value) {
      case ShippingFilter.pending:
        list = list.where((s) => s.status == ShipmentStatus.pending).toList();
        break;
      case ShippingFilter.processing:
        list =
            list.where((s) => s.status == ShipmentStatus.processing).toList();
        break;
      case ShippingFilter.shipped:
        list = list.where((s) => s.status == ShipmentStatus.shipped).toList();
        break;
      case ShippingFilter.inTransit:
        list = list.where((s) => s.status == ShipmentStatus.inTransit).toList();
        break;
      case ShippingFilter.delivered:
        list = list.where((s) => s.status == ShipmentStatus.delivered).toList();
        break;
      case ShippingFilter.cancelled:
        list = list.where((s) => s.status == ShipmentStatus.cancelled).toList();
        break;
      case ShippingFilter.all:
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((s) =>
              s.buyerName.toLowerCase().contains(q) ||
              s.orderId.toLowerCase().contains(q) ||
              s.productName.toLowerCase().contains(q) ||
              (s.trackingNumber?.toLowerCase().contains(q) ?? false) ||
              (s.partnerName?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    switch (selectedSort.value) {
      case ShippingSort.latest:
        list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        break;
      case ShippingSort.oldest:
        list.sort((a, b) => a.orderDate.compareTo(b.orderDate));
        break;
      case ShippingSort.deliverySoon:
        list.sort((a, b) {
          if (a.estimatedDelivery == null) return 1;
          if (b.estimatedDelivery == null) return -1;
          return a.estimatedDelivery!.compareTo(b.estimatedDelivery!);
        });
        break;
      case ShippingSort.deliveryLate:
        list.sort((a, b) {
          if (a.estimatedDelivery == null) return 1;
          if (b.estimatedDelivery == null) return -1;
          return b.estimatedDelivery!.compareTo(a.estimatedDelivery!);
        });
        break;
    }

    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setTab(ShippingTab t) => activeTab.value = t;
  void setFilter(ShippingFilter f) => selectedFilter.value = f;
  void setSort(ShippingSort s) => selectedSort.value = s;
  void onSearch(String val) => searchQuery.value = val;

  void markAsDispatched(String id) {
    final idx = shipments.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    shipments[idx] = shipments[idx].copyWith(
      status: ShipmentStatus.shipped,
      isDelayed: false,
    );
  }

  void trackShipment(ShipmentModel shipment) {
    // navigate to tracking detail
  }

  void togglePartnerStatus(String partnerId) {
    final idx = partners.indexWhere((p) => p.id == partnerId);
    if (idx == -1) return;
    final old = partners[idx];
    partners[idx] = DeliveryPartnerModel(
      id: old.id,
      name: old.name,
      emoji: old.emoji,
      logoBg: old.logoBg,
      type: old.type,
      status: old.status == PartnerStatus.active
          ? PartnerStatus.inactive
          : PartnerStatus.active,
      totalShipments: old.totalShipments,
      onTimePercent: old.onTimePercent,
      rating: old.rating,
      coverage: old.coverage,
    );
  }

  void addPartner() {
    // navigate to add partner screen
  }

  void assignPartnerToOrder(DeliveryPartnerModel partner) {
    // show order selection dialog
  }

  void viewPartnerDetails(DeliveryPartnerModel partner) {
    // navigate to partner detail screen
  }

  String deliveryMethodLabel(DeliveryMethod m) {
    switch (m) {
      case DeliveryMethod.self:
        return 'Self';
      case DeliveryMethod.thirdParty:
        return '3rd Party';
      case DeliveryMethod.buyerPickup:
        return 'Pickup';
    }
  }

  String formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: shipping_widgets.dart  — Reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

// ── 1. Shipping Stat Card ─────────────────────────────────────────────────────

class ShipStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeText;
  final Color valueColor;

  const ShipStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.badge,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeText,
    this.valueColor = CColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CSize.space12),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
            color: const Color(0xFFE2E8F0), width: CSize.borderWidth1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(CSize.radius10Medium)),
            child: Icon(icon, size: CSize.icon16Small, color: iconColor),
          ),
          const SizedBox(height: CSize.space8),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: valueColor)),
          const SizedBox(height: CSize.space2),
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: CColors.textSecondary,
                  letterSpacing: 0.3)),
          const SizedBox(height: CSize.space5),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: 2),
            decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(CSize.radius20Large)),
            child: Text(badge,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: badgeText)),
          ),
        ],
      ),
    );
  }
}

// ── 2. Shipment Status Pill ───────────────────────────────────────────────────

class ShipStatusPill extends StatelessWidget {
  final ShipmentStatus status;
  const ShipStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;
    switch (status) {
      case ShipmentStatus.pending:
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFF9A3412);
        label = 'Pending';
        break;
      case ShipmentStatus.processing:
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF1E40AF);
        label = 'Processing';
        break;
      case ShipmentStatus.shipped:
        bg = const Color(0xFFFEF9C3);
        text = const Color(0xFF854D0E);
        label = 'Shipped';
        break;
      case ShipmentStatus.inTransit:
        bg = const Color(0xFFE0F2FE);
        text = const Color(0xFF0369A1);
        label = 'In Transit';
        break;
      case ShipmentStatus.delivered:
        bg = CColors.backgroundEmerald100;
        text = CColors.textEmeraldGreen;
        label = 'Delivered';
        break;
      case ShipmentStatus.cancelled:
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFF991B1B);
        label = 'Cancelled';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space8, vertical: CSize.space2),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Text(label,
          style:
              TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: text)),
    );
  }
}

// ── 3. Shipment Progress Bar ──────────────────────────────────────────────────

class ShipmentProgressBar extends StatelessWidget {
  final int currentStep;
  const ShipmentProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        if (i.isEven) {
          final stepIdx = i ~/ 2;
          final isDone = stepIdx <= currentStep;
          final isNext = stepIdx == currentStep + 1;
          return Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isDone
                  ? CColors.backGroundEmeraldGreen
                  : CColors.backGroundWhite,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone || isNext
                    ? CColors.borderEmeraldGreen
                    : const Color(0xFFE2E8F0),
                width: CSize.borderWidth1,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded,
                    size: 9, color: CColors.iconWhite)
                : isNext
                    ? Center(
                        child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                color: CColors.backGroundEmeraldGreen,
                                shape: BoxShape.circle)))
                    : const SizedBox.shrink(),
          );
        } else {
          final lineIdx = i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: lineIdx < currentStep
                    ? CColors.backGroundEmeraldGreen
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          );
        }
      }),
    );
  }
}

// ── 4. Shipping Filter Chip ───────────────────────────────────────────────────

class ShipFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? activeBorder;
  final Color? inactiveBorder;
  final Color? inactiveText;

  const ShipFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.activeBorder,
    this.inactiveBorder,
    this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isActive
        ? (activeColor ?? CColors.backGroundEmeraldGreen)
        : CColors.backGroundWhite;
    final Color border = isActive
        ? (activeBorder ?? CColors.borderEmeraldGreen)
        : (inactiveBorder ?? const Color(0xFFE2E8F0));
    final Color text =
        isActive ? CColors.textWhite : (inactiveText ?? CColors.textSecondary);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12, vertical: CSize.space4),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(CSize.radius20Large),
            border: Border.all(color: border)),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: text)),
      ),
    );
  }
}

// ── 5. Delayed Shipment Card ──────────────────────────────────────────────────

class DelayedShipCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback onAction;

  const DelayedShipCard(
      {super.key, required this.shipment, required this.onAction});

  String get _actionLabel => shipment.status == ShipmentStatus.pending
      ? 'Mark as Dispatched'
      : 'Contact Courier';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
            color: const Color(0xFFFED7AA), width: CSize.borderWidth1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('#${shipment.orderId} · ${shipment.buyerName}',
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: CColors.textPrimary)),
          const SizedBox(height: 2),
          Text(
              '${shipment.productName} · ${shipment.quantity} ${shipment.unit}',
              style:
                  const TextStyle(fontSize: 9, color: CColors.textSecondary)),
          const SizedBox(height: CSize.space4),
          Text(shipment.delayReason ?? 'Delayed',
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9A3412))),
          const SizedBox(height: CSize.space8),
          GestureDetector(
            onTap: onAction,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: CSize.space5),
              decoration: BoxDecoration(
                  color: CColors.backGroundEmeraldGreen,
                  borderRadius: BorderRadius.circular(CSize.radius5Small)),
              alignment: Alignment.center,
              child: Text(_actionLabel,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: CColors.textWhite)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 6. Buyer Avatar ───────────────────────────────────────────────────────────

class ShipBuyerAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  const ShipBuyerAvatar(
      {super.key, required this.initials, required this.color, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(initials,
          style: TextStyle(
              fontSize: size * 0.33,
              fontWeight: FontWeight.w800,
              color: CColors.textWhite)),
    );
  }
}

// ── 7. Delivery Partner Card ──────────────────────────────────────────────────

class DeliveryPartnerCard extends StatelessWidget {
  final DeliveryPartnerModel partner;
  final VoidCallback onAssign;
  final VoidCallback onViewDetails;
  final VoidCallback onToggleStatus;

  const DeliveryPartnerCard({
    super.key,
    required this.partner,
    required this.onAssign,
    required this.onViewDetails,
    required this.onToggleStatus,
  });

  bool get _isActive => partner.status == PartnerStatus.active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CSize.space16),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color:
              _isActive ? CColors.borderEmeraldGreen : const Color(0xFFE2E8F0),
          width: _isActive ? CSize.borderWidth1 : CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row — logo + name + badge
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: partner.logoBg,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium)),
                alignment: Alignment.center,
                child:
                    Text(partner.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: CSize.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(partner.name,
                        style: const TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w800,
                            color: CColors.textPrimary)),
                    Text(partner.typeLabel,
                        style: const TextStyle(
                            fontSize: 10, color: CColors.textSecondary)),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space8, vertical: 2),
                decoration: BoxDecoration(
                  color: _isActive
                      ? CColors.backgroundEmerald100
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                ),
                child: Text(
                  _isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: _isActive
                        ? CColors.textEmeraldGreen
                        : CColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: CSize.space12),

          // Stats row
          Row(
            children: [
              Expanded(
                  child: _statItem('${partner.totalShipments}', 'Shipments',
                      CColors.textPrimary)),
              Expanded(
                  child: _statItem(
                      '${partner.onTimePercent.toStringAsFixed(0)}%',
                      'On Time',
                      CColors.textEmeraldGreen)),
              Expanded(
                  child: _statItem(partner.rating.toStringAsFixed(1), 'Rating',
                      const Color(0xFF1D4ED8))),
            ],
          ),

          const SizedBox(height: CSize.space10),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFF1F5F9)),
          const SizedBox(height: CSize.space10),

          // Coverage
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: CSize.font10XSmall, color: CColors.textSecondary),
              const SizedBox(width: CSize.space4),
              Expanded(
                child: Text(partner.coverage,
                    style: const TextStyle(
                        fontSize: 10, color: CColors.textSecondary)),
              ),
            ],
          ),

          const SizedBox(height: CSize.space10),

          // Action buttons
          Row(
            children: _isActive
                ? [
                    Expanded(child: _primaryBtn('Assign to Order', onAssign)),
                    const SizedBox(width: CSize.space8),
                    Expanded(
                        child: _secondaryBtn('View Details', onViewDetails)),
                  ]
                : [
                    Expanded(child: _secondaryBtn('Activate', onToggleStatus)),
                    const SizedBox(width: CSize.space8),
                    Expanded(child: _secondaryBtn('Remove', () {})),
                  ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: CSize.font16Medium,
                fontWeight: FontWeight.w800,
                color: valueColor)),
        Text(label,
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: CColors.textSecondary,
                letterSpacing: 0.3)),
      ],
    );
  }

  Widget _primaryBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: CSize.space8),
        decoration: BoxDecoration(
            color: CColors.backGroundEmeraldGreen,
            borderRadius: BorderRadius.circular(CSize.radius10Medium)),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: CColors.textWhite)),
      ),
    );
  }

  Widget _secondaryBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: CSize.space8),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(
              color: const Color(0xFFE2E8F0), width: CSize.borderWidth1),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CColors.textPrimary)),
      ),
    );
  }
}
