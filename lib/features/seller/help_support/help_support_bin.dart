import 'package:get/get.dart';
import 'package:agri_market/features/seller/help_support/help_support_con.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpSupportCon());
  }
}
