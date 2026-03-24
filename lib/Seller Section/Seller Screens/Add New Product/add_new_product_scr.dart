import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import 'add_new_product_con.dart';

class AddNewProductScr extends StatelessWidget {
  AddNewProductScr({super.key});

  final AddNewProductCon c = Get.put(AddNewProductCon());

  // ── Dropdown options ──────────────────────────────────────────────────────
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
  final List<String> countries = ['Pakistan', 'India', 'Bangladesh', 'Kenya'];
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
      backgroundColor: context.appBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBar(context),
            const SizedBox(height: CSize.space20),
            // ── Listing Type Selector ──
            _listingTypeSelector(context),
            const SizedBox(height: CSize.space20),
            // ── Form (only when type selected) ──
            Obx(() => c.selectedListingType.value == null
                ? _noSelectionBanner(context)
                : _formLayout(context)),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add New Product",
              style: TextStyle(
                fontSize: CSize.font24Large,
                fontWeight: FontWeight.w800,
                color: context.txtPrimary,
              ),
            ),
            const SizedBox(height: CSize.space2),
            Text(
              "Select a listing type and fill in the details",
              style: TextStyle(
                fontSize: CSize.font13Small,
                color: context.txtSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: c.saveDraft,
              icon: Icon(
                Icons.save_outlined,
                size: CSize.icon16Small,
                color: context.txtPrimary,
              ),
              label: Text(
                "Save as Draft",
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary,
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
            ElevatedButton.icon(
              onPressed: c.publishProduct,
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
  //  LISTING TYPE SELECTOR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _listingTypeSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: context.borderClr),
      ),
      padding: const EdgeInsets.all(CSize.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: CColors.backgroundEmerald100,
                  borderRadius: BorderRadius.circular(CSize.radius5Small),
                ),
                child: const Icon(
                  Icons.category_outlined,
                  size: CSize.icon16Small,
                  color: CColors.iconEmeraldGreen,
                ),
              ),
              const SizedBox(width: CSize.space8),
              Text(
                "Select Listing Type",
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary,
                ),
              ),
              const SizedBox(width: CSize.space8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                ),
                child: const Text(
                  "Required",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CSize.space5),
          Text(
            "You must select a listing type before adding product details",
            style: TextStyle(fontSize: 10, color: context.txtSecondary),
          ),
          const SizedBox(height: CSize.space16),
          // Type cards
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _typeCard(
                      type: AddListingType.marketplace,
                      icon: Icons.storefront_outlined,
                      title: "Marketplace",
                      subtitle:
                          "List product for direct sale with fixed pricing",
                      color: const Color(0xFF059669),
                      bgColor: const Color(0xFFECFDF5),
                      borderColor: const Color(0xFF6EE7B7),
                      context: context,
                    ),
                  ),
                  const SizedBox(width: CSize.space12),
                  Expanded(
                    child: _typeCard(
                      type: AddListingType.advanceBooking,
                      icon: Icons.calendar_month_outlined,
                      title: "Advance Booking",
                      subtitle:
                          "Accept pre-orders for upcoming harvest or stock",
                      color: const Color(0xFF2563EB),
                      bgColor: const Color(0xFFEFF6FF),
                      borderColor: const Color(0xFF93C5FD),
                      context: context,
                    ),
                  ),
                  const SizedBox(width: CSize.space12),
                  Expanded(
                    child: _typeCard(
                      type: AddListingType.liveAuctions,
                      icon: Icons.show_chart_rounded,
                      title: "Live Auctions",
                      subtitle:
                          "Set a starting bid and let buyers compete in real-time",
                      color: const Color(0xFFD97706),
                      bgColor: const Color(0xFFFFFBEB),
                      borderColor: const Color(0xFFFCD34D),
                      context: context,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _typeCard({
    required AddListingType type,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required BuildContext context,
  }) {
    final isSelected = c.selectedListingType.value == type;
    return GestureDetector(
      onTap: () => c.selectListingType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(CSize.space16),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : context.cardBg2,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(
            color: isSelected ? borderColor : context.borderClr,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.15) : context.cardBg2,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                  ),
                  child: Icon(
                    icon,
                    size: CSize.icon16Small,
                    color: isSelected ? color : context.txtSecondary,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  )
                else
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.borderClr, width: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: CSize.space10),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected ? color : context.txtPrimary,
              ),
            ),
            const SizedBox(height: CSize.space4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: context.txtSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  NO SELECTION BANNER
  // ══════════════════════════════════════════════════════════════════════════

  Widget _noSelectionBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: CSize.space28,
        horizontal: CSize.space24,
      ),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: context.borderClr),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: CColors.backgroundEmerald100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.touch_app_outlined,
              size: 28,
              color: CColors.iconEmeraldGreen,
            ),
          ),
          const SizedBox(height: CSize.space14),
          Text(
            "Select a Listing Type to Continue",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.txtPrimary,
            ),
          ),
          const SizedBox(height: CSize.space8),
          Text(
            "Choose Marketplace, Advance Booking, or Live Auctions above\nto unlock the product listing form.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: context.txtSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  FORM LAYOUT (shown after type selection)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _formLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left main column ──
        Expanded(
          flex: 7,
          child: Obx(() {
            final type = c.selectedListingType.value;
            return Column(
              children: [
                _commonBasicInfoCard(),
                const SizedBox(height: CSize.space16),
                if (type == AddListingType.marketplace) ...[
                  _marketplaceExtraBasicCard(),
                  const SizedBox(height: CSize.space16),
                  _qualityHarvestCard(showHarvestDate: true),
                  const SizedBox(height: CSize.space16),
                  _specificationsCard(),
                  const SizedBox(height: CSize.space16),
                  _sampleCard(),
                  const SizedBox(height: CSize.space16),
                  _marketplacePricingCard(),
                  const SizedBox(height: CSize.space16),
                  _locationCard(showDelivery: true),
                ] else if (type == AddListingType.advanceBooking) ...[
                  _qualityHarvestCard(showHarvestDate: true, harvestRequired: true),
                  const SizedBox(height: CSize.space16),
                  _advanceBookingPricingCard(),
                  const SizedBox(height: CSize.space16),
                  _locationCard(showDelivery: true),
                ] else if (type == AddListingType.liveAuctions) ...[
                  _qualityHarvestCard(showHarvestDate: false),
                  const SizedBox(height: CSize.space16),
                  _auctionDetailsCard(),
                  const SizedBox(height: CSize.space16),
                  _locationCard(showDelivery: false),
                ],
              ],
            );
          }),
        ),
        const SizedBox(width: CSize.space18),
        // ── Sidebar ──
        SizedBox(
          width: 300,
          child: Column(
            children: [
              _imagesCard(),
              const SizedBox(height: CSize.space16),
              _tagsCard(),
              const SizedBox(height: CSize.space16),
              _tipBox(),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SHARED CARD SHELL
  // ══════════════════════════════════════════════════════════════════════════

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
    String? subtitle,
    Color? accentColor,
  }) {
    final accent = accentColor ?? CColors.iconEmeraldGreen;
    final accentBg = accentColor != null
        ? accentColor.withOpacity(0.1)
        : CColors.backgroundEmerald100;
    return Container(
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        color: accentBg,
                        borderRadius: BorderRadius.circular(CSize.radius5Small),
                      ),
                      child: Icon(icon, size: CSize.icon16Small, color: accent),
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
          Padding(
            padding: const EdgeInsets.all(CSize.space18),
            child: child,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SHARED FIELD HELPERS
  // ══════════════════════════════════════════════════════════════════════════

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
          borderSide: const BorderSide(color: CColors.borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          borderSide: const BorderSide(color: CColors.borderGray),
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
    void Function(String)? onChanged,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: value.value.isEmpty ? null : value.value,
        hint: Text(hint,
            style: const TextStyle(
                fontSize: 11, color: CColors.textSecondary)),
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
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) {
          if (val == null) return;
          if (onChanged != null) {
            onChanged(val);
          } else {
            value.value = val;
          }
        },
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

  Widget _datePicker({
    required Rx<DateTime?> value,
    required String placeholder,
  }) {
    return Obx(
      () => InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          );
          if (picked != null) value.value = picked;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: CColors.borderGray),
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
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
                value.value != null
                    ? "${value.value!.day}/${value.value!.month}/${value.value!.year}"
                    : placeholder,
                style: TextStyle(
                  fontSize: 11,
                  color: value.value != null
                      ? CColors.textPrimary
                      : CColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTimePicker({
    required Rx<DateTime?> value,
    required String placeholder,
  }) {
    return Obx(
      () => InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now().add(const Duration(days: 1)),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (date == null) return;
          final time = await showTimePicker(
            context: Get.context!,
            initialTime: TimeOfDay.now(),
          );
          if (time == null) return;
          value.value = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: CColors.borderGray),
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: CSize.icon16Small,
                color: CColors.iconEmeraldGreen,
              ),
              const SizedBox(width: CSize.space8),
              Expanded(
                child: Text(
                  value.value != null
                      ? "${value.value!.day}/${value.value!.month}/${value.value!.year}  ${value.value!.hour.toString().padLeft(2, '0')}:${value.value!.minute.toString().padLeft(2, '0')}"
                      : placeholder,
                  style: TextStyle(
                    fontSize: 11,
                    color: value.value != null
                        ? CColors.textPrimary
                        : CColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  COMMON BASIC INFO (all types)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _commonBasicInfoCard() {
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
                  controller: c.productNameController,
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
                  value: c.selectedCategory,
                  items: categories,
                  onChanged: c.onCategoryChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          // Sub Category
          Obx(() {
            final subs = c.currentSubCategories;
            return _row2(
              left: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Sub Category", required: true),
                  subs.isEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: CSize.space12,
                            vertical: CSize.space8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius:
                                BorderRadius.circular(CSize.radius10Medium),
                          ),
                          child: const Text(
                            "Select a category first",
                            style: TextStyle(
                              fontSize: 11,
                              color: CColors.textSecondary,
                            ),
                          ),
                        )
                      : _dropdown(
                          hint: "Select Sub Category",
                          value: c.selectedSubCategory,
                          items: subs,
                        ),
                ],
              ),
              right: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Product Description", hint: "(optional)"),
                  _textField(
                    controller: c.descriptionController,
                    placeholder: "Describe your product briefly...",
                    maxLines: 2,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  MARKETPLACE EXTRA BASIC (Variety, SKU)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _marketplaceExtraBasicCard() {
    return _card(
      title: "Product Details",
      icon: Icons.inventory_2_outlined,
      child: _row2(
        left: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel("Product Variety", hint: "(optional)"),
            _textField(
              controller: c.varietyController,
              placeholder: "e.g. Basmati, Long Grain",
            ),
          ],
        ),
        right: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel("SKU / Product Code", hint: "(optional)"),
            _textField(
              controller: c.skuController,
              placeholder: "e.g. WHT-001",
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  QUALITY & HARVEST
  // ══════════════════════════════════════════════════════════════════════════

  Widget _qualityHarvestCard({
    bool showHarvestDate = true,
    bool harvestRequired = false,
  }) {
    return _card(
      title: "Quality and Harvest",
      icon: Icons.star_outline_rounded,
      child: Column(
        children: [
          showHarvestDate
              ? _row3(
                  a: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel("Quality / Grade", required: true),
                      _dropdown(
                        hint: "Select Grade",
                        value: c.selectedGrade,
                        items: grades,
                      ),
                    ],
                  ),
                  b: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel(
                        "Harvest Date",
                        required: harvestRequired,
                      ),
                      _datePicker(
                        value: c.harvestDate,
                        placeholder: "DD / MM / YYYY",
                      ),
                    ],
                  ),
                  c: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel("Storage Condition"),
                      _dropdown(
                        hint: "Select Condition",
                        value: c.selectedStorageCondition,
                        items: storageOptions,
                      ),
                    ],
                  ),
                )
              : _row2(
                  left: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel("Quality / Grade", required: true),
                      _dropdown(
                        hint: "Select Grade",
                        value: c.selectedGrade,
                        items: grades,
                      ),
                    ],
                  ),
                  right: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel("Storage Condition"),
                      _dropdown(
                        hint: "Select Condition",
                        value: c.selectedStorageCondition,
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
                  controller: c.certificationsController,
                  placeholder: "e.g. Organic, ISO 9001, Halal",
                ),
                const SizedBox(height: CSize.space2),
                const Text(
                  "Separate multiple with commas",
                  style:
                      TextStyle(fontSize: 10, color: CColors.textSecondary),
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Crop Year", hint: "(optional)"),
                _textField(
                  controller: c.cropYearController,
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
  //  SPECIFICATIONS (Marketplace only)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _specificationsCard() {
    return _card(
      title: "Product Specifications",
      icon: Icons.table_chart_outlined,
      subtitle: "Add nutritional & quality specs",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            children: c.quickSpecChips
                .map(
                  (chip) => InkWell(
                    onTap: () => c.addSpecFromChip(chip),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space10,
                        vertical: CSize.space4,
                      ),
                      decoration: BoxDecoration(
                        color: CColors.backgroundEmerald100,
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius:
                            BorderRadius.circular(CSize.radius20Large),
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
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: c.specNameControllers.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: CSize.space8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: c.specNameControllers[i],
                          style: const TextStyle(
                              fontSize: 11, color: CColors.textPrimary),
                          decoration: _specInputDec("e.g. Fiber, Iron..."),
                        ),
                      ),
                      const SizedBox(width: CSize.space8),
                      Expanded(
                        child: TextField(
                          controller: c.specValueControllers[i],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 11, color: CColors.textPrimary),
                          decoration: _specInputDec("e.g. 12.5"),
                        ),
                      ),
                      const SizedBox(width: CSize.space8),
                      SizedBox(
                        width: 100,
                        child: Obx(() => DropdownButtonFormField<String>(
                              value: c.specUnits[i],
                              style: const TextStyle(
                                  fontSize: 11, color: CColors.textPrimary),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFAFAFA),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: CSize.space8,
                                  vertical: CSize.space8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      CSize.radius10Medium),
                                  borderSide: const BorderSide(
                                      color: CColors.borderGray),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      CSize.radius10Medium),
                                  borderSide: const BorderSide(
                                      color: CColors.borderGray),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      CSize.radius10Medium),
                                  borderSide: const BorderSide(
                                      color: CColors.borderEmeraldGreen),
                                ),
                              ),
                              items: c.unitOptions
                                  .map((u) => DropdownMenuItem(
                                      value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (val) =>
                                  c.updateSpecUnit(i, val ?? '%'),
                            )),
                      ),
                      const SizedBox(width: CSize.space8),
                      InkWell(
                        onTap: () => c.removeSpec(i),
                        borderRadius:
                            BorderRadius.circular(CSize.radius10Medium),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(color: CColors.borderError),
                            borderRadius:
                                BorderRadius.circular(CSize.radius10Medium),
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
                ),
              ),
              InkWell(
                onTap: c.addEmptySpec,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: CSize.space10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    color: CColors.backgroundEmerald100,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,
                          size: CSize.icon16Small,
                          color: CColors.iconEmeraldGreen),
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

  InputDecoration _specInputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 11, color: CColors.textSecondary),
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
      );

  // ══════════════════════════════════════════════════════════════════════════
  //  SAMPLE AVAILABILITY (Marketplace only)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _sampleCard() {
    return _card(
      title: "Sample Availability",
      icon: Icons.science_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => InkWell(
              onTap: () => c.sampleAvailable.toggle(),
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space14,
                  vertical: CSize.space12,
                ),
                decoration: BoxDecoration(
                  color: c.sampleAvailable.value
                      ? CColors.backgroundEmerald100
                      : CColors.backGroundWhite,
                  border: Border.all(
                    color: c.sampleAvailable.value
                        ? CColors.borderEmeraldGreen
                        : CColors.borderGray,
                  ),
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                ),
                child: Row(
                  children: [
                    Switch(
                      value: c.sampleAvailable.value,
                      onChanged: (val) => c.sampleAvailable.value = val,
                      activeColor: CColors.backGroundEmeraldGreen,
                    ),
                    const SizedBox(width: CSize.space8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.sampleAvailable.value
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
          Obx(
            () => c.sampleAvailable.value
                ? Column(
                    children: [
                      const SizedBox(height: CSize.space12),
                      _row3(
                        a: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Sample Quantity", required: true),
                            _textField(
                              controller: c.sampleQtyController,
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
                              value: c.selectedSampleUnit,
                              items: sampleUnits,
                            ),
                          ],
                        ),
                        c: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel("Sample Price"),
                            _textField(
                              controller: this.c.samplePriceController,
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
                              value: this.c.selectedDispatchTime,
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
                              value: this.c.selectedDeliveryCoveredBy,
                              items: deliveryCoveredBy,
                            ),
                          ],
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
  //  MARKETPLACE PRICING
  // ══════════════════════════════════════════════════════════════════════════

  Widget _marketplacePricingCard() {
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
                  controller: c.priceController,
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
                  value: c.selectedUnit,
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
                  value: c.selectedCurrency,
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
                  controller: c.quantityController,
                  placeholder: "e.g. 500",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Min Order Quantity", hint: "(MOQ)"),
                _textField(
                  controller: c.moqController,
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
  //  ADVANCE BOOKING PRICING
  // ══════════════════════════════════════════════════════════════════════════

  Widget _advanceBookingPricingCard() {
    return _card(
      title: "Booking & Pricing",
      icon: Icons.attach_money_rounded,
      accentColor: const Color(0xFF2563EB),
      child: Column(
        children: [
          _row3(
            a: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Booking Price", required: true),
                _textField(
                  controller: c.bookingPriceController,
                  placeholder: "0.00",
                  prefixText: "\$ ",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: CSize.space2),
                const Text(
                  "Advance amount to confirm booking",
                  style:
                      TextStyle(fontSize: 10, color: CColors.textSecondary),
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Total Estimated Price", required: true),
                _textField(
                  controller: c.totalEstimatedPriceController,
                  placeholder: "0.00",
                  prefixText: "\$ ",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: CSize.space2),
                const Text(
                  "Full price at delivery time",
                  style:
                      TextStyle(fontSize: 10, color: CColors.textSecondary),
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Currency"),
                _dropdown(
                  hint: "Select",
                  value: c.selectedCurrency,
                  items: currencyOptions,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          _row3(
            a: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Available Quantity", required: true),
                _textField(
                  controller: c.quantityController,
                  placeholder: "e.g. 500",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Min Order Quantity"),
                _textField(
                  controller: c.moqController,
                  placeholder: "e.g. 50",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Unit Type", required: true),
                _dropdown(
                  hint: "Select Unit",
                  value: c.selectedUnit,
                  items: unitOptions,
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
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
            ),
            child: const Text(
              "Buyers will pay the Booking Price upfront to reserve stock. The remaining balance (Total Price - Booking Price) is collected upon delivery.",
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF1D4ED8),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  LIVE AUCTION DETAILS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _auctionDetailsCard() {
    return _card(
      title: "Auction Details",
      icon: Icons.show_chart_rounded,
      accentColor: const Color(0xFFD97706),
      child: Column(
        children: [
          _row3(
            a: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Starting Bid", required: true),
                _textField(
                  controller: c.startingBidController,
                  placeholder: "0.00",
                  prefixText: "\$ ",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Lot Size / Quantity", required: true),
                _textField(
                  controller: c.quantityController,
                  placeholder: "e.g. 500",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Unit Type", required: true),
                _dropdown(
                  hint: "Select Unit",
                  value: c.selectedUnit,
                  items: unitOptions,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          _row2(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Auction End Date & Time", required: true),
                _dateTimePicker(
                  value: c.auctionEndDateTime,
                  placeholder: "Select end date & time",
                ),
                const SizedBox(height: CSize.space2),
                const Text(
                  "Auction will close at this exact time",
                  style:
                      TextStyle(fontSize: 10, color: CColors.textSecondary),
                ),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Currency"),
                _dropdown(
                  hint: "Select",
                  value: c.selectedCurrency,
                  items: currencyOptions,
                ),
              ],
            ),
          ),
          const SizedBox(height: CSize.space12),
          Container(
            padding: const EdgeInsets.all(CSize.space12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              border: Border.all(color: const Color(0xFFFDE68A)),
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
            ),
            child: const Text(
              "The highest bidder at the auction end time wins. You will be notified immediately and can confirm the order from your dashboard.",
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF92400E),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  LOCATION & DELIVERY
  // ══════════════════════════════════════════════════════════════════════════

  Widget _locationCard({bool showDelivery = true}) {
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
                  value: c.selectedCountry,
                  items: countries,
                ),
              ],
            ),
            b: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Region / State", required: true),
                _textField(
                  controller: c.regionController,
                  placeholder: "e.g. Punjab",
                ),
              ],
            ),
            c: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("City / District"),
                _textField(
                  controller: c.cityController,
                  placeholder: "e.g. Lahore",
                ),
              ],
            ),
          ),
          if (showDelivery) ...[
            const SizedBox(height: CSize.space12),
            _row2(
              left: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Delivery Option"),
                  _dropdown(
                    hint: "Select Option",
                    value: c.selectedDeliveryOption,
                    items: deliveryOptions,
                  ),
                ],
              ),
              right: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Delivery Timeframe", hint: "(optional)"),
                  _textField(
                    controller: c.deliveryTimeController,
                    placeholder: "e.g. 3–5 business days",
                  ),
                ],
              ),
            ),
          ],
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
            onTap: () {},
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
                        fontSize: 10, color: CColors.textSecondary),
                  ),
                  Text(
                    "Up to 5 images allowed",
                    style: TextStyle(
                        fontSize: 10, color: CColors.textSecondary),
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
                      borderRadius:
                          BorderRadius.circular(CSize.radius10Medium),
                      border: Border.all(color: CColors.borderGray),
                    ),
                    child: const Center(
                      child:
                          Icon(Icons.add, color: CColors.textSecondary),
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
                      borderRadius:
                          BorderRadius.circular(CSize.radius10Medium),
                      border: Border.all(color: CColors.borderGray),
                    ),
                    child: const Center(
                      child:
                          Icon(Icons.add, color: CColors.textSecondary),
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
            controller: c.tagInputController,
            style:
                const TextStyle(fontSize: 11, color: CColors.textPrimary),
            onSubmitted: c.addTag,
            decoration: InputDecoration(
              hintText: "Add a tag and press Enter",
              hintStyle: const TextStyle(
                  fontSize: 11, color: CColors.textSecondary),
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
                borderSide:
                    const BorderSide(color: CColors.borderEmeraldGreen),
              ),
              suffixIcon: const Icon(Icons.add,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
            ),
          ),
          const SizedBox(height: CSize.space10),
          Obx(
            () => Wrap(
              spacing: CSize.space8,
              runSpacing: CSize.space8,
              children: c.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space10, vertical: CSize.space4),
                      decoration: BoxDecoration(
                        color: CColors.backgroundEmerald100,
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius:
                            BorderRadius.circular(CSize.radius20Large),
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
                          GestureDetector(
                            onTap: () => c.removeTag(tag),
                            child: const Icon(
                              Icons.close,
                              size: 10,
                              color: CColors.textEmeraldGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
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
    return Obx(() {
      final type = c.selectedListingType.value;
      String tipTitle = "Listing Tips";
      List<String> tips = [];

      if (type == AddListingType.marketplace) {
        tipTitle = "Marketplace Tips";
        tips = [
          "Add high-quality images to attract more buyers",
          "Set competitive pricing based on market rates",
          "Enable sample availability to build buyer trust",
          "Add complete specifications to rank higher",
        ];
      } else if (type == AddListingType.advanceBooking) {
        tipTitle = "Advance Booking Tips";
        tips = [
          "Set a realistic harvest date to manage expectations",
          "Keep booking price between 20–30% of total price",
          "Add clear harvest and delivery details",
          "Mention certifications to attract premium buyers",
        ];
      } else if (type == AddListingType.liveAuctions) {
        tipTitle = "Live Auction Tips";
        tips = [
          "Set a fair starting bid to attract initial bids",
          "Choose auction end time during peak hours",
          "Add quality grade to attract serious bidders",
          "Upload clear photos to increase competition",
        ];
      }

      if (tips.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(CSize.space16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    size: 14, color: Color(0xFFD97706)),
                const SizedBox(width: CSize.space5),
                Text(
                  tipTitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CSize.space10),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: CSize.space8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "•  ",
                      style: TextStyle(
                          fontSize: 10, color: Color(0xFF92400E)),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF92400E),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
