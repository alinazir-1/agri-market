import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/batch_model.dart';
import 'package:agri_market/features/seller/add_product/add_new_product_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_outlined_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const List<String> _batchDialogUnitOptions = [
  'Ton',
  'Kg',
  'Box',
  'Bag',
  'Quintal',
];

/// Dialog-scoped controller; disposed when the dialog closes.
class AddBatchDialogCon extends GetxController {
  final AddNewProductCon main = Get.find<AddNewProductCon>();

  late final String batchCode;
  final batchCodeDisplayController = TextEditingController();
  final sourceStateController = TextEditingController();
  final gradeController = TextEditingController();
  final quantityController = TextEditingController();
  final pricePerUnitController = TextEditingController();
  final RxString unit = 'Ton'.obs;
  final RxString status = 'available'.obs;
  final RxBool isSaving = false.obs;
  final RxInt specRevision = 0.obs;

  final specKeyControllers = <TextEditingController>[];
  final specValueControllers = <TextEditingController>[];

  @override
  void onInit() {
    super.onInit();
    batchCode = main.nextBatchCodeForAddBatchDialog();
    batchCodeDisplayController.text = batchCode;
    gradeController.text = main.selectedGrade.value;
    final u = main.selectedUnit.value.trim();
    unit.value = u.isEmpty ? 'Ton' : u;
    if (!_batchDialogUnitOptions.contains(unit.value)) {
      unit.value = 'Ton';
    }
    specKeyControllers.add(TextEditingController());
    specValueControllers.add(TextEditingController());
  }

  void addSpecRow() {
    specKeyControllers.add(TextEditingController());
    specValueControllers.add(TextEditingController());
    specRevision.value++;
  }

  void removeSpecRow(int index) {
    if (specKeyControllers.length <= 1) return;
    specKeyControllers.removeAt(index).dispose();
    specValueControllers.removeAt(index).dispose();
    specRevision.value++;
  }

  Future<void> save() async {
    if (isSaving.value) return;
    if (sourceStateController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Source state is required.');
      return;
    }
    final qty = double.tryParse(quantityController.text.trim()) ?? 0;
    if (qty <= 0) {
      Get.snackbar('Validation', 'Quantity must be greater than zero.');
      return;
    }
    final price = double.tryParse(pricePerUnitController.text.trim()) ?? 0;
    if (price < 0) {
      Get.snackbar('Validation', 'Price per unit cannot be negative.');
      return;
    }
    isSaving.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final specs = <String, String>{};
      for (var i = 0; i < specKeyControllers.length; i++) {
        final k = specKeyControllers[i].text.trim();
        final v = specValueControllers[i].text.trim();
        if (k.isNotEmpty && v.isNotEmpty) {
          specs[k] = v;
        }
      }
      main.addBatch(
        BatchModel(
          batchCode: batchCode,
          sourceState: sourceStateController.text.trim(),
          grade: gradeController.text.trim(),
          quantity: qty,
          pricePerUnit: price,
          unit: unit.value,
          status: status.value,
          specifications: specs,
        ),
      );
      Get.back<void>();
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    batchCodeDisplayController.dispose();
    sourceStateController.dispose();
    gradeController.dispose();
    quantityController.dispose();
    pricePerUnitController.dispose();
    for (final c in specKeyControllers) {
      c.dispose();
    }
    for (final c in specValueControllers) {
      c.dispose();
    }
    specKeyControllers.clear();
    specValueControllers.clear();
    super.onClose();
  }
}

Future<void> showAddBatchDialog() async {
  if (Get.isRegistered<AddBatchDialogCon>()) {
    Get.delete<AddBatchDialogCon>();
  }
  Get.put(AddBatchDialogCon());
  await Get.dialog<void>(
    const AddBatchDialog(),
    barrierDismissible: false,
  );
  if (Get.isRegistered<AddBatchDialogCon>()) {
    Get.delete<AddBatchDialogCon>();
  }
}

class AddBatchDialog extends StatelessWidget {
  const AddBatchDialog({super.key});

  static const TextStyle _inputStyle = TextStyle(
    fontSize: AppSize.font12,
    color: AppColors.textPrimary,
  );

  @override
  Widget build(BuildContext context) {
    final d = Get.find<AddBatchDialogCon>();
    final mq = MediaQuery.sizeOf(context);
    final dialogH = mq.height * 0.85 < 640 ? mq.height * 0.85 : 640.0;
    final dialogW = mq.width * 0.92 < 560 ? mq.width * 0.92 : 560.0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radius8),
      ),
      backgroundColor: AppColors.backgroundSurface,
      child: SizedBox(
        width: dialogW,
        height: dialogH,
        child: AppContainer(
          padding: const EdgeInsets.all(AppSize.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppText(
                text: 'Add Batch',
                fontSize: AppSize.font16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSize.space16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _dialogField(
                        label: 'Batch code',
                        controller: d.batchCodeDisplayController,
                        hint: '',
                        readOnly: true,
                      ),
                      const SizedBox(height: AppSize.space12),
                      _dialogField(
                        label: 'Source state',
                        controller: d.sourceStateController,
                        hint: 'e.g. Punjab',
                      ),
                      const SizedBox(height: AppSize.space12),
                      _dialogField(
                        label: 'Grade',
                        controller: d.gradeController,
                        hint: 'Grade',
                      ),
                      const SizedBox(height: AppSize.space12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final narrow = constraints.maxWidth < 420;
                          final qty = _dialogField(
                            label: 'Quantity',
                            controller: d.quantityController,
                            hint: '0',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          );
                          final unitDd = Obx(() {
                            final cur = d.unit.value;
                            final safe = _batchDialogUnitOptions.contains(cur)
                                ? cur
                                : _batchDialogUnitOptions.first;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText(
                                  text: 'Unit',
                                  fontSize: AppSize.font12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: AppSize.space4),
                                SizedBox(
                                  height: 32,
                                  child: DropdownButtonFormField<String>(
                                    value: safe,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: AppColors.backGroundWhite,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: AppSize.space12,
                                        vertical: AppSize.space8,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSize.radius8,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.borderGray,
                                        ),
                                      ),
                                    ),
                                    items: _batchDialogUnitOptions
                                        .map(
                                          (u) => DropdownMenuItem(
                                            value: u,
                                            child: AppText(
                                              text: u,
                                              fontSize: AppSize.font12,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) d.unit.value = v;
                                    },
                                  ),
                                ),
                              ],
                            );
                          });
                          if (narrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                qty,
                                const SizedBox(height: AppSize.space12),
                                unitDd,
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: qty),
                              const SizedBox(width: AppSize.space12),
                              Expanded(flex: 2, child: unitDd),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSize.space12),
                      _dialogField(
                        label: 'Price per unit',
                        controller: d.pricePerUnitController,
                        hint: '0',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: AppSize.space12),
                      Obx(() {
                        final cur = d.status.value;
                        final safe =
                            cur == 'coming_soon' ? 'coming_soon' : 'available';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              text: 'Status',
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSize.space4),
                            SizedBox(
                              height: 32,
                              child: DropdownButtonFormField<String>(
                                value: safe,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.backGroundWhite,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.space12,
                                    vertical: AppSize.space8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSize.radius8,
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColors.borderGray,
                                    ),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'available',
                                    child: AppText(
                                      text: 'Available',
                                      fontSize: AppSize.font12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'coming_soon',
                                    child: AppText(
                                      text: 'Coming Soon',
                                      fontSize: AppSize.font12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) d.status.value = v;
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: AppSize.space16),
                      Row(
                        children: [
                          const AppText(
                            text: 'Specifications (optional)',
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: d.addSpecRow,
                            child: AppContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.space8,
                                vertical: AppSize.space4,
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppSize.radius4),
                              border: Border.all(color: AppColors.borderLight),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    size: 14,
                                    color: AppColors.iconEmeraldGreen,
                                  ),
                                  SizedBox(width: AppSize.space4),
                                  AppText(
                                    text: 'Add row',
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.space8),
                      Obx(() {
                        d.specRevision.value;
                        return Column(
                          children: [
                            for (var i = 0;
                                i < d.specKeyControllers.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSize.space8,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _dialogField(
                                        label: i == 0 ? 'Key' : '',
                                        controller: d.specKeyControllers[i],
                                        hint: 'Name',
                                      ),
                                    ),
                                    const SizedBox(width: AppSize.space8),
                                    Expanded(
                                      child: _dialogField(
                                        label: i == 0 ? 'Value' : '',
                                        controller: d.specValueControllers[i],
                                        hint: 'Value',
                                      ),
                                    ),
                                    const SizedBox(width: AppSize.space4),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSize.space20,
                                      ),
                                      child: InkWell(
                                        onTap: () => d.removeSpecRow(i),
                                        child: AppContainer(
                                          width: 32,
                                          height: 32,
                                          borderRadius: BorderRadius.circular(
                                            AppSize.radius8,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              size: 18,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSize.space20),
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
                      onPressed: d.save,
                      isLoading: d.isSaving.value,
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
    );
  }

  static Widget _dialogField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          AppText(
            text: label,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        if (label.isNotEmpty) const SizedBox(height: AppSize.space4),
        AppTextField(
          controller: controller,
          hintText: hint,
          keyboardType: keyboardType,
          readOnly: readOnly,
          height: 32,
          isDense: true,
          inputTextStyle: readOnly ? _inputStyle.copyWith(color: AppColors.textSecondary) : _inputStyle,
          fillColor: AppColors.backGroundWhite,
          filled: true,
          borderRadius: AppSize.radius8,
        ),
      ],
    );
  }
}
