import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Data/Models/Shipping & Logistics Model/delivery_partner_model.dart';
import '../../../Data/Models/Shipping & Logistics Model/shipping_model.dart';

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
