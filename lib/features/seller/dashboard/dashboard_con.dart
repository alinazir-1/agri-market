// lib/features/seller/dashboard/dashboard_con.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/routes/app_routes.dart';

// ── Stat Card Model ───────────────────────────────────────────────────────────
class DashStat {
  final String label;
  final String value;
  final String trend;
  final bool isPositive;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const DashStat({
    required this.label,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

// ── Recent Order Model ────────────────────────────────────────────────────────
class DashOrder {
  final String id;
  final String buyer;
  final String product;
  final String amount;
  final String date;
  final String status;
  final Color statusBg;
  final Color statusColor;

  const DashOrder({
    required this.id,
    required this.buyer,
    required this.product,
    required this.amount,
    required this.date,
    required this.status,
    required this.statusBg,
    required this.statusColor,
  });
}

// ── Top Product Model ─────────────────────────────────────────────────────────
class DashTopProduct {
  final String name;
  final String category;
  final String revenue;
  final String units;
  final double progress;
  final Color progressColor;

  const DashTopProduct({
    required this.name,
    required this.category,
    required this.revenue,
    required this.units,
    required this.progress,
    required this.progressColor,
  });
}

// ── Activity Model ────────────────────────────────────────────────────────────
class DashActivity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const DashActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

// ── Quick Action Model ────────────────────────────────────────────────────────
class DashQuickAction {
  final String label;
  final IconData icon;
  /// Used with [SellerSideBarCon.changeScreen] when [namedRoute] is null.
  final int screenIndex;
  /// When set, opens this route instead of switching embedded sidebar index.
  final String? namedRoute;

  const DashQuickAction({
    required this.label,
    required this.icon,
    this.screenIndex = 0,
    this.namedRoute,
  });
}

// ── Controller ────────────────────────────────────────────────────────────────
class DashboardCon extends GetxController {
  // ── Revenue Chart ─────────────────────────────────────────────────────────
  final List<double> revenueMonthly = const [
    18200,
    21500,
    19800,
    22400,
    20100,
    24580
  ];
  final List<String> revenueLabels = const [
    'Oct',
    'Nov',
    'Dec',
    'Jan',
    'Feb',
    'Mar'
  ];

  // ── Stats ─────────────────────────────────────────────────────────────────
  final List<DashStat> stats = const [
    DashStat(
      label: 'TOTAL REVENUE',
      value: '\$24,580',
      trend: '+12.5% this month',
      isPositive: true,
      icon: Icons.attach_money_rounded,
      iconBg: AppColors.badgeSuccessBg,
      iconColor: AppColors.iconEmeraldGreen,
    ),
    DashStat(
      label: 'TOTAL ORDERS',
      value: '1,247',
      trend: '+8.3% this month',
      isPositive: true,
      icon: Icons.shopping_bag_outlined,
      iconBg: AppColors.badgeInfoBg,
      iconColor: AppColors.badgeInfoText,
    ),
    DashStat(
      label: 'ACTIVE PRODUCTS',
      value: '89',
      trend: '+3 new this week',
      isPositive: true,
      icon: Icons.inventory_2_outlined,
      iconBg: AppColors.badgeWarningBg,
      iconColor: AppColors.badgeWarningText,
    ),
    DashStat(
      label: 'TOTAL CUSTOMERS',
      value: '2,156',
      trend: '+45 new this month',
      isPositive: true,
      icon: Icons.people_alt_outlined,
      iconBg: AppColors.badgePurpleBg, // Manual add instructed
      iconColor: AppColors.badgePurpleText, // Manual add instructed
    ),
  ];

  // ── Recent Orders ─────────────────────────────────────────────────────────
  final List<DashOrder> recentOrders = const [
    DashOrder(
      id: '#ORD-4821',
      buyer: 'Ahmed Khan',
      product: 'Organic Wheat (500kg)',
      amount: '\$1,240',
      date: 'Mar 25, 2026',
      status: 'Delivered',
      statusBg: AppColors.badgeSuccessBg,
      statusColor: AppColors.badgeSuccessText,
    ),
    DashOrder(
      id: '#ORD-4820',
      buyer: 'Sara Malik',
      product: 'Premium Rice (200kg)',
      amount: '\$580',
      date: 'Mar 24, 2026',
      status: 'Processing',
      statusBg: AppColors.badgeInfoBg,
      statusColor: AppColors.badgeInfoText,
    ),
    DashOrder(
      id: '#ORD-4819',
      buyer: 'Usman Ali',
      product: 'Fresh Vegetables Box',
      amount: '\$320',
      date: 'Mar 24, 2026',
      status: 'Shipped',
      statusBg: AppColors.badgeWarningBg,
      statusColor: AppColors.badgeWarningText,
    ),
    DashOrder(
      id: '#ORD-4818',
      buyer: 'Fatima Raza',
      product: 'Mango (100kg)',
      amount: '\$450',
      date: 'Mar 23, 2026',
      status: 'Pending',
      statusBg: AppColors.badgeErrorBg,
      statusColor: AppColors.badgeErrorText,
    ),
    DashOrder(
      id: '#ORD-4817',
      buyer: 'Bilal Hussain',
      product: 'Sunflower Oil (50L)',
      amount: '\$290',
      date: 'Mar 23, 2026',
      status: 'Delivered',
      statusBg: AppColors.badgeSuccessBg,
      statusColor: AppColors.badgeSuccessText,
    ),
  ];

  // ── Top Products ──────────────────────────────────────────────────────────
  final List<DashTopProduct> topProducts = const [
    DashTopProduct(
      name: 'Organic Wheat',
      category: 'Grains',
      revenue: '\$8,420',
      units: '342 units',
      progress: 0.85,
      progressColor: AppColors.emeraldGreen,
    ),
    DashTopProduct(
      name: 'Premium Basmati Rice',
      category: 'Grains',
      revenue: '\$6,180',
      units: '218 units',
      progress: 0.62,
      progressColor: AppColors.badgeInfoText,
    ),
    DashTopProduct(
      name: 'Fresh Mango',
      category: 'Fruits',
      revenue: '\$4,950',
      units: '189 units',
      progress: 0.50,
      progressColor: AppColors.badgeWarningText,
    ),
    DashTopProduct(
      name: 'Sunflower Oil',
      category: 'Oils',
      revenue: '\$3,200',
      units: '145 units',
      progress: 0.32,
      progressColor: AppColors.badgeErrorText,
    ),
    DashTopProduct(
      name: 'Vegetable Box',
      category: 'Vegetables',
      revenue: '\$1,830',
      units: '98 units',
      progress: 0.18,
      progressColor: AppColors.badgeWarningText,
    ),
  ];

  // ── Activity Feed ─────────────────────────────────────────────────────────
  final List<DashActivity> activities = const [
    DashActivity(
      title: 'New order received',
      subtitle: 'Ahmed Khan ordered 500kg Organic Wheat',
      time: '2m ago',
      icon: Icons.shopping_bag_outlined,
      iconBg: AppColors.badgeSuccessBg,
      iconColor: AppColors.iconEmeraldGreen,
    ),
    DashActivity(
      title: 'Payment confirmed',
      subtitle: '\$580 received for order #ORD-4820',
      time: '18m ago',
      icon: Icons.payments_outlined,
      iconBg: AppColors.badgeInfoBg,
      iconColor: AppColors.badgeInfoText,
    ),
    DashActivity(
      title: 'New review posted',
      subtitle: 'Sara Malik gave 5 stars on Premium Rice',
      time: '1h ago',
      icon: Icons.star_outline_rounded,
      iconBg: AppColors.badgeWarningBg,
      iconColor: AppColors.badgeWarningText,
    ),
    DashActivity(
      title: 'Low stock alert',
      subtitle: 'Sunflower Oil stock below 10 units',
      time: '3h ago',
      icon: Icons.warning_amber_rounded,
      iconBg: AppColors.badgeErrorBg,
      iconColor: AppColors.badgeErrorText,
    ),
    DashActivity(
      title: 'Shipment dispatched',
      subtitle: 'Order #ORD-4819 shipped via FastEx',
      time: '5h ago',
      icon: Icons.local_shipping_outlined,
      iconBg: AppColors.badgePurpleBg,
      iconColor: AppColors.badgePurpleText,
    ),
  ];

  // ── Quick Actions ─────────────────────────────────────────────────────────
  static const List<DashQuickAction> quickActions = [
    DashQuickAction(
        label: 'Add Product',
        icon: Icons.add_circle_outline_rounded,
        namedRoute: AppRoutes.productForm),
    DashQuickAction(
        label: 'View Orders',
        icon: Icons.shopping_bag_outlined,
        screenIndex: 3),
    DashQuickAction(
        label: 'Check Inventory',
        icon: Icons.warehouse_outlined,
        screenIndex: 4),
    DashQuickAction(
        label: 'View Payments', icon: Icons.payments_outlined, screenIndex: 9),
  ];

  /// Shimmer while dashboard widgets mount (swap with real API later).
  final RxBool isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    Future<void>.delayed(const Duration(milliseconds: 380), () {
      isLoading.value = false;
    });
  }
}
