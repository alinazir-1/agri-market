import 'package:get/get.dart';

import 'package:agri_market/features/auth/email_verification_con.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerificationCon>(() => EmailVerificationCon());
  }
}
