import 'package:get/get.dart';

import '../Messages/message_con.dart';
import '../Notifications/notifications_con.dart';
import 'side_bar_con.dart';

class SellerSideBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SellerSideBarCon());
    // Register globally so ScreenTopBar can safely Get.find() from ANY screen
    Get.lazyPut(() => NotificationsCon());
    Get.lazyPut(() => MessagesCon());
  }
}
