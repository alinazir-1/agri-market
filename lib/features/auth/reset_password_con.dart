import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_routes.dart';

class ResetPasswordCon extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureNew = true.obs;
  final obscureConfirm = true.obs;
  final newPasswordError = RxnString();
  final confirmPasswordError = RxnString();
  final isLoading = false.obs;

  void toggleNew() => obscureNew.value = !obscureNew.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  bool _validate() {
    bool valid = true;

    final pw = newPasswordController.text;
    if (pw.isEmpty) {
      newPasswordError.value = 'Please enter a new password';
      valid = false;
    } else if (pw.length < 8) {
      newPasswordError.value = 'Password must be at least 8 characters';
      valid = false;
    } else {
      newPasswordError.value = null;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      valid = false;
    } else if (confirmPasswordController.text != pw) {
      confirmPasswordError.value = 'Passwords do not match';
      valid = false;
    } else {
      confirmPasswordError.value = null;
    }

    return valid;
  }

  void onResetPassword() {
    if (!_validate()) return;
    isLoading.value = true;

    // TODO: implement Supabase updateUser password flow from reset session.
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        'Password Reset',
        'Your password has been reset successfully. Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0E7C66),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
