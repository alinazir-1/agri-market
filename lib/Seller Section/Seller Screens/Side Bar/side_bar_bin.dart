import 'package:get/get.dart';

import '../Marketplace/marketplace_con.dart';
import 'side_bar_con.dart';

class SellerSideBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MarketplaceCon());
    Get.lazyPut(() => SellerSideBarCon());
  }
}
