import 'package:get/get.dart';

import 'reset_password_con.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordCon>(() => ResetPasswordCon());
  }
}
