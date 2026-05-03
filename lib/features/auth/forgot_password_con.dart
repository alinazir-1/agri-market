import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_routes.dart';

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

  Future<void> onSendCode() async {
    if (!_validate()) return;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      Get.offNamed(AppRoutes.login);
      Get.snackbar('Email Sent', 'Password reset link sent to your email.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
