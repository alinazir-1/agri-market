import 'package:get/get.dart';

import 'package:agri_market/features/auth/signup_con.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpCon());
  }
}
