import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/features/auth/signup_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

class SignUpScr extends StatelessWidget {
  SignUpScr({super.key});

  final SignUpCon c = Get.find();

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
                    child: Image.asset(
                      AppImages.logo,
                      height: 64,
                    ),
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
                        const AppText(
                          text: 'Create Account',
                          fontSize: AppSize.font24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: AppSize.space4),
                        const AppText(
                          text: 'Join AgriMarket and create your account',
                          fontSize: AppSize.font14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSize.space20),

                        /// Role Selection
                        const _FieldLabel('I am a'),
                        const SizedBox(height: AppSize.space8),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => _RoleCard(
                                  label: 'Buyer',
                                  icon: Icons.shopping_basket_rounded,
                                  description:
                                      'Purchase fresh agricultural products',
                                  isSelected: c.selectedRole.value ==
                                      UserRole.buyer,
                                  onTap: () => c.selectRole(UserRole.buyer),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSize.space12),
                            Expanded(
                              child: Obx(
                                () => _RoleCard(
                                  label: 'Seller',
                                  icon: Icons.storefront_rounded,
                                  description:
                                      'List and sell your farm produce',
                                  isSelected: c.selectedRole.value ==
                                      UserRole.seller,
                                  onTap: () => c.selectRole(UserRole.seller),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(() => c.roleError.value != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: AppSize.space8),
                                child: AppText(
                                  text: c.roleError.value!,
                                  fontSize: AppSize.font12,
                                  color: AppColors.textError,
                                ),
                              )
                            : const SizedBox.shrink()),

                        const SizedBox(height: AppSize.space20),

                        /// Full Name
                        _FieldLabel('Full Name'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.nameController,
                              hintText: 'Enter your full name',
                              prefixIcon: Icons.person_outline_rounded,
                              prefixIconColor: AppColors.iconEmeraldGreen,
                              isDense: true,
                              errorText: c.nameError.value,
                              onChanged: (_) => c.nameError.value = null,
                            )),
                        const SizedBox(height: AppSize.space16),

                        /// Email
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
                        const SizedBox(height: AppSize.space16),

                        /// Phone
                        _FieldLabel('Phone Number'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.phoneController,
                              hintText: 'e.g. 03001234567',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_outlined,
                              prefixIconColor: AppColors.iconEmeraldGreen,
                              isDense: true,
                              errorText: c.phoneError.value,
                              onChanged: (_) => c.phoneError.value = null,
                            )),
                        const SizedBox(height: AppSize.space16),

                        /// Password
                        _FieldLabel('Password'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.passwordController,
                              hintText: 'Create a password',
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
                            )),
                        const SizedBox(height: AppSize.space16),

                        /// Confirm Password
                        _FieldLabel('Confirm Password'),
                        const SizedBox(height: AppSize.space8),
                        Obx(() => AppTextField(
                              controller: c.confirmPasswordController,
                              hintText: 'Re-enter your password',
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: AppColors.iconEmeraldGreen,
                              obscureText: c.obscureConfirmPassword.value,
                              suffixWidget: IconButton(
                                onPressed: c.toggleConfirmPassword,
                                icon: Icon(
                                  c.obscureConfirmPassword.value
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
                        const SizedBox(height: AppSize.space24),

                        /// Sign Up Button
                        Obx(
                          () => AppElevatedButton(
                            text: 'Create Account',
                            onPressed: c.onSignUp,
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

                        /// Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppText(
                              text: 'Already have an account? ',
                              fontSize: AppSize.font14,
                              color: AppColors.textSecondary,
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.login),
                              child: const AppText(
                                text: 'Log In',
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

/// Role Selection Card
class _RoleCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space12,
          vertical: AppSize.space12,
        ),
        backgroundColor:
            isSelected ? AppColors.badgeSuccessBg : AppColors.backGroundLightGrey,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        border: Border.all(
          color:
              isSelected ? AppColors.borderEmeraldGreen : AppColors.borderGray,
          width: isSelected ? AppSize.borderWidth2 : AppSize.borderWidth1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppContainer(
                  padding: const EdgeInsets.all(AppSize.space8),
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  backgroundColor:
                      isSelected
                        ? AppColors.emeraldGreen
                        : AppColors.borderGray.withValues(alpha: 0.2),
                  child: Icon(
                    icon,
                    size: AppSize.icon20,
                    color: isSelected
                        ? AppColors.iconWhite
                        : AppColors.iconBlack,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.iconEmeraldGreen,
                    size: AppSize.icon20,
                  ),
              ],
            ),
            const SizedBox(height: AppSize.space8),
            AppText(
              text: label,
              fontSize: AppSize.font16,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColors.textEmeraldGreen
                  : AppColors.textPrimary,
            ),
            const SizedBox(height: AppSize.space4),
            AppText(
              text: description,
              fontSize: AppSize.font12,
              color: AppColors.textSecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              height: 1.4,
            ),
          ],
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
