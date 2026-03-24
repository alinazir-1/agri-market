import 'package:get/get.dart';
import 'help_support_con.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpSupportCon());
  }
}
