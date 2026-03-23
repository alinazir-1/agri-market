import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/images.dart';
import '../../Core/Constant/sizes.dart';
import '../Common Widgets/c_elevated_button.dart';
import '../Common Widgets/c_text_field.dart';
import '../../Core/Routes/app_routes.dart';
import 'signup_con.dart';

class SignUpScr extends StatelessWidget {
  SignUpScr({super.key});

  final SignUpCon c = Get.find();

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
                    child: Image.asset(
                      CImages.logo,
                      height: 64,
                    ),
                  ),
                  const SizedBox(height: CSize.space28),

                  /// Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(CSize.space28),
                    decoration: BoxDecoration(
                      color: CColors.backGroundWhite,
                      borderRadius:
                          BorderRadius.circular(CSize.radius20Large),
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
                        /// Heading
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: CSize.font24Large,
                            fontWeight: FontWeight.w700,
                            color: CColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: CSize.space4),
                        const Text(
                          'Join AgriMarket — select your role to get started',
                          style: TextStyle(
                            fontSize: CSize.font13Small,
                            color: CColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: CSize.space24),

                        /// Role Selection
                        const Text(
                          'I am a',
                          style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w600,
                            color: CColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: CSize.space10),
                        Obx(() => Row(
                              children: [
                                Expanded(
                                  child: _RoleCard(
                                    label: 'Buyer',
                                    icon: Icons.shopping_basket_rounded,
                                    description: 'Purchase fresh agricultural products',
                                    isSelected:
                                        c.selectedRole.value == UserRole.buyer,
                                    onTap: () => c.selectRole(UserRole.buyer),
                                  ),
                                ),
                                const SizedBox(width: CSize.space12),
                                Expanded(
                                  child: _RoleCard(
                                    label: 'Seller',
                                    icon: Icons.storefront_rounded,
                                    description: 'List and sell your farm produce',
                                    isSelected:
                                        c.selectedRole.value == UserRole.seller,
                                    onTap: () => c.selectRole(UserRole.seller),
                                  ),
                                ),
                              ],
                            )),
                        Obx(() => c.roleError.value != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: CSize.space8),
                                child: Text(
                                  c.roleError.value!,
                                  style: const TextStyle(
                                    fontSize: CSize.font13Small,
                                    color: CColors.textError,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),

                        const SizedBox(height: CSize.space20),

                        /// Full Name
                        _FieldLabel('Full Name'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.nameController,
                              hintText: 'Enter your full name',
                              hintStyle: const TextStyle(
                                  color: CColors.textSecondary,
                                  fontSize: CSize.font13Small),
                              prefixIcon: Icons.person_outline_rounded,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.nameError.value,
                              onChanged: (_) => c.nameError.value = null,
                            )),
                        const SizedBox(height: CSize.space16),

                        /// Email
                        _FieldLabel('Email Address'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.emailController,
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                  color: CColors.textSecondary,
                                  fontSize: CSize.font13Small),
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.emailError.value,
                              onChanged: (_) => c.emailError.value = null,
                            )),
                        const SizedBox(height: CSize.space16),

                        /// Phone
                        _FieldLabel('Phone Number'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.phoneController,
                              hintText: 'e.g. 03001234567',
                              hintStyle: const TextStyle(
                                  color: CColors.textSecondary,
                                  fontSize: CSize.font13Small),
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_outlined,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.phoneError.value,
                              onChanged: (_) => c.phoneError.value = null,
                            )),
                        const SizedBox(height: CSize.space16),

                        /// Password
                        _FieldLabel('Password'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.passwordController,
                              hintText: 'Create a password',
                              hintStyle: const TextStyle(
                                  color: CColors.textSecondary,
                                  fontSize: CSize.font13Small),
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              obscureText: c.obscurePassword.value,
                              suffixIcon: c.obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              iconColor: CColors.iconEmeraldGreen,
                              onSuffixTap: c.togglePassword,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.passwordError.value,
                              onChanged: (_) => c.passwordError.value = null,
                            )),
                        const SizedBox(height: CSize.space16),

                        /// Confirm Password
                        _FieldLabel('Confirm Password'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.confirmPasswordController,
                              hintText: 'Re-enter your password',
                              hintStyle: const TextStyle(
                                  color: CColors.textSecondary,
                                  fontSize: CSize.font13Small),
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              obscureText: c.obscureConfirmPassword.value,
                              suffixIcon: c.obscureConfirmPassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              iconColor: CColors.iconEmeraldGreen,
                              onSuffixTap: c.toggleConfirmPassword,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.confirmPasswordError.value,
                              onChanged: (_) =>
                                  c.confirmPasswordError.value = null,
                            )),
                        const SizedBox(height: CSize.space28),

                        /// Sign Up Button
                        CElevatedButton(
                          text: 'Create Account',
                          onPressed: c.onSignUp,
                          width: double.infinity,
                          height: 50,
                          backgroundColor: CColors.buttonEmeraldGreen,
                          textColor: CColors.textWhite,
                          borderRadius: CSize.radius10Medium,
                          fontSize: CSize.font16Medium,
                          fontWeight: FontWeight.w600,
                          elevation: CSize.elevation0,
                        ),
                        const SizedBox(height: CSize.space20),

                        /// Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: CSize.font13Small,
                                color: CColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.login),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: CSize.font13Small,
                                  fontWeight: FontWeight.w600,
                                  color: CColors.textEmeraldGreen,
                                ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: CSize.space12,
          vertical: CSize.space14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? CColors.backgroundEmerald100
              : CColors.backGroundLightGrey,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(
            color: isSelected
                ? CColors.borderEmeraldGreen
                : CColors.borderGray,
            width: isSelected
                ? CSize.borderWidth2
                : CSize.borderWidth1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(CSize.space8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CColors.backGroundEmeraldGreen
                        : CColors.borderGray.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(CSize.radius5Small),
                  ),
                  child: Icon(
                    icon,
                    size: CSize.icon20Medium,
                    color: isSelected
                        ? CColors.iconWhite
                        : CColors.iconBlack,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: CColors.iconEmeraldGreen,
                    size: CSize.icon20Medium,
                  ),
              ],
            ),
            const SizedBox(height: CSize.space10),
            Text(
              label,
              style: TextStyle(
                fontSize: CSize.font16Medium,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? CColors.textEmeraldGreen
                    : CColors.textPrimary,
              ),
            ),
            const SizedBox(height: CSize.space4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 11,
                color: CColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Field Label helper
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
