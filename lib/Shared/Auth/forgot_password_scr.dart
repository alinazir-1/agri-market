import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/images.dart';
import '../../Core/Constant/sizes.dart';
import '../Common Widgets/c_elevated_button.dart';
import '../Common Widgets/c_text_field.dart';
import 'forgot_password_con.dart';

class ForgotPasswordScr extends StatelessWidget {
  ForgotPasswordScr({super.key});

  final ForgotPasswordCon c = Get.find();

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Icon badge
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color:
                                  CColors.buttonEmeraldGreen.withOpacity(0.10),
                              borderRadius:
                                  BorderRadius.circular(CSize.radius20Large),
                            ),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              size: 32,
                              color: CColors.iconEmeraldGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSize.space20),

                        /// Heading
                        const Center(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: CSize.font24Large,
                              fontWeight: FontWeight.w700,
                              color: CColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSize.space4),
                        const Center(
                          child: Text(
                            'Enter your email and we\'ll send you a\nverification code to reset your password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: CSize.font13Small,
                              color: CColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSize.space28),

                        /// Email Field
                        _FieldLabel('Email Address'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.emailController,
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                color: CColors.textSecondary,
                                fontSize: CSize.font13Small,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.emailError.value,
                              onChanged: (_) => c.emailError.value = null,
                            )),
                        const SizedBox(height: CSize.space28),

                        /// Send Code Button
                        Obx(() => CElevatedButton(
                              text: 'Send Verification Code',
                              onPressed:
                                  c.isLoading.value ? null : c.onSendCode,
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

                        /// Back to Login
                        Center(
                          child: GestureDetector(
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
                                  'Back to Login',
                                  style: TextStyle(
                                    fontSize: CSize.font13Small,
                                    fontWeight: FontWeight.w500,
                                    color: CColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: CSize.font13Small,
        fontWeight: FontWeight.w600,
        color: CColors.textPrimary,
      ),
    );
  }
}
