import 'package:get/get.dart';

import 'signup_con.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpCon());
  }
}
