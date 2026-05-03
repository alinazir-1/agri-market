import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';

class BusinessProfileCon extends GetxController {
  final isEditing = false.obs;
  final isSaving = false.obs;

  // ── Form controllers ───────────────────────────────────────────────────────
  final businessName = TextEditingController(text: 'Green Valley Farms');
  final ownerName = TextEditingController(text: 'Ahmad Sultan');
  final email = TextEditingController(text: 'ahmad@greenvalleyfarms.com');
  final phone = TextEditingController(text: '+92 300 1234567');
  final whatsapp = TextEditingController(text: '+92 300 1234567');
  final website = TextEditingController(text: 'www.greenvalleyfarms.com');
  final regNumber = TextEditingController(text: 'REG-2021-AGR-00124');
  final taxNumber = TextEditingController(text: 'NTN-2948710-3');
  final addressLine1 = TextEditingController(text: 'Plot 45, Block C');
  final addressLine2 = TextEditingController(text: 'Industrial Area, Gulberg');
  final city = TextEditingController(text: 'Lahore');
  final state = TextEditingController(text: 'Punjab');
  final pincode = TextEditingController(text: '54000');
  final country = TextEditingController(text: 'Pakistan');
  final bankName = TextEditingController(text: 'Habib Bank Limited');
  final accountTitle = TextEditingController(text: 'Ahmad Sultan');
  final accountNumber = TextEditingController(text: '0123-4567891-03');
  final ifscCode = TextEditingController(text: 'HBL-0001234');
  final upiId = TextEditingController(text: 'ahmad@hbl');

  // ── Category ───────────────────────────────────────────────────────────────
  final selectedCategory = 'Grains & Cereals'.obs;
  final categories = const [
    'Grains & Cereals',
    'Fresh Produce',
    'Legumes',
    'Oil Seeds',
    'Dairy & Eggs',
    'Spices & Herbs',
    'Live Stock',
    'Animal Feed',
    'Other',
  ];

  // ── Actions ────────────────────────────────────────────────────────────────
  void toggleEdit() => isEditing.toggle();

  void cancelEdit() => isEditing.value = false;

  Future<void> saveProfile() async {
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isSaving.value = false;
    isEditing.value = false;
    Get.snackbar(
      'Profile Saved',
      'Your business profile has been updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.emeraldGreen,
      colorText: AppColors.textWhite,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
    );
  }

  @override
  void onClose() {
    businessName.dispose();
    ownerName.dispose();
    email.dispose();
    phone.dispose();
    whatsapp.dispose();
    website.dispose();
    regNumber.dispose();
    taxNumber.dispose();
    addressLine1.dispose();
    addressLine2.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    country.dispose();
    bankName.dispose();
    accountTitle.dispose();
    accountNumber.dispose();
    ifscCode.dispose();
    upiId.dispose();
    super.onClose();
  }
}
