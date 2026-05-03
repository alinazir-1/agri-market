import 'package:get/get.dart';

import 'package:agri_market/features/auth/login_con.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginCon());
  }
}
