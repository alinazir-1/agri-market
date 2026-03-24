import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/images.dart';
import '../../Core/Constant/sizes.dart';
import '../Common Widgets/c_elevated_button.dart';
import '../Common Widgets/c_text_field.dart';
import 'reset_password_con.dart';

class ResetPasswordScr extends StatelessWidget {
  ResetPasswordScr({super.key});

  final ResetPasswordCon c = Get.find();

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
                              Icons.lock_outline_rounded,
                              size: 32,
                              color: CColors.iconEmeraldGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSize.space20),

                        /// Heading
                        const Center(
                          child: Text(
                            'Set New Password',
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
                            'Your new password must be at least\n8 characters long.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: CSize.font13Small,
                              color: CColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSize.space28),

                        /// New Password
                        _FieldLabel('New Password'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.newPasswordController,
                              hintText: 'Enter new password',
                              hintStyle: const TextStyle(
                                color: CColors.textSecondary,
                                fontSize: CSize.font13Small,
                              ),
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              obscureText: c.obscureNew.value,
                              suffixIcon: c.obscureNew.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              iconColor: CColors.iconEmeraldGreen,
                              onSuffixTap: c.toggleNew,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.newPasswordError.value,
                              onChanged: (_) => c.newPasswordError.value = null,
                            )),
                        const SizedBox(height: CSize.space16),

                        /// Confirm Password
                        _FieldLabel('Confirm Password'),
                        const SizedBox(height: CSize.space8),
                        Obx(() => CTextField(
                              controller: c.confirmPasswordController,
                              hintText: 'Re-enter new password',
                              hintStyle: const TextStyle(
                                color: CColors.textSecondary,
                                fontSize: CSize.font13Small,
                              ),
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconColor: CColors.iconEmeraldGreen,
                              obscureText: c.obscureConfirm.value,
                              suffixIcon: c.obscureConfirm.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              iconColor: CColors.iconEmeraldGreen,
                              onSuffixTap: c.toggleConfirm,
                              suffixIconSize: CSize.icon20Medium,
                              isDense: true,
                              errorText: c.confirmPasswordError.value,
                              onChanged: (_) =>
                                  c.confirmPasswordError.value = null,
                            )),

                        /// Password strength hint
                        const SizedBox(height: CSize.space12),
                        _PasswordHint(),
                        const SizedBox(height: CSize.space28),

                        /// Reset Button
                        Obx(() => CElevatedButton(
                              text: 'Reset Password',
                              onPressed:
                                  c.isLoading.value ? null : c.onResetPassword,
                              width: double.infinity,
                              height: 50,
                              backgroundColor: CColors.buttonEmeraldGreen,
                              textColor: CColors.textWhite,
                              borderRadius: CSize.radius10Medium,
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w600,
                              elevation: CSize.elevation0,
                            )),
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

class _PasswordHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CSize.space12),
      decoration: BoxDecoration(
        color: CColors.buttonEmeraldGreen.withOpacity(0.06),
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Password requirements:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: CColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
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
            size: 13,
            color: CColors.iconEmeraldGreen,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: CColors.textSecondary,
            ),
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
