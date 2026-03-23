import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Data/Models/payment_model.dart';
import '../../../Data/Models/product_type_enums.dart';

class PaymentsCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<PaymentFilter> selectedFilter = PaymentFilter.all.obs;
  final Rx<PaymentSort> selectedSort = PaymentSort.latest.obs;

  // ── Payments Data ─────────────────────────────────────────────────────────

  final RxList<PaymentModel> payments = <PaymentModel>[
    PaymentModel(
      id: 'PAY1',
      orderId: 'ORD-0892',
      buyerId: 'C2',
      buyerName: 'Sara Malik',
      buyerEmail: 'sara@mail.com',
      avatarColor: const Color(0xFF7C3AED),
      productName: 'Sella Basmati Rice',
      quantity: '200',
      unit: 'Ton',
      productType: ProductType.marketplace,
      amount: 29600,
      status: PaymentStatus.paid,
      date: DateTime(2026, 3, 15),
    ),
    PaymentModel(
      id: 'PAY2',
      orderId: 'ORD-0891',
      buyerId: 'C5',
      buyerName: 'Usman Tariq',
      buyerEmail: 'usman@mail.com',
      avatarColor: const Color(0xFFD97706),
      productName: 'Premium Soybean',
      quantity: '150',
      unit: 'Ton',
      productType: ProductType.liveAuction,
      amount: 11200,
      status: PaymentStatus.pending,
      date: DateTime(2026, 3, 8),
      dueDate: DateTime(2026, 3, 22),
    ),
    PaymentModel(
      id: 'PAY3',
      orderId: 'ORD-0890',
      buyerId: 'C3',
      buyerName: 'Ali Hassan',
      buyerEmail: 'ali@mail.com',
      avatarColor: const Color(0xFF0891B2),
      productName: 'Fresh Mangoes',
      quantity: '50',
      unit: 'box',
      productType: ProductType.advanceBooking,
      amount: 3000,
      status: PaymentStatus.partial,
      date: DateTime(2026, 3, 12),
      dueDate: DateTime(2026, 3, 28),
    ),
    PaymentModel(
      id: 'PAY4',
      orderId: 'ORD-0889',
      buyerId: 'C1',
      buyerName: 'Ahmed Khan',
      buyerEmail: 'ahmed@mail.com',
      avatarColor: const Color(0xFF0E7C66),
      productName: 'Desiree Potato',
      quantity: '100',
      unit: 'Ton',
      productType: ProductType.marketplace,
      amount: 9500,
      status: PaymentStatus.paid,
      date: DateTime(2026, 3, 10),
    ),
    PaymentModel(
      id: 'PAY5',
      orderId: 'ORD-0888',
      buyerId: 'C4',
      buyerName: 'Fatima Zahra',
      buyerEmail: 'fatima@mail.com',
      avatarColor: const Color(0xFFDC2626),
      productName: 'Desiree Potato',
      quantity: '20',
      unit: 'Ton',
      productType: ProductType.marketplace,
      amount: 1400,
      status: PaymentStatus.failed,
      date: DateTime(2026, 1, 10),
    ),
    PaymentModel(
      id: 'PAY6',
      orderId: 'ORD-0887',
      buyerId: 'C6',
      buyerName: 'Zara Ahmed',
      buyerEmail: 'zara@mail.com',
      avatarColor: const Color(0xFF059669),
      productName: 'Apple',
      quantity: '30',
      unit: 'Ton',
      productType: ProductType.marketplace,
      amount: 4440,
      status: PaymentStatus.pending,
      date: DateTime(2026, 2, 20),
      dueDate: DateTime(2026, 3, 25),
    ),
  ].obs;

  // ── Monthly Revenue ───────────────────────────────────────────────────────

  final List<MonthlyRevenue> monthlyRevenue = const [
    MonthlyRevenue(month: 'Oct', amount: 18000, isCurrent: false),
    MonthlyRevenue(month: 'Nov', amount: 22000, isCurrent: false),
    MonthlyRevenue(month: 'Dec', amount: 14000, isCurrent: false),
    MonthlyRevenue(month: 'Jan', amount: 26000, isCurrent: false),
    MonthlyRevenue(month: 'Feb', amount: 20000, isCurrent: false),
    MonthlyRevenue(month: 'Mar', amount: 28400, isCurrent: true),
  ];

  // ── Computed Stats ────────────────────────────────────────────────────────

  double get totalRevenue => payments
      .where((p) => p.status == PaymentStatus.paid)
      .fold(0.0, (sum, p) => sum + p.amount);

  double get thisMonthRevenue => payments
      .where((p) =>
          p.status == PaymentStatus.paid &&
          p.date.month == DateTime.now().month &&
          p.date.year == DateTime.now().year)
      .fold(0.0, (sum, p) => sum + p.amount);

  double get pendingAmount => payments
      .where((p) =>
          p.status == PaymentStatus.pending ||
          p.status == PaymentStatus.partial)
      .fold(0.0, (sum, p) => sum + p.amount);

  double get failedAmount => payments
      .where((p) => p.status == PaymentStatus.failed)
      .fold(0.0, (sum, p) => sum + p.amount);

  int get pendingCount => payments
      .where((p) =>
          p.status == PaymentStatus.pending ||
          p.status == PaymentStatus.partial)
      .length;

  int get failedCount =>
      payments.where((p) => p.status == PaymentStatus.failed).length;

  double get maxMonthlyRevenue =>
      monthlyRevenue.map((m) => m.amount).reduce((a, b) => a > b ? a : b);

  List<PaymentModel> get pendingPayments => payments
      .where((p) =>
          p.status == PaymentStatus.pending ||
          p.status == PaymentStatus.partial)
      .toList();

  // ── Filtered List ─────────────────────────────────────────────────────────

  List<PaymentModel> get filteredPayments {
    List<PaymentModel> list = List.from(payments);

    switch (selectedFilter.value) {
      case PaymentFilter.paid:
        list = list.where((p) => p.status == PaymentStatus.paid).toList();
        break;
      case PaymentFilter.pending:
        list = list.where((p) => p.status == PaymentStatus.pending).toList();
        break;
      case PaymentFilter.partial:
        list = list.where((p) => p.status == PaymentStatus.partial).toList();
        break;
      case PaymentFilter.failed:
        list = list.where((p) => p.status == PaymentStatus.failed).toList();
        break;
      case PaymentFilter.all:
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((p) =>
              p.buyerName.toLowerCase().contains(q) ||
              p.orderId.toLowerCase().contains(q) ||
              p.productName.toLowerCase().contains(q))
          .toList();
    }

    switch (selectedSort.value) {
      case PaymentSort.latest:
        list.sort((a, b) => b.date.compareTo(a.date));
        break;
      case PaymentSort.oldest:
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case PaymentSort.highestAmount:
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case PaymentSort.lowestAmount:
        list.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setFilter(PaymentFilter f) => selectedFilter.value = f;
  void setSort(PaymentSort s) => selectedSort.value = s;
  void onSearch(String val) => searchQuery.value = val;

  void sendReminder(PaymentModel payment) {
    // send reminder logic — connect to messaging/email when backend ready
    Get.snackbar(
      'Reminder Sent',
      'Payment reminder sent to ${payment.buyerName}',
      backgroundColor: CColors.backgroundEmerald100,
      colorText: CColors.textEmeraldGreen,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void viewPayment(PaymentModel payment) {
    // navigate to payment detail screen
  }

  String formatAmount(double amount) {
    if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}k';
    }
    return '\$${amount.toStringAsFixed(0)}';
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
