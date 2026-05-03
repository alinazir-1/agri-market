// lib/features/buyer/cart/buyer_cart_bin.dart

import 'package:get/get.dart';

import 'package:agri_market/features/buyer/cart/buyer_cart_con.dart';

class BuyerCartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BuyerCartCon>()) {
      Get.lazyPut<BuyerCartCon>(() => BuyerCartCon(), fenix: true);
    }
  }
}
