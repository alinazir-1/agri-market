import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Data/Models/Customers Model/customer_activity_model.dart';
import '../../../Data/Models/Customers Model/customer_model.dart';
import '../../../Data/Models/product_type_enums.dart';

enum CustomerFilter { all, active, inactive, vip }

enum CustomerSort { latest, oldest, highestSpent, mostOrders }

class CustomersCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<CustomerFilter> filter = CustomerFilter.all.obs;
  final Rx<CustomerSort> sort = CustomerSort.latest.obs;

  // ── Data ──────────────────────────────────────────────────────────────────

  final RxList<CustomerModel> customers = <CustomerModel>[
    CustomerModel(
      id: 'C1',
      name: 'Ahmed Khan',
      email: 'ahmed@mail.com',
      location: 'Karachi, PK',
      avatarColor: const Color(0xFF0E7C66),
      status: CustomerStatus.active,
      primaryBuyType: ProductType.marketplace,
      totalOrders: 12,
      totalSpent: 4820,
      lastOrderDate: DateTime(2026, 3, 15),
    ),
    CustomerModel(
      id: 'C2',
      name: 'Sara Malik',
      email: 'sara@mail.com',
      location: 'Lahore, PK',
      avatarColor: const Color(0xFF7C3AED),
      status: CustomerStatus.vip,
      primaryBuyType: ProductType.liveAuction,
      totalOrders: 28,
      totalSpent: 18600,
      lastOrderDate: DateTime(2026, 3, 14),
    ),
    CustomerModel(
      id: 'C3',
      name: 'Ali Hassan',
      email: 'ali@mail.com',
      location: 'Dubai, UAE',
      avatarColor: const Color(0xFF0891B2),
      status: CustomerStatus.active,
      primaryBuyType: ProductType.advanceBooking,
      totalOrders: 7,
      totalSpent: 9240,
      lastOrderDate: DateTime(2026, 3, 12),
    ),
    CustomerModel(
      id: 'C4',
      name: 'Fatima Zahra',
      email: 'fatima@mail.com',
      location: 'Islamabad, PK',
      avatarColor: const Color(0xFFDC2626),
      status: CustomerStatus.inactive,
      primaryBuyType: ProductType.marketplace,
      totalOrders: 3,
      totalSpent: 1480,
      lastOrderDate: DateTime(2026, 1, 10),
    ),
    CustomerModel(
      id: 'C5',
      name: 'Usman Tariq',
      email: 'usman@mail.com',
      location: 'Multan, PK',
      avatarColor: const Color(0xFFD97706),
      status: CustomerStatus.vip,
      primaryBuyType: ProductType.liveAuction,
      totalOrders: 34,
      totalSpent: 24500,
      lastOrderDate: DateTime(2026, 3, 8),
    ),
    CustomerModel(
      id: 'C6',
      name: 'Zara Ahmed',
      email: 'zara@mail.com',
      location: 'Faisalabad, PK',
      avatarColor: const Color(0xFF059669),
      status: CustomerStatus.active,
      primaryBuyType: ProductType.marketplace,
      totalOrders: 5,
      totalSpent: 2200,
      lastOrderDate: DateTime(2026, 2, 20),
    ),
  ].obs;

  final RxList<CustomerActivity> activityLog = <CustomerActivity>[
    CustomerActivity(
        message: 'Ahmed Khan placed a new order — \$2,960',
        timeAgo: '2 hours ago',
        dotColor: const Color(0xFF0E7C66),
        type: CustomerActivityType.newOrder),
    CustomerActivity(
        message: 'Sara Malik won auction — Premium Soybean',
        timeAgo: '5 hours ago',
        dotColor: const Color(0xFF7C3AED),
        type: CustomerActivityType.auctionWon),
    CustomerActivity(
        message: 'Usman Tariq booked 40 Ton Mangoes',
        timeAgo: 'Yesterday',
        dotColor: const Color(0xFFD97706),
        type: CustomerActivityType.booking),
    CustomerActivity(
        message: 'Fatima Zahra account became inactive',
        timeAgo: '2 months ago',
        dotColor: const Color(0xFF9CA3AF),
        type: CustomerActivityType.inactive),
  ].obs;

  // ── Computed ──────────────────────────────────────────────────────────────

  int get totalCustomers => customers.length;
  int get activeCount =>
      customers.where((c) => c.status == CustomerStatus.active).length;
  int get vipCount =>
      customers.where((c) => c.status == CustomerStatus.vip).length;
  double get totalRevenue =>
      customers.fold(0.0, (sum, c) => sum + c.totalSpent);

  List<CustomerModel> get topCustomers {
    final list = List<CustomerModel>.from(customers);
    list.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    return list.take(3).toList();
  }

  List<CustomerModel> get filteredCustomers {
    List<CustomerModel> list = List.from(customers);

    // Filter
    switch (filter.value) {
      case CustomerFilter.active:
        list = list.where((c) => c.status == CustomerStatus.active).toList();
        break;
      case CustomerFilter.inactive:
        list = list.where((c) => c.status == CustomerStatus.inactive).toList();
        break;
      case CustomerFilter.vip:
        list = list.where((c) => c.status == CustomerStatus.vip).toList();
        break;
      case CustomerFilter.all:
        break;
    }

    // Search
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              c.email.toLowerCase().contains(q) ||
              c.location.toLowerCase().contains(q))
          .toList();
    }

    // Sort
    switch (sort.value) {
      case CustomerSort.latest:
        list.sort((a, b) => b.lastOrderDate.compareTo(a.lastOrderDate));
        break;
      case CustomerSort.oldest:
        list.sort((a, b) => a.lastOrderDate.compareTo(b.lastOrderDate));
        break;
      case CustomerSort.highestSpent:
        list.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
        break;
      case CustomerSort.mostOrders:
        list.sort((a, b) => b.totalOrders.compareTo(a.totalOrders));
        break;
    }

    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setFilter(CustomerFilter f) => filter.value = f;
  void setSort(CustomerSort s) => sort.value = s;
  void onSearch(String val) => searchQuery.value = val;

  void viewCustomer(CustomerModel customer) {
    // navigate to customer detail
  }

  void messageCustomer(CustomerModel customer) {
    // navigate to messages
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
