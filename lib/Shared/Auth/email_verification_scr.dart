import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/images.dart';
import '../../Core/Constant/sizes.dart';
import '../Common Widgets/c_elevated_button.dart';
import 'email_verification_con.dart';

class EmailVerificationScr extends StatelessWidget {
  EmailVerificationScr({super.key});

  final EmailVerificationCon c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.backGroundLightGrey,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space24,
              vertical: CSize.space32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Logo
                  Center(
                    child: Image.asset(CImages.logo, height: 64),
                  ),
                  const SizedBox(height: CSize.space28),

                  /// Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(CSize.space28),
                    decoration: BoxDecoration(
                      color: CColors.backGroundWhite,
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                      boxShadow: [
                        BoxShadow(
                          color: CColors.shadowLight.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Icon badge
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: CColors.buttonEmeraldGreen.withOpacity(0.10),
                            borderRadius:
                                BorderRadius.circular(CSize.radius10Medium),
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 32,
                            color: CColors.iconEmeraldGreen,
                          ),
                        ),
                        const SizedBox(height: CSize.space20),

                        /// Heading
                        const Text(
                          'Check Your Email',
                          style: TextStyle(
                            fontSize: CSize.font24Large,
                            fontWeight: FontWeight.w700,
                            color: CColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: CSize.space4),
                        Text(
                          'We sent a 6-digit code to\n${c.email}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: CSize.font13Small,
                            color: CColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: CSize.space28),

                        /// OTP fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              6,
                              (i) => _OtpBox(
                                    controller: c.otpControllers[i],
                                    focusNode: c.focusNodes[i],
                                    onChanged: (v) => c.onOtpChanged(i, v),
                                  )),
                        ),

                        /// OTP error
                        Obx(() {
                          if (c.otpError.value == null) {
                            return const SizedBox(height: CSize.space8);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: CSize.space8, bottom: 0),
                            child: Text(
                              c.otpError.value!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: CColors.textError,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: CSize.space24),

                        /// Verify Button
                        Obx(() => CElevatedButton(
                              text: 'Verify Code',
                              onPressed: c.isLoading.value ? null : c.onVerify,
                              width: double.infinity,
                              height: 50,
                              backgroundColor: CColors.buttonEmeraldGreen,
                              textColor: CColors.textWhite,
                              borderRadius: CSize.radius10Medium,
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w600,
                              elevation: CSize.elevation0,
                            )),
                        const SizedBox(height: CSize.space20),

                        /// Resend
                        Obx(() {
                          final secs = c.resendCooldown.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  fontSize: CSize.font13Small,
                                  color: CColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: secs == 0 ? c.onResendCode : null,
                                child: Text(
                                  secs > 0 ? 'Resend in ${secs}s' : 'Resend',
                                  style: TextStyle(
                                    fontSize: CSize.font13Small,
                                    fontWeight: FontWeight.w600,
                                    color: secs > 0
                                        ? CColors.textSecondary
                                        : CColors.textEmeraldGreen,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: CSize.space16),

                        /// Back
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 13,
                                color: CColors.textSecondary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Change Email',
                                style: TextStyle(
                                  fontSize: CSize.font13Small,
                                  fontWeight: FontWeight.w500,
                                  color: CColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: CSize.font24Large,
          fontWeight: FontWeight.w700,
          color: CColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            borderSide: const BorderSide(color: CColors.borderGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            borderSide: const BorderSide(
              color: CColors.buttonEmeraldGreen,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: CColors.backGroundWhite,
        ),
      ),
    );
  }
}
