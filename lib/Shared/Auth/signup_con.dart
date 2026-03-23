import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Routes/app_routes.dart';

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

  bool _validate() {
    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Please enter your full name';
      valid = false;
    } else {
      nameError.value = null;
    }

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Please enter your email';
      valid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      valid = false;
    } else {
      emailError.value = null;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Please enter your phone number';
      valid = false;
    } else {
      phoneError.value = null;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Please enter a password';
      valid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      valid = false;
    } else {
      passwordError.value = null;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      valid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      valid = false;
    } else {
      confirmPasswordError.value = null;
    }

    if (selectedRole.value == null) {
      roleError.value = 'Please select your role';
      valid = false;
    } else {
      roleError.value = null;
    }

    return valid;
  }

  void onSignUp() {
    if (!_validate()) return;

    if (selectedRole.value == UserRole.seller) {
      Get.offAllNamed(AppRoutes.sellerDashboard);
    } else {
      // Buyer section — jab buyer screens ban jayein tab route add hoga
      Get.snackbar(
        'Welcome Buyer!',
        'Buyer section coming soon.',
        backgroundColor: const Color(0xFF0E7C66),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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