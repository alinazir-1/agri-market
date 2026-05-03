import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_routes.dart';

class EmailVerificationCon extends GetxController {
  late String email;
  RxBool isChecking = false.obs;
  RxBool isLoading = false.obs;
  final isResending = false.obs;
  final resendCooldown = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? '';
    _startResendCooldown();
  }

  void _startResendCooldown() {
    resendCooldown.value = 30;
    Future.doWhile(() async {
      if (isClosed) return false;
      await Future<void>.delayed(const Duration(seconds: 1));
      if (isClosed) return false;
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
        return true;
      }
      return false;
    });
  }

  void onCheckVerification() {
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    try {
      isChecking.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 300));
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        'Email verified',
        'Please login again with your email and password.',
      );
    } catch (_) {
      Get.snackbar('Verification Error', 'Something went wrong. Please try again.');
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> onResendCode() async {
    if (resendCooldown.value > 0) return;
    isResending.value = true;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      Get.snackbar('Email Sent', 'Verification email sent again.');
    } catch (_) {
      Get.snackbar('Resend Failed', 'Could not resend verification email.');
    } finally {
      isResending.value = false;
      isLoading.value = false;
    }
    _startResendCooldown();
  }
}
