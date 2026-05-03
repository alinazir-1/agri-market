import 'package:get/get.dart';
import 'package:agri_market/features/seller/business_profile/business_profile_con.dart';

class BusinessProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessProfileCon());
  }
}
