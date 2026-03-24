import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Routes/app_routes.dart';

class EmailVerificationCon extends GetxController {
  late String email;

  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final otpError = RxnString();
  final isLoading = false.obs;
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
      await Future.delayed(const Duration(seconds: 1));
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
        return true;
      }
      return false;
    });
  }

  void onOtpChanged(int index, String value) {
    otpError.value = null;
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode =>
      otpControllers.map((c) => c.text).join();

  bool _validate() {
    if (_otpCode.length < 6 || _otpCode.contains(' ')) {
      otpError.value = 'Please enter the complete 6-digit code';
      return false;
    }
    otpError.value = null;
    return true;
  }

  void onVerify() {
    if (!_validate()) return;
    isLoading.value = true;

    // TODO: verify OTP with backend / Firebase
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.toNamed(
        AppRoutes.resetPassword,
        arguments: {'email': email, 'otp': _otpCode},
      );
    });
  }

  void onResendCode() {
    if (resendCooldown.value > 0) return;
    for (final c in otpControllers) {
      c.clear();
    }
    otpError.value = null;
    focusNodes[0].requestFocus();
    _startResendCooldown();
    // TODO: resend OTP via Firebase / backend
  }

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
