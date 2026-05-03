import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/auth/forgot_password_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

class ForgotPasswordScr extends StatelessWidget {
  ForgotPasswordScr({super.key});

  final ForgotPasswordCon c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundLightGrey,
      body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space24,
              vertical: AppSize.space32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Logo
                  Center(
                    child: Image.asset(AppImages.logo, height: 64),
                  ),
                  const SizedBox(height: AppSize.space24),

                  /// Card
                  AppContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSize.space24),
                    backgroundColor: AppColors.backGroundWhite,
                    borderRadius: BorderRadius.circular(AppSize.radius20),
                    boxShadows: [
                      BoxShadow(
                        color: AppColors.shadowBase.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: AppContainer(
                            width: 64,
                            height: 64,
                            backgroundColor:
                                AppColors.emeraldGreen.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(AppSize.radius20),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              size: 32,
                              color: AppColors.iconEmeraldGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSize.space20),

                        /// Heading
                        const Center(
                          child: AppText(
                            text: 'Forgot Password?',
                            fontSize: AppSize.font24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSize.space4),
                        const Center(
                          child: AppText(
                            text:
                                'Enter your email and we\'ll send you a reset link.',
                            textAlign: TextAlign.center,
                            fontSize: AppSize.font14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSize.space24),

                        /// Email Field
                        _FieldLabel('Email Address'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.emailController,
                              hintText: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              prefixIconColor: AppColors.iconEmeraldGreen,
                              isDense: true,
                              errorText: c.emailError.value,
                              onChanged: (_) => c.emailError.value = null,
                            )),
                        const SizedBox(height: AppSize.space24),

                        /// Send Code Button
                        Obx(
                          () => AppElevatedButton(
                            text: 'Send Reset Link',
                            onPressed: c.onSendCode,
                            width: double.infinity,
                            height: 50,
                            backgroundColor: AppColors.emeraldGreen,
                            textColor: AppColors.textWhite,
                            borderRadius: AppSize.radius12,
                            fontSize: AppSize.font16,
                            fontWeight: FontWeight.w600,
                            elevation: 0,
                            isLoading: c.isLoading.value,
                          ),
                        ),
                        const SizedBox(height: AppSize.space20),

                        /// Back to Login
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: AppSize.icon12,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: AppSize.space4),
                                AppText(
                                  text: 'Back to Login',
                                  fontSize: AppSize.font14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
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
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      fontSize: AppSize.font14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }
}
