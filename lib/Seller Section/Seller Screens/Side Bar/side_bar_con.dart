import 'package:agri_market/Seller%20Section/Seller%20Screens/Customers/customers_con.dart';
import 'package:agri_market/Seller%20Section/Seller%20Screens/Payment/payment_scr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../Add New Product/add_new_product_scr.dart';
import '../Advance Booking/advance_booking_scr.dart';
import '../Customers/customers_scr.dart';
import '../Inventory/inventory_scr.dart';
import '../Live Auctions/live_auctions_scr.dart';
import '../Marketplace/marketplace_scr.dart';
import '../Messages/message_scr.dart';
import '../Orders/orders_scr.dart';
import '../Review and Rating/review&rating_scr.dart';
import '../Shipping and Logistics/shipping_scr.dart';

// ── Nav Item Model ─────────────────────────────────────────────────────────

class NavItem {
  final String title;
  final IconData icon;

  const NavItem({required this.title, required this.icon});
}

// ── Placeholder Screen ─────────────────────────────────────────────────────

class _PlaceholderScr extends StatelessWidget {
  final String title;
  const _PlaceholderScr({required this.title});

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

// ── Controller ────────────────────────────────────────────────────────────

class SellerSideBarCon extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeScreen(int index) => selectedIndex.value = index;

  // Nav items — parallel list to screens
  static const List<NavItem> navItems = [
    NavItem(title: 'Dashboard', icon: Icons.grid_view_outlined),
    NavItem(title: 'My Products', icon: Icons.inventory_2_outlined),
    NavItem(title: 'Add New Product', icon: Icons.add_circle_outline_rounded),
    NavItem(title: 'Marketplace', icon: Icons.storefront_outlined),
    NavItem(title: 'Advance Booking', icon: Icons.calendar_month_outlined),
    NavItem(title: 'Live Auctions', icon: Icons.show_chart_rounded),
    NavItem(title: 'Orders', icon: Icons.shopping_bag_outlined),
    NavItem(title: 'Inventory', icon: Icons.warehouse_outlined),
    NavItem(title: 'Customers', icon: Icons.people_alt_outlined),
    NavItem(title: 'Messages', icon: Icons.chat_bubble_outline_rounded),
    NavItem(title: 'Reviews & Ratings', icon: Icons.rate_review_outlined),
    NavItem(title: 'Payments', icon: Icons.payments_outlined),
    NavItem(title: 'Shipping & Logistics', icon: Icons.local_shipping_outlined),
    NavItem(title: 'Analytics', icon: Icons.bar_chart_rounded),
    NavItem(title: 'Notifications', icon: Icons.notifications_none_outlined),
    NavItem(title: 'Business Profile', icon: Icons.person_outline_rounded),
    NavItem(title: 'Settings', icon: Icons.settings_outlined),
    NavItem(title: 'Help & Support', icon: Icons.help_outline_rounded),
  ];

  // Screens list — screens without implementation keep _PlaceholderScr
  final List<Widget> screens = [
    const _PlaceholderScr(title: 'Dashboard'),
    const _PlaceholderScr(title: 'My Products'),
    AddNewProductScr(),
    MarketplaceScr(),
    AdvanceBookingScr(),
    LiveAuctionsScr(),
    OrdersScr(),
    InventoryScr(),
    CustomersScr(),
    MessagesScr(),
    ReviewsScr(),
    PaymentsScr(),
    ShippingScr(),
    const _PlaceholderScr(title: 'Analytics'),
    const _PlaceholderScr(title: 'Notifications'),
    const _PlaceholderScr(title: 'Business Profile'),
    const _PlaceholderScr(title: 'Settings'),
    const _PlaceholderScr(title: 'Help & Support'),
  ];
}
