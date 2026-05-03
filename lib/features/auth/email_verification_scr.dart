import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/auth/email_verification_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class EmailVerificationScr extends StatelessWidget {
  EmailVerificationScr({super.key});

  final EmailVerificationCon c = Get.find();

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(AppImages.logo, height: AppSize.space64),
                  ),
                  const SizedBox(height: AppSize.space24),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppContainer(
                          width: 64,
                          height: 64,
                          backgroundColor:
                              AppColors.emeraldGreen.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(AppSize.radius12),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 32,
                            color: AppColors.iconEmeraldGreen,
                          ),
                        ),
                        const SizedBox(height: AppSize.space20),
                        const AppText(
                          text: 'Check Your Email',
                          fontSize: AppSize.font24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: AppSize.space8),
                        AppText(
                          text:
                              'We sent a verification link to:\n${c.email}\nOpen your email, verify your account, then tap below.',
                          textAlign: TextAlign.center,
                          fontSize: AppSize.font14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        const SizedBox(height: AppSize.space24),
                        Obx(
                          () => AppElevatedButton(
                            text: 'I Have Verified',
                            onPressed: c.onCheckVerification,
                            width: double.infinity,
                            height: 50,
                            backgroundColor: AppColors.emeraldGreen,
                            textColor: AppColors.textWhite,
                            borderRadius: AppSize.radius12,
                            fontSize: AppSize.font16,
                            fontWeight: FontWeight.w600,
                            elevation: 0,
                            isLoading: c.isChecking.value,
                          ),
                        ),
                        const SizedBox(height: AppSize.space16),
                        Obx(() {
                          final secs = c.resendCooldown.value;
                          final resending = c.isResending.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AppText(
                                text: "Didn't receive the email? ",
                                fontSize: AppSize.font14,
                                color: AppColors.textSecondary,
                              ),
                              resending
                                  ? const AppInlineProgress()
                                  : GestureDetector(
                                      onTap:
                                          secs == 0 ? c.onResendCode : null,
                                      child: AppText(
                                        text: secs > 0
                                            ? 'Resend in ${secs}s'
                                            : 'Resend',
                                        fontSize: AppSize.font14,
                                        fontWeight: FontWeight.w600,
                                        color: secs > 0
                                            ? AppColors.textSecondary
                                            : AppColors.textEmeraldGreen,
                                      ),
                                    ),
                            ],
                          );
                        }),
                        const SizedBox(height: AppSize.space16),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: AppSize.icon12,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: AppSize.space4),
                              AppText(
                                text: 'Change Email',
                                fontSize: AppSize.font14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
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
    );
  }
}
