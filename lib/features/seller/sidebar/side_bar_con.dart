// lib/features/seller/sidebar/side_bar_con.dart

import 'package:agri_market/features/seller/customers/customers_scr.dart';
import 'package:agri_market/features/seller/dashboard/dashboard_scr.dart';
import 'package:agri_market/features/seller/products/my_products_scr.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../business_profile/business_profile_scr.dart';
import '../help_support/help_support_scr.dart';
import '../inventory/inventory_scr.dart';
import '../messages/message_scr.dart';
import '../notifications/notifications_scr.dart';
import '../orders/orders_scr.dart';
import '../payments/payment_scr.dart';
import '../reviews/review_rating_scr.dart';
import '../settings/settings_scr.dart';
import '../shipping/shipping_scr.dart';
import '../suppliers/suppliers_scr.dart';

// ── Sidebar Entry Models ──────────────────────────────────────────────────────

abstract class SideBarEntry {
  const SideBarEntry();
}

class SideBarHeading extends SideBarEntry {
  final String title;
  const SideBarHeading(this.title);
}

class NavItem extends SideBarEntry {
  final String title;
  final IconData icon;
  final int screenIndex;
  const NavItem({
    required this.title,
    required this.icon,
    required this.screenIndex,
  });
}

// ── Controller ────────────────────────────────────────────────────────────────

class SellerSideBarCon extends GetxController {
  final RxInt selectedIndex = 0.obs;

  // ✅ Lazy Loading State Management (Replaces StatefulWidget)
  late final RxList<bool> visitedScreens;

  @override
  void onInit() {
    super.onInit();
    // Initially only the first screen (index 0) is true/visited
    visitedScreens = List.generate(screens.length, (index) => index == 0).obs;
  }

  void changeScreen(int index) {
    selectedIndex.value = index;
    // Mark as visited so it builds and stays in memory
    if (!visitedScreens[index]) {
      visitedScreens[index] = true;
    }
  }

  /// 💀🔥 ---------------- Sidebar Entries ----------------
  static const List<SideBarEntry> sideBarEntries = [
    SideBarHeading('MAIN'),
    NavItem(title: 'Dashboard', icon: Icons.grid_view_outlined, screenIndex: 0),
    SideBarHeading('CATALOG'),
    NavItem(
        title: 'My Products', icon: Icons.inventory_2_outlined, screenIndex: 1),
    SideBarHeading('OPERATIONS'),
    NavItem(title: 'Orders', icon: Icons.shopping_bag_outlined, screenIndex: 3),
    NavItem(title: 'Inventory', icon: Icons.warehouse_outlined, screenIndex: 4),
    NavItem(title: 'Suppliers', icon: Icons.store_outlined, screenIndex: 5),
    NavItem(
        title: 'Customers', icon: Icons.people_alt_outlined, screenIndex: 6),
    SideBarHeading('COMMUNICATION'),
    NavItem(
        title: 'Messages',
        icon: Icons.chat_bubble_outline_rounded,
        screenIndex: 7),
    NavItem(
        title: 'Reviews & Ratings',
        icon: Icons.rate_review_outlined,
        screenIndex: 8),
    SideBarHeading('FINANCE'),
    NavItem(title: 'Payments', icon: Icons.payments_outlined, screenIndex: 9),
    NavItem(
        title: 'Shipping & Logistics',
        icon: Icons.local_shipping_outlined,
        screenIndex: 10),
    SideBarHeading('ACCOUNT'),
    NavItem(
        title: 'Notifications',
        icon: Icons.notifications_none_outlined,
        screenIndex: 11),
    NavItem(
        title: 'Business Profile',
        icon: Icons.person_outline_rounded,
        screenIndex: 12),
    NavItem(title: 'Settings', icon: Icons.settings_outlined, screenIndex: 13),
    NavItem(
        title: 'Help & Support',
        icon: Icons.help_outline_rounded,
        screenIndex: 14),
  ];

  // ✅ All screens instantiated with Placeholders (Ready to be replaced later)
  /// 💀🔥 ---------------- Sidebar Screen Map ----------------
  final List<Widget> screens = [
    DashboardScr(), //0
    MyProductsScr(), // 1
    const AppContainer(), // 2 — unused shell slot; product form uses [AppRoutes.productForm]
    OrdersScr(), // 3
    InventoryScr(), // 4
    SuppliersScr(), // 5
    CustomersScr(), // 6
    MessagesScr(), // 7
    ReviewsScr(), // 8
    PaymentsScr(), // 9
    ShippingScr(), // 10
    NotificationsScr(), // 11
    BusinessProfileScr(), // 12
    SettingsScr(), // 13
    HelpSupportScr(), // 14
  ];
}
