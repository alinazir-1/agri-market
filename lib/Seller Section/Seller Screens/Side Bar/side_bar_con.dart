import 'package:agri_market/Seller%20Section/Seller%20Screens/My%20Products/my_products_scr.dart';
import 'package:agri_market/Seller%20Section/Seller%20Screens/Notifications/notifications_scr.dart';
import 'package:agri_market/Seller%20Section/Seller%20Screens/Payment/payment_scr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Add New Product/add_new_product_scr.dart';
import '../Business Profile/business_profile_scr.dart';
import '../Customers/customers_scr.dart';
import '../Help and Support/help_support_scr.dart';
import '../Inventory/inventory_scr.dart';
import '../Messages/message_scr.dart';
import '../Orders/orders_scr.dart';
import '../Review and Rating/review&rating_scr.dart';
import '../Settings/settings_scr.dart';
import '../Shipping and Logistics/shipping_scr.dart';
import '../Suppliers/suppliers_scr.dart';

// ── Sidebar Entry Models ────────────────────────────────────────────────────

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

// ── Placeholder Screen ──────────────────────────────────────────────────────

class PlaceholderScr extends StatelessWidget {
  final String title;
  const PlaceholderScr({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_outlined,
                size: 48, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'This screen is under construction',
              style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Controller ─────────────────────────────────────────────────────────────

class SellerSideBarCon extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeScreen(int index) => selectedIndex.value = index;

  // Sidebar entries: section headings + nav items
  static const List<SideBarEntry> sideBarEntries = [
    // ── MAIN ──────────────────────────────────────────────────────────────
    SideBarHeading('MAIN'),
    NavItem(title: 'Dashboard', icon: Icons.grid_view_outlined, screenIndex: 0),

    // ── CATALOG ───────────────────────────────────────────────────────────
    SideBarHeading('CATALOG'),
    NavItem(
        title: 'My Products', icon: Icons.inventory_2_outlined, screenIndex: 1),
    NavItem(
        title: 'Add New Product',
        icon: Icons.add_circle_outline_rounded,
        screenIndex: 2),

    // ── OPERATIONS ────────────────────────────────────────────────────────
    SideBarHeading('OPERATIONS'),
    NavItem(title: 'Orders', icon: Icons.shopping_bag_outlined, screenIndex: 3),
    NavItem(title: 'Inventory', icon: Icons.warehouse_outlined, screenIndex: 4),
    NavItem(title: 'Suppliers', icon: Icons.store_outlined, screenIndex: 5),
    NavItem(
        title: 'Customers', icon: Icons.people_alt_outlined, screenIndex: 6),

    // ── COMMUNICATION ─────────────────────────────────────────────────────
    SideBarHeading('COMMUNICATION'),
    NavItem(
        title: 'Messages',
        icon: Icons.chat_bubble_outline_rounded,
        screenIndex: 7),
    NavItem(
        title: 'Reviews & Ratings',
        icon: Icons.rate_review_outlined,
        screenIndex: 8),

    // ── FINANCE ───────────────────────────────────────────────────────────
    SideBarHeading('FINANCE'),
    NavItem(title: 'Payments', icon: Icons.payments_outlined, screenIndex: 9),
    NavItem(
        title: 'Shipping & Logistics',
        icon: Icons.local_shipping_outlined,
        screenIndex: 10),

    // ── ACCOUNT ───────────────────────────────────────────────────────────
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

  // Screens — indexed by screenIndex in NavItem
  final List<Widget> screens = [
    const PlaceholderScr(title: 'Dashboard'), // 0
    MyProductsScr(), // 1
    AddNewProductScr(), // 2
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
