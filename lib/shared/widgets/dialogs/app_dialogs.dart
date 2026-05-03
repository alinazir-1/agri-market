import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import '../common/app_container.dart';
import '../common/app_elevated_button.dart';
import '../common/app_outlined_button.dart';
import '../common/app_text.dart'; // ✅ NEW: Imported AppContainer

// ─── AppDialogs ───────────────────────────────────────────────────────────────
class AppDialogs {
  AppDialogs._();

  static void showLoading({String message = 'Please wait…'}) {
    Get.dialog(
      AppLoadingDialog(message: message),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  static void success({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      AppSuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onConfirm: onConfirm,
      ),
    );
  }

  static void error({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      AppErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onConfirm: onConfirm,
      ),
    );
  }

  static void confirm({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) {
    Get.dialog(
      AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerous: isDangerous,
      ),
    );
  }
}

// ─── _DialogShell ─────────────────────────────────────────────────────────────
class _DialogShell extends StatelessWidget {
  final Widget child;
  const _DialogShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radius20),
      ),
      backgroundColor: context.cardBg,
      // ✅ FIXED: Replaced raw Padding with AppContainer
      child: AppContainer(
        padding: const EdgeInsets.all(AppSize.space24),
        child: child,
      ),
    );
  }
}

// ─── AppLoadingDialog ─────────────────────────────────────────────────────────
class AppLoadingDialog extends StatelessWidget {
  final String message;
  const AppLoadingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return _DialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppShimmer(
            child: AppContainer(
              width: 56,
              height: 56,
              shape: BoxShape.circle,
              backgroundColor: context.cardBg2,
            ),
          ),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: message,
            fontSize: AppSize.font12,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── AppSuccessDialog ─────────────────────────────────────────────────────────
class AppSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onConfirm;

  const AppSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return _DialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ FIXED: Replaced raw Container with AppContainer for circular shape
          AppContainer(
            padding: const EdgeInsets.all(AppSize.space16),
            backgroundColor: AppColors.emerald100,
            shape: BoxShape.circle,
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.iconEmeraldGreen,
              size: AppSize.icon32,
            ),
          ),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: title,
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w700,
            color: context.txtPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: message,
            fontSize: AppSize.font12, // Adjusted from font13Small
            color: context.txtSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.space24),
          AppElevatedButton(
            text: buttonText,
            width: double.infinity,
            height: AppSize.space48, // Adjusted from buttonHeight48
            backgroundColor:
                AppColors.emeraldGreen, // Adjusted from buttonEmeraldGreen
            textColor: AppColors.textWhite,
            borderRadius: AppSize.radius12, // Adjusted from radius10Medium
            fontWeight: FontWeight.w600,
            onPressed: () {
              Get.back();
              onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }
}

// ─── AppErrorDialog ───────────────────────────────────────────────────────────
class AppErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onConfirm;

  const AppErrorDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return _DialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ FIXED: Replaced raw Container with AppContainer
          AppContainer(
            padding: const EdgeInsets.all(AppSize.space16),
            backgroundColor:
                AppColors.badgeErrorBg, // Adjusted from badgeLightRed
            shape: BoxShape.circle,
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.iconError,
              size: AppSize.icon32, // Adjusted from icon36XLarge
            ),
          ),
          const SizedBox(height: AppSize.space16),
          AppText(
            text: title,
            fontSize: AppSize.font16, // Adjusted from font16Medium
            fontWeight: FontWeight.w700,
            color: context.txtPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: message,
            fontSize: AppSize.font12, // Adjusted from font13Small
            color: context.txtSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.space24),
          AppElevatedButton(
            text: buttonText,
            width: double.infinity,
            height: AppSize.space48, // Adjusted from buttonHeight48
            backgroundColor: AppColors.borderError,
            textColor: AppColors.textWhite,
            borderRadius: AppSize.radius12, // Adjusted from radius10Medium
            fontWeight: FontWeight.w600,
            onPressed: () {
              Get.back();
              onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }
}

// ─── AppConfirmDialog ─────────────────────────────────────────────────────────
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    final confirmColor = isDangerous
        ? AppColors.borderError
        : AppColors.emeraldGreen; // Adjusted buttonEmeraldGreen

    return _DialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            fontSize: AppSize.font16, // Adjusted from font16Medium
            fontWeight: FontWeight.w700,
            color: context.txtPrimary,
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: message,
            fontSize: AppSize.font12, // Adjusted from font13Small
            color: context.txtSecondary,
          ),
          const SizedBox(height: AppSize.space24),
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  text: cancelText,
                  height: AppSize.space48, // Adjusted from buttonHeight48
                  textColor: AppColors.textSecondary,
                  foregroundColor: AppColors.textSecondary,
                  border: const BorderSide(color: AppColors.borderGray),
                  borderRadius:
                      AppSize.radius12, // Adjusted from radius10Medium
                  onPressed: () {
                    Get.back();
                    onCancel?.call();
                  },
                ),
              ),
              const SizedBox(width: AppSize.space12),
              Expanded(
                child: AppElevatedButton(
                  text: confirmText,
                  height: AppSize.space48, // Adjusted from buttonHeight48
                  backgroundColor: confirmColor,
                  textColor: AppColors.textWhite,
                  borderRadius:
                      AppSize.radius12, // Adjusted from radius10Medium
                  fontWeight: FontWeight.w600,
                  onPressed: () {
                    Get.back();
                    onConfirm?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
