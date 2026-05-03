import 'package:get/get.dart';
import 'package:agri_market/features/seller/settings/settings_con.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsCon());
  }
}
