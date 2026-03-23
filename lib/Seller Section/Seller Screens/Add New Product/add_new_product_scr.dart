import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import 'add_new_product_con.dart';

class AddNewProductScr extends StatelessWidget {
  AddNewProductScr({super.key});

  final AddNewProductCon newProductController = Get.put(AddNewProductCon());
  // ── Dropdown options ──
  final List<String> categories = [
    'Grains & Cereals',
    'Fruits',
    'Vegetables',
    'Spices',
  ];
  final List<String> grades = ['Grade A+', 'Grade A', 'Grade B+', 'Grade B'];
  final List<String> storageOptions = [
    'Room Temperature',
    'Cold Storage',
    'Refrigerated',
  ];
  final List<String> unitOptions = ['Ton', 'Kg', 'Box', 'Bag', 'Quintal'];
  final List<String> currencyOptions = ['USD (\$)', 'PKR (₨)', 'INR (₹)'];
  final List<String> countries = ['Pakistan', 'India', 'Bangladesh'];
  final List<String> deliveryOptions = [
    'Seller Delivers',
    'Buyer Picks Up',
    'Both Available',
  ];
  final List<String> sampleUnits = ['kg', 'g', 'box', 'pack', 'Ton'];
  final List<String> dispatchTimes = [
    'Within 24 hours',
    '2–3 business days',
    'Within 1 week',
    'Custom',
  ];
  final List<String> deliveryCoveredBy = [
    'Seller pays delivery',
    'Buyer pays delivery',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar ──
            _topBar(),
            const SizedBox(height: CSize.space20),

            // ── Main Layout: Left + Sidebar ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left main column
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      _basicInfoCard(),
                      const SizedBox(height: CSize.space16),
                      _qualityHarvestCard(),
                      const SizedBox(height: CSize.space16),
                      _specificationsCard(),
                      const SizedBox(height: CSize.space16),
                      _sampleCard(),
                      const SizedBox(height: CSize.space16),
                      _pricingCard(),
                      const SizedBox(height: CSize.space16),
                      _locationCard(),
                    ],
                  ),
                ),

                const SizedBox(width: CSize.space18),

                // Sidebar
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      _imagesCard(),
                      const SizedBox(height: CSize.space16),
                      _tagsCard(),
                      const SizedBox(height: CSize.space16),
                      _tipBox(),
                      const SizedBox(height: CSize.space16),
                      _formCompletionCard(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Product",
              style: TextStyle(
                fontSize: CSize.font24Large,
                fontWeight: FontWeight.w800,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(height: CSize.space2),
            Text(
              "Fill in the details to list your product on the marketplace",
              style: TextStyle(
                fontSize: CSize.font13Small,
                color: CColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Save as Draft
            OutlinedButton.icon(
              onPressed: newProductController.saveDraft,
              icon: const Icon(
                Icons.save_outlined,
                size: CSize.icon16Small,
                color: CColors.textPrimary,
              ),
              label: const Text(
                "Save as Draft",
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w700,
                  color: CColors.textPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: CColors.borderGray,
                  width: CSize.borderWidth1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space20,
                  vertical: CSize.space12,
                ),
              ),
            ),

            const SizedBox(width: CSize.space10),

            // Publish Product
            ElevatedButton.icon(
              onPressed: newProductController.publishProduct,
              icon: const Icon(
                Icons.send_rounded,
                size: CSize.icon16Small,
                color: CColors.textWhite,
              ),
              label: const Text(
                "Publish Product",
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w700,
                  color: CColors.textWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CColors.backGroundEmeraldGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space20,
                  vertical: CSize.space12,
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SHARED HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
    String? subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: CColors.borderGray,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space18,
              vertical: CSize.space12,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: CColors.backgroundEmerald100,
                        borderRadius: BorderRadius.circular(CSize.radius5Small),
                      ),
                      child: Icon(
                        icon,
                        size: CSize.icon16Small,
                        color: CColors.iconEmeraldGreen,
                      ),
                    ),
                    const SizedBox(width: CSize.space8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: CSize.font13Small,
                        fontWeight: FontWeight.w800,
                        color: CColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: CColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(CSize.space18), child: child),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label, {bool required = false, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CSize.space5),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: CColors.textPrimary,
            ),
          ),
          if (required)
            const Text(
              " *",
              style: TextStyle(color: CColors.textError, fontSize: 11),
            ),
          if (hint != null)
            Text(
              "  $hint",
              style: const TextStyle(
                fontSize: 10,
                color: CColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String? placeholder,
    String? prefixText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
      decoration: InputDecoration(
        hintText: placeholder,
        prefixText: prefixText,
        hintStyle: const TextStyle(fontSize: 11, color: CColors.textSecondary),
        prefixStyle: const TextStyle(
          fontSize: 11,
          color: CColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: CSize.space12,
          vertical: CSize.space8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          borderSide: const BorderSide(
            color: CColors.borderGray,
            width: CSize.borderWidth1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          borderSide: const BorderSide(
            color: CColors.borderGray,
            width: CSize.borderWidth1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          borderSide: const BorderSide(
            color: CColors.borderEmeraldGreen,
            width: CSize.borderWidth1,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required RxString value,
    required List<String> items,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: value.value.isEmpty ? null : value.value,
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 11, color: CColors.textSecondary),
        ),
        style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            borderSide: const BorderSide(
              color: CColors.borderGray,
              width: CSize.borderWidth1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            borderSide: const BorderSide(
              color: CColors.borderGray,
              width: CSize.borderWidth1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            borderSide: const BorderSide(
              color: CColors.borderEmeraldGreen,
              width: CSize.borderWidth1,
            ),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => value.value = val ?? '',
      ),
    );
  }

  Widget _row2({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: CSize.space12),
        Expanded(child: right),
      ],
    );
  }

  Widget _row3({required Widget a, required Widget b, required Widget c}) {
    return Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: CSize.space12),
        Expanded(child: b),
        const SizedBox(width: CSize.space12),
        Expanded(child: c),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BASIC INFO
  // ══════════════════════════════════════════════════════════════════════════

  Widget _basicInfoCard() {
    return _card(
      title: "Basic Information",
      icon: Icons.description_outlined,
      child: Column(
        children: [
          _row2(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Product Name", required: true),
                _textField(
                  controller: newProductController.productNameController,
                  placeholder: "e.g. Premium Basmati Rice",
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Category", required: true),
                _dropdown(
                  hint: "Select Category",
                  value: newProductController.selectedCategory,
                  items: categories,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          _row2(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Product Variety", hint: "(optional)"),
                _textField(
                  controller: newProductController.varietyController,
                  placeholder: "e.g. Basmati, Long Grain",
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("SKU / Product Code", hint: "(optional)"),
                _textField(
                  controller: newProductController.skuController,
                  placeholder: "e.g. WHT-001",
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel("Product Description"),
              _textField(
                controller: newProductController.descriptionController,
                placeholder:
                    "Describe your product — quality, packaging, special features...",
                maxLines: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  QUALITY & HARVEST
  // ══════════════════════════════════════════════════════════════════════════

  Widget _qualityHarvestCard() {
    return _card(
      title: "Quality and Harvest",
      icon: Icons.star_outline_rounded,
      child: Column(
        children: [
          _row3(
            a: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Quality / Grade", required: true),
                _dropdown(
                  hint: "Select Grade",
                  value: newProductController.selectedGrade,
                  items: grades,
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Harvest Date"),
                Obx(
                  () => InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null)
                        newProductController.harvestDate.value = picked;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space12,
                        vertical: CSize.space8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        border: Border.all(
                          color: CColors.borderGray,
                          width: CSize.borderWidth1,
                        ),
                        borderRadius: BorderRadius.circular(
                          CSize.radius10Medium,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: CSize.icon16Small,
                            color: CColors.iconEmeraldGreen,
                          ),
                          const SizedBox(width: CSize.space8),
                          Text(
                            newProductController.harvestDate.value != null
                                ? "${newProductController.harvestDate.value!.day}/${newProductController.harvestDate.value!.month}/${newProductController.harvestDate.value!.year}"
                                : "DD / MM / YYYY",
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  newProductController.harvestDate.value != null
                                      ? CColors.textPrimary
                                      : CColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Storage Condition"),
                _dropdown(
                  hint: "Select Condition",
                  value: newProductController.selectedStorageCondition,
                  items: storageOptions,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          _row2(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Certifications", hint: "(optional)"),
                _textField(
                  controller: newProductController.certificationsController,
                  placeholder: "e.g. Organic, ISO 9001, Halal",
                ),
                const SizedBox(height: CSize.space2),
                const Text(
                  "Separate multiple with commas",
                  style: TextStyle(fontSize: 10, color: CColors.textSecondary),
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Crop Year", hint: "(optional)"),
                _textField(
                  controller: newProductController.cropYearController,
                  placeholder: "e.g. 2025",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SPECIFICATIONS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _specificationsCard() {
    return _card(
      title: "Product Specifications",
      icon: Icons.table_chart_outlined,
      subtitle: "Add nutritional & quality specs",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick add chips
          const Text(
            "QUICK ADD — COMMON SPECS",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: CColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: CSize.space8),

          Wrap(
            spacing: CSize.space8,
            runSpacing: CSize.space8,
            children: newProductController.quickSpecChips
                .map(
                  (chip) => InkWell(
                    onTap: () => newProductController.addSpecFromChip(chip),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space10,
                        vertical: CSize.space4,
                      ),
                      decoration: BoxDecoration(
                        color: CColors.backgroundEmerald100,
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius: BorderRadius.circular(
                          CSize.radius20Large,
                        ),
                      ),
                      child: Text(
                        chip,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: CColors.textEmeraldGreen,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: CSize.space16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: CSize.space12),

          // Column labels
          Row(
            children: const [
              Expanded(
                child: Text(
                  "SPECIFICATION NAME",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: CColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(width: CSize.space8),
              Expanded(
                child: Text(
                  "VALUE",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: CColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(width: CSize.space8),
              SizedBox(
                width: 100,
                child: Text(
                  "UNIT",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: CColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(width: CSize.space8),
              SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: CSize.space8),

          // Spec rows + add button wrapped in Obx for length changes
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newProductController.specNameControllers.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: CSize.space8),
                    child: Row(
                      children: [
                        // Name field
                        Expanded(
                          child: TextField(
                            controller:
                                newProductController.specNameControllers[i],
                            style: const TextStyle(
                              fontSize: 11,
                              color: CColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "e.g. Fiber, Iron...",
                              hintStyle: const TextStyle(
                                fontSize: 11,
                                color: CColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: CSize.space12,
                                vertical: CSize.space8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderGray,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderGray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderEmeraldGreen,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: CSize.space8),

                        // Value field
                        Expanded(
                          child: TextField(
                            controller:
                                newProductController.specValueControllers[i],
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 11,
                              color: CColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "e.g. 12.5",
                              hintStyle: const TextStyle(
                                fontSize: 11,
                                color: CColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: CSize.space12,
                                vertical: CSize.space8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderGray,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderGray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderEmeraldGreen,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: CSize.space8),

                        // Unit dropdown
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField<String>(
                            value: newProductController.specUnits[i],
                            style: const TextStyle(
                              fontSize: 11,
                              color: CColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: CSize.space8,
                                vertical: CSize.space8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderGray,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderGray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  CSize.radius10Medium,
                                ),
                                borderSide: const BorderSide(
                                  color: CColors.borderEmeraldGreen,
                                ),
                              ),
                            ),
                            items: newProductController.unitOptions
                                .map(
                                  (u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => newProductController
                                .updateSpecUnit(i, val ?? '%'),
                          ),
                        ),

                        const SizedBox(width: CSize.space8),

                        // Delete button
                        InkWell(
                          onTap: () => newProductController.removeSpec(i),
                          borderRadius: BorderRadius.circular(
                            CSize.radius10Medium,
                          ),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(color: CColors.borderError),
                              borderRadius: BorderRadius.circular(
                                CSize.radius10Medium,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              size: CSize.icon16Small,
                              color: CColors.iconError,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Add another button
              InkWell(
                onTap: newProductController.addEmptySpec,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: CSize.space10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFBBF7D0),
                      width: CSize.borderWidth1,
                    ),
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    color: CColors.backgroundEmerald100,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: CSize.icon16Small,
                        color: CColors.iconEmeraldGreen,
                      ),
                      SizedBox(width: CSize.space5),
                      Text(
                        "Add Another Specification",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CColors.textEmeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SAMPLE AVAILABILITY
  // ══════════════════════════════════════════════════════════════════════════

  Widget _sampleCard() {
    return _card(
      title: "Sample Availability",
      icon: Icons.science_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle
          Obx(
            () => InkWell(
              onTap: () => newProductController.sampleAvailable.toggle(),
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space14,
                  vertical: CSize.space12,
                ),
                decoration: BoxDecoration(
                  color: newProductController.sampleAvailable.value
                      ? CColors.backgroundEmerald100
                      : CColors.backGroundWhite,
                  border: Border.all(
                    color: newProductController.sampleAvailable.value
                        ? CColors.borderEmeraldGreen
                        : CColors.borderGray,
                    width: CSize.borderWidth1,
                  ),
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                ),
                child: Row(
                  children: [
                    Switch(
                      value: newProductController.sampleAvailable.value,
                      onChanged: (val) =>
                          newProductController.sampleAvailable.value = val,
                      activeColor: CColors.backGroundEmeraldGreen,
                    ),
                    const SizedBox(width: CSize.space8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newProductController.sampleAvailable.value
                              ? "Sample Available"
                              : "Sample Not Available",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: CColors.textPrimary,
                          ),
                        ),
                        const Text(
                          "Buyers can request a sample before placing a bulk order",
                          style: TextStyle(
                            fontSize: 10,
                            color: CColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sample fields (shown when toggle is on)
          Obx(
            () => newProductController.sampleAvailable.value
                ? Column(
                    children: [
                      const SizedBox(height: CSize.space12),
                      _row3(
                        a: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Sample Quantity", required: true),
                            _textField(
                              controller:
                                  newProductController.sampleQtyController,
                              placeholder: "e.g. 1",
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        b: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Sample Unit"),
                            _dropdown(
                              hint: "Select Unit",
                              value: newProductController.selectedSampleUnit,
                              items: sampleUnits,
                            ),
                          ],
                        ),
                        c: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Sample Price"),
                            _textField(
                              controller:
                                  newProductController.samplePriceController,
                              placeholder: "0.00 or Free",
                              prefixText: "\$ ",
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CSize.space12),
                      _row2(
                        left: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Sample Dispatch Time"),
                            _dropdown(
                              hint: "Select Timeframe",
                              value: newProductController.selectedDispatchTime,
                              items: dispatchTimes,
                            ),
                          ],
                        ),
                        right: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Delivery Covered By"),
                            _dropdown(
                              hint: "Select",
                              value: newProductController
                                  .selectedDeliveryCoveredBy,
                              items: deliveryCoveredBy,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CSize.space12),
                      Container(
                        padding: const EdgeInsets.all(CSize.space12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                          borderRadius: BorderRadius.circular(
                            CSize.radius10Medium,
                          ),
                        ),
                        child: const Text(
                          "Note: Enabling sample requests increases buyer trust and conversion. Buyers will be able to request a sample directly from your product page. You will be notified via dashboard when a request is made.",
                          style: TextStyle(
                            fontSize: 10,
                            color: CColors.textBlue700,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  PRICING & QUANTITY
  // ══════════════════════════════════════════════════════════════════════════

  Widget _pricingCard() {
    return _card(
      title: "Pricing and Quantity",
      icon: Icons.attach_money_rounded,
      child: Column(
        children: [
          _row3(
            a: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Price Per Unit", required: true),
                _textField(
                  controller: newProductController.priceController,
                  placeholder: "0.00",
                  prefixText: "\$ ",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Unit Type", required: true),
                _dropdown(
                  hint: "Select Unit",
                  value: newProductController.selectedUnit,
                  items: unitOptions,
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Currency"),
                _dropdown(
                  hint: "Select",
                  value: newProductController.selectedCurrency,
                  items: currencyOptions,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          _row2(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Available Quantity", required: true),
                _textField(
                  controller: newProductController.quantityController,
                  placeholder: "e.g. 500",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Minimum Order Quantity"),
                _textField(
                  controller: newProductController.moqController,
                  placeholder: "e.g. 50",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  LOCATION & DELIVERY
  // ══════════════════════════════════════════════════════════════════════════

  Widget _locationCard() {
    return _card(
      title: "Location and Delivery",
      icon: Icons.location_on_outlined,
      child: Column(
        children: [
          _row3(
            a: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Country", required: true),
                _dropdown(
                  hint: "Select Country",
                  value: newProductController.selectedCountry,
                  items: countries,
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Region / State", required: true),
                _textField(
                  controller: newProductController.regionController,
                  placeholder: "e.g. Punjab",
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("City / District"),
                _textField(
                  controller: newProductController.cityController,
                  placeholder: "e.g. Lahore",
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          _row2(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Delivery Option"),
                _dropdown(
                  hint: "Select Option",
                  value: newProductController.selectedDeliveryOption,
                  items: deliveryOptions,
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Delivery Timeframe", hint: "(optional)"),
                _textField(
                  controller: newProductController.deliveryTimeController,
                  placeholder: "e.g. 3–5 business days",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SIDEBAR — IMAGES
  // ══════════════════════════════════════════════════════════════════════════

  Widget _imagesCard() {
    return _card(
      title: "Product Images",
      icon: Icons.image_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // your image picker logic here
            },
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: CSize.space28),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD1FAE5), width: 2),
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                color: CColors.backgroundEmerald100,
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.upload_file_outlined,
                    size: CSize.icon24Large,
                    color: CColors.iconEmeraldGreen,
                  ),
                  SizedBox(height: CSize.space8),
                  Text(
                    "Click to Upload",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: CColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: CSize.space2),
                  Text(
                    "PNG, JPG, WEBP — max 5MB",
                    style: TextStyle(
                      fontSize: 10,
                      color: CColors.textSecondary,
                    ),
                  ),
                  Text(
                    "Up to 5 images allowed",
                    style: TextStyle(
                      fontSize: 10,
                      color: CColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: CSize.space12),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CColors.borderGray,
                      borderRadius: BorderRadius.circular(CSize.radius10Medium),
                      border: Border.all(
                        color: CColors.borderGray,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: CColors.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: CSize.space8),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CColors.borderGray,
                      borderRadius: BorderRadius.circular(CSize.radius10Medium),
                      border: Border.all(color: CColors.borderGray),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: CColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CSize.space8),
          const Text(
            "First image will be the cover photo",
            style: TextStyle(fontSize: 10, color: CColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SIDEBAR — TAGS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _tagsCard() {
    return _card(
      title: "Tags",
      icon: Icons.label_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: newProductController.tagInputController,
            style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
            onSubmitted: newProductController.addTag,
            decoration: InputDecoration(
              hintText: "Add a tag and press Enter",
              hintStyle: const TextStyle(
                fontSize: 11,
                color: CColors.textSecondary,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: CSize.space12,
                vertical: CSize.space8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: CColors.borderGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: CColors.borderGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: CColors.borderEmeraldGreen),
              ),
            ),
          ),
          const SizedBox(height: CSize.space8),
          Obx(
            () => Wrap(
              spacing: CSize.space5,
              runSpacing: CSize.space5,
              children: [
                ...newProductController.tags.map(
                  (tag) => InkWell(
                    onTap: () => newProductController.removeTag(tag),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space10,
                        vertical: CSize.space4,
                      ),
                      decoration: BoxDecoration(
                        color: CColors.backgroundEmerald100,
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius: BorderRadius.circular(
                          CSize.radius20Large,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: CColors.textEmeraldGreen,
                            ),
                          ),
                          const SizedBox(width: CSize.space4),
                          const Icon(
                            Icons.close,
                            size: 10,
                            color: CColors.iconEmeraldGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => newProductController.addTag(
                    newProductController.tagInputController.text,
                  ),
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space10,
                      vertical: CSize.space4,
                    ),
                    decoration: BoxDecoration(
                      color: CColors.backGroundLightGrey,
                      border: Border.all(
                        color: CColors.borderGray,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                    ),
                    child: const Text(
                      "+ Add",
                      style: TextStyle(
                        fontSize: 10,
                        color: CColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SIDEBAR — TIP BOX
  // ══════════════════════════════════════════════════════════════════════════

  Widget _tipBox() {
    return Container(
      padding: const EdgeInsets.all(CSize.space12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFDE68A)),
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: CSize.icon16Small,
                color: Color(0xFF92400E),
              ),
              SizedBox(width: CSize.space5),
              Text(
                "Tips for better listings",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          SizedBox(height: CSize.space4),
          Text(
            "- Add specs like Moisture & Protein to attract serious buyers\n"
            "- Offer free samples to increase inquiries\n"
            "- Use clear, high-quality images\n"
            "- Accurate grade helps buyers find you",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF78350F),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SIDEBAR — FORM COMPLETION
  // ══════════════════════════════════════════════════════════════════════════

  Widget _formCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(CSize.space14),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: CColors.borderGray,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Form Completion",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: CColors.textPrimary,
            ),
          ),
          const SizedBox(height: CSize.space8),
          Obx(() {
            final pct = newProductController.formCompletion.value;
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: CSize.space5,
                    backgroundColor: CColors.borderGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      CColors.backGroundEmeraldGreen,
                    ),
                  ),
                ),
                const SizedBox(height: CSize.space4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(pct * 100).toInt()}% complete",
                      style: const TextStyle(
                        fontSize: 10,
                        color: CColors.textSecondary,
                      ),
                    ),
                    Text(
                      "${(pct * 18).toInt()} / 18 fields",
                      style: const TextStyle(
                        fontSize: 10,
                        color: CColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
