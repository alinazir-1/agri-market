import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/features/auth/login_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

class LoginScr extends StatelessWidget {
  LoginScr({super.key});

  final LoginCon c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
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
                  Center(
                    child: Image.asset(AppImages.logo, height: AppSize.space64),
                  ),
                  const SizedBox(height: AppSize.space24),
                  AppContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSize.space24),
                    backgroundColor: context.cardBg,
                    borderRadius: BorderRadius.circular(AppSize.radius20),
                    boxShadows: [
                      BoxShadow(
                        color: AppColors.shadowBase.withValues(alpha: 0.06),
                        blurRadius: AppSize.space20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Welcome Back',
                          fontSize: AppSize.font24,
                          fontWeight: FontWeight.w700,
                          color: context.txtPrimary,
                        ),
                        const SizedBox(height: AppSize.space4),
                        AppText(
                          text: 'Log in to your AgriMarket account',
                          fontSize: AppSize.font14,
                          color: context.txtSecondary,
                        ),
                        const SizedBox(height: AppSize.space24),
                        const _FieldLabel('Email Address'),
                        const SizedBox(height: AppSize.space8),
                        Obx(
                          () => AppTextField(
                            controller: c.emailController,
                            hintText: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            prefixIconColor: AppColors.iconEmeraldGreen,
                            isDense: true,
                            errorText: c.emailError.value,
                            onChanged: (_) => c.emailError.value = null,
                          ),
                        ),
                        const SizedBox(height: AppSize.space16),
                        const _FieldLabel('Password'),
                        const SizedBox(height: AppSize.space8),
                        Obx(
                          () => AppTextField(
                            controller: c.passwordController,
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            prefixIconColor: AppColors.iconEmeraldGreen,
                            obscureText: c.obscurePassword.value,
                            suffixWidget: IconButton(
                              onPressed: c.togglePassword,
                              icon: Icon(
                                c.obscurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.iconEmeraldGreen,
                                size: AppSize.icon20,
                              ),
                            ),
                            isDense: true,
                            errorText: c.passwordError.value,
                            onChanged: (_) => c.passwordError.value = null,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                            child: const AppText(
                              text: 'Forgot Password?',
                              fontSize: AppSize.font14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textEmeraldGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSize.space12),
                        Obx(
                          () => AppElevatedButton(
                            text: 'Log In',
                            onPressed: c.onLogin,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Don't have an account? ",
                              fontSize: AppSize.font14,
                              color: context.txtSecondary,
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.signUp),
                              child: const AppText(
                                text: 'Sign Up',
                                fontSize: AppSize.font14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textEmeraldGreen,
                              ),
                            ),
                          ],
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
      color: context.txtPrimary,
    );
  }
}
