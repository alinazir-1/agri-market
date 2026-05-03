import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_outlined_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

/// 💀🔥 ---------------- Add Customer Dialog Controller ----------------
class AddCustomerDialogCon extends GetxController {
  final RxBool isSaving = false.obs;

  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final postalCodeController = TextEditingController();
  final companyController = TextEditingController();

  Future<void> save() async {
    if (isSaving.value) return;
    isSaving.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 160));
    Get.back<void>();
  }

  @override
  void onClose() {
    nameController.dispose();
    countryController.dispose();
    cityController.dispose();
    emailController.dispose();
    mobileController.dispose();
    postalCodeController.dispose();
    companyController.dispose();
    super.onClose();
  }
}

/// 💀🔥 ---------------- Add Customer Dialog Launcher ----------------
Future<void> showAddCustomerDialog(BuildContext context) async {
  final ctrlAddCustomerDialog = Get.put(AddCustomerDialogCon());
  await Get.dialog<void>(
    Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radius8)),
      backgroundColor: AppColors.backgroundSurface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: AppContainer(
          padding: const EdgeInsets.all(AppSize.space20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 💀🔥 ---------------- Add Customer Dialog Header ----------------
              const AppText(
                text: 'Add Customer',
                fontSize: AppSize.font16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSize.space12),

              /// 💀🔥 ---------------- Add Customer Dialog Form ----------------
              Row(
                children: [
                  Expanded(
                    child: _field(
                        label: 'Customer Name',
                        controller: ctrlAddCustomerDialog.nameController,
                        hint: 'Enter name'),
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: _field(
                        label: 'Country',
                        controller: ctrlAddCustomerDialog.countryController,
                        hint: 'Enter country'),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space12),
              Row(
                children: [
                  Expanded(
                    child: _field(
                        label: 'City',
                        controller: ctrlAddCustomerDialog.cityController,
                        hint: 'Enter city'),
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: _field(
                        label: 'Email',
                        controller: ctrlAddCustomerDialog.emailController,
                        hint: 'Enter email'),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space12),
              Row(
                children: [
                  Expanded(
                    child: _field(
                        label: 'Mobile Number',
                        controller: ctrlAddCustomerDialog.mobileController,
                        hint: 'Enter mobile number'),
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: _field(
                        label: 'Postal Code',
                        controller: ctrlAddCustomerDialog.postalCodeController,
                        hint: 'Enter postal code'),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space12),
              _field(
                  label: 'Company (Optional)',
                  controller: ctrlAddCustomerDialog.companyController,
                  hint: 'Enter company name'),
              const SizedBox(height: AppSize.space20),

              /// 💀🔥 ---------------- Add Customer Dialog Actions ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppOutlinedButton(
                    onPressed: () => Get.back<void>(),
                    text: 'Cancel',
                    height: 32,
                    width: 100,
                    borderRadius: AppSize.radius8,
                    textColor: AppColors.textSecondary,
                    border: const BorderSide(color: AppColors.borderLight),
                  ),
                  const SizedBox(width: AppSize.space8),
                  Obx(
                    () => AppElevatedButton(
                      onPressed: ctrlAddCustomerDialog.save,
                      isLoading: ctrlAddCustomerDialog.isSaving.value,
                      text: 'Save',
                      height: 32,
                      width: 100,
                      fontWeight: FontWeight.w700,
                      backgroundColor: AppColors.emeraldGreen,
                      textColor: AppColors.textWhite,
                      borderRadius: AppSize.radius8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Get.delete<AddCustomerDialogCon>();
}

/// 💀🔥 ---------------- Add Customer Field ----------------
Widget _field({
  required String label,
  required TextEditingController controller,
  required String hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(
        text: label,
        fontSize: AppSize.font12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      const SizedBox(height: AppSize.space4),
      AppTextField(
        controller: controller,
        hintText: hint,
        height: 32,
        isDense: true,
        fillColor: AppColors.backGroundWhite,
        filled: true,
        borderRadius: AppSize.radius8,
      ),
    ],
  );
}
