import 'package:get/get.dart';
import 'package:agri_market/features/seller/suppliers/suppliers_con.dart';

class SuppliersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuppliersCon());
  }
}
