import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/batch_model.dart';
import 'package:agri_market/features/seller/add_product/add_new_product_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_outlined_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';
import 'package:agri_market/shared/widgets/common/app_url_or_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Listing-type card palette (this screen only; Material icons stand in for SVG).
const Color _ltUnselBorder = Color(0xFFD1D5DB);
const Color _ltUnselCardBg = Color(0xFFFFFFFF);

class _ListingTypeTokens {
  const _ListingTypeTokens({
    required this.accent,
    required this.iconBoxBg,
    required this.iconColor,
    required this.selectedCardBg,
    required this.selectedBorder,
    required this.iconData,
  });
  final Color accent;
  final Color iconBoxBg;
  final Color iconColor;
  final Color selectedCardBg;
  final Color selectedBorder;
  final IconData iconData;

  static _ListingTypeTokens from(AddListingType type) {
    switch (type) {
      case AddListingType.marketplace:
        return const _ListingTypeTokens(
          accent: Color(0xFF1D9E75),
          iconBoxBg: Color(0xFFD4F0E4),
          iconColor: Color(0xFF1D9E75),
          selectedCardBg: Color(0xFFF0FAF6),
          selectedBorder: Color(0xFF1D9E75),
          iconData: Icons.grid_view_rounded,
        );
      case AddListingType.advanceBooking:
        return const _ListingTypeTokens(
          accent: Color(0xFF378ADD),
          iconBoxBg: Color(0xFFE8F0FB),
          iconColor: Color(0xFF378ADD),
          selectedCardBg: Color(0xFFF0F5FD),
          selectedBorder: Color(0xFF378ADD),
          iconData: Icons.calendar_month_rounded,
        );
      case AddListingType.liveAuctions:
        return const _ListingTypeTokens(
          accent: Color(0xFFBA7517),
          iconBoxBg: Color(0xFFFEF3E2),
          iconColor: Color(0xFFBA7517),
          selectedCardBg: Color(0xFFFEF9F0),
          selectedBorder: Color(0xFFBA7517),
          iconData: Icons.trending_up_rounded,
        );
    }
  }
}

final Map<String, Future<Uint8List>> _productPhotoThumbFutureCache = {};

Future<Uint8List> _productPhotoThumbBytes(XFile file) {
  final key =
      'p:${file.path.isNotEmpty ? file.path : '${file.name}#${identityHashCode(file)}'}';
  return _productPhotoThumbFutureCache.putIfAbsent(
    key,
    () => file.readAsBytes(),
  );
}

class ProductFormScreen extends StatelessWidget {
  ProductFormScreen({super.key});

  /// Registered by [AppRoutes.productForm] or by callers before [Get.to].
  AddNewProductCon get c => Get.find<AddNewProductCon>();

  List<String> get categories {
    final set = <String>{...c.categories};
    final cur = c.selectedCategory.value;
    if (cur.isNotEmpty && !set.contains(cur)) {
      set.add(cur);
    }
    return set.toList()..sort();
  }
  final List<String> unitOptions = const ['Ton', 'Kg', 'Box', 'Bag', 'Quintal'];
  final List<String> currencyOptions = const ['USD (\$)', 'PKR (₨)', 'INR (₹)'];
  final List<String> deliveryOptions = const [
    'Seller Delivers',
    'Buyer Picks Up',
    'Both Available'
  ];

  static const TextStyle _fieldInputStyle = TextStyle(
    fontSize: AppSize.font12,
    color: AppColors.textPrimary,
  );

  /// Same height as top-bar **Add Inventory** / **Publish Product** buttons.
  static const double _formControlHeight = 35;

  /// Min height for a row of floating-labeled [#_field] / [AppTextField] when a fixed slot is required.
  static const double _floatingLabeledFieldRowHeight =
      _formControlHeight + AppSize.space8;

  /// Batch detail: quality (left) + images/tags (right) in one row when wider than this.
  static const double _batchDetailTwoColumnMinWidth = 820;

  /// Fixed height for searchable product catalog overlay (scroll inside).
  static const double _productPickerMenuHeight = 240;

  /// Single-line [AppTextField] / [TextFormField] / [DropdownButtonFormField] content padding.
  static const EdgeInsets _floatingContentPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 14);

  /// Product Description textarea only ([AppTextField] multiline).
  static const EdgeInsets _descriptionTextareaContentPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 12);

  /// [AppContainer] padding for date/duration readouts (not [InputDecoration]).
  static const EdgeInsets _fieldContentPadding = EdgeInsets.symmetric(
    horizontal: AppSize.space12,
    vertical: AppSize.space8 + AppSize.space2,
  );

  /// Dropdown-specific padding: keeps text centered in [_formControlHeight] pickers.
  static const EdgeInsets _dropdownPadding = EdgeInsets.symmetric(
      horizontal: AppSize.space12, vertical: AppSize.space2);

  /// [DropdownButtonFormField] decoration contentPadding (spec rows, tier unit).
  static const EdgeInsets _dropdownContentPadding = _floatingContentPadding;
  static const double _errorSlotHeight = 16;

  static const double _productThumbDisplay = 80;

  static const TextStyle _floatingHintStyle = TextStyle(
    fontSize: AppSize.font12,
    color: AppColors.textSecondary,
  );

  static OutlineInputBorder _floatingEnabledBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radius12),
      borderSide: BorderSide(
        color: hasError
            ? AppColors.error
            : AppColors.emeraldGreen.withValues(alpha: 0.4),
        width: AppSize.borderWidth1,
      ),
    );
  }

  static OutlineInputBorder _floatingFocusedBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radius12),
      borderSide: BorderSide(
        color: hasError ? AppColors.error : AppColors.emeraldGreen,
        width: AppSize.borderWidth1 + AppSize.borderWidth05,
      ),
    );
  }

  /// Open dropdown list: comfortable tap targets + clear separation.
  static Widget _dropdownMenuRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: AppSize.font12,
            height: 1.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) => c.resetFormForCreate(),
      child: Scaffold(
        backgroundColor: context.appBg,
        body: Theme(
          data: Theme.of(context).copyWith(
          // Opened dropdown list (overlay menu) — rounded panel + typography.
          dropdownMenuTheme: DropdownMenuThemeData(
            menuStyle: MenuStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(
                  AppColors.backGroundWhite),
              elevation: const WidgetStatePropertyAll<double>(10),
              shadowColor: const WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(0, 0, 0, 0.14)),
              padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: AppSize.space8, horizontal: 4),
              ),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radius12),
                  side: const BorderSide(color: AppColors.borderGray),
                ),
              ),
            ),
            textStyle: const TextStyle(
              fontSize: AppSize.font12,
              height: 1.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: AppColors.backGroundWhite,
            elevation: 10,
            shadowColor: const Color.fromRGBO(0, 0, 0, 0.14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              side: const BorderSide(color: AppColors.borderGray),
            ),
            textStyle: const TextStyle(
              fontSize: AppSize.font12,
              height: 1.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          menuTheme: MenuThemeData(
            style: MenuStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(
                  AppColors.backGroundWhite),
              elevation: const WidgetStatePropertyAll<double>(10),
              shadowColor: const WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(0, 0, 0, 0.14)),
              padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: AppSize.space8, horizontal: 4),
              ),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radius12),
                  side: const BorderSide(color: AppColors.borderGray),
                ),
              ),
            ),
          ),
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSize.space24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topBar(context),
                        const SizedBox(height: AppSize.space20),
                        _listingTypeSelector(context),
                        Obx(() {
                          if (c.selectedListingType.value != null) {
                            return const SizedBox.shrink();
                          }
                          return _listingTypeHintBanner(context);
                        }),
                        _formFieldsAfterListing(context),
                      ],
                    ),
                  ),
                ),
              ),
              _bottomActionBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    /// 💀🔥 ---------------- Add Product Header With Back ----------------
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if ((c.editingProductId.value ?? '').isNotEmpty) {
                  c.cancelEditingAndClose();
                  return;
                }
                c.resetFormForCreate();
                Get.back<void>();
              },
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: AppContainer(
                width: _formControlHeight,
                height: _formControlHeight,
                border: Border.all(color: AppColors.borderGray),
                borderRadius: BorderRadius.circular(AppSize.radius8),
                child: Icon(Icons.arrow_back_rounded,
                    size: AppSize.icon16, color: context.txtPrimary),
              ),
            ),
            const SizedBox(width: AppSize.space8),
            Obx(
              () => AppText(
                  text: (c.editingProductId.value ?? '').isNotEmpty
                      ? 'Edit Product'
                      : 'Add New Product',
                  fontSize: AppSize.font18,
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppSize.space2),
        AppText(
            text: 'Fill in product details, then choose how to list',
            fontSize: AppSize.font10,
            color: context.txtSecondary),
      ],
    );
    return titleBlock;
  }

  Widget _bottomActionBar(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space24,
        vertical: AppSize.space12,
      ),
      backgroundColor: context.appBg,
      border: Border(
        top: BorderSide(color: context.borderClr),
      ),
      child: Obx(() {
          final isEditMode = (c.editingProductId.value ?? '').isNotEmpty;
          final canPress = !c.isUploading.value;
          final listingType = c.selectedListingType.value;
          final actionsEnabled = c.listingActionsEnabled.value;

          if (isEditMode) {
            return Row(
              children: [
                const Spacer(),
                AppElevatedButton(
                  onPressed: canPress ? () => c.publishProduct() : null,
                  isLoading: c.isUploading.value,
                  icon: Icons.save_outlined,
                  iconSize: AppSize.icon16,
                  iconColor: AppColors.textWhite,
                  text: 'Save changes',
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.textWhite,
                  backgroundColor: AppColors.emeraldGreen,
                  borderRadius: AppSize.radius8,
                  height: _formControlHeight,
                ),
              ],
            );
          }

          if (listingType == null) {
            return const SizedBox.shrink();
          }

          final muted = !actionsEnabled;
          return Row(
            children: [
              const Spacer(),
              AppOutlinedButton(
                onPressed: canPress ? c.addInventory : null,
                icon: Icons.inventory_2_outlined,
                iconSize: AppSize.icon16,
                iconColor:
                    muted ? AppColors.textSecondary : context.txtPrimary,
                text: 'Add to inventory',
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w700,
                textColor:
                    muted ? AppColors.textSecondary : context.txtPrimary,
                border: BorderSide(
                  color: muted ? AppColors.borderLight : AppColors.borderGray,
                ),
                borderRadius: AppSize.radius8,
                height: _formControlHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space8,
                  vertical: AppSize.space4,
                ),
              ),
              const SizedBox(width: AppSize.space8),
              AppElevatedButton(
                onPressed: canPress ? () => c.publishProduct() : null,
                isLoading: c.isUploading.value,
                icon: Icons.send_rounded,
                iconSize: AppSize.icon16,
                iconColor:
                    muted ? AppColors.textSecondary : AppColors.textWhite,
                text: 'Publish',
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w700,
                textColor:
                    muted ? AppColors.textSecondary : AppColors.textWhite,
                backgroundColor: muted
                    ? AppColors.borderGray
                    : AppColors.emeraldGreen,
                borderRadius: AppSize.radius8,
                height: _formControlHeight,
              ),
            ],
          );
        }),
    );
  }

  Widget _listingTypeSelector(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: context.borderClr),
      padding: const EdgeInsets.all(AppSize.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                width: 28,
                height: 28,
                backgroundColor: AppColors.badgeSuccessBg,
                borderRadius: BorderRadius.circular(AppSize.radius4),
                child: const Icon(
                  Icons.category_outlined,
                  size: AppSize.icon16,
                  color: AppColors.iconEmeraldGreen,
                ),
              ),
              const SizedBox(width: AppSize.space8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppText(
                            text: 'Select Listing Type',
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w800,
                            color: context.txtPrimary,
                          ),
                        ),
                        Obx(() {
                          if ((c.editingProductId.value ?? '').isNotEmpty) {
                            return const SizedBox.shrink();
                          }
                          if (c.selectedListingType.value != null) {
                            return const SizedBox.shrink();
                          }
                          return AppContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.space8,
                              vertical: 4,
                            ),
                            backgroundColor: AppColors.badgeErrorBg,
                            borderRadius:
                                BorderRadius.circular(AppSize.radius20),
                            child: const AppText(
                              text: 'Required',
                              fontSize: AppSize.font10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.badgeErrorText,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: AppSize.space8),
                    AppText(
                      text: 'Choose how you want to list this product',
                      fontSize: AppSize.font10,
                      color: context.txtSecondary,
                      height: 1.45,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.space16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _listingTypeOptionTile(
                  context: context,
                  type: AddListingType.marketplace,
                  title: 'Marketplace',
                  subtitle: 'Direct sale with fixed pricing',
                ),
              ),
              const SizedBox(width: AppSize.space8),
              Expanded(
                child: _listingTypeOptionTile(
                  context: context,
                  type: AddListingType.advanceBooking,
                  title: 'Advance Booking',
                  subtitle: 'Pre-orders for upcoming harvest or stock',
                ),
              ),
              const SizedBox(width: AppSize.space8),
              Expanded(
                child: _listingTypeOptionTile(
                  context: context,
                  type: AddListingType.liveAuctions,
                  title: 'Live Auctions',
                  subtitle: 'Starting bid — buyers compete in real-time',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listingTypeRadioCircle(bool selected, Color accent) {
    const double size = 18;
    if (!selected) {
      return AppContainer(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(9),
        backgroundColor: _ltUnselCardBg,
        border: Border.all(color: _ltUnselBorder, width: 0.5),
      );
    }
    return AppContainer(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(9),
      backgroundColor: accent,
      border: Border.all(color: accent, width: 0.5),
      alignment: Alignment.center,
      child: AppContainer(
        width: 6,
        height: 6,
        borderRadius: BorderRadius.circular(3),
        backgroundColor: AppColors.textWhite,
      ),
    );
  }

  Widget _listingTypeOptionTile({
    required BuildContext context,
    required AddListingType type,
    required String title,
    required String subtitle,
  }) {
    final tokens = _ListingTypeTokens.from(type);
    return Material(
      color: AppColors.backGroundTransparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.radius8),
        onTap: () => c.selectListingType(type),
        child: Obx(() {
          final isSelected = c.selectedListingType.value == type;
          return AppContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            borderRadius: BorderRadius.circular(AppSize.radius8),
            border: Border.all(
              color: isSelected ? tokens.selectedBorder : _ltUnselBorder,
              width: isSelected ? 1 : 0.5,
            ),
            backgroundColor:
                isSelected ? tokens.selectedCardBg : _ltUnselCardBg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppContainer(
                  width: 40,
                  height: 40,
                  backgroundColor: tokens.iconBoxBg,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Icon(
                      tokens.iconData,
                      size: 20,
                      color: tokens.iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: title,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.txtPrimary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSize.space4),
                      AppText(
                        text: subtitle,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: context.txtSecondary,
                        height: 1.35,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.space8),
                _listingTypeRadioCircle(isSelected, tokens.accent),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _listingTypeHintBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSize.space16),
      child: AppContainer(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        backgroundColor: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        border: Border.all(
          color: AppColors.emeraldGreen.withValues(alpha: 0.25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.touch_app_outlined,
                size: 28,
                color: AppColors.emeraldGreen,
              ),
            ),
            const SizedBox(height: AppSize.space16),
            const AppText(
              text: 'Select a Listing Type to Continue',
              fontSize: AppSize.font16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSize.space8),
            const AppText(
              text:
                  'Choose Marketplace, Advance Booking, or Live Auctions\n'
                  'to unlock the product listing form.',
              fontSize: 13,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFieldsAfterListing(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSize.space16),
        Obx(() {
          if (c.selectedListingType.value == null) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _commonBasicInfoCard(context, narrow: true),
              const SizedBox(height: AppSize.space16),
              _batchDetailParentCard(context),
            ],
          );
        }),
      ],
    );
  }

  Widget _batchDetailAddBatchHeaderAction(BuildContext context) {
    return Material(
      color: AppColors.backGroundTransparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.radius8),
        onTap: () {
          c.batchExpandedStates.add(false.obs);
          c.addBatch(
            BatchModel(
              batchCode: c.nextBatchCodeForAddBatchDialog(),
              sourceState: '',
              grade: '',
              quantity: 0,
              pricePerUnit: 0,
              unit: 'Ton',
            ),
          );
        },
        child: AppContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12,
            vertical: AppSize.space4,
          ),
          child: const AppText(
            text: '+ Add batch',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w600,
            color: AppColors.emeraldGreen,
          ),
        ),
      ),
    );
  }

  /// Only the "Batch detail" title row is white + bordered; Batch 1+ body stays on page background.
  Widget _batchDetailParentCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppContainer(
          width: double.infinity,
          backgroundColor: AppColors.backGroundWhite,
          borderRadius: BorderRadius.circular(AppSize.radius20),
          border: Border.all(color: AppColors.borderLight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space20,
            vertical: AppSize.space12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AppContainer(
                      width: 28,
                      height: 28,
                      backgroundColor: AppColors.badgeSuccessBg,
                      borderRadius: BorderRadius.circular(AppSize.radius4),
                      child: const Icon(
                        Icons.description_outlined,
                        size: AppSize.icon16,
                        color: AppColors.iconEmeraldGreen,
                      ),
                    ),
                    const SizedBox(width: AppSize.space8),
                    AppText(
                      text: 'Batch detail',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              _batchDetailAddBatchHeaderAction(context),
            ],
          ),
        ),
        const SizedBox(height: AppSize.space16),
        Obx(() {
          final n = c.batchExpandedStates.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < n; i++) ...[
                if (i > 0) const SizedBox(height: AppSize.space16),
                _productFormBatchSubCard(context, i),
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget _productFormBatchSubCard(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(() {
          if (index >= c.batchExpandedStates.length) {
            return const SizedBox.shrink();
          }
          final open = c.batchExpandedStates[index].value;
          return Material(
            color: AppColors.backGroundTransparent,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                if (index < c.batchExpandedStates.length) {
                  c.batchExpandedStates[index].toggle();
                }
              },
              borderRadius: BorderRadius.circular(AppSize.radius12),
              child: AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space16,
                  vertical: AppSize.space12,
                ),
                backgroundColor: open
                    ? AppColors.badgeSuccessBg
                    : AppColors.backgroundSurface,
                borderRadius: BorderRadius.circular(AppSize.radius12),
                border: Border.all(
                  color: open
                      ? AppColors.borderEmeraldGreen
                      : AppColors.borderLight,
                  width: AppSize.borderWidth1,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppText(
                        text: 'Batch ${index + 1}',
                        fontSize: AppSize.font14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Icon(
                      open
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: AppSize.icon20,
                      color: AppColors.emeraldGreen,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        Obx(() {
          if (index >= c.batchExpandedStates.length) {
            return const SizedBox.shrink();
          }
          if (!c.batchExpandedStates[index].value) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: AppSize.space12),
            child: _qualityCardInner(context, narrow: true),
          );
        }),
      ],
    );
  }

  Widget _card(
      {required String title,
      required IconData icon,
      required Widget child,
      String? subtitle,
      Widget? headerEnd,
      double? titleFontSize,
      bool elevated = false}) {
    final List<BoxShadow>? cardShadows = elevated
        ? <BoxShadow>[
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ]
        : null;
    return AppContainer(
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: AppColors.borderLight),
      boxShadows: cardShadows,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space20, vertical: AppSize.space12),
          border: const Border(
              bottom: BorderSide(color: AppColors.backgroundDivider)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AppContainer(
                        width: 28,
                        height: 28,
                        backgroundColor: AppColors.badgeSuccessBg,
                        borderRadius: BorderRadius.circular(AppSize.radius4),
                        child: Icon(icon,
                            size: AppSize.icon16,
                            color: AppColors.iconEmeraldGreen)),
                    const SizedBox(width: AppSize.space8),
                    AppText(
                        text: title,
                        fontSize: titleFontSize ?? AppSize.font10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                  ],
                ),
              ),
              if (headerEnd != null) ...[
                headerEnd,
                if (subtitle != null) const SizedBox(width: AppSize.space12),
              ],
              if (subtitle != null)
                AppText(
                    text: subtitle,
                    fontSize: AppSize.font10,
                    color: AppColors.textSecondary),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(AppSize.space20), child: child),
      ]),
    );
  }

  Widget _label(String txt, {bool required = false}) => Padding(
      padding: const EdgeInsets.only(bottom: AppSize.space4),
      child: Row(children: [
        AppText(
            text: txt,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary),
        if (required)
          const AppText(
              text: ' *', color: AppColors.textError, fontSize: AppSize.font10),
      ]));

  Widget _errorSlot(String requiredKey) => Obx(
        () => SizedBox(
          height: _errorSlotHeight,
          child: c.hasFieldError(requiredKey)
              ? AppText(
                  text: c.fieldErrorText(requiredKey),
                  fontSize: AppSize.font10,
                  color: AppColors.textError,
                )
              : null,
        ),
      );

  Widget _floatingLabelStack({
    required String label,
    required Widget child,
    bool labelRequired = false,
    Color? labelColor,
  }) {
    final lc = labelColor ?? AppColors.emeraldGreen;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -AppSize.space8,
          left: AppSize.space8 + AppSize.space2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.space4),
            color: AppColors.backGroundWhite,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: label,
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w500,
                  color: lc,
                  letterSpacing: 0.3,
                ),
                if (labelRequired)
                  const AppText(
                    text: ' *',
                    fontSize: AppSize.font10,
                    color: AppColors.textError,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _batchCodeReadOnlyField() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TextFormField(
          controller: c.batchCodeController,
          readOnly: true,
          style: _fieldInputStyle,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: _floatingContentPadding,
            filled: true,
            fillColor: AppColors.backGroundLightGrey,
            hintStyle: _floatingHintStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(
                color: AppColors.borderGray.withValues(alpha: 0.55),
                width: AppSize.borderWidth1,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(
                color: AppColors.borderGray.withValues(alpha: 0.55),
                width: AppSize.borderWidth1,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(
                color: AppColors.borderGray.withValues(alpha: 0.55),
                width: AppSize.borderWidth1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        Positioned(
          top: -AppSize.space8,
          left: AppSize.space8 + AppSize.space2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.space4),
            color: AppColors.backGroundWhite,
            child: const AppText(
              text: 'Batch code',
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  /// Shared floating-outline [AppTextField] for this screen.
  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool labelRequired = false,
    String? placeholder,
    String? prefixText,
    int maxLines = 1,
    int? minLines,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onEditingComplete,
    required bool hasError,
    required String errorText,
    bool reserveErrorSpace = true,
  }) {
    final pfx = prefixText;
    final Widget? prefixW = (pfx != null && pfx.isNotEmpty)
        ? Text(
            pfx,
            style: const TextStyle(
              fontSize: AppSize.font12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          )
        : null;

    final bool multiline = maxLines > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _floatingLabelStack(
          label: label,
          labelRequired: labelRequired,
          child: AppTextField(
            controller: controller,
            hintText: placeholder,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: multiline ? minLines : null,
            readOnly: readOnly,
            onEditingComplete: onEditingComplete,
            isDense: true,
            inputTextStyle: _fieldInputStyle,
            hintStyle: _floatingHintStyle,
            prefix: prefixW,
            filled: false,
            borderRadius: AppSize.radius12,
            contentPadding: multiline
                ? _descriptionTextareaContentPadding
                : _floatingContentPadding,
            customBorder: _floatingEnabledBorder(hasError),
            customFocusedBorder: _floatingFocusedBorder(hasError),
          ),
        ),
        if (reserveErrorSpace) ...[
          const SizedBox(height: AppSize.space4),
          SizedBox(
            height: _errorSlotHeight,
            child: hasError && errorText.isNotEmpty
                ? AppText(
                    text: errorText,
                    fontSize: AppSize.font10,
                    color: AppColors.textError,
                  )
                : null,
          ),
        ] else if (hasError && errorText.isNotEmpty) ...[
          const SizedBox(height: AppSize.space4),
          AppText(
            text: errorText,
            fontSize: AppSize.font10,
            color: AppColors.textError,
          ),
        ],
      ],
    );
  }

  Widget _field(
    TextEditingController controller, {
    required String label,
    String hint = '',
    TextInputType? type,
    int lines = 1,
    int? minLines,
    bool readOnly = false,
    String? requiredKey,
    bool? labelRequired,
    bool reserveErrorSpace = true,
  }) {
    final bool labelReq = labelRequired ?? (requiredKey != null);
    if (requiredKey == null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, _, __) => _textField(
          controller: controller,
          label: label,
          labelRequired: labelReq,
          placeholder: hint,
          keyboardType: type,
          maxLines: lines,
          minLines: minLines,
          readOnly: readOnly,
          hasError: false,
          errorText: '',
          reserveErrorSpace: false,
        ),
      );
    }
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, _, __) => Obx(() {
        final hasError = c.hasFieldError(requiredKey);
        return _textField(
          controller: controller,
          label: label,
          labelRequired: labelReq,
          placeholder: hint,
          keyboardType: type,
          maxLines: lines,
          minLines: minLines,
          readOnly: readOnly,
          hasError: hasError,
          errorText: c.fieldErrorText(requiredKey),
          reserveErrorSpace: reserveErrorSpace,
        );
      }),
    );
  }

  Widget _productNameField(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return CompositedTransformTarget(
          link: c.productPickerLayerLink,
          child: Focus(
            onFocusChange: (hasFocus) {
              c.onProductNameFieldFocusChanged(hasFocus);
              if (hasFocus &&
                  c.productNameController.text.trim().isNotEmpty) {
                c.showProductCatalogPicker(
                  context,
                  _productSuggestionsOnlyOverlayEntry(context, w),
                  requestListSearchFocus: false,
                );
              }
            },
            child: Obx(
              () => _floatingLabelStack(
                label: 'Product Name',
                labelRequired: true,
                child: AppTextField(
                  controller: c.productNameController,
                  focusNode: c.productNameFocusNode,
                  hintText: 'Type product name…',
                  isDense: true,
                  inputTextStyle: _fieldInputStyle,
                  hintStyle: _floatingHintStyle,
                  filled: false,
                  borderRadius: AppSize.radius12,
                  contentPadding: _floatingContentPadding,
                  customBorder: _floatingEnabledBorder(c.hasFieldError('productName')),
                  customFocusedBorder:
                      _floatingFocusedBorder(c.hasFieldError('productName')),
                  onChanged: (v) {
                    c.updateProductNameInput(v);
                    if (!c.productNameFocusNode.hasFocus) return;
                    if (v.trim().isEmpty) {
                      c.closeProductPicker();
                      return;
                    }
                    if (c.productPickerOverlay == null) {
                      c.showProductCatalogPicker(
                        context,
                        _productSuggestionsOnlyOverlayEntry(context, w),
                        requestListSearchFocus: false,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Same overlay UX as product name: under field, rounded panel, type-to-filter.
  OverlayEntry _searchableSelectOverlayEntry({
    required LayerLink layerLink,
    required double fieldWidth,
    required RxString filterRx,
    required TextEditingController searchController,
    required FocusNode searchFocus,
    required List<String> items,
    required VoidCallback onDismiss,
    required void Function(String value) onSelected,
    required String filterHint,
  }) {
    return OverlayEntry(
      builder: (overlayCtx) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: const ColoredBox(color: Color(0x33000000)),
            ),
          ),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, _formControlHeight + AppSize.space4),
            child: Material(
              color: AppColors.backGroundWhite,
              elevation: 10,
              shadowColor: const Color.fromRGBO(0, 0, 0, 0.14),
              borderRadius: BorderRadius.circular(AppSize.radius12),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: fieldWidth,
                height: _productPickerMenuHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSize.space8,
                        AppSize.space8,
                        AppSize.space8,
                        AppSize.space4,
                      ),
                      child: _floatingLabelStack(
                        label: 'Search',
                        child: AppTextField(
                          controller: searchController,
                          focusNode: searchFocus,
                          hintText: filterHint,
                          isDense: true,
                          inputTextStyle: _fieldInputStyle,
                          hintStyle: _floatingHintStyle,
                          filled: false,
                          borderRadius: AppSize.radius12,
                          contentPadding: _floatingContentPadding,
                          customBorder: _floatingEnabledBorder(false),
                          customFocusedBorder: _floatingFocusedBorder(false),
                          onChanged: (v) => filterRx.value = v,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    Expanded(
                      child: Obx(() {
                        final q = filterRx.value.trim().toLowerCase();
                        final names = q.isEmpty
                            ? items
                            : items
                                .where((n) => n.toLowerCase().contains(q))
                                .toList();
                        if (names.isEmpty) {
                          return const Center(
                            child: AppText(
                              text: 'No matches',
                              fontSize: AppSize.font12,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.space4),
                          itemCount: names.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: AppColors.borderLight,
                          ),
                          itemBuilder: (ctx, i) {
                            final name = names[i];
                            return InkWell(
                              onTap: () => onSelected(name),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.space12,
                                  vertical: 10,
                                ),
                                child: AppText(
                                  text: name,
                                  fontSize: AppSize.font12,
                                  color: AppColors.textPrimary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formListOverlayList(
    List<String> items,
    void Function(String value) onSelected,
  ) {
    if (items.isEmpty) {
      return const Center(
        child: AppText(
          text: 'No matches',
          fontSize: AppSize.font12,
          color: AppColors.textSecondary,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSize.space4),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: AppColors.borderLight,
      ),
      itemBuilder: (ctx, i) {
        final name = items[i];
        return InkWell(
          onTap: () => onSelected(name),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12,
              vertical: 10,
            ),
            child: AppText(
              text: name,
              fontSize: AppSize.font12,
              color: AppColors.textPrimary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  /// Category-style list overlay without search field. Optional letter/space type-ahead (country/region/city).
  OverlayEntry _formListOverlayEntry({
    required LayerLink layerLink,
    required double fieldWidth,
    required bool enableTypeAhead,
    required List<String> Function() itemsGetter,
    required VoidCallback onDismiss,
    required void Function(String value) onSelected,
    int maxVisibleItems = 5,
  }) {
    return OverlayEntry(
      builder: (overlayCtx) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: const ColoredBox(color: Color(0x33000000)),
            ),
          ),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, _formControlHeight + AppSize.space4),
            child: Material(
              color: AppColors.backGroundWhite,
              elevation: 10,
              shadowColor: const Color.fromRGBO(0, 0, 0, 0.14),
              borderRadius: BorderRadius.circular(AppSize.radius12),
              clipBehavior: Clip.antiAlias,
              child: Builder(builder: (ctx) {
                final list = itemsGetter();
                final visibleCount = list.length.clamp(1, maxVisibleItems);
                final shouldScroll = list.length > maxVisibleItems;
                final itemHeight = _formControlHeight;
                final double menuHeight = shouldScroll
                    ? visibleCount * itemHeight
                    : (list.length * itemHeight).clamp(itemHeight, 1000).toDouble();
                return SizedBox(
                  width: fieldWidth,
                  height: menuHeight,
                  child: Focus(
                    focusNode: c.listPickerOverlayFocus,
                    onKeyEvent: (node, event) {
                      if (!enableTypeAhead) {
                        return KeyEventResult.ignored;
                      }
                      if (event is! KeyDownEvent) {
                        return KeyEventResult.ignored;
                      }
                      if (event.logicalKey == LogicalKeyboardKey.backspace) {
                        c.removeLastListPickerTypeAheadChar();
                        return KeyEventResult.handled;
                      }
                      String? ch = event.character;
                      if (ch == null || ch.isEmpty) {
                        final lab = event.logicalKey.keyLabel;
                        if (lab.length == 1) ch = lab;
                      }
                      if (ch == null || ch.isEmpty) {
                        return KeyEventResult.ignored;
                      }
                      final lower = ch.toLowerCase();
                      if (RegExp(r'^[a-z ]$').hasMatch(lower)) {
                        c.appendListPickerTypeAheadChar(lower);
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: enableTypeAhead
                        ? Obx(() {
                            final pFull = c.listPickerTypeAheadPrefix.value;
                            var items = itemsGetter();
                            final p = pFull.trim().toLowerCase();
                            if (p.isNotEmpty) {
                              final filtered = items
                                  .where((e) => e.toLowerCase().startsWith(p))
                                  .toList();
                              if (filtered.isNotEmpty) items = filtered;
                            }
                            return _formListOverlayList(items, onSelected);
                          })
                        : _formListOverlayList(list, onSelected),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formListSelectField({
    required String label,
    bool labelRequired = false,
    required LayerLink layerLink,
    required RxString selection,
    required String hint,
    required List<String> items,
    required bool enabled,
    required String disabledMessage,
    required void Function(BuildContext context, double w) openPicker,
    bool hasError = false,
    String errorText = '',
  }) {
    final Color outlineColor = hasError
        ? AppColors.error
        : AppColors.emeraldGreen.withValues(alpha: 0.4);
    if (!enabled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _floatingLabelStack(
            label: label,
            labelRequired: labelRequired,
            child: AppContainer(
              height: _formControlHeight,
              padding: _dropdownPadding,
              backgroundColor: AppColors.backGroundWhite,
              borderRadius: BorderRadius.circular(AppSize.radius12),
              border: Border.all(
                color: outlineColor,
                width: AppSize.borderWidth1,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  text: disabledMessage,
                  fontSize: AppSize.font12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.space4),
          SizedBox(
            height: _errorSlotHeight,
            child: hasError && errorText.isNotEmpty
                ? AppText(
                    text: errorText,
                    fontSize: AppSize.font10,
                    color: AppColors.textError,
                  )
                : null,
          ),
        ],
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _floatingLabelStack(
              label: label,
              labelRequired: labelRequired,
              child: CompositedTransformTarget(
                link: layerLink,
                child: Material(
                  color: AppColors.backGroundTransparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    onTap: () {
                      if (items.isEmpty) return;
                      FocusManager.instance.primaryFocus?.unfocus();
                      openPicker(context, w);
                    },
                    child: AppContainer(
                      height: _formControlHeight,
                      padding: _dropdownPadding,
                      backgroundColor: AppColors.backGroundWhite,
                      borderRadius: BorderRadius.circular(AppSize.radius12),
                      border: Border.all(
                        color: outlineColor,
                        width: AppSize.borderWidth1,
                      ),
                      child: Obx(() {
                        final sel = selection.value;
                        final isHint = sel.isEmpty;
                        return Row(
                          children: [
                            Expanded(
                              child: AppText(
                                text: isHint ? hint : sel,
                                fontSize: AppSize.font12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: isHint
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.space4),
            SizedBox(
              height: _errorSlotHeight,
              child: hasError && errorText.isNotEmpty
                  ? AppText(
                      text: errorText,
                      fontSize: AppSize.font10,
                      color: AppColors.textError,
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }

  /// Waits for [csc_picker_plus] JSON before enabling country/region/city pickers.
  Widget _locationFieldWhenCscReady(Widget Function() builder) {
    return Obx(() {
      if (!c.cscLocationDataReady.value) {
        if (c.cscLocationLoadError.value.isNotEmpty) {
          return AppContainer(
            height: _formControlHeight,
            padding: _dropdownPadding,
            backgroundColor: AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            border: Border.all(
              color: AppColors.emeraldGreen.withValues(alpha: 0.4),
              width: AppSize.borderWidth1,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: 'Could not load locations',
                fontSize: AppSize.font12,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
        return AppContainer(
          height: _formControlHeight,
          padding: _dropdownPadding,
          backgroundColor: AppColors.backGroundWhite,
          borderRadius: BorderRadius.circular(AppSize.radius12),
          border: Border.all(
            color: AppColors.emeraldGreen.withValues(alpha: 0.4),
            width: AppSize.borderWidth1,
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              text: 'Loading locations…',
              fontSize: AppSize.font12,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }
      return builder();
    });
  }

  /// Product suggestions only: same position/size as before; filter = main text field ([productQuery]).
  OverlayEntry _productSuggestionsOnlyOverlayEntry(
      BuildContext context, double fieldWidth) {
    return OverlayEntry(
      builder: (overlayCtx) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                c.closeProductPicker();
                c.productNameFocusNode.unfocus();
              },
              child: const ColoredBox(color: Color(0x33000000)),
            ),
          ),
          CompositedTransformFollower(
            link: c.productPickerLayerLink,
            showWhenUnlinked: false,
            offset: Offset(0, _formControlHeight + AppSize.space4),
            child: Material(
              color: AppColors.backGroundWhite,
              elevation: 10,
              shadowColor: const Color.fromRGBO(0, 0, 0, 0.14),
              borderRadius: BorderRadius.circular(AppSize.radius12),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: fieldWidth,
                height: _productPickerMenuHeight,
                child: Obx(() {
                  final q = c.productQuery.value.trim().toLowerCase();
                  final all = AddNewProductCon.catalogNamesSorted;
                  final names = q.isEmpty
                      ? all
                      : all
                          .where((n) => n.toLowerCase().contains(q))
                          .toList();
                  if (names.isEmpty) {
                    return const Center(
                      child: AppText(
                        text: 'No matches',
                        fontSize: AppSize.font12,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSize.space4),
                    itemCount: names.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.borderLight,
                    ),
                    itemBuilder: (ctx, i) {
                      final name = names[i];
                      return InkWell(
                        onTap: () => c.selectProductByName(name),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space12,
                            vertical: 10,
                          ),
                          child: AppText(
                            text: name,
                            fontSize: AppSize.font12,
                            color: AppColors.textPrimary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryField(BuildContext context) {
    final items = categories;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return _floatingLabelStack(
          label: 'Category',
          labelRequired: true,
          child: CompositedTransformTarget(
            link: c.categoryPickerLayerLink,
            child: Material(
              color: AppColors.backGroundTransparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSize.radius12),
                onTap: () {
                  if (items.isEmpty) return;
                  FocusManager.instance.primaryFocus?.unfocus();
                  c.showCategoryPicker(
                    context,
                    _searchableSelectOverlayEntry(
                      layerLink: c.categoryPickerLayerLink,
                      fieldWidth: w,
                      filterRx: c.categoryPickerFilter,
                      searchController: c.categoryPickerSearchController,
                      searchFocus: c.categoryPickerSearchFocus,
                      items: items,
                      onDismiss: c.closeCategoryPicker,
                      onSelected: c.onCategoryChanged,
                      filterHint: 'Type to filter category…',
                    ),
                  );
                },
                child: AppContainer(
                  height: _formControlHeight,
                  padding: _dropdownPadding,
                  backgroundColor: AppColors.backGroundWhite,
                  borderRadius: BorderRadius.circular(AppSize.radius12),
                  border: Border.all(
                    color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                    width: AppSize.borderWidth1,
                  ),
                  child: Obx(() {
                    final sel = c.selectedCategory.value;
                    final isHint = sel.isEmpty;
                    return Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: isHint ? 'Select Category' : sel,
                            fontSize: AppSize.font12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            color: isHint
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _subCategoryField(BuildContext context) {
    return Obx(() {
      final needCategoryFirst = c.selectedCategory.value.isEmpty;
      if (needCategoryFirst) {
        return _floatingLabelStack(
          label: 'Sub Category',
          labelRequired: true,
          child: AppContainer(
            height: _formControlHeight,
            padding: _dropdownPadding,
            backgroundColor: AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            border: Border.all(
              color: AppColors.emeraldGreen.withValues(alpha: 0.4),
              width: AppSize.borderWidth1,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: 'Select Category first',
                fontSize: AppSize.font12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }
      final items = List<String>.from(c.currentSubCategories)
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return _floatingLabelStack(
            label: 'Sub Category',
            labelRequired: true,
            child: CompositedTransformTarget(
              link: c.subCategoryPickerLayerLink,
              child: Material(
                color: AppColors.backGroundTransparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSize.radius12),
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    c.showSubCategoryPicker(
                      context,
                      _searchableSelectOverlayEntry(
                        layerLink: c.subCategoryPickerLayerLink,
                        fieldWidth: w,
                        filterRx: c.subCategoryPickerFilter,
                        searchController: c.subCategoryPickerSearchController,
                        searchFocus: c.subCategoryPickerSearchFocus,
                        items: items,
                        onDismiss: c.closeSubCategoryPicker,
                        onSelected: c.onSubCategoryChanged,
                        filterHint: 'Type to filter sub category…',
                      ),
                    );
                  },
                  child: AppContainer(
                    height: _formControlHeight,
                    padding: _dropdownPadding,
                    backgroundColor: AppColors.backGroundWhite,
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    border: Border.all(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                      width: AppSize.borderWidth1,
                    ),
                    child: Obx(() {
                      final sel = c.selectedSubCategory.value;
                      final isHint = sel.isEmpty;
                      return Row(
                        children: [
                          Expanded(
                            child: AppText(
                              text: isHint ? 'Select Sub Category' : sel,
                              fontSize: AppSize.font12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              color: isHint
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _varietyField(BuildContext context) {
    return Obx(() {
      final needProductFirst = c.selectedProduct.value == null;
      if (needProductFirst) {
        return _floatingLabelStack(
          label: 'Product Variety',
          labelRequired: false,
          child: AppContainer(
            height: _formControlHeight,
            padding: _dropdownPadding,
            backgroundColor: AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            border: Border.all(
              color: AppColors.emeraldGreen.withValues(alpha: 0.4),
              width: AppSize.borderWidth1,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: 'Select product name first',
                fontSize: AppSize.font12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }
      final items = List<String>.from(c.currentVarieties)
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return _floatingLabelStack(
            label: 'Product Variety',
            labelRequired: false,
            child: CompositedTransformTarget(
              link: c.varietyPickerLayerLink,
              child: Material(
                color: AppColors.backGroundTransparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSize.radius12),
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    c.showVarietyPicker(
                      context,
                      _searchableSelectOverlayEntry(
                        layerLink: c.varietyPickerLayerLink,
                        fieldWidth: w,
                        filterRx: c.varietyPickerFilter,
                        searchController: c.varietyPickerSearchController,
                        searchFocus: c.varietyPickerSearchFocus,
                        items: items,
                        onDismiss: c.closeVarietyPicker,
                        onSelected: c.onVarietyChanged,
                        filterHint: 'Type to filter variety…',
                      ),
                    );
                  },
                  child: AppContainer(
                    height: _formControlHeight,
                    padding: _dropdownPadding,
                    backgroundColor: AppColors.backGroundWhite,
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    border: Border.all(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                      width: AppSize.borderWidth1,
                    ),
                    child: Obx(() {
                      final sel = c.selectedVarietyDisplay.value.trim();
                      final isHint = sel.isEmpty;
                      return Row(
                        children: [
                          Expanded(
                            child: AppText(
                              text: isHint
                                  ? 'Select Product Variety'
                                  : sel,
                              fontSize: AppSize.font12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              color: isHint
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _commonBasicInfoCard(BuildContext context, {required bool narrow}) {
    return _card(
        title: 'Basic Information',
        icon: Icons.description_outlined,
        child: Column(children: [
          if (narrow) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _productNameField(context),
                      const SizedBox(height: AppSize.space4),
                      _errorSlot('productName'),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _categoryField(context),
                      const SizedBox(height: AppSize.space4),
                      _errorSlot('category'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.space20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subCategoryField(context),
                      const SizedBox(height: AppSize.space4),
                      _errorSlot('subCategory'),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: _varietyField(context),
                ),
              ],
            ),
            const SizedBox(height: AppSize.space20),
            _field(
              c.descriptionController,
              label: 'Product Description',
              hint: 'Describe your product briefly...',
              lines: 5,
              minLines: 3,
              requiredKey: 'description',
              reserveErrorSpace: false,
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _productNameField(context),
                      const SizedBox(height: AppSize.space4),
                      _errorSlot('productName'),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _categoryField(context),
                      const SizedBox(height: AppSize.space4),
                      _errorSlot('category'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.space20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _subCategoryField(context),
                      const SizedBox(height: AppSize.space4),
                      _errorSlot('subCategory'),
                    ])),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: _varietyField(context),
                ),
              ],
            ),
            const SizedBox(height: AppSize.space20),
            _field(
              c.descriptionController,
              label: 'Product Description',
              hint: 'Describe your product briefly...',
              lines: 5,
              minLines: 3,
              requiredKey: 'description',
              reserveErrorSpace: false,
            ),
          ],
        ]));
  }

  /// One horizontal row of equal square tiles; [cell] capped so tiles stay compact on wide layouts.
  Widget _gradeSquaresRow() {
    final grades = AddNewProductCon.qualityGrades;
    return LayoutBuilder(
      builder: (context, constraints) {
        final n = grades.length;
        const gap = AppSize.space8;
        final w = constraints.maxWidth;
        final ideal = (w - gap * (n - 1)) / n;
        // Smaller tiles on desktop; still usable on narrow screens.
        final cellSide = ideal.clamp(22.0, 28.0);
        return SizedBox(
          height: cellSide,
          child: Obx(() {
            final selected = c.selectedGrade.value;
            return Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(n, (i) {
                    final g = grades[i];
                    final isSel = selected == g;
                    return Padding(
                      padding: EdgeInsets.only(right: i < n - 1 ? gap : 0),
                      child: Material(
                        color: AppColors.backGroundTransparent,
                        child: InkWell(
                          onTap: () => c.selectedGrade.value = g,
                          borderRadius: BorderRadius.circular(AppSize.radius4),
                          child: SizedBox(
                            width: cellSide,
                            height: cellSide,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.badgeSuccessBg
                                    : AppColors.backgroundSurface,
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.borderEmeraldGreen
                                      : AppColors.borderGray,
                                ),
                                borderRadius:
                                    BorderRadius.circular(AppSize.radius4),
                              ),
                              child: Center(
                                child: AppText(
                                  text: g,
                                  fontSize: AppSize.font10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _qualityCardInner(BuildContext context, {required bool narrow}) {
    final gradeColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Quality / Grade', required: true),
        const SizedBox(height: AppSize.space4),
        _gradeSquaresRow(),
      ],
    );

    final batchColumn = _batchCodeReadOnlyField();

    final cropColumn = _field(
      c.cropYearController,
      label: 'Crop Year',
      hint: 'e.g. 2025',
      type: TextInputType.number,
    );

    /// Batch detail: grade + batch / crop (wrapped in its own section card below).
    final leftBatchDetailSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        gradeColumn,
        const SizedBox(height: AppSize.space20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: batchColumn),
            const SizedBox(width: AppSize.space12),
            Expanded(child: cropColumn),
          ],
        ),
      ],
    );

    final typeSections = Obx(() {
      final type = c.selectedListingType.value;
      if (type == null) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (type == AddListingType.marketplace) ...[
            const SizedBox(height: AppSize.space16),
            _marketplacePricingCard(context),
            const SizedBox(height: AppSize.space16),
            _sampleCard(context),
            const SizedBox(height: AppSize.space16),
            _tierPricingCard(
              context: context,
              title: 'Tier Pricing',
              minQtyControllers: c.marketplaceTierQtyControllers,
              maxQtyControllers: c.marketplaceTierMaxQtyControllers,
              priceControllers: c.marketplaceTierPriceControllers,
              tierUnits: c.marketplaceTierUnits,
              onTierUnitChanged: c.updateMarketplaceTierUnit,
              revision: c.marketplaceTierRevision,
              onAdd: c.addMarketplaceTier,
              onRemove: (_) {},
              narrow: narrow,
              showTierEnableToggle: true,
              showTierRowDelete: false,
            ),
          ],
          if (type == AddListingType.advanceBooking) ...[
            const SizedBox(height: AppSize.space16),
            _advanceBookingPricingCard(context),
            const SizedBox(height: AppSize.space16),
            _advanceBookingScheduleCard(context),
            const SizedBox(height: AppSize.space16),
            _tierPricingCard(
              context: context,
              title: 'Tier Pricing',
              minQtyControllers: c.bookingTierQtyControllers,
              maxQtyControllers: c.bookingTierMaxQtyControllers,
              priceControllers: c.bookingTierPriceControllers,
              tierUnits: c.bookingTierUnits,
              onTierUnitChanged: c.updateBookingTierUnit,
              revision: c.bookingTierRevision,
              onAdd: c.addBookingTier,
              onRemove: (_) {},
              narrow: narrow,
              showTierEnableToggle: true,
              showTierRowDelete: false,
            ),
          ],
          if (type == AddListingType.liveAuctions) ...[
            const SizedBox(height: AppSize.space16),
            _liveAuctionLotCard(context),
            const SizedBox(height: AppSize.space16),
            _liveAuctionTimingCard(context),
          ],
        ],
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumn =
            constraints.maxWidth >= _batchDetailTwoColumnMinWidth;

        final qualitySection = _card(
          title: 'Quality & batch',
          icon: Icons.fact_check_outlined,
          elevated: true,
          child: leftBatchDetailSection,
        );

        final imagesSection = _card(
          title: 'Product images',
          icon: Icons.add_photo_alternate_outlined,
          elevated: true,
          child: _imagesCard(),
        );

        final Widget topBlock = useTwoColumn
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: qualitySection,
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    flex: 1,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 200),
                      child: imagesSection,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  qualitySection,
                  const SizedBox(height: AppSize.space16),
                  imagesSection,
                ],
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topBlock,
            const SizedBox(height: AppSize.space16),
            _specificationsCard(context, narrow: narrow),
            const SizedBox(height: AppSize.space16),
            _tagsCard(elevated: true),
            const SizedBox(height: AppSize.space16),
            _locationCard(context),
            typeSections,
          ],
        );
      },
    );
  }

  Widget _specUnitDropdown(int index) {
    if (index >= c.specNameControllers.length) return const SizedBox.shrink();
    final current =
        index < c.specUnits.length ? c.specUnits[index] : c.unitOptions.first;
    final safe =
        c.unitOptions.contains(current) ? current : c.unitOptions.first;
    return _floatingLabelStack(
      label: 'Unit',
      child: SizedBox(
        height: _floatingLabeledFieldRowHeight,
        child: DropdownButtonFormField<String>(
          key: ValueKey<String>('spec_${index}_$safe'),
          isDense: true,
          isExpanded: true,
          value: safe,
          style: _fieldInputStyle,
          selectedItemBuilder: (context) => c.unitOptions
              .map(
                (e) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _fieldInputStyle,
                  ),
                ),
              )
              .toList(),
          decoration: InputDecoration(
            isDense: true,
            filled: false,
            contentPadding: _dropdownContentPadding,
            hintStyle: _floatingHintStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(
                color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                width: AppSize.borderWidth1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(
                color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                width: AppSize.borderWidth1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(
                color: AppColors.emeraldGreen,
                width: AppSize.borderWidth1 + AppSize.borderWidth05,
              ),
            ),
          ),
          items: c.unitOptions
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: _dropdownMenuRow(e),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) c.updateSpecUnit(index, v);
          },
        ),
      ),
    );
  }

  Widget _specificationsCard(BuildContext context, {required bool narrow}) {
    return _card(
        title: 'Product Specifications',
        icon: Icons.table_chart_outlined,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Obx(() => Wrap(
                spacing: AppSize.space8,
                runSpacing: AppSize.space8,
                children: c.quickChipsVisible
                    .map((chip) => AppContainer(
                          padding: const EdgeInsets.only(
                              left: AppSize.space8,
                              right: AppSize.space4,
                              top: AppSize.space4,
                              bottom: AppSize.space4),
                          backgroundColor: AppColors.badgeSuccessBg,
                          border: Border.all(color: AppColors.emerald100),
                          borderRadius: BorderRadius.circular(AppSize.radius20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => c.addSpecFromChip(chip),
                                child: AppText(
                                    text: chip,
                                    fontSize: AppSize.font10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textEmeraldGreen),
                              ),
                              const SizedBox(width: AppSize.space4),
                              GestureDetector(
                                onTap: () => c.removeQuickChipFromBar(chip),
                                child: const Icon(Icons.close,
                                    size: 14,
                                    color: AppColors.textEmeraldGreen),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              )),
          const SizedBox(height: AppSize.space12),
          Obx(() {
            final _ = c.specLayoutRevision.value;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: c.specNameControllers.length,
              itemBuilder: (_, i) {
                final row = Padding(
                  padding: const EdgeInsets.only(top: AppSize.space8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 2,
                          child: _field(
                            c.specNameControllers[i],
                            label: 'Spec name',
                            hint: 'Spec Name',
                          )),
                      const SizedBox(width: AppSize.space8),
                      Expanded(
                          flex: 2,
                          child: _field(
                            c.specValueControllers[i],
                            label: 'Value',
                            hint: 'Value',
                          )),
                      const SizedBox(width: AppSize.space8),
                      SizedBox(width: 92, child: _specUnitDropdown(i)),
                      const SizedBox(width: AppSize.space4),
                      Obx(() {
                        final _ = c.specLayoutRevision.value;
                        return c.specNameControllers.length > 1
                            ? IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.error, size: 18),
                                onPressed: () => c.removeSpec(i),
                              )
                            : const SizedBox.shrink();
                      }),
                    ],
                  ),
                );
                if (narrow) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSize.space8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final parentW = constraints.maxWidth;
                        final innerW = !parentW.isFinite || parentW < 520
                            ? 520.0
                            : parentW;
                        return SizedBox(
                          height:
                              AppSize.space8 + _floatingLabeledFieldRowHeight,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: innerW,
                              child: row,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.space8),
                  child: row,
                );
              },
            );
          }),
          InkWell(
              onTap: c.addEmptySpec,
              child: AppContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
                  border: Border.all(color: AppColors.emerald100),
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  backgroundColor: AppColors.badgeSuccessBg,
                  child: const Center(
                      child: AppText(
                          text: 'Add Specification',
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textEmeraldGreen))))
        ]));
  }

  Widget _locationCard(BuildContext context) {
    final row1 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationFieldWhenCscReady(() => _formListSelectField(
                    label: 'Country',
                    labelRequired: true,
                    layerLink: c.countryPickerLayerLink,
                    selection: c.selectedCountry,
                    hint: 'Select country',
                    items: c.allCountries,
                    enabled: c.allCountries.isNotEmpty,
                    disabledMessage: 'No countries',
                    hasError: c.hasFieldError('country'),
                    errorText: c.fieldErrorText('country'),
                    openPicker: (ctx, w) => c.showCountryPicker(
                      ctx,
                      _formListOverlayEntry(
                        layerLink: c.countryPickerLayerLink,
                        fieldWidth: w,
                        enableTypeAhead: true,
                        itemsGetter: () => c.allCountries,
                        onDismiss: () {
                          c.clearListPickerTypeAhead();
                          c.closeCountryPicker();
                        },
                        onSelected: c.onCountryChanged,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationFieldWhenCscReady(() => Obx(() {
                    final needCountry = c.selectedCountry.value.isEmpty;
                    final regions = c.regionsForCountry;
                    return _formListSelectField(
                      label: 'Region / State',
                      labelRequired: true,
                      layerLink: c.regionPickerLayerLink,
                      selection: c.selectedRegion,
                      hint: 'Select Region',
                      items: regions,
                      enabled: !needCountry && regions.isNotEmpty,
                      hasError: c.hasFieldError('region'),
                      errorText: c.fieldErrorText('region'),
                      disabledMessage: needCountry
                          ? 'Select Country first'
                          : 'No regions',
                      openPicker: (ctx, w) => c.showRegionPicker(
                        ctx,
                        _formListOverlayEntry(
                          layerLink: c.regionPickerLayerLink,
                          fieldWidth: w,
                          enableTypeAhead: true,
                          itemsGetter: () => c.regionsForCountry,
                          onDismiss: () {
                            c.clearListPickerTypeAhead();
                            c.closeRegionPicker();
                          },
                          onSelected: c.onRegionChanged,
                        ),
                      ),
                    );
                  })),
            ],
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationFieldWhenCscReady(() => Obx(() {
                    final needRegion = c.selectedRegion.value.isEmpty;
                    final cities = c.citiesForRegion;
                    return _formListSelectField(
                      label: 'City / District',
                      labelRequired: true,
                      layerLink: c.cityPickerLayerLink,
                      selection: c.selectedCity,
                      hint: 'Select City',
                      items: cities,
                      enabled: !needRegion && cities.isNotEmpty,
                      hasError: c.hasFieldError('city'),
                      errorText: c.fieldErrorText('city'),
                      disabledMessage: needRegion
                          ? 'Select Region first'
                          : 'No cities',
                      openPicker: (ctx, w) => c.showCityPicker(
                        ctx,
                        _formListOverlayEntry(
                          layerLink: c.cityPickerLayerLink,
                          fieldWidth: w,
                          enableTypeAhead: true,
                          itemsGetter: () => c.citiesForRegion,
                          onDismiss: () {
                            c.clearListPickerTypeAhead();
                            c.closeCityPicker();
                          },
                          onSelected: c.onCityChanged,
                        ),
                      ),
                    );
                  })),
            ],
          ),
        ),
      ],
    );
    final row2 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formListSelectField(
                label: 'Delivery Option',
                layerLink: c.deliveryPickerLayerLink,
                selection: c.selectedDeliveryOption,
                hint: 'Select Option',
                items: deliveryOptions,
                enabled: deliveryOptions.isNotEmpty,
                disabledMessage: 'No options',
                openPicker: (ctx, w) => c.showDeliveryPicker(
                  ctx,
                  _formListOverlayEntry(
                    layerLink: c.deliveryPickerLayerLink,
                    fieldWidth: w,
                    enableTypeAhead: false,
                    itemsGetter: () => deliveryOptions,
                    onDismiss: () {
                      c.clearListPickerTypeAhead();
                      c.closeDeliveryPicker();
                    },
                    onSelected: c.onDeliveryOptionSelected,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                c.deliveryTimeController,
                label: 'Delivery Time',
                hint: 'e.g. 3–5 business days',
                lines: 1,
              ),
            ],
          ),
        ),
      ],
    );
    return _card(
        title: 'Location & Delivery',
        icon: Icons.location_on_outlined,
        child: Column(children: [
          row1,
          const SizedBox(height: AppSize.space20),
          row2,
        ]));
  }

  Widget _marketplacePricingCard(BuildContext context) {
    final row1 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _field(
            c.priceController,
            label: 'Price per Unit',
            hint: '0.00',
            type: TextInputType.number,
            requiredKey: 'price',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _formListSelectField(
            label: 'Unit Type',
            labelRequired: true,
            layerLink: c.unitPickerLayerLink,
            selection: c.selectedUnit,
            hint: 'Select Unit',
            items: unitOptions,
            enabled: unitOptions.isNotEmpty,
            hasError: c.hasFieldError('unit'),
            errorText: c.fieldErrorText('unit'),
            disabledMessage: 'No units',
            openPicker: (ctx, w) => c.showUnitPicker(
              ctx,
              _formListOverlayEntry(
                layerLink: c.unitPickerLayerLink,
                fieldWidth: w,
                enableTypeAhead: false,
                itemsGetter: () => unitOptions,
                onDismiss: () {
                  c.clearListPickerTypeAhead();
                  c.closeUnitPicker();
                },
                onSelected: c.onUnitSelected,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _formListSelectField(
            label: 'Currency',
            labelRequired: true,
            layerLink: c.currencyPickerLayerLink,
            selection: c.selectedCurrency,
            hint: 'Select Currency',
            items: currencyOptions,
            enabled: currencyOptions.isNotEmpty,
            disabledMessage: 'No currencies',
            openPicker: (ctx, w) => c.showCurrencyPicker(
              ctx,
              _formListOverlayEntry(
                layerLink: c.currencyPickerLayerLink,
                fieldWidth: w,
                enableTypeAhead: false,
                itemsGetter: () => currencyOptions,
                onDismiss: () {
                  c.clearListPickerTypeAhead();
                  c.closeCurrencyPicker();
                },
                onSelected: c.onCurrencySelected,
              ),
            ),
          ),
        ),
      ],
    );
    final row2 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _field(
            c.quantityController,
            label: 'Available Quantity',
            hint: 'e.g. 500',
            type: TextInputType.number,
            requiredKey: 'quantity',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _field(
            c.moqController,
            label: 'Minimum Order Quantity',
            hint: 'e.g. 50',
            type: TextInputType.number,
            requiredKey: 'moq',
          ),
        ),
      ],
    );
    return _card(
        title: 'Pricing and Quantity',
        icon: Icons.attach_money_rounded,
        child: Column(children: [
          row1,
          const SizedBox(height: AppSize.space20),
          row2,
        ]));
  }

  Widget _samplePriceField() {
    return _textField(
      controller: c.samplePriceController,
      label: 'Sample Price',
      placeholder: '0.00 or Free',
      prefixText: r'$ ',
      keyboardType: TextInputType.number,
      hasError: false,
      errorText: '',
    );
  }

  Widget _sampleCard(BuildContext context) {
    final sampleRow1 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _field(
            c.sampleQtyController,
            label: 'Sample Quantity',
            hint: 'e.g. 1',
            type: TextInputType.number,
            labelRequired: true,
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _dropdown(
            context,
            c.selectedSampleUnit,
            AddNewProductCon.sampleUnitOptions,
            'Select Unit',
            label: 'Sample Unit',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(child: _samplePriceField()),
      ],
    );

    final sampleRow2 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _formListSelectField(
            label: 'Sample Dispatch Time',
            layerLink: c.sampleDispatchPickerLayerLink,
            selection: c.selectedDispatchTime,
            hint: 'Select Timeframe',
            items: AddNewProductCon.sampleDispatchTimeOptions,
            enabled: AddNewProductCon.sampleDispatchTimeOptions.isNotEmpty,
            disabledMessage: 'No options',
            openPicker: (ctx, w) => c.showSampleDispatchPicker(
              ctx,
              _formListOverlayEntry(
                layerLink: c.sampleDispatchPickerLayerLink,
                fieldWidth: w,
                enableTypeAhead: false,
                itemsGetter: () => AddNewProductCon.sampleDispatchTimeOptions,
                onDismiss: c.closeSampleDispatchPicker,
                onSelected: c.onSampleDispatchTimeSelected,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _formListSelectField(
            label: 'Delivery Covered By',
            layerLink: c.sampleDeliveryCoveredPickerLayerLink,
            selection: c.selectedDeliveryCoveredBy,
            hint: 'Select',
            items: AddNewProductCon.sampleDeliveryCoveredByOptions,
            enabled:
                AddNewProductCon.sampleDeliveryCoveredByOptions.isNotEmpty,
            disabledMessage: 'No options',
            openPicker: (ctx, w) => c.showSampleDeliveryCoveredPicker(
              ctx,
              _formListOverlayEntry(
                layerLink: c.sampleDeliveryCoveredPickerLayerLink,
                fieldWidth: w,
                enableTypeAhead: false,
                itemsGetter: () =>
                    AddNewProductCon.sampleDeliveryCoveredByOptions,
                onDismiss: c.closeSampleDeliveryCoveredPicker,
                onSelected: c.onSampleDeliveryCoveredBySelected,
              ),
            ),
          ),
        ),
      ],
    );

    return _card(
      title: 'Sample Availability',
      icon: Icons.science_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => InkWell(
              onTap: () => c.sampleAvailable.toggle(),
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space16,
                  vertical: AppSize.space12,
                ),
                backgroundColor: c.sampleAvailable.value
                    ? AppColors.badgeSuccessBg
                    : AppColors.backGroundWhite,
                border: Border.all(
                  color: c.sampleAvailable.value
                      ? AppColors.borderEmeraldGreen
                      : AppColors.borderGray,
                ),
                borderRadius: BorderRadius.circular(AppSize.radius8),
                child: Row(
                  children: [
                    Switch(
                      value: c.sampleAvailable.value,
                      onChanged: (val) => c.sampleAvailable.value = val,
                      activeThumbColor: AppColors.emeraldGreen,
                      activeTrackColor:
                          AppColors.emeraldGreen.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: c.sampleAvailable.value
                                ? 'Sample Available'
                                : 'Sample Not Available',
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          const AppText(
                            text:
                                'Buyers can request a sample before placing a bulk order',
                            fontSize: AppSize.font10,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => c.sampleAvailable.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSize.space12),
                      sampleRow1,
                      const SizedBox(height: AppSize.space12),
                      sampleRow2,
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _advanceBookingPricingCard(BuildContext context) {
    final row1 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _field(
            c.bookingPriceController,
            label: 'Booking Price',
            hint: '0.00',
            requiredKey: 'bookingPrice',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _field(
            c.totalEstimatedPriceController,
            label: 'Est. delivery price',
            hint: '0.00',
            requiredKey: 'estimatedPrice',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _formListSelectField(
            label: 'Currency',
            layerLink: c.currencyPickerLayerLink,
            selection: c.selectedBookingCurrency,
            hint: 'Select Currency',
            items: currencyOptions,
            enabled: currencyOptions.isNotEmpty,
            hasError: c.hasFieldError('bookingCurrency'),
            errorText: c.fieldErrorText('bookingCurrency'),
            disabledMessage: 'No currencies',
            openPicker: (ctx, w) => c.showCurrencyPicker(
              ctx,
              _formListOverlayEntry(
                layerLink: c.currencyPickerLayerLink,
                fieldWidth: w,
                enableTypeAhead: false,
                itemsGetter: () => currencyOptions,
                onDismiss: c.closeCurrencyPicker,
                onSelected: (v) {
                  c.closeCurrencyPicker();
                  c.selectedBookingCurrency.value = v;
                },
              ),
            ),
          ),
        ),
      ],
    );
    final row2 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _field(
            c.bookingQtyController,
            label: 'Available Quantity',
            hint: 'e.g. 500',
            requiredKey: 'bookingQuantity',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _field(
            c.bookingMoqController,
            label: 'Minimum Order Quantity',
            hint: 'e.g. 50',
            requiredKey: 'bookingMoq',
          ),
        ),
        const SizedBox(width: AppSize.space12),
        Expanded(
          child: _formListSelectField(
            label: 'Unit Type',
            labelRequired: true,
            layerLink: c.unitPickerLayerLink,
            selection: c.selectedBookingUnit,
            hint: 'Select Unit',
            items: unitOptions,
            enabled: unitOptions.isNotEmpty,
            hasError: c.hasFieldError('bookingUnit'),
            errorText: c.fieldErrorText('bookingUnit'),
            disabledMessage: 'No units',
            openPicker: (ctx, w) => c.showUnitPicker(
              ctx,
              _formListOverlayEntry(
                layerLink: c.unitPickerLayerLink,
                fieldWidth: w,
                enableTypeAhead: false,
                itemsGetter: () => unitOptions,
                onDismiss: c.closeUnitPicker,
                onSelected: (v) {
                  c.closeUnitPicker();
                  c.selectedBookingUnit.value = v;
                },
              ),
            ),
          ),
        ),
      ],
    );
    return _card(
      title: 'Booking terms',
      icon: Icons.article_outlined,
      child: Column(
        children: [
          row1,
          const SizedBox(height: AppSize.space20),
          row2,
        ],
      ),
    );
  }

  Widget _advanceBookingScheduleCard(BuildContext context) {
    final harvest = _dateField(
      c.harvestDate,
      c.pickHarvestDate,
      'DD / MM / YYYY',
      fieldLabel: 'Harvest Date',
      labelRequired: true,
      requiredKey: 'harvestDate',
    );
    final bookingDl = _dateField(
      c.bookingDeadline,
      c.pickBookingDeadlineDate,
      'DD / MM / YYYY',
      fieldLabel: 'Booking deadline',
    );
    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: harvest),
        const SizedBox(width: AppSize.space12),
        Expanded(child: bookingDl),
      ],
    );
    return _card(
      title: 'Schedule',
      icon: Icons.event_note_outlined,
      child: body,
    );
  }

  Widget _liveAuctionLotCard(BuildContext context) {
    final bid = _field(
      c.startingBidController,
      label: 'Starting bid',
      hint: '0.00',
      type: TextInputType.number,
      requiredKey: 'startingBid',
    );
    final reserve = _field(
      c.reservePriceController,
      label: 'Reserve price (optional)',
      hint: '0.00',
      type: TextInputType.number,
    );
    final increment = _field(
      c.bidIncrementController,
      label: 'Bid increment',
      hint: '0.00',
      type: TextInputType.number,
    );
    final lot = _field(
      c.lotSizeController,
      label: 'Lot size / quantity',
      hint: 'e.g. 500',
      type: TextInputType.number,
      requiredKey: 'lotSize',
    );
    final unit = _formListSelectField(
      label: 'Unit type',
      labelRequired: true,
      layerLink: c.unitPickerLayerLink,
      selection: c.selectedAuctionUnit,
      hint: 'Select Unit',
      items: unitOptions,
      enabled: unitOptions.isNotEmpty,
      hasError: c.hasFieldError('auctionUnit'),
      errorText: c.fieldErrorText('auctionUnit'),
      disabledMessage: 'No units',
      openPicker: (ctx, w) => c.showUnitPicker(
        ctx,
        _formListOverlayEntry(
          layerLink: c.unitPickerLayerLink,
          fieldWidth: w,
          enableTypeAhead: false,
          itemsGetter: () => unitOptions,
          onDismiss: c.closeUnitPicker,
          onSelected: (v) {
            c.closeUnitPicker();
            c.selectedAuctionUnit.value = v;
          },
        ),
      ),
    );
    final lotRow1 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: lot),
        const SizedBox(width: AppSize.space12),
        Expanded(child: unit),
        const SizedBox(width: AppSize.space12),
        Expanded(child: bid),
      ],
    );
    final lotRow2 = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: reserve),
        const SizedBox(width: AppSize.space12),
        Expanded(child: increment),
      ],
    );

    return _card(
      title: 'Auction lot',
      icon: Icons.gavel_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          lotRow1,
          const SizedBox(height: AppSize.space20),
          lotRow2,
        ],
      ),
    );
  }

  Widget _liveAuctionTimingCard(BuildContext context) {
    final start = _dateTimeField(
      c.auctionStartDateTime,
      c.pickAuctionStartDateTime,
      'Select start date & time',
      fieldLabel: 'Auction start',
    );
    final end = _dateTimeField(
      c.auctionEndDateTime,
      c.pickAuctionEndDateTime,
      'Select end date & time',
      fieldLabel: 'Auction end',
      labelRequired: true,
      requiredKey: 'auctionEnd',
    );
    final duration = _floatingLabelStack(
      label: 'Duration',
      child: Obx(() {
        final readout = c.auctionDurationReadout();
        final empty = readout.isEmpty;
        return AppContainer(
          height: _formControlHeight,
          alignment: Alignment.centerLeft,
          padding: _fieldContentPadding,
          backgroundColor: AppColors.backGroundWhite,
          borderRadius: BorderRadius.circular(AppSize.radius12),
          border: Border.all(
            color: AppColors.emeraldGreen.withValues(alpha: 0.4),
            width: AppSize.borderWidth1,
          ),
          child: AppText(
            text: empty ? 'Set start and end' : readout,
            fontSize: AppSize.font12,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: empty ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        );
      }),
    );

    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: start),
        const SizedBox(width: AppSize.space12),
        Expanded(child: end),
        const SizedBox(width: AppSize.space12),
        Expanded(child: duration),
      ],
    );

    return _card(
      title: 'Auction timing',
      icon: Icons.schedule_outlined,
      child: body,
    );
  }

  Widget _tierUnitDropdown(
    BuildContext context,
    int index,
    RxList<String> tierUnits,
    void Function(int, String) onTierUnitChanged,
    RxInt revision,
  ) {
    return Obx(() {
      final _ = revision.value;
      if (index >= tierUnits.length) return const SizedBox.shrink();
      final current = tierUnits[index];
      final safe = unitOptions.contains(current) ? current : unitOptions.first;
      return _floatingLabelStack(
        label: 'Unit',
        child: SizedBox(
          height: _floatingLabeledFieldRowHeight,
          child: DropdownButtonFormField<String>(
            key: ValueKey<String>('tier_${index}_$safe'),
            isDense: true,
            isExpanded: true,
            value: safe,
            style: _fieldInputStyle,
            selectedItemBuilder: (context) => unitOptions
                .map(
                  (e) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _fieldInputStyle,
                    ),
                  ),
                )
                .toList(),
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              contentPadding: _dropdownContentPadding,
              hintStyle: _floatingHintStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.radius12),
                borderSide: BorderSide(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                  width: AppSize.borderWidth1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.radius12),
                borderSide: BorderSide(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.4),
                  width: AppSize.borderWidth1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.radius12),
                borderSide: BorderSide(
                  color: AppColors.emeraldGreen,
                  width: AppSize.borderWidth1 + AppSize.borderWidth05,
                ),
              ),
            ),
            items: unitOptions
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: _dropdownMenuRow(e),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onTierUnitChanged(index, v);
            },
          ),
        ),
      );
    });
  }

  Widget _tierPricingCard({
    required BuildContext context,
    required String title,
    required List<TextEditingController> minQtyControllers,
    required List<TextEditingController> maxQtyControllers,
    required List<TextEditingController> priceControllers,
    required RxList<String> tierUnits,
    required void Function(int, String) onTierUnitChanged,
    required RxInt revision,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
    required bool narrow,
    bool showTierEnableToggle = false,
    bool showTierRowDelete = true,
  }) {
    final tiersBody = Obx(() {
      final _ = revision.value;
      if (showTierEnableToggle && !c.tierPricingEnabled.value) {
        return const SizedBox.shrink();
      }
      final rows = List<Widget>.generate(3, (i) {
        final row = SizedBox(
          height: _floatingLabeledFieldRowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _field(
                  minQtyControllers[i],
                  label: 'Min qty',
                  hint: 'Min qty',
                  type: TextInputType.number,
                  reserveErrorSpace: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  maxQtyControllers[i],
                  label: 'Max qty',
                  hint: 'Max qty',
                  type: TextInputType.number,
                  reserveErrorSpace: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  priceControllers[i],
                  label: 'Price',
                  hint: 'Price',
                  type: TextInputType.number,
                  reserveErrorSpace: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _tierUnitDropdown(
                  context,
                  i,
                  tierUnits,
                  onTierUnitChanged,
                  revision,
                ),
              ),
            ],
          ),
        );
        if (narrow) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final parentW = constraints.maxWidth;
              final innerW = !parentW.isFinite || parentW < 560
                  ? 560.0
                  : parentW;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: innerW,
                  child: row,
                ),
              );
            },
          );
        }
        return row;
      });

      return Column(
        children: [
          rows[0],
          const SizedBox(height: 12),
          rows[1],
          const SizedBox(height: 12),
          rows[2],
        ],
      );
    });

    return _card(
        title: title,
        icon: Icons.auto_graph_outlined,
        child: showTierEnableToggle
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => InkWell(
                      onTap: () => c.tierPricingEnabled.toggle(),
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      child: AppContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space16,
                          vertical: AppSize.space12,
                        ),
                        backgroundColor: c.tierPricingEnabled.value
                            ? AppColors.primaryLight
                            : AppColors.backGroundWhite,
                        border: Border.all(
                          color: c.tierPricingEnabled.value
                              ? AppColors.borderEmeraldGreen
                              : AppColors.borderGray,
                        ),
                        borderRadius: BorderRadius.circular(AppSize.radius8),
                        child: Row(
                          children: [
                            Switch(
                              value: c.tierPricingEnabled.value,
                              onChanged: (v) => c.tierPricingEnabled.value = v,
                              activeThumbColor: AppColors.emeraldGreen,
                              activeTrackColor: AppColors.emeraldGreen
                                  .withValues(alpha: 0.35),
                            ),
                            const SizedBox(width: AppSize.space8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: c.tierPricingEnabled.value
                                        ? 'Tier Pricing Enabled'
                                        : 'Tier Pricing',
                                    fontSize: AppSize.font12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  const AppText(
                                    text:
                                        'Set different prices for different quantities',
                                    fontSize: AppSize.font10,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.space12),
                  tiersBody,
                ],
              )
            : tiersBody);
  }

  Widget _dateTimeField(
    Rx<DateTime?> value,
    VoidCallback onTap,
    String placeholder, {
    required String fieldLabel,
    bool labelRequired = false,
    String? requiredKey,
  }) {
    return Obx(() {
      final hasError = requiredKey != null && c.hasFieldError(requiredKey);
      final dt = value.value;
      final text = dt == null
          ? placeholder
          : '${dt.day}/${dt.month}/${dt.year} '
              '${dt.hour.toString().padLeft(2, '0')}:'
              '${dt.minute.toString().padLeft(2, '0')}';
      final Color outline = hasError
          ? AppColors.error
          : AppColors.emeraldGreen.withValues(alpha: 0.4);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _floatingLabelStack(
            label: fieldLabel,
            labelRequired: labelRequired,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppSize.radius12),
              child: AppContainer(
                height: _formControlHeight,
                alignment: Alignment.centerLeft,
                padding: _fieldContentPadding,
                backgroundColor: AppColors.backGroundWhite,
                borderRadius: BorderRadius.circular(AppSize.radius12),
                border: Border.all(
                  color: outline,
                  width: AppSize.borderWidth1,
                ),
                child: AppText(
                  text: text,
                  fontSize: AppSize.font12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: dt == null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.space4),
          SizedBox(
            height: _errorSlotHeight,
            child: hasError
                ? AppText(
                    text: c.fieldErrorText(requiredKey),
                    fontSize: AppSize.font10,
                    color: AppColors.textError,
                  )
                : null,
          ),
        ],
      );
    });
  }

  Widget _dateField(
    Rx<DateTime?> value,
    VoidCallback onTap,
    String placeholder, {
    required String fieldLabel,
    bool labelRequired = false,
    String? requiredKey,
  }) {
    return Obx(() {
      final hasError = requiredKey != null && c.hasFieldError(requiredKey);
      final Color outline = hasError
          ? AppColors.error
          : AppColors.emeraldGreen.withValues(alpha: 0.4);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _floatingLabelStack(
            label: fieldLabel,
            labelRequired: labelRequired,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppSize.radius12),
              child: AppContainer(
                height: _formControlHeight,
                alignment: Alignment.centerLeft,
                padding: _fieldContentPadding,
                backgroundColor: AppColors.backGroundWhite,
                borderRadius: BorderRadius.circular(AppSize.radius12),
                border: Border.all(
                  color: outline,
                  width: AppSize.borderWidth1,
                ),
                child: AppText(
                  text: value.value == null
                      ? placeholder
                      : '${value.value!.day}/${value.value!.month}/${value.value!.year}',
                  fontSize: AppSize.font12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: value.value == null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.space4),
          SizedBox(
            height: _errorSlotHeight,
            child: hasError
                ? AppText(
                    text: c.fieldErrorText(requiredKey),
                    fontSize: AppSize.font10,
                    color: AppColors.textError,
                  )
                : null,
          ),
        ],
      );
    });
  }

  Widget _dropdown(
    BuildContext context,
    RxString value,
    List<String> items,
    String hint, {
    required String label,
    void Function(String)? onChanged,
    String? placeholderWhenNoItems,
  }) {
    final decoration = InputDecoration(
      isDense: true,
      filled: false,
      contentPadding: _floatingContentPadding,
      hintStyle: _floatingHintStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radius12),
        borderSide: BorderSide(
          color: AppColors.emeraldGreen.withValues(alpha: 0.4),
          width: AppSize.borderWidth1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radius12),
        borderSide: BorderSide(
          color: AppColors.emeraldGreen.withValues(alpha: 0.4),
          width: AppSize.borderWidth1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radius12),
        borderSide: BorderSide(
          color: AppColors.emeraldGreen,
          width: AppSize.borderWidth1 + AppSize.borderWidth05,
        ),
      ),
    );

    return Obx(() {
      // Always read Rx inside Obx; some empty-list branches previously read no Rx
      // which triggers GetX "improper use" warning/error.
      final selectedValue = value.value;
      final itemList = List<String>.from(items);
      if (itemList.isEmpty) {
        final msg = placeholderWhenNoItems ?? hint;
        return _floatingLabelStack(
          label: label,
          child: SizedBox(
            height: _formControlHeight,
            child: InputDecorator(
              decoration: decoration,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  msg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _floatingHintStyle,
                ),
              ),
            ),
          ),
        );
      }

      final hasVal =
          selectedValue.isNotEmpty && itemList.contains(selectedValue);
      final fieldValue = hasVal ? selectedValue : null;

      return _floatingLabelStack(
        label: label,
        child: SizedBox(
          height: _formControlHeight,
          child: DropdownButtonFormField<String>(
            key: ValueKey<String>(
                'dd_${value.hashCode}_${fieldValue}_${itemList.length}'),
            isDense: true,
            isExpanded: true,
            value: fieldValue,
            hint: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _floatingHintStyle,
              ),
            ),
            style: _fieldInputStyle,
            selectedItemBuilder: (context) => itemList
                .map(
                  (e) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _fieldInputStyle,
                    ),
                  ),
                )
                .toList(),
            decoration: decoration,
            items: itemList
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: _dropdownMenuRow(e),
                    ))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              if (onChanged != null) {
                onChanged(v);
              } else {
                value.value = v;
              }
            },
          ),
        ),
      );
    });
  }

  Widget _imagesCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AppColors.backGroundTransparent,
          child: InkWell(
            onTap: () => c.pickProductImage(),
            borderRadius: BorderRadius.circular(AppSize.radius8),
            child: AppContainer(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSize.space20),
              backgroundColor: AppColors.badgeSuccessBg,
              border: Border.all(
                color: AppColors.emerald100,
                width: AppSize.borderWidth2,
              ),
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: const Column(
                children: [
                  Icon(
                    Icons.upload_file_outlined,
                    size: AppSize.icon20,
                    color: AppColors.iconEmeraldGreen,
                  ),
                  SizedBox(height: AppSize.space8),
                  AppText(
                    text: 'Click to Upload (max 5)',
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          final pickedList = c.productImages;
          final uploadedList = c.uploadedImageUrls;
          if (pickedList.isEmpty && uploadedList.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: AppSize.space12),
            child: Wrap(
              spacing: AppSize.space8,
              runSpacing: AppSize.space8,
              alignment: WrapAlignment.start,
              children: [
                ...List.generate(uploadedList.length, (i) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _UploadedProductImageThumb(
                        path: uploadedList[i],
                        displaySize: _productThumbDisplay,
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: InkWell(
                          onTap: () => c.removeUploadedImageAt(i),
                          child: AppContainer(
                            width: 22,
                            height: 22,
                            backgroundColor: AppColors.backGroundWhite,
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusCircular),
                            border: Border.all(color: AppColors.borderGray),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                ...List.generate(pickedList.length, (i) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _ProductImageThumb(
                        file: pickedList[i],
                        displaySize: _productThumbDisplay,
                        onTap: () => c.openProductImagePreview(pickedList, i),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: InkWell(
                          onTap: () => c.removeProductImageAt(i),
                          child: AppContainer(
                            width: 22,
                            height: 22,
                            backgroundColor: AppColors.backGroundWhite,
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusCircular),
                            border: Border.all(color: AppColors.borderGray),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _tagsCard({bool elevated = false}) => _card(
      title: 'Tags',
      icon: Icons.label_outline_rounded,
      elevated: elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _textField(
          controller: c.tagInputController,
          label: 'Tags',
          placeholder: 'Add a tag and press Enter',
          onEditingComplete: () => c.addTag(c.tagInputController.text),
          hasError: false,
          errorText: '',
        ),
        const SizedBox(height: AppSize.space8),
        Obx(() => Wrap(
            spacing: AppSize.space8,
            runSpacing: AppSize.space8,
            children: c.tags
                .map((tag) => AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.space8, vertical: AppSize.space4),
                    backgroundColor: AppColors.badgeSuccessBg,
                    border: Border.all(color: AppColors.emerald100),
                    borderRadius: BorderRadius.circular(AppSize.radius20),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      AppText(
                          text: tag,
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textEmeraldGreen),
                      const SizedBox(width: AppSize.space4),
                      GestureDetector(
                          onTap: () => c.removeTag(tag),
                          child: const Icon(Icons.close,
                              size: AppSize.font10,
                              color: AppColors.textEmeraldGreen)),
                    ])))
                .toList()))
      ]));
}

class _UploadedProductImageThumb extends StatelessWidget {
  const _UploadedProductImageThumb({
    required this.path,
    required this.displaySize,
  });

  final String path;
  final double displaySize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.radius8),
      child: SizedBox(
        width: displaySize,
        height: displaySize,
        child: AppUrlOrAssetImage(
          path: path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ProductImageThumb extends StatelessWidget {
  const _ProductImageThumb({
    required this.file,
    required this.displaySize,
    required this.onTap,
  });

  final XFile file;
  final double displaySize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cachePx = (displaySize * dpr).round().clamp(128, 384);

    return FutureBuilder<Uint8List>(
      future: _productPhotoThumbBytes(file),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        final child = bytes == null
            ? AppThumbSkeleton(size: displaySize)
            : Image.memory(
                bytes,
                fit: BoxFit.cover,
                width: displaySize,
                height: displaySize,
                gaplessPlayback: true,
                cacheWidth: cachePx,
                cacheHeight: cachePx,
              );

        return Material(
          color: AppColors.backGroundTransparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: SizedBox(
                width: displaySize,
                height: displaySize,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
