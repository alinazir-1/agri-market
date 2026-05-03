import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/auth/reset_password_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

class ResetPasswordScr extends StatelessWidget {
  ResetPasswordScr({super.key});

  final ResetPasswordCon c = Get.find();

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
                        /// Icon badge
                        Center(
                          child: AppContainer(
                            width: 64,
                            height: 64,
                            backgroundColor:
                                AppColors.emeraldGreen.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(AppSize.radius20),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              size: 32,
                              color: AppColors.iconEmeraldGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSize.space20),

                        /// Heading
                        const Center(
                          child: AppText(
                            text: 'Set New Password',
                            fontSize: AppSize.font24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSize.space4),
                        const Center(
                          child: AppText(
                            text:
                            'Your new password must be at least\n8 characters long.',
                            textAlign: TextAlign.center,
                            fontSize: AppSize.font14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSize.space24),

                        /// New Password
                        _FieldLabel('New Password'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.newPasswordController,
                              hintText: 'Enter new password',
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: AppColors.iconEmeraldGreen,
                              obscureText: c.obscureNew.value,
                              suffixWidget: IconButton(
                                onPressed: c.toggleNew,
                                icon: Icon(
                                  c.obscureNew.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.iconEmeraldGreen,
                                  size: AppSize.icon20,
                                ),
                              ),
                              isDense: true,
                              errorText: c.newPasswordError.value,
                              onChanged: (_) => c.newPasswordError.value = null,
                            )),
                        const SizedBox(height: AppSize.space16),

                        /// Confirm Password
                        _FieldLabel('Confirm Password'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.confirmPasswordController,
                              hintText: 'Re-enter new password',
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: AppColors.iconEmeraldGreen,
                              obscureText: c.obscureConfirm.value,
                              suffixWidget: IconButton(
                                onPressed: c.toggleConfirm,
                                icon: Icon(
                                  c.obscureConfirm.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.iconEmeraldGreen,
                                  size: AppSize.icon20,
                                ),
                              ),
                              isDense: true,
                              errorText: c.confirmPasswordError.value,
                              onChanged: (_) =>
                                  c.confirmPasswordError.value = null,
                            )),

                        /// Password strength hint
                        const SizedBox(height: AppSize.space12),
                        _PasswordHint(),
                        const SizedBox(height: AppSize.space24),

                        /// Reset Button
                        Obx(
                          () => AppElevatedButton(
                            text: 'Reset Password',
                            onPressed: c.onResetPassword,
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

class _PasswordHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: AppColors.emeraldGreen.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppSize.radius12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppText(
            text: 'Password requirements:',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: AppSize.space4),
          _HintRow('At least 8 characters'),
          _HintRow('Mix of letters and numbers recommended'),
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  final String text;
  const _HintRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: AppSize.icon12,
            color: AppColors.iconEmeraldGreen,
          ),
          const SizedBox(width: AppSize.space4),
          AppText(
            text: text,
            fontSize: AppSize.font12,
            color: AppColors.textSecondary,
          ),
        ],
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
