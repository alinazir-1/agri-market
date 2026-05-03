import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_routes.dart';

class LoginCon extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isLoading = false.obs;
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

  Future<void> onLogin() async {
    if (!_validate()) return;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final email = emailController.text.trim().toLowerCase();
      if (email.contains('buyer')) {
        Get.offAllNamed(AppRoutes.buyerDashboard);
      } else {
        Get.offAllNamed(AppRoutes.sellerDashboard);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
