// lib/features/buyer/common/widgets/buyer_home_orders_con.dart
//
// Buyer-side procurement orders (dummy data). [OrderModel.buyerName] is used as
// **supplier** display for UI copy consistency with seller order rows.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/data/models/order_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';

class BuyerHomeOrdersCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxInt chipFilter = 0.obs;
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);
  final RxBool isLoading = false.obs;

  /// 0 All · 1 To pay · 2 In progress · 3 Shipped · 4 Delivered
  static const List<String> chipLabels = [
    'All',
    'To pay',
    'In progress',
    'Shipped',
    'Delivered',
  ];

  final RxList<OrderModel> allOrders = <OrderModel>[
    OrderModel(
      orderId: 'PO-2026-0142',
      productId: '1',
      productName: 'Sella Basmati Rice',
      productImage: AppImages.p1,
      productGrade: 'A',
      productType: ProductType.marketplace,
      buyerId: 'S001',
      buyerName: 'Al-Rehman Traders',
      buyerLocation: 'Sahiwal, PK',
      quantity: 25,
      unit: 'Ton',
      pricePerUnit: 1180,
      totalAmount: 29500,
      currency: 'PKR',
      orderStatus: OrderStatus.processing,
      orderPaymentStatus: OrderPaymentStatus.pending,
      orderDate: DateTime(2026, 4, 22),
      deliveryOption: 'Supplier delivers',
      deliveryAddress: 'Lahore warehouse, PK',
    ),
    OrderModel(
      orderId: 'PO-2026-0138',
      productId: '5',
      productName: 'Premium Soybean',
      productImage: AppImages.p5,
      productGrade: 'A',
      productType: ProductType.liveAuction,
      buyerId: 'S002',
      buyerName: 'Madinah Agro Supply',
      buyerLocation: 'Multan, PK',
      quantity: 12,
      unit: 'Ton',
      pricePerUnit: 2100,
      totalAmount: 25200,
      currency: 'PKR',
      orderStatus: OrderStatus.shipped,
      orderPaymentStatus: OrderPaymentStatus.paid,
      orderDate: DateTime(2026, 4, 20),
      estimatedDeliveryDate: DateTime(2026, 4, 28),
      deliveryOption: 'Supplier delivers',
      deliveryAddress: 'Karachi Port, PK',
    ),
    OrderModel(
      orderId: 'PO-2026-0121',
      productId: '4',
      productName: 'Fresh Mangoes',
      productImage: AppImages.p4,
      productGrade: 'B+',
      productType: ProductType.advanceBooking,
      buyerId: 'S003',
      buyerName: 'Sindh Pulse Hub',
      buyerLocation: 'Larkana, PK',
      quantity: 8,
      unit: 'Ton',
      pricePerUnit: 1650,
      totalAmount: 13200,
      currency: 'PKR',
      orderStatus: OrderStatus.pending,
      orderPaymentStatus: OrderPaymentStatus.pending,
      orderDate: DateTime(2026, 4, 18),
      deliveryOption: 'Pickup',
      deliveryAddress: 'Larkana cold storage, PK',
    ),
    OrderModel(
      orderId: 'PO-2026-0099',
      productId: '2',
      productName: 'Desiree Potato',
      productImage: AppImages.p2,
      productGrade: 'A',
      productType: ProductType.marketplace,
      buyerId: 'S004',
      buyerName: 'Pak Harvest Co.',
      buyerLocation: 'Gujranwala, PK',
      quantity: 15,
      unit: 'Ton',
      pricePerUnit: 920,
      totalAmount: 13800,
      currency: 'PKR',
      orderStatus: OrderStatus.delivered,
      orderPaymentStatus: OrderPaymentStatus.paid,
      orderDate: DateTime(2026, 4, 2),
      deliveryOption: 'Supplier delivers',
      deliveryAddress: 'Gujranwala, PK',
    ),
    OrderModel(
      orderId: 'PO-2026-0088',
      productId: '3',
      productName: 'Diamond Potato',
      productImage: AppImages.p3,
      productGrade: 'A',
      productType: ProductType.marketplace,
      buyerId: 'S005',
      buyerName: 'Green Valley Foods',
      buyerLocation: 'Islamabad, PK',
      quantity: 6,
      unit: 'Ton',
      pricePerUnit: 880,
      totalAmount: 5280,
      currency: 'PKR',
      orderStatus: OrderStatus.confirmed,
      orderPaymentStatus: OrderPaymentStatus.partial,
      orderDate: DateTime(2026, 3, 28),
      deliveryOption: 'Supplier delivers',
      deliveryAddress: 'Islamabad, PK',
    ),
    OrderModel(
      orderId: 'PO-2026-0075',
      productId: '6',
      productName: 'Yellow Maize',
      productImage: AppImages.p6,
      productGrade: 'A',
      productType: ProductType.marketplace,
      buyerId: 'S006',
      buyerName: 'Urban Organics',
      buyerLocation: 'Rawalpindi, PK',
      quantity: 20,
      unit: 'Ton',
      pricePerUnit: 750,
      totalAmount: 15000,
      currency: 'PKR',
      orderStatus: OrderStatus.cancelled,
      orderPaymentStatus: OrderPaymentStatus.pending,
      orderDate: DateTime(2026, 3, 10),
      deliveryOption: 'Supplier delivers',
      deliveryAddress: 'Rawalpindi, PK',
    ),
  ].obs;

  int get totalCount => allOrders.length;

  int get activeAttentionCount => allOrders
      .where((o) =>
          o.orderStatus == OrderStatus.pending ||
          o.orderStatus == OrderStatus.processing ||
          o.orderPaymentStatus == OrderPaymentStatus.pending)
      .length;

  int get inProgressCount => allOrders
      .where((o) =>
          o.orderStatus == OrderStatus.pending ||
          o.orderStatus == OrderStatus.confirmed ||
          o.orderStatus == OrderStatus.processing)
      .length;

  int get shippedCount =>
      allOrders.where((o) => o.orderStatus == OrderStatus.shipped).length;

  int get deliveredCount =>
      allOrders.where((o) => o.orderStatus == OrderStatus.delivered).length;

  List<OrderModel> get filteredOrders {
    var list = List<OrderModel>.from(allOrders);
    switch (chipFilter.value) {
      case 1:
        list = list
            .where((o) =>
                o.orderPaymentStatus == OrderPaymentStatus.pending ||
                o.orderPaymentStatus == OrderPaymentStatus.partial)
            .toList();
        break;
      case 2:
        list = list
            .where((o) =>
                o.orderStatus == OrderStatus.pending ||
                o.orderStatus == OrderStatus.confirmed ||
                o.orderStatus == OrderStatus.processing)
            .toList();
        break;
      case 3:
        list =
            list.where((o) => o.orderStatus == OrderStatus.shipped).toList();
        break;
      case 4:
        list =
            list.where((o) => o.orderStatus == OrderStatus.delivered).toList();
        break;
      default:
        break;
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((o) =>
              o.orderId.toLowerCase().contains(q) ||
              o.productName.toLowerCase().contains(q) ||
              o.buyerName.toLowerCase().contains(q))
          .toList();
    }
    list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return list;
  }

  void setChip(int i) {
    chipFilter.value = i.clamp(0, chipLabels.length - 1);
  }

  void onSearch(String v) => searchQuery.value = v;

  void selectOrder(OrderModel o) {
    selectedOrder.value =
        selectedOrder.value?.orderId == o.orderId ? null : o;
  }

  void clearSelection() => selectedOrder.value = null;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 160));
    isLoading.value = false;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
