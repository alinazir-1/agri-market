import 'package:get/get.dart';
import 'settings_con.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsCon());
  }
}
