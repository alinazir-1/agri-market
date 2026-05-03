// home_bin.dart
import 'package:get/get.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_con.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_messages_con.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_orders_con.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_top_bar_message_overlay_con.dart';
import 'package:agri_market/features/buyer/home/buyer_shell_search_con.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/home/home_ticker_con.dart';

class HomeBinding extends Bindings {
  /// Shared buyer search field — survives [HomeCon] teardown during navigation.
  static void ensureBuyerShellSearchCon() {
    if (!Get.isRegistered<BuyerShellSearchCon>()) {
      Get.put(BuyerShellSearchCon(), permanent: true);
    }
  }

  /// Call from [BuyerTopBar] if [HomeBinding] did not run (same pattern as messaging).
  static void ensureBuyerOrdersCon() {
    if (!Get.isRegistered<BuyerHomeOrdersCon>()) {
      Get.lazyPut<BuyerHomeOrdersCon>(
        () => BuyerHomeOrdersCon(),
        fenix: true,
      );
    }
  }

  static void ensureBuyerCartCon() {
    if (!Get.isRegistered<BuyerCartCon>()) {
      Get.lazyPut<BuyerCartCon>(
        () => BuyerCartCon(),
        fenix: true,
      );
    }
  }

  /// Call from [BuyerTopBar] (or anywhere) if [HomeBinding] might not have run
  /// (e.g. embedded home / hot reload) so GetX finds succeed.
  /// Ensures [HomeCon] exists when [BuyerTopBar] is shown outside the home route
  /// (e.g. product detail) so search controller and category overlay work.
  static void ensureHomeCon() {
    ensureBuyerShellSearchCon();
    if (!Get.isRegistered<HomeCon>()) {
      Get.lazyPut<HomeCon>(
        () => HomeCon(),
        fenix: true,
      );
    }
  }

  /// Permanent so GetX does **not** dispose [HomeTickerCon] when pushing routes over buyer home
  /// (e.g. product detail) — same pattern as [BuyerShellSearchCon]. Pause/resume only; no recreate.
  static void ensureHomeTickerCon() {
    if (!Get.isRegistered<HomeTickerCon>()) {
      Get.put<HomeTickerCon>(HomeTickerCon(), permanent: true);
    }
  }

  static void ensureMessagingControllers() {
    if (!Get.isRegistered<BuyerHomeMessagesCon>()) {
      Get.lazyPut<BuyerHomeMessagesCon>(
        () => BuyerHomeMessagesCon(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<BuyerTopBarMessageOverlayCon>()) {
      Get.lazyPut<BuyerTopBarMessageOverlayCon>(
        () => BuyerTopBarMessageOverlayCon(),
        fenix: true,
      );
    }
  }

  @override
  void dependencies() {
    ensureBuyerShellSearchCon();
    Get.lazyPut<HomeCon>(() => HomeCon());
    ensureHomeTickerCon();
    ensureMessagingControllers();
    ensureBuyerOrdersCon();
    ensureBuyerCartCon();
  }
}
