import 'package:get/get.dart';

import 'package:agri_market/features/auth/reset_password_con.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordCon>(() => ResetPasswordCon());
  }
}
