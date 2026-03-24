import 'package:get/get.dart';

import 'forgot_password_con.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordCon>(() => ForgotPasswordCon());
  }
}
