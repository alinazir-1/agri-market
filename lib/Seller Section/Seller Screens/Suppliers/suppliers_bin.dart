import 'package:get/get.dart';
import 'suppliers_con.dart';

class SuppliersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuppliersCon());
  }
}
