import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Routes/app_routes.dart';

class LoginCon extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final emailError = RxnString();
  final passwordError = RxnString();

  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  bool _validate() {
    bool valid = true;

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Please enter your email';
      valid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      valid = false;
    } else {
      emailError.value = null;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Please enter your password';
      valid = false;
    } else {
      passwordError.value = null;
    }

    return valid;
  }

  void onLogin() {
    if (!_validate()) return;

    // TODO: role-based login logic — for now navigate to seller
    Get.offAllNamed(AppRoutes.sellerDashboard);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
