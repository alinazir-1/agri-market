import 'package:get/get.dart';

import 'login_con.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginCon());
  }
}
