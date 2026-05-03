// Binding for the seller section.
// Registers controllers that must exist before any screen is built:
//   - SellerSideBarCon: sidebar nav state
//   - NotificationsCon / MessagesCon: read by ScreenTopBar via Get.find() globally
//   - PaymentsCon / BusinessProfileCon: their screens use Get.find(), not Get.put()
//   - MobileShellCon: needed when viewport width < 600
// Screen-local controllers (DashboardCon, CustomersCon, etc.) are registered
// by their own screens via Get.put(), so they don't belong here.
import 'package:get/get.dart';
import 'package:agri_market/features/seller/products/my_products_con.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_con.dart';

class SellerSideBarBinding extends Bindings {
  @override
  void dependencies() {
    // Core nav controller — must exist before any sidebar widget renders.
    Get.lazyPut(() => SellerSideBarCon());

    // In-memory seller catalog (replaces Supabase); other features read via Get.find.
    if (!Get.isRegistered<MyProductsCon>()) {
      Get.put(MyProductsCon(), permanent: true);
    }

    // // Global controllers read by ScreenTopBar via Get.find() on every screen.
    // Get.lazyPut(() => NotificationsCon());
    // Get.lazyPut(() => MessagesCon());
    //
    // // Screens that use Get.find() instead of Get.put().
    // Get.lazyPut(() => PaymentsCon());
    // Get.lazyPut(() => BusinessProfileCon());
    //
    // // Mobile shell controller needed when width < 600.
    // Get.lazyPut(() => MobileShellCon());
  }
}
