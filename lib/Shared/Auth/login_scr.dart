import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/images.dart';
import '../../Core/Constant/sizes.dart';
import '../../Core/Routes/app_routes.dart';
import '../../Core/Theme/app_theme.dart';
import '../Common Widgets/c_elevated_button.dart';
import '../Common Widgets/c_text_field.dart';
import 'login_con.dart';

class LoginScr extends StatelessWidget {
  LoginScr({super.key});

  final LoginCon c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
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
                      color: context.cardBg,
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
                        /// Heading
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: CSize.font24Large,
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary,
                          ),
                        ),
                        const SizedBox(height: CSize.space4),
                        Text(
                          'Log in to your AgriMarket account',
                          style: TextStyle(
                            fontSize: CSize.font13Small,
                            color: context.txtSecondary,
                          ),
                        ),
                        const SizedBox(height: CSize.space28),

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

                        /// Password
                        _FieldLabel('Password'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.passwordController,
                              hintText: 'Enter your password',
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

                        /// Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  top: CSize.space8, bottom: CSize.space4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: CSize.font13Small,
                                fontWeight: FontWeight.w500,
                                color: CColors.textEmeraldGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: CSize.space20),

                        /// Login Button
                        CElevatedButton(
                          text: 'Log In',
                          onPressed: c.onLogin,
                          width: double.infinity,
                          height: 50,
                          backgroundColor: CColors.buttonEmeraldGreen,
                          textColor: CColors.textWhite,
                          borderRadius: CSize.radius10Medium,
                          fontSize: CSize.font16Medium,
                          fontWeight: FontWeight.w600,
                          elevation: CSize.elevation0,
                        ),
                        const SizedBox(height: CSize.space24),

                        /// Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: CColors.borderGray,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CSize.space12),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontSize: CSize.font13Small,
                                  color: context.txtSecondary,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: CColors.borderGray,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: CSize.space20),

                        /// Social Login Buttons
                        _SocialButton(
                          image: CImages.google,
                          label: 'Continue with Google',
                          onTap: () {},
                        ),
                        const SizedBox(height: CSize.space12),
                        _SocialButton(
                          image: CImages.facebook,
                          label: 'Continue with Facebook',
                          onTap: () {},
                        ),
                        const SizedBox(height: CSize.space24),

                        /// Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: CSize.font13Small,
                                color: context.txtSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.signUp),
                              child: const Text(
                                'Sign Up',
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

class _SocialButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(color: context.borderClr),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 22, width: 22),
            const SizedBox(width: CSize.space10),
            Text(
              label,
              style: TextStyle(
                fontSize: CSize.font13Small,
                fontWeight: FontWeight.w500,
                color: context.txtPrimary,
              ),
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
    return Text(
      text,
      style: TextStyle(
        fontSize: CSize.font13Small,
        fontWeight: FontWeight.w600,
        color: context.txtPrimary,
      ),
    );
  }
}
