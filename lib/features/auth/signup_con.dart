import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_routes.dart';

enum UserRole { buyer, seller }

class SignUpCon extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final selectedRole = Rx<UserRole?>(null);
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  final nameError = RxnString();
  final emailError = RxnString();
  final phoneError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final roleError = RxnString();

  void selectRole(UserRole role) {
    selectedRole.value = role;
    roleError.value = null;
  }

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> onSignUp() async {
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (selectedRole.value == UserRole.buyer) {
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
