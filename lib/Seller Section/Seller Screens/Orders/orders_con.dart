import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/images.dart';
import '../../../Data/Models/order_model.dart';
import '../../../Data/Models/product_type_enums.dart';

class OrdersCon extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────

  final RxInt selectedTab = 0.obs; // 0=All,1=Pending...6=Cancelled
  final RxString selectedTypeFilter = 'All Types'.obs;
  final RxString sortBy = 'Latest'.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // ── Orders Data ────────────────────────────────────────────────────────────

  final RxList<OrderModel> allOrders = <OrderModel>[
    OrderModel(
      orderId: 'ORD-2024-001',
      productId: '1',
      productName: 'Sella Basmati Rice',
      productImage: CImages.p1,
      productGrade: 'A',
      productType: ProductType.marketplace,
      buyerId: 'B001',
      buyerName: 'Ahmed Khan',
      buyerLocation: 'Karachi, PK',
      quantity: 20,
      unit: 'Ton',
      pricePerUnit: 148,
      totalAmount: 2960,
      currency: 'USD',
      orderStatus: OrderStatus.pending,
      orderPaymentStatus: OrderPaymentStatus.pending,
      orderDate: DateTime(2026, 3, 15),
      deliveryOption: 'Seller Delivers',
      deliveryAddress: 'Karachi Port, PK',
    ),
    OrderModel(
      orderId: 'ORD-2024-002',
      productId: '5',
      productName: 'Premium Soybean',
      productImage: CImages.p5,
      productGrade: 'A',
      productType: ProductType.liveAuction,
      buyerId: 'B002',
      buyerName: 'Sara Malik',
      buyerLocation: 'Lahore, PK',
      quantity: 50,
      unit: 'Ton',
      pricePerUnit: 148,
      totalAmount: 7400,
      currency: 'USD',
      orderStatus: OrderStatus.processing,
      orderPaymentStatus: OrderPaymentStatus.paid,
      orderDate: DateTime(2026, 3, 14),
      deliveryOption: 'Seller Delivers',
      deliveryAddress: 'Lahore Warehouse, PK',
    ),
    OrderModel(
      orderId: 'ORD-2024-003',
      productId: '4',
      productName: 'Fresh Mangoes',
      productImage: CImages.p4,
      productGrade: 'B+',
      productType: ProductType.advanceBooking,
      buyerId: 'B003',
      buyerName: 'Ali Hassan',
      buyerLocation: 'Dubai, UAE',
      quantity: 30,
      unit: 'Ton',
      pricePerUnit: 148,
      totalAmount: 4440,
      currency: 'USD',
      orderStatus: OrderStatus.shipped,
      orderPaymentStatus: OrderPaymentStatus.partial,
      orderDate: DateTime(2026, 3, 12),
      estimatedDeliveryDate: DateTime(2026, 3, 20),
      deliveryOption: 'Seller Delivers',
      deliveryAddress: 'Dubai Port, UAE',
    ),
    OrderModel(
      orderId: 'ORD-2024-004',
      productId: '2',
      productName: 'Desiree Potato',
      productImage: CImages.p2,
      productGrade: 'C',
      productType: ProductType.marketplace,
      buyerId: 'B004',
      buyerName: 'Fatima Zahra',
      buyerLocation: 'Islamabad, PK',
      quantity: 10,
      unit: 'Ton',
      pricePerUnit: 148,
      totalAmount: 1480,
      currency: 'USD',
      orderStatus: OrderStatus.delivered,
      orderPaymentStatus: OrderPaymentStatus.paid,
      orderDate: DateTime(2026, 3, 10),
      deliveryOption: 'Buyer Picks Up',
      deliveryAddress: 'Islamabad, PK',
    ),
    OrderModel(
      orderId: 'ORD-2024-005',
      productId: '3',
      productName: 'Diamond Potato',
      productImage: CImages.p3,
      productGrade: 'A',
      productType: ProductType.liveAuction,
      buyerId: 'B005',
      buyerName: 'Usman Tariq',
      buyerLocation: 'Multan, PK',
      quantity: 40,
      unit: 'Ton',
      pricePerUnit: 148,
      totalAmount: 5920,
      currency: 'USD',
      orderStatus: OrderStatus.confirmed,
      orderPaymentStatus: OrderPaymentStatus.paid,
      orderDate: DateTime(2026, 3, 8),
      deliveryOption: 'Seller Delivers',
      deliveryAddress: 'Multan, PK',
    ),
    OrderModel(
      orderId: 'ORD-2024-006',
      productId: '6',
      productName: 'Premium Soybean',
      productImage: CImages.p6,
      productGrade: 'A',
      productType: ProductType.marketplace,
      buyerId: 'B006',
      buyerName: 'Zara Ahmed',
      buyerLocation: 'Faisalabad, PK',
      quantity: 15,
      unit: 'Ton',
      pricePerUnit: 148,
      totalAmount: 2220,
      currency: 'USD',
      orderStatus: OrderStatus.cancelled,
      orderPaymentStatus: OrderPaymentStatus.pending,
      orderDate: DateTime(2026, 3, 5),
      deliveryOption: 'Buyer Picks Up',
      deliveryAddress: 'Faisalabad, PK',
    ),
  ].obs;

  // ── Sample Requests Data ───────────────────────────────────────────────────

  final RxList<SampleRequestModel> sampleRequests = <SampleRequestModel>[
    SampleRequestModel(
      sampleId: 'SMP-001',
      productId: '1',
      productName: 'Sella Basmati Rice',
      productImage: CImages.p1,
      buyerId: 'B001',
      buyerName: 'Ahmed Khan',
      buyerLocation: 'Karachi, PK',
      sampleQty: 2,
      sampleUnit: 'kg',
      samplePrice: 0,
      isDeliveryBySeller: true,
      status: SampleStatus.newRequest,
      requestDate: DateTime(2026, 3, 16),
    ),
    SampleRequestModel(
      sampleId: 'SMP-002',
      productId: '5',
      productName: 'Premium Soybean',
      productImage: CImages.p5,
      buyerId: 'B002',
      buyerName: 'Sara Malik',
      buyerLocation: 'Lahore, PK',
      sampleQty: 1,
      sampleUnit: 'kg',
      samplePrice: 5.0,
      isDeliveryBySeller: false,
      status: SampleStatus.accepted,
      requestDate: DateTime(2026, 3, 15),
    ),
    SampleRequestModel(
      sampleId: 'SMP-003',
      productId: '4',
      productName: 'Fresh Mangoes',
      productImage: CImages.p4,
      buyerId: 'B003',
      buyerName: 'Ali Hassan',
      buyerLocation: 'Dubai, UAE',
      sampleQty: 3,
      sampleUnit: 'box',
      samplePrice: 12.0,
      isDeliveryBySeller: true,
      status: SampleStatus.dispatched,
      requestDate: DateTime(2026, 3, 14),
    ),
    SampleRequestModel(
      sampleId: 'SMP-004',
      productId: '3',
      productName: 'Diamond Potato',
      productImage: CImages.p3,
      buyerId: 'B005',
      buyerName: 'Usman Tariq',
      buyerLocation: 'Multan, PK',
      sampleQty: 5,
      sampleUnit: 'kg',
      samplePrice: 0,
      isDeliveryBySeller: false,
      status: SampleStatus.newRequest,
      requestDate: DateTime(2026, 3, 13),
    ),
  ].obs;

  // ── Computed Stats ─────────────────────────────────────────────────────────

  int get totalOrders => allOrders.length;
  int get pendingOrders =>
      allOrders.where((o) => o.orderStatus == OrderStatus.pending).length;
  int get processingOrders =>
      allOrders.where((o) => o.orderStatus == OrderStatus.processing).length;
  int get newSamples =>
      sampleRequests.where((s) => s.status == SampleStatus.newRequest).length;

  double get monthRevenue => allOrders
      .where((o) => o.orderPaymentStatus == OrderPaymentStatus.paid)
      .fold(0.0, (sum, o) => sum + o.totalAmount);

  int countByStatus(OrderStatus s) =>
      allOrders.where((o) => o.orderStatus == s).length;

  // ── Filtered Orders ────────────────────────────────────────────────────────

  List<OrderModel> get filteredOrders {
    List<OrderModel> list = List.from(allOrders);

    // Tab filter
    final tabs = [
      null,
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];
    if (selectedTab.value != 0) {
      list =
          list.where((o) => o.orderStatus == tabs[selectedTab.value]).toList();
    }

    // Type filter
    if (selectedTypeFilter.value == 'Marketplace') {
      list =
          list.where((o) => o.productType == ProductType.marketplace).toList();
    } else if (selectedTypeFilter.value == 'Live Auction') {
      list =
          list.where((o) => o.productType == ProductType.liveAuction).toList();
    } else if (selectedTypeFilter.value == 'Advance Booking') {
      list = list
          .where((o) => o.productType == ProductType.advanceBooking)
          .toList();
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where(
            (o) =>
                o.orderId.toLowerCase().contains(q) ||
                o.productName.toLowerCase().contains(q) ||
                o.buyerName.toLowerCase().contains(q),
          )
          .toList();
    }

    // Sort
    if (sortBy.value == 'Latest') {
      list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    } else if (sortBy.value == 'Oldest') {
      list.sort((a, b) => a.orderDate.compareTo(b.orderDate));
    } else if (sortBy.value == 'Amount High') {
      list.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    }

    return list;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final i = allOrders.indexWhere((o) => o.orderId == orderId);
    if (i == -1) return;
    final old = allOrders[i];
    allOrders[i] = OrderModel(
      orderId: old.orderId,
      productId: old.productId,
      productName: old.productName,
      productImage: old.productImage,
      productGrade: old.productGrade,
      productType: old.productType,
      buyerId: old.buyerId,
      buyerName: old.buyerName,
      buyerLocation: old.buyerLocation,
      quantity: old.quantity,
      unit: old.unit,
      pricePerUnit: old.pricePerUnit,
      totalAmount: old.totalAmount,
      currency: old.currency,
      orderStatus: newStatus,
      orderPaymentStatus: old.orderPaymentStatus,
      orderDate: old.orderDate,
      estimatedDeliveryDate: old.estimatedDeliveryDate,
      deliveryOption: old.deliveryOption,
      deliveryAddress: old.deliveryAddress,
    );
  }

  void updateSampleStatus(String sampleId, SampleStatus newStatus) {
    final i = sampleRequests.indexWhere((s) => s.sampleId == sampleId);
    if (i == -1) return;
    final old = sampleRequests[i];
    sampleRequests[i] = SampleRequestModel(
      sampleId: old.sampleId,
      productId: old.productId,
      productName: old.productName,
      productImage: old.productImage,
      buyerId: old.buyerId,
      buyerName: old.buyerName,
      buyerLocation: old.buyerLocation,
      sampleQty: old.sampleQty,
      sampleUnit: old.sampleUnit,
      samplePrice: old.samplePrice,
      isDeliveryBySeller: old.isDeliveryBySeller,
      status: newStatus,
      requestDate: old.requestDate,
    );
  }

  void selectTab(int index) => selectedTab.value = index;
  void selectTypeFilter(String type) => selectedTypeFilter.value = type;
  void selectSort(String sort) => sortBy.value = sort;
  void onSearch(String val) => searchQuery.value = val;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
