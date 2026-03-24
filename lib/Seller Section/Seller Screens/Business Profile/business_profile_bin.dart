import 'package:get/get.dart';
import 'business_profile_con.dart';

class BusinessProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessProfileCon());
  }
}
