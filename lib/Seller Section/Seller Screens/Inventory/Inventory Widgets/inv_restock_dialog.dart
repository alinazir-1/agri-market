// ── 10. Restock Dialog ───────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class InvRestockDialog extends StatelessWidget {
  final String productName;
  final String unit;
  final TextEditingController controller;
  final VoidCallback onConfirm;

  const InvRestockDialog({
    super.key,
    required this.productName,
    required this.unit,
    required this.controller,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Padding(
        padding: const EdgeInsets.all(CSize.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Restock Product',
                style: TextStyle(
                    fontSize: CSize.font16Medium,
                    fontWeight: FontWeight.w800,
                    color: CColors.textPrimary)),
            const SizedBox(height: CSize.space4),
            Text(productName,
                style: const TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
            const SizedBox(height: CSize.space16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontSize: CSize.font13Small, color: CColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Quantity to add ($unit)',
                labelStyle: const TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary),
                suffixText: unit,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    borderSide: const BorderSide(
                        color: CColors.borderEmeraldGreen,
                        width: CSize.borderWidth1)),
              ),
            ),
            const SizedBox(height: CSize.space16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CSize.radius10Medium)),
                      padding:
                          const EdgeInsets.symmetric(vertical: CSize.space12),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            color: CColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: CSize.space12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CColors.backGroundEmeraldGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CSize.radius10Medium)),
                      padding:
                          const EdgeInsets.symmetric(vertical: CSize.space12),
                      elevation: 0,
                    ),
                    child: const Text('Confirm',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w700,
                            color: CColors.textWhite)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
