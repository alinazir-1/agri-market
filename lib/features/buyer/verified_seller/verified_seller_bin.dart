import 'package:get/get.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_con.dart';

class VerifiedSellerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifiedSellerCon>(() => VerifiedSellerCon());
  }
}
