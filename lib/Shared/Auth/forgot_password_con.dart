import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Routes/app_routes.dart';

class ForgotPasswordCon extends GetxController {
  final emailController = TextEditingController();

  final emailError = RxnString();
  final isLoading = false.obs;

  bool _validate() {
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      return false;
    }
    emailError.value = null;
    return true;
  }

  void onSendCode() {
    if (!_validate()) return;
    isLoading.value = true;

    // TODO: call Firebase sendPasswordResetEmail or OTP service
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.toNamed(
        AppRoutes.emailVerification,
        arguments: {'email': emailController.text.trim()},
      );
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
