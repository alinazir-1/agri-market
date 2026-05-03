// lib/features/seller/add_product/add_new_product_con.dart

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agri_market/features/seller/products/my_products_con.dart';
import 'package:csc_picker_plus/model/select_status_model.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/utils/product_image_storage.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/batch_model.dart';
import 'package:agri_market/data/models/tier_price_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/data/models/stock_batch_model.dart';
import 'package:agri_market/data/models/inventory_model.dart';
import 'package:agri_market/data/models/product_model.dart';
import 'package:agri_market/features/seller/inventory/inventory_con.dart';
import 'package:agri_market/features/seller/add_product/product_catalog_data.dart';
import 'package:agri_market/features/seller/add_product/product_variety_catalog.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_con.dart';
import 'package:agri_market/features/shared/product_detail/product_detail_screen.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

enum AddListingType { marketplace, advanceBooking, liveAuctions }

class AddNewProductCon extends GetxController {
  /// No listing type chosen until the user selects one (create flow).
  final Rxn<AddListingType> selectedListingType = Rxn<AddListingType>();

  final RxnString editingProductId = RxnString();
  final RxString productNameError = ''.obs;
  final RxBool isFormValid = false.obs;

  /// True when a listing type is selected **and** that type’s minimum fields
  /// (price/unit/qty/MOQ, etc.) are filled — drives Publish / Add to inventory.
  final RxBool listingActionsEnabled = false.obs;
  final RxBool submitAttempted = false.obs;

  void selectListingType(AddListingType type) {
    selectedListingType.value = type;
  }

  final productNameController = TextEditingController();
  final productNameFocusNode = FocusNode();
  /// Bound to product-name [DropdownButtonFormField] (catalog pick).
  final RxString productDropdownSelection = ''.obs;

  /// Searchable catalog overlay (aligned under product row).
  final LayerLink productPickerLayerLink = LayerLink();
  OverlayEntry? productPickerOverlay;
  final RxString productPickerFilter = ''.obs;
  final TextEditingController productPickerSearchController =
      TextEditingController();
  final FocusNode productPickerSearchFocus = FocusNode();

  /// Lets list item [onTap] run before overlay is removed on text-field focus loss.
  Timer? _productPickerUnfocusDebounce;

  void _cancelProductPickerUnfocusDebounce() {
    _productPickerUnfocusDebounce?.cancel();
    _productPickerUnfocusDebounce = null;
  }

  /// Call from product name [Focus.onFocusChange] so suggestions hide when leaving the field.
  void onProductNameFieldFocusChanged(bool hasFocus) {
    if (hasFocus) {
      _cancelProductPickerUnfocusDebounce();
    } else {
      _cancelProductPickerUnfocusDebounce();
      _productPickerUnfocusDebounce =
          Timer(const Duration(milliseconds: 200), () {
        _productPickerUnfocusDebounce = null;
        if (!productNameFocusNode.hasFocus) {
          closeProductPicker();
        }
      });
    }
  }

  /// Category / sub-category searchable fields (same overlay pattern as product).
  final LayerLink categoryPickerLayerLink = LayerLink();
  OverlayEntry? categoryPickerOverlay;
  final RxString categoryPickerFilter = ''.obs;
  final TextEditingController categoryPickerSearchController =
      TextEditingController();
  final FocusNode categoryPickerSearchFocus = FocusNode();

  final LayerLink subCategoryPickerLayerLink = LayerLink();
  OverlayEntry? subCategoryPickerOverlay;
  final RxString subCategoryPickerFilter = ''.obs;
  final TextEditingController subCategoryPickerSearchController =
      TextEditingController();
  final FocusNode subCategoryPickerSearchFocus = FocusNode();

  final LayerLink varietyPickerLayerLink = LayerLink();
  OverlayEntry? varietyPickerOverlay;
  final RxString varietyPickerFilter = ''.obs;
  final TextEditingController varietyPickerSearchController =
      TextEditingController();
  final FocusNode varietyPickerSearchFocus = FocusNode();

  /// Country / region / city / delivery / unit / currency — category-style overlay (no search field).
  final LayerLink countryPickerLayerLink = LayerLink();
  OverlayEntry? countryPickerOverlay;
  final LayerLink regionPickerLayerLink = LayerLink();
  OverlayEntry? regionPickerOverlay;
  final LayerLink cityPickerLayerLink = LayerLink();
  OverlayEntry? cityPickerOverlay;
  final LayerLink deliveryPickerLayerLink = LayerLink();
  OverlayEntry? deliveryPickerOverlay;
  final LayerLink unitPickerLayerLink = LayerLink();
  OverlayEntry? unitPickerOverlay;
  final LayerLink currencyPickerLayerLink = LayerLink();
  OverlayEntry? currencyPickerOverlay;
  final LayerLink sampleDispatchPickerLayerLink = LayerLink();
  OverlayEntry? sampleDispatchPickerOverlay;
  final LayerLink sampleDeliveryCoveredPickerLayerLink = LayerLink();
  OverlayEntry? sampleDeliveryCoveredPickerOverlay;
  final LayerLink bookingUnitPickerLayerLink = LayerLink();
  OverlayEntry? bookingUnitPickerOverlay;
  final LayerLink bookingCurrencyPickerLayerLink = LayerLink();
  OverlayEntry? bookingCurrencyPickerOverlay;
  final LayerLink auctionUnitPickerLayerLink = LayerLink();
  OverlayEntry? auctionUnitPickerOverlay;
  final LayerLink auctionCurrencyPickerLayerLink = LayerLink();
  OverlayEntry? auctionCurrencyPickerOverlay;

  final FocusNode listPickerOverlayFocus = FocusNode(skipTraversal: true);
  final RxString listPickerTypeAheadPrefix = ''.obs;

  void clearListPickerTypeAhead() {
    listPickerTypeAheadPrefix.value = '';
  }

  /// Prefix stays until user picks an item, closes overlay, or uses Backspace — no auto-timeout.
  void appendListPickerTypeAheadChar(String ch) {
    if (listPickerTypeAheadPrefix.value.length >= 32) return;
    final lower = ch.length == 1 ? ch.toLowerCase() : ch;
    if (!RegExp(r'^[a-z ]$').hasMatch(lower)) return;
    listPickerTypeAheadPrefix.value = listPickerTypeAheadPrefix.value + lower;
  }

  void removeLastListPickerTypeAheadChar() {
    final p = listPickerTypeAheadPrefix.value;
    if (p.isEmpty) return;
    listPickerTypeAheadPrefix.value = p.substring(0, p.length - 1);
  }

  void closeCountryPicker() {
    countryPickerOverlay?.remove();
    countryPickerOverlay = null;
  }

  void closeRegionPicker() {
    regionPickerOverlay?.remove();
    regionPickerOverlay = null;
  }

  void closeCityPicker() {
    cityPickerOverlay?.remove();
    cityPickerOverlay = null;
  }

  void closeDeliveryPicker() {
    deliveryPickerOverlay?.remove();
    deliveryPickerOverlay = null;
  }

  void closeUnitPicker() {
    unitPickerOverlay?.remove();
    unitPickerOverlay = null;
  }

  void closeCurrencyPicker() {
    currencyPickerOverlay?.remove();
    currencyPickerOverlay = null;
  }

  void closeSampleDispatchPicker() {
    sampleDispatchPickerOverlay?.remove();
    sampleDispatchPickerOverlay = null;
  }

  void closeSampleDeliveryCoveredPicker() {
    sampleDeliveryCoveredPickerOverlay?.remove();
    sampleDeliveryCoveredPickerOverlay = null;
  }

  void closeBookingUnitPicker() {
    bookingUnitPickerOverlay?.remove();
    bookingUnitPickerOverlay = null;
  }

  void closeBookingCurrencyPicker() {
    bookingCurrencyPickerOverlay?.remove();
    bookingCurrencyPickerOverlay = null;
  }

  void closeAuctionUnitPicker() {
    auctionUnitPickerOverlay?.remove();
    auctionUnitPickerOverlay = null;
  }

  void closeAuctionCurrencyPicker() {
    auctionCurrencyPickerOverlay?.remove();
    auctionCurrencyPickerOverlay = null;
  }

  void closeFormListPickers() {
    closeCountryPicker();
    closeRegionPicker();
    closeCityPicker();
    closeDeliveryPicker();
    closeUnitPicker();
    closeCurrencyPicker();
    closeSampleDispatchPicker();
    closeSampleDeliveryCoveredPicker();
    closeBookingUnitPicker();
    closeBookingCurrencyPicker();
    closeAuctionUnitPicker();
    closeAuctionCurrencyPicker();
    clearListPickerTypeAhead();
  }

  void _requestListPickerOverlayFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listPickerOverlayFocus.canRequestFocus) {
        listPickerOverlayFocus.requestFocus();
      }
    });
  }

  void showCountryPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    countryPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showRegionPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    regionPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showCityPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    cityPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showDeliveryPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    deliveryPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showUnitPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    unitPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showCurrencyPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    currencyPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showSampleDispatchPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    sampleDispatchPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showSampleDeliveryCoveredPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    sampleDeliveryCoveredPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showBookingUnitPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    bookingUnitPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showBookingCurrencyPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    bookingCurrencyPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showAuctionUnitPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    auctionUnitPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void showAuctionCurrencyPicker(BuildContext context, OverlayEntry entry) {
    closeAllCatalogPickers();
    closeFormListPickers();
    auctionCurrencyPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    _requestListPickerOverlayFocus();
  }

  void closeProductPicker() {
    _cancelProductPickerUnfocusDebounce();
    productPickerOverlay?.remove();
    productPickerOverlay = null;
    productPickerSearchController.clear();
    productPickerFilter.value = '';
  }

  void closeCategoryPicker() {
    categoryPickerOverlay?.remove();
    categoryPickerOverlay = null;
    categoryPickerSearchController.clear();
    categoryPickerFilter.value = '';
  }

  void closeSubCategoryPicker() {
    subCategoryPickerOverlay?.remove();
    subCategoryPickerOverlay = null;
    subCategoryPickerSearchController.clear();
    subCategoryPickerFilter.value = '';
  }

  void closeVarietyPicker() {
    varietyPickerOverlay?.remove();
    varietyPickerOverlay = null;
    varietyPickerSearchController.clear();
    varietyPickerFilter.value = '';
  }

  /// Closes product + category + sub-category list overlays (before opening another).
  void closeAllCatalogPickers() {
    closeProductPicker();
    closeCategoryPicker();
    closeSubCategoryPicker();
    closeVarietyPicker();
  }

  void _insertPickerOverlay(BuildContext context, OverlayEntry entry) {
    final overlayState =
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.of(context);
    overlayState.insert(entry);
  }

  void showProductCatalogPicker(
    BuildContext context,
    OverlayEntry entry, {
    bool requestListSearchFocus = true,
  }) {
    closeFormListPickers();
    closeAllCatalogPickers();
    productPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    if (requestListSearchFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (productPickerSearchFocus.canRequestFocus) {
          productPickerSearchFocus.requestFocus();
        }
      });
    }
  }

  void showCategoryPicker(BuildContext context, OverlayEntry entry) {
    closeFormListPickers();
    closeAllCatalogPickers();
    categoryPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (categoryPickerSearchFocus.canRequestFocus) {
        categoryPickerSearchFocus.requestFocus();
      }
    });
  }

  void showSubCategoryPicker(BuildContext context, OverlayEntry entry) {
    closeFormListPickers();
    closeAllCatalogPickers();
    subCategoryPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (subCategoryPickerSearchFocus.canRequestFocus) {
        subCategoryPickerSearchFocus.requestFocus();
      }
    });
  }

  void showVarietyPicker(BuildContext context, OverlayEntry entry) {
    closeFormListPickers();
    closeAllCatalogPickers();
    varietyPickerOverlay = entry;
    _insertPickerOverlay(context, entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (varietyPickerSearchFocus.canRequestFocus) {
        varietyPickerSearchFocus.requestFocus();
      }
    });
  }

  static final Map<String, Map<String, List<String>>> productCatalog =
      ProductCatalogData.catalog;

  static final Map<String, ({String category, String subCategory})>
      productMetaByName = _buildProductMetaByName();

  static final List<String> allProducts = productMetaByName.keys.toList();

  static List<String>? _catalogNamesSorted;

  /// All catalog product names, sorted (stable list for dropdown).
  static List<String> get catalogNamesSorted {
    _catalogNamesSorted ??= List<String>.from(allProducts)
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return _catalogNamesSorted!;
  }

  /// Sync filter for [Autocomplete.optionsBuilder] (must be synchronous; debounced Rx alone breaks the overlay).
  static Iterable<String> filteredProductSuggestions(String raw) {
    final q = raw.trim().toLowerCase();
    if (q.isEmpty) return const Iterable<String>.empty();
    var suggestions = allProducts
        .where((name) => name.toLowerCase().contains(q))
        .take(20)
        .toList();
    if (suggestions.length == 1 && suggestions.first.toLowerCase() == q) {
      suggestions = <String>[];
    }
    return suggestions;
  }

  final RxList<String> productNameSuggestions = <String>[].obs;
  final RxnString selectedProduct = RxnString();
  final RxString productQuery = ''.obs;

  final descriptionController = TextEditingController();
  final varietyController = TextEditingController();
  /// Synced with [varietyController] for dropdown UI (GetX [Obx]).
  final RxString selectedVarietyDisplay = ''.obs;
  final batchCodeController = TextEditingController();
  final RxList<BatchModel> batches = <BatchModel>[].obs;
  final Rxn<int> expandedBatchIndex = Rxn<int>();

  /// Product form: one expand flag per batch card (first batch starts expanded).
  final RxList<RxBool> batchExpandedStates = <RxBool>[true.obs].obs;

  void addBatch(BatchModel batch) {
    batches.add(batch);
  }

  void removeBatch(int index) {
    if (index < 0 || index >= batches.length) return;
    batches.removeAt(index);
    final ex = expandedBatchIndex.value;
    if (ex == null) return;
    if (ex == index) {
      expandedBatchIndex.value = null;
    } else if (ex > index) {
      expandedBatchIndex.value = ex - 1;
    }
  }

  void toggleBatchRowExpanded(int index) {
    expandedBatchIndex.value =
        expandedBatchIndex.value == index ? null : index;
  }

  String nextBatchCodeForAddBatchDialog() {
    final y = DateTime.now().year;
    final seq = _getNextBatchSequence(includeLocalBatchRows: true);
    return 'BATCH-$y-${seq.toString().padLeft(3, '0')}';
  }

  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;

  List<String> get categories => productCatalog.keys.toList();

  List<String> get currentSubCategories =>
      productCatalog[selectedCategory.value]?.keys.toList() ??
      (selectedSubCategory.value.isEmpty ? [] : [selectedSubCategory.value]);

  List<String> get currentVarieties {
    final name = selectedProduct.value;
    if (name == null || name.isEmpty) return const [];
    return ProductVarietyCatalog.varietiesFor(name);
  }

  void _clearVariety() {
    varietyController.clear();
    selectedVarietyDisplay.value = '';
  }

  void onVarietyChanged(String v) {
    closeFormListPickers();
    closeAllCatalogPickers();
    varietyController.text = v;
    selectedVarietyDisplay.value = v;
  }

  List<String> get currentProducts {
    if (selectedCategory.value.isEmpty) {
      return allProducts;
    }
    if (selectedSubCategory.value.isEmpty) {
      final inCategory = productCatalog[selectedCategory.value];
      if (inCategory == null) return allProducts;
      return inCategory.values.expand((x) => x).toList();
    }
    final inSub = productCatalog[selectedCategory.value]?[selectedSubCategory.value];
    if (inSub == null || inSub.isEmpty) return allProducts;
    return inSub;
  }

  Future<List<String>> _uploadProductImages({
    required String sellerId,
    required String productId,
  }) async {
    final out = <String>[];
    for (final x in productImages.take(5)) {
      final raw = await x.readAsBytes();
      final ready = ProductImageStorage.compressBytes(raw);
      out.add(ProductImageStorage.toHiveString(ready));
    }
    return out;
  }

  void onCategoryChanged(String cat) {
    closeFormListPickers();
    closeAllCatalogPickers();
    selectedCategory.value = cat;
    selectedSubCategory.value = '';
    selectedProduct.value = null;
    productDropdownSelection.value = '';
    productNameController.clear();
    productNameSuggestions.clear();
    productNameError.value = '';
    _clearVariety();
  }

  void onSubCategoryChanged(String sub) {
    closeFormListPickers();
    closeAllCatalogPickers();
    selectedSubCategory.value = sub;
    selectedProduct.value = null;
    productDropdownSelection.value = '';
    productNameController.clear();
    productNameSuggestions.clear();
    productNameError.value = '';
    _clearVariety();
  }

  static const List<String> qualityGrades = ['A+', 'A', 'B+', 'B', 'C'];
  final RxString selectedGrade = 'A+'.obs;
  final cropYearController = TextEditingController();
  final moistureController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> openProductImagePreview(List<XFile> files, int index) async {
    await _openPickedImagePreviewDialog(
      files: files,
      initialIndex: index,
    );
  }

  Future<void> _openPickedImagePreviewDialog({
    required List<XFile> files,
    required int initialIndex,
  }) async {
    if (files.isEmpty) return;
    final idxRef = <int>[
      initialIndex.clamp(0, files.length - 1),
    ];
    final zoomCtrl = TransformationController();

    void resetZoom() {
      zoomCtrl.value = Matrix4.identity();
    }

    await Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(AppSize.space24),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            final idx = idxRef[0];
            final file = files[idx];
            final screen = MediaQuery.sizeOf(context);
            final dialogW = (screen.width - 48).clamp(320.0, 920.0);
            final imageH = (screen.height * 0.70).clamp(380.0, 680.0);
            final maxDialogH = screen.height * 0.94;
            final viewW = dialogW - AppSize.space20 * 2;
            final viewH = imageH;

            /// Scale about viewport center; [minScale]=1 matches initial "fit" preview.
            void bumpZoom(double mult) {
              const minScale = 1.0;
              const maxScale = 5.0;
              final cur = zoomCtrl.value.getMaxScaleOnAxis();
              if (cur <= 0) return;
              final next = (cur * mult).clamp(minScale, maxScale);
              final ratio = next / cur;
              if ((ratio - 1).abs() < 0.001) return;
              final cx = viewW / 2;
              final cy = viewH / 2;
              final tPos = Matrix4.translationValues(cx, cy, 0);
              final s = Matrix4.diagonal3Values(ratio, ratio, 1.0);
              final tNeg = Matrix4.translationValues(-cx, -cy, 0);
              zoomCtrl.value = tPos * s * tNeg * zoomCtrl.value;
            }

            final title =
                files.length > 1 ? 'Product images' : 'Product image';

            return AppContainer(
              width: dialogW,
              constraints: BoxConstraints(maxHeight: maxDialogH),
              padding: const EdgeInsets.all(AppSize.space20),
              backgroundColor: AppColors.backGroundWhite,
              borderRadius: BorderRadius.circular(AppSize.radius16),
              border: Border.all(color: AppColors.borderGray),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              text: title,
                              fontSize: AppSize.font18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              decoration: TextDecoration.none,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (files.length > 1) ...[
                              const SizedBox(height: AppSize.space4),
                              AppText(
                                text: '${idx + 1} of ${files.length}',
                                fontSize: AppSize.font12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.none,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Material(
                        color: AppColors.backGroundTransparent,
                        child: InkWell(
                          onTap: () => Get.back<void>(),
                          borderRadius:
                              BorderRadius.circular(AppSize.radius8),
                          child: const Padding(
                            padding: EdgeInsets.all(AppSize.space4),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.space16),
                  SizedBox(
                    height: imageH,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(
                            color: AppColors.backgroundSurface,
                            child: FutureBuilder<Uint8List>(
                              key: ValueKey<Object>(file),
                              future: file.readAsBytes(),
                              builder: (context, snap) {
                                if (snap.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.textEmeraldGreen,
                                      ),
                                    ),
                                  );
                                }
                                if (snap.hasError || !snap.hasData) {
                                  return const Center(
                                    child: AppText(
                                      text: 'Could not load image',
                                      fontSize: AppSize.font12,
                                      color: AppColors.textSecondary,
                                      decoration: TextDecoration.none,
                                    ),
                                  );
                                }
                                return InteractiveViewer(
                                  transformationController: zoomCtrl,
                                  minScale: 1.0,
                                  maxScale: 5.0,
                                  panAxis: PanAxis.vertical,
                                  clipBehavior: Clip.hardEdge,
                                  boundaryMargin: const EdgeInsets.symmetric(
                                    vertical: 200,
                                    horizontal: 24,
                                  ),
                                  child: Image.memory(
                                    snap.data!,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                    filterQuality: FilterQuality.medium,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (idx > 0)
                            Positioned(
                              left: 6,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Material(
                                  color: AppColors.backGroundWhite
                                      .withValues(alpha: 0.92),
                                  shape: const CircleBorder(),
                                  elevation: 2,
                                  shadowColor: const Color(0x33000000),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () {
                                      resetZoom();
                                      idxRef[0] = idx - 1;
                                      setDialogState(() {});
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.chevron_left,
                                        size: 32,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (idx < files.length - 1)
                            Positioned(
                              right: 6,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Material(
                                  color: AppColors.backGroundWhite
                                      .withValues(alpha: 0.92),
                                  shape: const CircleBorder(),
                                  elevation: 2,
                                  shadowColor: const Color(0x33000000),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () {
                                      resetZoom();
                                      idxRef[0] = idx + 1;
                                      setDialogState(() {});
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: 32,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: ListenableBuilder(
                              listenable: zoomCtrl,
                              builder: (context, _) {
                                final s =
                                    zoomCtrl.value.getMaxScaleOnAxis();
                                const zoomInThreshold = 1.02;
                                final isZoomedIn = s > zoomInThreshold;
                                final atMaxZoom = s >= 4.92;

                                const btnFill =
                                    AppColors.backGroundLightGrey;
                                final zoomInIconColor = isZoomedIn
                                    ? AppColors.emeraldGreen
                                    : AppColors.textPrimary;
                                const zoomOutIconColor =
                                    AppColors.textPrimary;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Opacity(
                                      opacity: atMaxZoom ? 0.45 : 1,
                                      child: Material(
                                        color: btnFill,
                                        shape: const CircleBorder(),
                                        elevation: 1,
                                        shadowColor:
                                            const Color(0x22000000),
                                        child: InkWell(
                                          customBorder:
                                              const CircleBorder(),
                                          onTap: atMaxZoom
                                              ? null
                                              : () => bumpZoom(1.18),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.zoom_in,
                                              size: 22,
                                              color: zoomInIconColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isZoomedIn) ...[
                                      const SizedBox(
                                          height: AppSize.space8),
                                      Material(
                                        color: btnFill,
                                        shape: const CircleBorder(),
                                        elevation: 1,
                                        shadowColor:
                                            const Color(0x22000000),
                                        child: InkWell(
                                          customBorder:
                                              const CircleBorder(),
                                          onTap: () =>
                                              bumpZoom(1 / 1.18),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.zoom_out,
                                              size: 22,
                                              color: zoomOutIconColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.space12),
                  AppText(
                    text: file.name,
                    textAlign: TextAlign.center,
                    fontSize: AppSize.font12,
                    height: 1.4,
                    color: AppColors.textSecondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    decoration: TextDecoration.none,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: true,
    ).whenComplete(zoomCtrl.dispose);

  }

  final RxList<Map<String, String>> specifications = <Map<String, String>>[
    {'name': '', 'value': '', 'unit': '%'}
  ].obs;
  final List<TextEditingController> specNameControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> specValueControllers = [
    TextEditingController()
  ];
  final RxList<String> specUnits = <String>['%'].obs;

  final List<String> quickSpecChips = [
    'Oil',
    'Protein',
    'Fiber',
    'Moisture',
    'Fat',
    'Ash Content',
    'Carbohydrates',
    'Gluten',
    'Iron',
    'Calcium',
  ];

  final List<String> unitOptions = ['%', 'g/100g', 'mg/kg', 'ppm', 'custom'];

  /// Bumps when spec rows change so GetX rebuilds dropdowns / list rows.
  final RxInt specLayoutRevision = 0.obs;

  final RxList<String> quickChipsVisible = <String>[].obs;

  void addSpecFromChip(String chipLabel) {
    var emptyIndex = -1;
    for (var i = specNameControllers.length - 1; i >= 0; i--) {
      if (specNameControllers[i].text.trim().isEmpty &&
          specValueControllers[i].text.trim().isEmpty) {
        emptyIndex = i;
        break;
      }
    }
    if (emptyIndex != -1) {
      specNameControllers[emptyIndex].text = chipLabel;
      if (emptyIndex < specifications.length) {
        final s = specifications[emptyIndex];
        specifications[emptyIndex] = {
          'name': chipLabel,
          'value': (s['value'] ?? '').toString(),
          'unit': (s['unit'] ?? '%').toString(),
        };
      }
      specLayoutRevision.value++;
      return;
    }
    specNameControllers.add(TextEditingController(text: chipLabel));
    specValueControllers.add(TextEditingController());
    specUnits.add('%');
    specifications.add({'name': chipLabel, 'value': '', 'unit': '%'});
    specLayoutRevision.value++;
  }

  void addEmptySpec() {
    specNameControllers.add(TextEditingController());
    specValueControllers.add(TextEditingController());
    specUnits.add('%');
    specifications.add({'name': '', 'value': '', 'unit': '%'});
    specLayoutRevision.value++;
  }

  void removeSpec(int index) {
    if (specifications.length <= 1) return;
    specNameControllers[index].dispose();
    specValueControllers[index].dispose();
    specNameControllers.removeAt(index);
    specValueControllers.removeAt(index);
    specUnits.removeAt(index);
    specifications.removeAt(index);
    specLayoutRevision.value++;
  }

  void clearSpecRow(int index) {
    if (index < 0 || index >= specNameControllers.length) return;
    specNameControllers[index].clear();
    specValueControllers[index].clear();
    if (index < specUnits.length) {
      specUnits[index] = '%';
    }
    if (index < specifications.length) {
      specifications[index] = {'name': '', 'value': '', 'unit': '%'};
    }
    specLayoutRevision.value++;
  }

  void removeQuickChipFromBar(String name) {
    quickChipsVisible.remove(name);
  }

  void updateSpecUnit(int index, String unit) {
    specUnits[index] = unit;
    final updated = Map<String, String>.from(specifications[index]);
    updated['unit'] = unit;
    specifications[index] = updated;
    specLayoutRevision.value++;
  }

  final RxString selectedCountry = ''.obs;
  final RxString selectedRegion = ''.obs;
  final RxString selectedCity = ''.obs;
  final deliveryTimeController = TextEditingController();
  final RxString selectedDeliveryOption = ''.obs;

  /// [csc_picker_plus] ships `countries.json`; same hierarchy as package widget.
  List<Country>? _cscCountriesCache;
  final RxBool cscLocationDataReady = false.obs;
  final RxString cscLocationLoadError = ''.obs;

  Future<void> _loadCscCountriesJson() async {
    if (_cscCountriesCache != null) return;
    final raw = await rootBundle.loadString(
      'packages/csc_picker_plus/lib/assets/countries.json',
    );
    final decoded = jsonDecode(raw) as List<dynamic>;
    _cscCountriesCache = decoded
        .map((e) => Country.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _ensureCscLocationReady() async {
    try {
      cscLocationLoadError.value = '';
      await _loadCscCountriesJson();
      cscLocationDataReady.value = true;
      _normalizeLocationSelectionToCsc();
    } catch (e, st) {
      debugPrint('CSC location data: $e\n$st');
      cscLocationLoadError.value = '$e';
      cscLocationDataReady.value = false;
    }
  }

  Country? _cscCountryByName(String name) {
    if (name.isEmpty || _cscCountriesCache == null) return null;
    for (final c in _cscCountriesCache!) {
      if (c.name == name) return c;
    }
    return null;
  }

  void _normalizeLocationSelectionToCsc() {
    if (_cscCountriesCache == null) return;
    final countries = allCountries;
    if (selectedCountry.value.isNotEmpty &&
        !countries.contains(selectedCountry.value)) {
      selectedCountry.value = countries.isNotEmpty ? countries.first : '';
      selectedRegion.value = '';
      selectedCity.value = '';
      return;
    }
    if (selectedRegion.value.isNotEmpty &&
        !regionsForCountry.contains(selectedRegion.value)) {
      selectedRegion.value = '';
      selectedCity.value = '';
    }
    if (selectedCity.value.isNotEmpty &&
        !citiesForRegion.contains(selectedCity.value)) {
      selectedCity.value = '';
    }
    if (selectedCountry.value.isEmpty) {
      selectedRegion.value = '';
      selectedCity.value = '';
    }
  }

  List<String> get allCountries {
    final list = _cscCountriesCache;
    if (list == null) return const [];
    final names = list.map((e) => e.name).whereType<String>().toList();
    names.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return names;
  }

  List<String> get regionsForCountry {
    final co = _cscCountryByName(selectedCountry.value);
    final states = co?.state;
    if (states == null || states.isEmpty) return const [];
    final names = states.map((r) => r.name).whereType<String>().toList();
    names.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return names;
  }

  List<String> get citiesForRegion {
    final co = _cscCountryByName(selectedCountry.value);
    if (co?.state == null) return const [];
    final rn = selectedRegion.value;
    Region? region;
    for (final r in co!.state!) {
      if (r.name == rn) {
        region = r;
        break;
      }
    }
    if (region?.city == null || region!.city!.isEmpty) return const [];
    final cityNames =
        region.city!.map((ci) => ci.name).whereType<String>().toList();
    cityNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return cityNames;
  }

  void onCountryChanged(String country) {
    closeCountryPicker();
    clearListPickerTypeAhead();
    selectedCountry.value = country;
    selectedRegion.value = '';
    selectedCity.value = '';
  }

  void onRegionChanged(String region) {
    closeRegionPicker();
    clearListPickerTypeAhead();
    selectedRegion.value = region;
    selectedCity.value = '';
  }

  void onCityChanged(String city) {
    closeCityPicker();
    clearListPickerTypeAhead();
    selectedCity.value = city;
  }

  void onDeliveryOptionSelected(String v) {
    closeDeliveryPicker();
    selectedDeliveryOption.value = v;
  }

  void onUnitSelected(String v) {
    closeUnitPicker();
    selectedUnit.value = v;
  }

  void onCurrencySelected(String v) {
    closeCurrencyPicker();
    selectedCurrency.value = v;
  }

  void onSampleDispatchTimeSelected(String v) {
    closeSampleDispatchPicker();
    selectedDispatchTime.value = v;
  }

  void onSampleDeliveryCoveredBySelected(String v) {
    closeSampleDeliveryCoveredPicker();
    selectedDeliveryCoveredBy.value = v;
  }

  void onBookingUnitSelected(String v) {
    closeBookingUnitPicker();
    selectedBookingUnit.value = v;
  }

  void onBookingCurrencySelected(String v) {
    closeBookingCurrencyPicker();
    selectedBookingCurrency.value = v;
  }

  void onAuctionUnitSelected(String v) {
    closeAuctionUnitPicker();
    selectedAuctionUnit.value = v;
  }

  void onAuctionCurrencySelected(String v) {
    closeAuctionCurrencyPicker();
    selectedAuctionCurrency.value = v;
  }

  final tagInputController = TextEditingController();
  final RxList<String> tags =
      <String>['Organic', 'Premium', 'Export Quality'].obs;
  final RxList<XFile> productImages = <XFile>[].obs;
  final RxList<String> uploadedImageUrls = <String>[].obs;
  final RxBool isUploading = false.obs;

  Future<void> pickProductImage() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      final totalImages = uploadedImageUrls.length + productImages.length;
      if (totalImages >= 5) {
        Get.snackbar('Limit reached', 'You can upload up to 5 images only.');
        return;
      }
      final files = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (files.isNotEmpty) {
        final slots = 5 - totalImages;
        final picked = files.take(slots).toList();
        productImages.addAll(picked);
        if (files.length > slots) {
          Get.snackbar('Limit reached', 'Only first $slots images were added.');
        }
      }
    } catch (e, st) {
      debugPrint('pickProductImage: $e\n$st');
      final msg = kIsWeb
          ? 'Web: use Chrome/Edge over http://localhost and allow file access when prompted.'
          : e.toString();
      Get.snackbar('Could not pick image', msg,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4));
    }
  }

  void removeProductImageAt(int index) {
    if (index >= 0 && index < productImages.length) {
      productImages.removeAt(index);
    }
  }

  void removeUploadedImageAt(int index) {
    if (index >= 0 && index < uploadedImageUrls.length) {
      uploadedImageUrls.removeAt(index);
    }
  }

  void addTag(String tag) {
    if (tag.trim().isNotEmpty && !tags.contains(tag.trim())) {
      tags.add(tag.trim());
      tagInputController.clear();
    }
  }

  void removeTag(String tag) => tags.remove(tag);

  final RxBool sampleAvailable = true.obs;
  final sampleQtyController = TextEditingController();
  final samplePriceController = TextEditingController();
  final RxString selectedSampleUnit = 'kg'.obs;
  final RxString selectedDispatchTime = ''.obs;
  final RxString selectedDeliveryCoveredBy = ''.obs;

  static const List<String> sampleUnitOptions = [
    'kg',
    'g',
    'lb',
    'Ton',
    'Box',
  ];
  static const List<String> sampleDispatchTimeOptions = [
    'Within 24 hours',
    '2–3 business days',
    '5–7 business days',
    '1–2 weeks',
  ];
  static const List<String> sampleDeliveryCoveredByOptions = [
    'Seller',
    'Buyer',
    'Shared',
  ];

  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final moqController = TextEditingController();
  final RxString selectedUnit = ''.obs;
  final RxString selectedCurrency = 'USD (\$)'.obs;

  final bookingPriceController = TextEditingController();
  final totalEstimatedPriceController = TextEditingController();
  final bookingQtyController = TextEditingController();
  final bookingMoqController = TextEditingController();
  final RxString selectedBookingUnit = ''.obs;
  final RxString selectedBookingCurrency = 'USD (\$)'.obs;
  final Rx<DateTime?> harvestDate = Rx<DateTime?>(null);

  final startingBidController = TextEditingController();
  final lotSizeController = TextEditingController();
  final reservePriceController = TextEditingController();
  final bidIncrementController = TextEditingController();
  final maxBiddersController = TextEditingController();
  final Rx<DateTime?> auctionStartDateTime = Rx<DateTime?>(null);
  final Rx<DateTime?> auctionEndDateTime = Rx<DateTime?>(null);
  final RxString selectedAuctionCurrency = 'USD (\$)'.obs;
  final RxString selectedAuctionUnit = ''.obs;
  final RxBool auctionAutoExtend = false.obs;
  final RxBool auctionReserveVisibleToBidders = true.obs;

  final supplierNameController = TextEditingController();
  final supplierContactController = TextEditingController();
  final supplierLocationController = TextEditingController();
  final Rx<DateTime?> purchaseDate = Rx<DateTime?>(null);

  final advancePaymentPercentController = TextEditingController(text: '20');
  final Rx<DateTime?> bookingDeadline = Rx<DateTime?>(null);
  final Rx<DateTime?> estimatedDeliveryDate = Rx<DateTime?>(null);

  final List<TextEditingController> marketplaceTierQtyControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> marketplaceTierMaxQtyControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> marketplaceTierPriceControllers = [
    TextEditingController()
  ];
  final RxList<String> marketplaceTierUnits = <String>['Ton'].obs;
  final RxInt marketplaceTierRevision = 0.obs;
  final RxBool tierPricingEnabled = false.obs;

  final List<TextEditingController> bookingTierQtyControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> bookingTierMaxQtyControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> bookingTierPriceControllers = [
    TextEditingController()
  ];
  final RxList<String> bookingTierUnits = <String>['Ton'].obs;
  final RxInt bookingTierRevision = 0.obs;

  void addMarketplaceTier() {
    marketplaceTierQtyControllers.add(TextEditingController());
    marketplaceTierMaxQtyControllers.add(TextEditingController());
    marketplaceTierPriceControllers.add(TextEditingController());
    marketplaceTierUnits.add(
        selectedUnit.value.isEmpty ? 'Ton' : selectedUnit.value);
    marketplaceTierRevision.value++;
  }

  void removeMarketplaceTier(int index) {
    if (marketplaceTierQtyControllers.length <= 1) return;
    marketplaceTierQtyControllers[index].dispose();
    marketplaceTierMaxQtyControllers[index].dispose();
    marketplaceTierPriceControllers[index].dispose();
    marketplaceTierQtyControllers.removeAt(index);
    marketplaceTierMaxQtyControllers.removeAt(index);
    marketplaceTierPriceControllers.removeAt(index);
    marketplaceTierUnits.removeAt(index);
    marketplaceTierRevision.value++;
  }

  void updateMarketplaceTierUnit(int index, String unit) {
    if (index < 0 || index >= marketplaceTierUnits.length) return;
    marketplaceTierUnits[index] = unit;
    marketplaceTierUnits.refresh();
    marketplaceTierRevision.value++;
  }

  void _resetMarketplaceTiers() {
    for (final c in marketplaceTierQtyControllers) {
      c.dispose();
    }
    for (final c in marketplaceTierMaxQtyControllers) {
      c.dispose();
    }
    for (final c in marketplaceTierPriceControllers) {
      c.dispose();
    }
    marketplaceTierQtyControllers
      ..clear()
      ..add(TextEditingController())
      ..add(TextEditingController())
      ..add(TextEditingController());
    marketplaceTierMaxQtyControllers
      ..clear()
      ..add(TextEditingController())
      ..add(TextEditingController())
      ..add(TextEditingController());
    marketplaceTierPriceControllers
      ..clear()
      ..add(TextEditingController())
      ..add(TextEditingController())
      ..add(TextEditingController());
    marketplaceTierUnits
      ..clear()
      ..add(selectedUnit.value.isEmpty ? 'Ton' : selectedUnit.value)
      ..add(selectedUnit.value.isEmpty ? 'Ton' : selectedUnit.value)
      ..add(selectedUnit.value.isEmpty ? 'Ton' : selectedUnit.value);
    marketplaceTierRevision.value++;
  }

  void _resetBookingTiers() {
    for (final c in bookingTierQtyControllers) {
      c.dispose();
    }
    for (final c in bookingTierMaxQtyControllers) {
      c.dispose();
    }
    for (final c in bookingTierPriceControllers) {
      c.dispose();
    }
    bookingTierQtyControllers
      ..clear()
      ..add(TextEditingController())
      ..add(TextEditingController())
      ..add(TextEditingController());
    bookingTierMaxQtyControllers
      ..clear()
      ..add(TextEditingController())
      ..add(TextEditingController())
      ..add(TextEditingController());
    bookingTierPriceControllers
      ..clear()
      ..add(TextEditingController())
      ..add(TextEditingController())
      ..add(TextEditingController());
    bookingTierUnits
      ..clear()
      ..add(selectedBookingUnit.value.isEmpty ? 'Ton' : selectedBookingUnit.value)
      ..add(selectedBookingUnit.value.isEmpty ? 'Ton' : selectedBookingUnit.value)
      ..add(selectedBookingUnit.value.isEmpty ? 'Ton' : selectedBookingUnit.value);
    bookingTierRevision.value++;
  }

  void _applyMarketplaceTiersFromSpecs(Map<String, String> specs) {
    _resetMarketplaceTiers();
    var inserted = 0;
    for (var i = 0; i < 3; i++) {
      final qty = specs['tier_qty_$i']?.trim() ?? '';
      final price = specs['tier_price_$i']?.trim() ?? '';
      final unit = specs['tier_unit_$i']?.trim() ?? '';
      if (qty.isEmpty || price.isEmpty) continue;
      if (inserted > 0) {
        addMarketplaceTier();
      }
      marketplaceTierQtyControllers[inserted].text = qty;
      marketplaceTierMaxQtyControllers[inserted].text =
          specs['tier_max_$i']?.trim() ?? '';
      marketplaceTierPriceControllers[inserted].text = price;
      marketplaceTierUnits[inserted] = unit.isEmpty ? selectedUnit.value : unit;
      inserted++;
    }
    marketplaceTierRevision.value++;
  }

  void _applyBookingTiersFromSpecs(Map<String, String> specs) {
    _resetBookingTiers();
    var inserted = 0;
    for (var i = 0; i < 3; i++) {
      var qty = specs['booking_tier_qty_$i']?.trim() ?? '';
      var price = specs['booking_tier_price_$i']?.trim() ?? '';
      var unit = specs['booking_tier_unit_$i']?.trim() ?? '';
      if (qty.isEmpty || price.isEmpty) {
        qty = specs['tier_qty_$i']?.trim() ?? '';
        price = specs['tier_price_$i']?.trim() ?? '';
        unit = specs['tier_unit_$i']?.trim() ?? '';
      }
      if (qty.isEmpty || price.isEmpty) continue;
      if (inserted > 0) {
        addBookingTier();
      }
      bookingTierQtyControllers[inserted].text = qty;
      bookingTierMaxQtyControllers[inserted].text =
          (specs['booking_tier_max_$i']?.trim().isNotEmpty == true)
              ? specs['booking_tier_max_$i']!.trim()
              : (specs['tier_max_$i']?.trim() ?? '');
      bookingTierPriceControllers[inserted].text = price;
      bookingTierUnits[inserted] =
          unit.isEmpty ? selectedBookingUnit.value : unit;
      inserted++;
    }
    bookingTierRevision.value++;
  }

  void _syncTierPricingEnabledFromTiers() {
    final qtyCtrls = selectedListingType.value == AddListingType.advanceBooking
        ? bookingTierQtyControllers
        : marketplaceTierQtyControllers;
    final priceCtrls = selectedListingType.value == AddListingType.advanceBooking
        ? bookingTierPriceControllers
        : marketplaceTierPriceControllers;
    for (var i = 0; i < qtyCtrls.length; i++) {
      final q = qtyCtrls[i].text.trim();
      final p = priceCtrls[i].text.trim();
      if (q.isNotEmpty && p.isNotEmpty) {
        tierPricingEnabled.value = true;
        return;
      }
    }
    tierPricingEnabled.value = false;
  }

  Map<String, String> _collectMarketplaceTierSpecs() {
    final out = <String, String>{};
    for (var i = 0; i < marketplaceTierQtyControllers.length && i < 3; i++) {
      final qty = marketplaceTierQtyControllers[i].text.trim();
      final price = marketplaceTierPriceControllers[i].text.trim();
      if (qty.isEmpty || price.isEmpty) continue;
      out['tier_qty_$i'] = qty;
      final maxQ = marketplaceTierMaxQtyControllers[i].text.trim();
      if (maxQ.isNotEmpty) {
        out['tier_max_$i'] = maxQ;
      }
      out['tier_price_$i'] = price;
      out['tier_unit_$i'] =
          i < marketplaceTierUnits.length ? marketplaceTierUnits[i] : selectedUnit.value;
    }
    return out;
  }

  Map<String, String> _collectBookingTierSpecs() {
    final out = <String, String>{};
    for (var i = 0; i < bookingTierQtyControllers.length && i < 3; i++) {
      final qty = bookingTierQtyControllers[i].text.trim();
      final price = bookingTierPriceControllers[i].text.trim();
      if (qty.isEmpty || price.isEmpty) continue;
      out['booking_tier_qty_$i'] = qty;
      final maxQ = bookingTierMaxQtyControllers[i].text.trim();
      if (maxQ.isNotEmpty) {
        out['booking_tier_max_$i'] = maxQ;
      }
      out['booking_tier_price_$i'] = price;
      out['booking_tier_unit_$i'] =
          i < bookingTierUnits.length ? bookingTierUnits[i] : selectedBookingUnit.value;
    }
    return out;
  }

  void addBookingTier() {
    bookingTierQtyControllers.add(TextEditingController());
    bookingTierMaxQtyControllers.add(TextEditingController());
    bookingTierPriceControllers.add(TextEditingController());
    bookingTierUnits.add(
        selectedBookingUnit.value.isEmpty ? 'Ton' : selectedBookingUnit.value);
    bookingTierRevision.value++;
  }

  void removeBookingTier(int index) {
    if (bookingTierQtyControllers.length <= 1) return;
    bookingTierQtyControllers[index].dispose();
    bookingTierMaxQtyControllers[index].dispose();
    bookingTierPriceControllers[index].dispose();
    bookingTierQtyControllers.removeAt(index);
    bookingTierMaxQtyControllers.removeAt(index);
    bookingTierPriceControllers.removeAt(index);
    bookingTierUnits.removeAt(index);
    bookingTierRevision.value++;
  }

  void updateBookingTierUnit(int index, String unit) {
    if (index < 0 || index >= bookingTierUnits.length) return;
    bookingTierUnits[index] = unit;
    bookingTierUnits.refresh();
    bookingTierRevision.value++;
  }

  Future<void> pickHarvestDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      harvestDate.value = picked;
    }
  }

  Future<void> pickPurchaseDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      purchaseDate.value = picked;
    }
  }

  Future<void> pickAuctionEndDateTime() async {
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
    auctionEndDateTime.value =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> pickAuctionStartDateTime() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    auctionStartDateTime.value =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> pickBookingDeadlineDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: bookingDeadline.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      bookingDeadline.value = picked;
    }
  }

  Future<void> pickEstimatedDeliveryDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: estimatedDeliveryDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      estimatedDeliveryDate.value = picked;
    }
  }

  String auctionDurationReadout() {
    final start = auctionStartDateTime.value;
    final end = auctionEndDateTime.value;
    if (start == null || end == null || !end.isAfter(start)) {
      return '';
    }
    final d = end.difference(start);
    final totalMins = d.inMinutes;
    final days = totalMins ~/ (60 * 24);
    final hours = (totalMins % (60 * 24)) ~/ 60;
    final mins = totalMins % 60;
    if (days > 0) {
      return '${days}d ${hours}h ${mins}m';
    }
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  bool _hasText(TextEditingController c) => c.text.trim().isNotEmpty;

  bool hasFieldError(String key) => submitAttempted.value && _isFieldMissing(key);

  String fieldErrorText(String key) {
    if (!hasFieldError(key)) return '';
    switch (key) {
      case 'region':
        return 'Select region/state';
      case 'city':
        return 'Select city';
      case 'description':
        return 'Enter product description';
      case 'country':
        return 'Select country';
      case 'unit':
        return 'Select unit type';
      case 'moq':
        return 'Select minimum order quantity';
      case 'price':
        return 'Select price';
      case 'quantity':
        return 'Select quantity';
      case 'bookingPrice':
        return 'Select booking price';
      case 'estimatedPrice':
        return 'Select total estimated price';
      case 'bookingQuantity':
        return 'Select available quantity';
      case 'bookingMoq':
        return 'Select minimum order quantity';
      case 'bookingUnit':
        return 'Select unit type';
      case 'bookingCurrency':
        return 'Select currency';
      case 'startingBid':
        return 'Select starting bid price';
      case 'lotSize':
        return 'Select lot size';
      case 'auctionUnit':
        return 'Select unit type';
      case 'auctionCurrency':
        return 'Select currency';
      case 'auctionEnd':
        return 'Select auction end date/time';
      case 'auctionStart':
        return 'Select auction start date/time';
      case 'harvestDate':
        return 'Select harvest date';
      case 'productName':
        return 'Select product name';
      case 'category':
        return 'Select category';
      case 'subCategory':
        return 'Select sub category';
      default:
        return 'Required field';
    }
  }

  bool _isFieldMissing(String key) {
    switch (key) {
      case 'productName':
        return productNameController.text.trim().isEmpty;
      case 'category':
        return selectedCategory.value.trim().isEmpty;
      case 'subCategory':
        return selectedSubCategory.value.trim().isEmpty;
      case 'country':
        return selectedCountry.value.trim().isEmpty;
      case 'region':
        return selectedRegion.value.trim().isEmpty;
      case 'city':
        return selectedCity.value.trim().isEmpty;
      case 'description':
        return descriptionController.text.trim().isEmpty;
      case 'price':
        return priceController.text.trim().isEmpty;
      case 'unit':
        return selectedUnit.value.trim().isEmpty;
      case 'quantity':
        return quantityController.text.trim().isEmpty;
      case 'moq':
        return moqController.text.trim().isEmpty;
      case 'bookingPrice':
        return bookingPriceController.text.trim().isEmpty;
      case 'estimatedPrice':
        return totalEstimatedPriceController.text.trim().isEmpty;
      case 'bookingQuantity':
        return bookingQtyController.text.trim().isEmpty;
      case 'bookingMoq':
        return bookingMoqController.text.trim().isEmpty;
      case 'bookingUnit':
        return selectedBookingUnit.value.trim().isEmpty;
      case 'bookingCurrency':
        return selectedBookingCurrency.value.trim().isEmpty;
      case 'startingBid':
        return startingBidController.text.trim().isEmpty;
      case 'lotSize':
        return lotSizeController.text.trim().isEmpty;
      case 'auctionUnit':
        return selectedAuctionUnit.value.trim().isEmpty;
      case 'auctionCurrency':
        return selectedAuctionCurrency.value.trim().isEmpty;
      case 'auctionEnd':
        return auctionEndDateTime.value == null;
      case 'auctionStart':
        return auctionStartDateTime.value == null;
      case 'harvestDate':
        return harvestDate.value == null;
      default:
        return false;
    }
  }

  /// Full validation for publish / add to inventory (common + type-specific).
  /// When [markAttempted] is true, inline errors may show via [hasFieldError].
  bool _validateRequiredBeforeSubmit({bool markAttempted = true}) {
    if (markAttempted) {
      submitAttempted.value = true;
    }
    final type = selectedListingType.value;
    if (type == null) return false;
    final commonValid = !_isFieldMissing('productName') &&
        !_isFieldMissing('category') &&
        !_isFieldMissing('subCategory') &&
        !_isFieldMissing('description') &&
        !_isFieldMissing('country') &&
        !_isFieldMissing('region') &&
        !_isFieldMissing('city');
    if (!commonValid) return false;
    switch (type) {
      case AddListingType.marketplace:
        return !_isFieldMissing('price') &&
            !_isFieldMissing('unit') &&
            !_isFieldMissing('quantity') &&
            !_isFieldMissing('moq');
      case AddListingType.advanceBooking:
        return !_isFieldMissing('bookingPrice') &&
            !_isFieldMissing('bookingQuantity') &&
            !_isFieldMissing('harvestDate');
      case AddListingType.liveAuctions:
        return !_isFieldMissing('startingBid') &&
            !_isFieldMissing('lotSize') &&
            !_isFieldMissing('auctionEnd');
    }
  }

  void _recomputeListingActionsEnabled() {
    final type = selectedListingType.value;
    if (type == null) {
      listingActionsEnabled.value = false;
      return;
    }
    final common = !_isFieldMissing('productName') &&
        !_isFieldMissing('category') &&
        !_isFieldMissing('subCategory') &&
        !_isFieldMissing('description') &&
        !_isFieldMissing('country') &&
        !_isFieldMissing('region') &&
        !_isFieldMissing('city');
    if (!common) {
      listingActionsEnabled.value = false;
      return;
    }
    switch (type) {
      case AddListingType.marketplace:
        listingActionsEnabled.value = !_isFieldMissing('price') &&
            !_isFieldMissing('unit') &&
            !_isFieldMissing('quantity') &&
            !_isFieldMissing('moq');
        break;
      case AddListingType.advanceBooking:
        listingActionsEnabled.value = !_isFieldMissing('bookingPrice') &&
            !_isFieldMissing('bookingQuantity') &&
            !_isFieldMissing('harvestDate');
        break;
      case AddListingType.liveAuctions:
        listingActionsEnabled.value = !_isFieldMissing('startingBid') &&
            !_isFieldMissing('lotSize') &&
            !_isFieldMissing('auctionEnd');
        break;
    }
  }

  void _recomputeHasFormInput() {
    final hasName = _hasText(productNameController);
    final hasCategory = selectedCategory.value.isNotEmpty;
    final hasSubCategory = selectedSubCategory.value.isNotEmpty;
    final hasImage = productImages.isNotEmpty || uploadedImageUrls.isNotEmpty;

    final type = selectedListingType.value;
    var hasTypeData = false;
    switch (type) {
      case AddListingType.marketplace:
        hasTypeData = _hasText(priceController) &&
            _hasText(quantityController) &&
            _hasText(moqController) &&
            selectedUnit.value.isNotEmpty;
        break;
      case AddListingType.advanceBooking:
        hasTypeData = _hasText(bookingPriceController) &&
            _hasText(bookingQtyController) &&
            harvestDate.value != null;
        break;
      case AddListingType.liveAuctions:
        hasTypeData = _hasText(startingBidController) &&
            _hasText(lotSizeController) &&
            auctionEndDateTime.value != null;
        break;
      case null:
        hasTypeData = false;
        break;
    }
    isFormValid.value =
        hasName && hasCategory && hasSubCategory && hasImage && hasTypeData;
    _recomputeListingActionsEnabled();
  }

  void _attachFormListeners() {
    final watched = <TextEditingController>[
      productNameController,
      descriptionController,
      varietyController,
      cropYearController,
      moistureController,
      sampleQtyController,
      samplePriceController,
      priceController,
      quantityController,
      moqController,
      bookingPriceController,
      totalEstimatedPriceController,
      bookingQtyController,
      bookingMoqController,
      startingBidController,
      lotSizeController,
    ];
    for (final ctrl in watched) {
      ctrl.addListener(_recomputeHasFormInput);
    }
  }

  void _goToInventoryScreen() {
    final canPop = Get.key.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back<void>();
    }
    if (Get.isRegistered<SellerSideBarCon>()) {
      Get.find<SellerSideBarCon>().changeScreen(4);
      return;
    }
  }

  void _goToMyProductsScreen(AddListingType type) {
    final canPop = Get.key.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back<void>();
    }
    if (Get.isRegistered<SellerSideBarCon>()) {
      final sideBar = Get.find<SellerSideBarCon>();
      sideBar.changeScreen(1);
      if (Get.isRegistered<MyProductsCon>()) {
        final myProducts = Get.find<MyProductsCon>();
        switch (type) {
          case AddListingType.marketplace:
            myProducts.setTab(MyProductsTab.marketplace);
            break;
          case AddListingType.advanceBooking:
            myProducts.setTab(MyProductsTab.advanceBooking);
            break;
          case AddListingType.liveAuctions:
            myProducts.setTab(MyProductsTab.liveAuctions);
            break;
        }
      }
      return;
    }
  }

  void addInventory() async {
    if (!_validateRequiredBeforeSubmit()) {
      return;
    }
    final type = selectedListingType.value;
    if (type == null) {
      Get.snackbar('Missing fields', 'Select listing type first.');
      return;
    }
    final name = productNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Missing fields', 'Product name is required.');
      return;
    }
    final uid = MyProductsCon.fakeSellerId;
    var qty = 0.0;
    var unit = '';
    switch (type) {
      case AddListingType.marketplace:
        qty = double.tryParse(quantityController.text.trim()) ?? 0;
        unit = selectedUnit.value;
        break;
      case AddListingType.advanceBooking:
        qty = double.tryParse(bookingQtyController.text.trim()) ?? 0;
        unit = selectedBookingUnit.value;
        break;
      case AddListingType.liveAuctions:
        qty = double.tryParse(lotSizeController.text.trim()) ?? 0;
        unit = selectedAuctionUnit.value;
        break;
    }
    if (qty <= 0) {
      Get.snackbar('Missing fields', 'Quantity must be greater than zero.');
      return;
    }
    final productId = editingProductId.value ?? const Uuid().v4();
    final batchCode = _resolvedBatchCodeForSubmit(productId: productId);
    String? imageUrl =
        uploadedImageUrls.isNotEmpty ? uploadedImageUrls.first : null;
    final inventoryType = type == AddListingType.liveAuctions
        ? ProductType.liveAuction
        : type == AddListingType.advanceBooking
            ? ProductType.advanceBooking
            : ProductType.marketplace;
    try {
      if (imageUrl == null && productImages.isNotEmpty) {
        final urls = await _uploadProductImages(
          sellerId: uid,
          productId: productId,
        );
        if (urls.isNotEmpty) {
          uploadedImageUrls.assignAll(urls);
          imageUrl = urls.first;
          productImages.clear();
        }
      }
      final inventoryImageUrls =
          imageUrl == null ? const <String>[] : <String>[imageUrl];
      // ignore: avoid_print
      print('Saving inventory imageUrls: $inventoryImageUrls');
      final inv = InventoryModel(
        id: const Uuid().v4(),
        productId: productId,
        sellerId: uid,
        productName: name,
        stockQty: qty,
        unit: unit.isEmpty ? 'Ton' : unit,
        updatedAt: DateTime.now(),
        listingType: inventoryType,
        imageUrl: imageUrl,
        imageUrls: inventoryImageUrls,
        category: selectedCategory.value,
        sold: 0,
        remaining: qty,
        batchCode: batchCode,
        supplierId: null,
      );
      if (Get.isRegistered<MyProductsCon>()) {
        Get.find<MyProductsCon>().upsertInventoryRow(inv);
      }
      if (Get.isRegistered<InventoryCon>()) {
        final invCon = Get.find<InventoryCon>();
        invCon.addProductToInventory(
          name: name,
          category: selectedCategory.value,
          image: imageUrl ?? '',
          unit: inv.unit,
          listingType: inventoryType,
          initialBatch: StockBatch(
            id: const Uuid().v4(),
            productId: productId,
            productName: name,
            batchNumber: batchCode,
            supplierName: '',
            supplierContact: '',
            supplierLocation: '',
            purchaseDate: DateTime.now(),
            initialQty: qty,
            currentQty: qty,
            unit: inv.unit,
            sellingPrice: 0,
            addedDate: DateTime.now(),
            grade: selectedGrade.value,
            qualityParams: const {},
            certifications: const [],
            source: inventoryType == ProductType.advanceBooking
                ? BatchSource.advanceBooking
                : inventoryType == ProductType.liveAuction
                    ? BatchSource.liveAuction
                    : BatchSource.marketplace,
          ),
          sellingPrice: 0,
        );
      }
      if (Get.isRegistered<InventoryCon>()) {
        await Get.find<InventoryCon>().refreshNow();
      }
      if (Get.isRegistered<MyProductsCon>()) {
        await Get.find<MyProductsCon>().refreshNow();
      }
      _resetAfterPublish();
      Get.snackbar('Saved', 'Inventory saved successfully');
      _goToInventoryScreen();
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  String _buildAutoBatchCode({String? productId}) {
    final now = DateTime.now();
    final yy = (now.year % 100).toString().padLeft(2, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final hh = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    final seed = (productId ?? const Uuid().v4())
        .replaceAll('-', '')
        .substring(0, 6)
        .toUpperCase();
    return 'B$yy$mm$dd$hh$min-$seed';
  }

  void regenerateBatchCodeForNewProduct({String? productId}) {
    if (editingProductId.value != null) return;
    batchCodeController.text = _newBatchCodeForCreate();
  }

  String _newBatchCodeForCreate() {
    final year = DateTime.now().year;
    final seq = _getNextBatchSequence(includeLocalBatchRows: false)
        .clamp(1, 999);
    return 'BATCH-$year-${seq.toString().padLeft(3, '0')}';
  }

  int _getNextBatchSequence({bool includeLocalBatchRows = false}) {
    final year = DateTime.now().year;
    final re = RegExp(r'^BATCH-(\d{4})-(\d{3})$');
    var maxSeq = 0;
    void consider(String code) {
      final m = re.firstMatch(code.trim());
      if (m == null) return;
      final y = int.tryParse(m.group(1) ?? '') ?? 0;
      if (y != year) return;
      final n = int.tryParse(m.group(2) ?? '') ?? 0;
      if (n > maxSeq) maxSeq = n;
    }

    if (Get.isRegistered<MyProductsCon>()) {
      final my = Get.find<MyProductsCon>();
      for (final inv in my.snapshotInventory()) {
        consider(inv.batchCode);
      }
      for (final pr in my.snapshotProducts()) {
        consider(pr.specifications['batchCode'] ?? '');
      }
    }
    consider(batchCodeController.text);
    if (includeLocalBatchRows) {
      for (final b in batches) {
        consider(b.batchCode);
      }
    }
    return maxSeq + 1;
  }

  String _resolvedBatchCodeForSubmit({required String productId}) {
    final trimmed = batchCodeController.text.trim();
    if (trimmed.isNotEmpty) return trimmed;
    if (editingProductId.value != null) {
      if (Get.isRegistered<MyProductsCon>()) {
        final my = Get.find<MyProductsCon>();
        final prod = my.getProductById(productId);
        final fromSpec = prod?.specifications['batchCode']?.trim() ?? '';
        if (fromSpec.isNotEmpty) return fromSpec;
        for (final inv in my.snapshotInventory()) {
          if (inv.productId == productId) {
            final b = inv.batchCode.trim();
            if (b.isNotEmpty) return b;
          }
        }
      }
    } else {
      return _newBatchCodeForCreate();
    }
    return _buildAutoBatchCode(productId: productId);
  }

  List<TierPriceModel> _tierPricesFromIndexedSpecs(
    Map<String, String> specs, {
    required String qtyKeyPrefix,
    required String priceKeyPrefix,
    required String unitKeyPrefix,
    required String defaultUnit,
  }) {
    final out = <TierPriceModel>[];
    for (var i = 0; i < 3; i++) {
      final q = specs['$qtyKeyPrefix$i']?.trim() ?? '';
      final p = specs['$priceKeyPrefix$i']?.trim() ?? '';
      if (q.isEmpty || p.isEmpty) continue;
      out.add(
        TierPriceModel(
          minQty: q,
          price: p,
          unit: specs['$unitKeyPrefix$i']?.trim() ?? defaultUnit,
        ),
      );
    }
    return out;
  }

  void _resetAfterPublish({bool skipBatchRegenerate = false}) {
    closeFormListPickers();
    closeAllCatalogPickers();
    productNameController.clear();
    descriptionController.clear();
    varietyController.clear();
    selectedVarietyDisplay.value = '';
    moistureController.clear();
    batchCodeController.clear();
    batches.clear();
    expandedBatchIndex.value = null;
    batchExpandedStates
      ..clear()
      ..add(true.obs);
    priceController.clear();
    quantityController.clear();
    moqController.clear();
    bookingPriceController.clear();
    totalEstimatedPriceController.clear();
    bookingQtyController.clear();
    bookingMoqController.clear();
    startingBidController.clear();
    lotSizeController.clear();
    supplierNameController.clear();
    supplierContactController.clear();
    supplierLocationController.clear();
    productImages.clear();
    uploadedImageUrls.clear();
    _resetMarketplaceTiers();
    _resetBookingTiers();
    harvestDate.value = null;
    bookingDeadline.value = null;
    estimatedDeliveryDate.value = null;
    advancePaymentPercentController.text = '20';
    auctionEndDateTime.value = null;
    auctionStartDateTime.value = null;
    reservePriceController.clear();
    bidIncrementController.clear();
    maxBiddersController.clear();
    auctionAutoExtend.value = false;
    auctionReserveVisibleToBidders.value = true;
    purchaseDate.value = null;
    productNameError.value = '';
    productNameSuggestions.clear();
    selectedProduct.value = null;
    productDropdownSelection.value = '';
    productQuery.value = '';
    editingProductId.value = null;
    submitAttempted.value = false;
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    selectedListingType.value = null;
    tierPricingEnabled.value = false;
    if (!skipBatchRegenerate) {
      regenerateBatchCodeForNewProduct();
    }
    _recomputeHasFormInput();
  }

  void resetFormForCreate() {
    _resetAfterPublish();
  }

  void cancelEditingAndClose() {
    _resetAfterPublish();
    final canPop = Get.key.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back<void>();
    }
  }

  void setListingTypeForTab(AddListingType t) => selectListingType(t);

  void updateProductNameInput(String value) {
    onProductQueryChanged(value);
  }

  void chooseProductName(String name) {
    selectProductByName(name);
    productNameSuggestions.clear();
  }

  void onProductQueryChanged(String value) {
    if (productNameController.text != value) {
      productNameController.text = value;
    }
    final q = value.trim();
    if (q.isEmpty) {
      selectedProduct.value = null;
      selectedCategory.value = '';
      selectedSubCategory.value = '';
      productNameError.value = '';
      productNameSuggestions.clear();
      productQuery.value = '';
      _clearVariety();
      return;
    }

    final selected = selectedProduct.value;
    if (selected != null && selected.toLowerCase() != q.toLowerCase()) {
      selectedProduct.value = null;
      selectedCategory.value = '';
      selectedSubCategory.value = '';
      _clearVariety();
    }
    productNameError.value = '';
    productQuery.value = q;
    _applyGlobalSuggestions();
  }

  void _applyGlobalSuggestions() {
    final q = productQuery.value.trim().toLowerCase();
    if (q.isEmpty) {
      productNameSuggestions.clear();
      return;
    }
    var suggestions = allProducts
        .where((name) => name.toLowerCase().contains(q))
        .take(20)
        .toList();
    // Hide single exact echo to avoid looking like a duplicated text field row.
    if (suggestions.length == 1 && suggestions.first.toLowerCase() == q) {
      suggestions = <String>[];
    }
    productNameSuggestions.assignAll(suggestions);
  }

  void selectProductByName(String name) {
    final meta = productMetaByName[name];
    if (meta == null) return;
    _clearVariety();
    selectedProduct.value = name;
    productDropdownSelection.value = name;
    productNameController.text = name;
    productQuery.value = name;
    selectedCategory.value = meta.category;
    selectedSubCategory.value = meta.subCategory;
    productNameError.value = '';
    productNameSuggestions.clear();
    closeFormListPickers();
    closeAllCatalogPickers();
  }

  String? normalizedExactProductName(String raw) {
    final q = raw.trim();
    if (q.isEmpty) return null;
    return allProducts
        .where((name) => name.toLowerCase() == q.toLowerCase())
        .toList()
        .firstOrNull;
  }

  void validateProductNameStrict() {
    final q = productNameController.text.trim();
    if (q.isEmpty) {
      selectedProduct.value = null;
      selectedCategory.value = '';
      selectedSubCategory.value = '';
      productNameError.value = '';
      _clearVariety();
      return;
    }
    final exact = allProducts
        .where((name) => name.toLowerCase() == q.toLowerCase())
        .toList()
        .firstOrNull;
    if (exact == null) {
      selectedProduct.value = null;
      selectedCategory.value = '';
      selectedSubCategory.value = '';
      productNameError.value = 'Select correct spelling';
      _clearVariety();
      return;
    }
    selectProductByName(exact);
  }

  Future<void> openForEdit(String productId) async {
    if (!Get.isRegistered<MyProductsCon>()) return;
    final p = Get.find<MyProductsCon>().getProductById(productId);
    if (p == null) return;
    _resetAfterPublish(skipBatchRegenerate: true);
    await _ensureCscLocationReady();
    editingProductId.value = productId;
    final myProducts = Get.find<MyProductsCon>();
    var batchFromProduct = (p.specifications['batchCode'] ?? '').trim();
    if (batchFromProduct.isEmpty) {
      for (final inv in myProducts.snapshotInventory()) {
        if (inv.productId == productId) {
          batchFromProduct = inv.batchCode.trim();
          break;
        }
      }
    }
    batchCodeController.text = batchFromProduct;
    productNameController.text = p.name;
    selectedProduct.value = p.name;
    productDropdownSelection.value =
        productMetaByName.containsKey(p.name) ? p.name : '';
    productQuery.value = p.name;
    descriptionController.text = p.description;
    varietyController.text = p.variety;
    selectedVarietyDisplay.value = p.variety.trim();
    moistureController.text = p.specifications['moisture']?.trim() ?? '';
    uploadedImageUrls.assignAll(p.images);
    selectedCategory.value = p.category;
    selectedSubCategory.value = p.subCategory;
    selectedCountry.value = p.origin;
    selectedRegion.value = p.state;
    selectedCity.value = p.city;
    if (selectedCity.value.isEmpty &&
        selectedRegion.value.isEmpty &&
        p.location.trim().isNotEmpty) {
      final parts = p.location
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) selectedCity.value = parts.first;
      if (parts.length > 1) selectedRegion.value = parts[1];
    }
    _normalizeLocationSelectionToCsc();
    supplierLocationController.text = p.location;
    if (p.productType == ProductType.marketplace) {
      selectListingType(AddListingType.marketplace);
      priceController.text = (p.price ?? 0).toStringAsFixed(0);
      quantityController.text = p.stock.toString();
      selectedUnit.value = p.unit;
      _applyMarketplaceTiersFromSpecs(p.specifications);
      _syncTierPricingEnabledFromTiers();
    } else if (p.productType == ProductType.advanceBooking ||
        p.productType == ProductType.booking) {
      selectListingType(AddListingType.advanceBooking);
      bookingPriceController.text = (p.price ?? 0).toStringAsFixed(0);
      bookingQtyController.text = p.stock.toString();
      selectedBookingUnit.value = p.unit;
      final ap = p.specifications['advancePaymentPercent']?.trim();
      advancePaymentPercentController.text =
          (ap != null && ap.isNotEmpty) ? ap : '20';
      bookingDeadline.value =
          DateTime.tryParse(p.specifications['bookingDeadline'] ?? '');
      estimatedDeliveryDate.value =
          DateTime.tryParse(p.specifications['estimatedDeliveryDate'] ?? '');
      _applyBookingTiersFromSpecs(p.specifications);
      _syncTierPricingEnabledFromTiers();
    } else {
      selectListingType(AddListingType.liveAuctions);
      startingBidController.text =
          (double.tryParse(p.specifications['startingBid'] ?? '') ?? 0)
              .toStringAsFixed(0);
      lotSizeController.text = p.stock.toString();
      selectedAuctionUnit.value = p.unit;
      reservePriceController.text =
          p.specifications['reservePrice']?.trim() ?? '';
      bidIncrementController.text =
          p.specifications['bidIncrement']?.trim() ?? '';
      maxBiddersController.text = p.specifications['maxBidders']?.trim() ?? '';
      auctionStartDateTime.value =
          DateTime.tryParse(p.specifications['auctionStart'] ?? '');
      auctionEndDateTime.value =
          DateTime.tryParse(p.specifications['auctionEnd'] ?? '');
      auctionAutoExtend.value =
          p.specifications['auctionAutoExtend'] == 'true';
      auctionReserveVisibleToBidders.value =
          p.specifications['auctionReserveVisible'] != 'false';
    }
  }

  Future<void> publishProduct() async {
    if (isUploading.value) return;
    if (!_validateRequiredBeforeSubmit()) {
      return;
    }
    final listingTypeBeforeSave = selectedListingType.value;
    if (listingTypeBeforeSave == null) return;

    final name = productNameController.text.trim();
    final category = selectedCategory.value;

    double qty = 0;
    String unit = '';
    switch (selectedListingType.value) {
      case AddListingType.marketplace:
        qty = double.tryParse(quantityController.text.trim()) ?? 0;
        unit = selectedUnit.value;
        break;
      case AddListingType.advanceBooking:
        qty = double.tryParse(bookingQtyController.text.trim()) ?? 0;
        unit = selectedBookingUnit.value;
        break;
      case AddListingType.liveAuctions:
        qty = double.tryParse(lotSizeController.text.trim()) ?? 0;
        unit = selectedAuctionUnit.value;
        break;
      default:
        break;
    }

    final qualityParams = <String, String>{};
    for (var i = 0; i < specifications.length; i++) {
      final n = specNameControllers[i].text.trim();
      final v = specValueControllers[i].text.trim();
      if (n.isNotEmpty && v.isNotEmpty) {
        qualityParams[n] = '$v ${specUnits[i]}'.trim();
      }
    }

    final listingSpecs = Map<String, String>.from(qualityParams);
    final cropYear = cropYearController.text.trim();
    if (cropYear.isNotEmpty) {
      listingSpecs['cropYear'] = cropYear;
    }
    final deliveryOption = selectedDeliveryOption.value.trim();
    if (deliveryOption.isNotEmpty) {
      listingSpecs['deliveryOption'] = deliveryOption;
    }
    final deliveryTime = deliveryTimeController.text.trim();
    if (deliveryTime.isNotEmpty) {
      listingSpecs['deliveryTime'] = deliveryTime;
    }
    final samplePrice = samplePriceController.text.trim();
    if (samplePrice.isNotEmpty) {
      listingSpecs['samplePrice'] = samplePrice;
    }
    if (tags.isNotEmpty) {
      listingSpecs['tags'] = tags.join(', ');
    }
    final subCategory = selectedSubCategory.value.trim();
    if (subCategory.isNotEmpty) {
      listingSpecs['subCategory'] = subCategory;
    }
    final moisture = moistureController.text.trim();
    if (moisture.isNotEmpty) {
      listingSpecs['moisture'] = moisture;
    }
    if (selectedListingType.value == AddListingType.liveAuctions) {
      listingSpecs['startingBid'] = startingBidController.text.trim();
      if (auctionEndDateTime.value != null) {
        listingSpecs['auctionEnd'] = auctionEndDateTime.value!.toIso8601String();
      }
      if (auctionStartDateTime.value != null) {
        listingSpecs['auctionStart'] =
            auctionStartDateTime.value!.toIso8601String();
      }
      listingSpecs['reservePrice'] = reservePriceController.text.trim();
      listingSpecs['bidIncrement'] = bidIncrementController.text.trim();
      listingSpecs['maxBidders'] = maxBiddersController.text.trim();
      listingSpecs['auctionAutoExtend'] = auctionAutoExtend.value.toString();
      listingSpecs['auctionReserveVisible'] =
          auctionReserveVisibleToBidders.value.toString();
    }
    if (selectedListingType.value == AddListingType.advanceBooking &&
        harvestDate.value != null) {
      final h = harvestDate.value!;
      listingSpecs['harvestDate'] =
          '${h.year}-${h.month.toString().padLeft(2, '0')}-${h.day.toString().padLeft(2, '0')}';
    }
    if (selectedListingType.value == AddListingType.advanceBooking) {
      listingSpecs['advancePaymentPercent'] =
          advancePaymentPercentController.text.trim();
      if (bookingDeadline.value != null) {
        listingSpecs['bookingDeadline'] =
            bookingDeadline.value!.toIso8601String();
      }
      if (estimatedDeliveryDate.value != null) {
        listingSpecs['estimatedDeliveryDate'] =
            estimatedDeliveryDate.value!.toIso8601String();
      }
    }
    if (selectedListingType.value == AddListingType.marketplace &&
        tierPricingEnabled.value) {
      listingSpecs.addAll(_collectMarketplaceTierSpecs());
    }
    if (selectedListingType.value == AddListingType.advanceBooking &&
        tierPricingEnabled.value) {
      listingSpecs.addAll(_collectBookingTierSpecs());
    }

    final List<TierPriceModel> tierPrices;
    if (tierPricingEnabled.value) {
      if (selectedListingType.value == AddListingType.marketplace) {
        final tierSpecs = _collectMarketplaceTierSpecs();
        tierPrices = _tierPricesFromIndexedSpecs(
          tierSpecs,
          qtyKeyPrefix: 'tier_qty_',
          priceKeyPrefix: 'tier_price_',
          unitKeyPrefix: 'tier_unit_',
          defaultUnit:
              selectedUnit.value.isEmpty ? 'Ton' : selectedUnit.value,
        );
      } else if (selectedListingType.value == AddListingType.advanceBooking) {
        final bt = _collectBookingTierSpecs();
        tierPrices = _tierPricesFromIndexedSpecs(
          bt,
          qtyKeyPrefix: 'booking_tier_qty_',
          priceKeyPrefix: 'booking_tier_price_',
          unitKeyPrefix: 'booking_tier_unit_',
          defaultUnit: selectedBookingUnit.value.isEmpty
              ? 'Ton'
              : selectedBookingUnit.value,
        );
      } else {
        tierPrices = [];
      }
    } else {
      tierPrices = [];
    }

    try {
      final uid = MyProductsCon.fakeSellerId;
      const sellerName = 'Demo Seller';
      final listingType = selectedListingType.value!;
      final price = listingType == AddListingType.advanceBooking
          ? (double.tryParse(bookingPriceController.text.trim()) ?? 0)
          : listingType == AddListingType.liveAuctions
              ? (double.tryParse(startingBidController.text.trim()) ?? 0)
              : (double.tryParse(priceController.text.trim()) ?? 0);
      final isEdit = editingProductId.value != null;
      final productId = editingProductId.value ?? const Uuid().v4();
      final old = isEdit && Get.isRegistered<MyProductsCon>()
          ? Get.find<MyProductsCon>().getProductById(productId)
          : null;
      isUploading.value = true;
      final urls = productImages.isNotEmpty
          ? await _uploadProductImages(
              sellerId: uid,
              productId: productId,
            )
          : (isEdit ? (old?.images ?? const <String>[]) : const <String>[]);
      final oldUrls = isEdit ? uploadedImageUrls.toList() : <String>[];
      final mergedUrls = <String>[
        ...oldUrls,
        ...urls,
      ].where((e) => e.trim().isNotEmpty).toSet().toList();
      final finalUrls = mergedUrls.take(5).toList();
      // ignore: avoid_print
      print('Saving product imageUrls: $finalUrls');
      final imageUrl = finalUrls.isNotEmpty ? finalUrls.first : '';

      ProductType pType = ProductType.marketplace;
      if (selectedListingType.value == AddListingType.liveAuctions) {
        pType = ProductType.liveAuction;
      } else if (selectedListingType.value == AddListingType.advanceBooking) {
        pType = ProductType.advanceBooking;
      }

      final batchCode = _resolvedBatchCodeForSubmit(productId: productId);
      listingSpecs['batchCode'] = batchCode;
      final locationLabel = [
        selectedCity.value.trim(),
        selectedRegion.value.trim(),
        selectedCountry.value.trim(),
      ].where((x) => x.isNotEmpty).join(', ');

      final publishedProduct = ProductModel(
        id: productId,
        name: name,
        description: descriptionController.text.trim(),
        images: finalUrls,
        category: category,
        sellerId: uid,
        sellerName: sellerName,
        createdAt: old?.createdAt ?? DateTime.now(),
        status: ProductStatus.active,
        productType: pType,
        location: locationLabel,
        origin: selectedCountry.value,
        country: selectedCountry.value,
        state: selectedRegion.value,
        city: selectedCity.value,
        specifications: listingSpecs,
        tierPrices: tierPrices,
        grade: selectedGrade.value,
        currency: 'PKR',
        variety: varietyController.text.trim(),
        minOrderQty: double.tryParse(moqController.text.trim()),
        price: price,
        unit: unit.isEmpty ? 'Ton' : unit,
        stock: qty.round().clamp(0, 1 << 30),
        listingType: selectedListingType.value!.name,
        subCategory: selectedSubCategory.value,
      );

      final inv = InventoryModel(
        id: const Uuid().v4(),
        productId: productId,
        sellerId: uid,
        productName: name,
        stockQty: qty,
        unit: unit.isEmpty ? 'Ton' : unit,
        updatedAt: DateTime.now(),
        listingType: pType,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        imageUrls: finalUrls,
        category: category,
        sold: 0,
        remaining: qty,
        batchCode: batchCode,
        supplierId: null,
      );
      if (Get.isRegistered<MyProductsCon>()) {
        Get.find<MyProductsCon>().upsertPublishedProduct(
          product: publishedProduct,
          inventory: inv,
        );
      }
      uploadedImageUrls.assignAll(finalUrls);
      productImages.clear();

      if (Get.isRegistered<InventoryCon>()) {
        final inventoryCon = Get.find<InventoryCon>();
        inventoryCon.addProductToInventory(
          name: name,
          category: category,
          image: imageUrl.isNotEmpty ? imageUrl : '',
          unit: unit.isEmpty ? 'Ton' : unit,
          listingType: pType,
          initialBatch: StockBatch(
            id: const Uuid().v4(),
            productId: productId,
            productName: name,
            batchNumber: batchCode,
            supplierName: sellerName,
            supplierContact: '',
            supplierLocation: locationLabel,
            purchaseDate: DateTime.now(),
            initialQty: qty,
            currentQty: qty,
            unit: unit.isEmpty ? 'Ton' : unit,
            sellingPrice: price,
            addedDate: DateTime.now(),
            grade: selectedGrade.value,
            qualityParams: qualityParams,
            certifications: const <String>[],
            source: pType == ProductType.advanceBooking
                ? BatchSource.advanceBooking
                : pType == ProductType.liveAuction
                    ? BatchSource.liveAuction
                    : BatchSource.marketplace,
          ),
          sellingPrice: price,
        );
      }
      if (Get.isRegistered<InventoryCon>()) {
        await Get.find<InventoryCon>().refreshNow();
      }
      if (Get.isRegistered<MyProductsCon>()) {
        await Get.find<MyProductsCon>().refreshNow();
      }

      Get.snackbar(
        'Saved',
        isEdit ? 'Product updated successfully' : 'Product published successfully',
      );
      _resetAfterPublish();
      if (listingTypeBeforeSave == AddListingType.marketplace) {
        Get.off(
          () => ProductDetailScreen(
            productModel: publishedProduct,
            isSeller: true,
          ),
        );
      } else {
        _goToMyProductsScreen(listingTypeBeforeSave);
      }
    } catch (e, st) {
      debugPrint('publishProduct: $e\n$st');
      Get.snackbar('Error', '$e');
    } finally {
      isUploading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    selectedListingType.value = null;
    selectedUnit.value = 'Ton';
    selectedBookingUnit.value = 'Ton';
    selectedAuctionUnit.value = 'Ton';
    unawaited(_ensureCscLocationReady());
    quickChipsVisible.assignAll(quickSpecChips);
    selectedDispatchTime.value = sampleDispatchTimeOptions.first;
    selectedDeliveryCoveredBy.value = sampleDeliveryCoveredByOptions.first;
    selectedSampleUnit.value = sampleUnitOptions.first;
    while (marketplaceTierQtyControllers.length < 3) {
      marketplaceTierQtyControllers.add(TextEditingController());
    }
    while (marketplaceTierMaxQtyControllers.length < 3) {
      marketplaceTierMaxQtyControllers.add(TextEditingController());
    }
    while (marketplaceTierPriceControllers.length < 3) {
      marketplaceTierPriceControllers.add(TextEditingController());
    }
    while (marketplaceTierUnits.length < 3) {
      marketplaceTierUnits.add(selectedUnit.value.isEmpty ? 'Ton' : selectedUnit.value);
    }
    while (bookingTierQtyControllers.length < 3) {
      bookingTierQtyControllers.add(TextEditingController());
    }
    while (bookingTierMaxQtyControllers.length < 3) {
      bookingTierMaxQtyControllers.add(TextEditingController());
    }
    while (bookingTierPriceControllers.length < 3) {
      bookingTierPriceControllers.add(TextEditingController());
    }
    while (bookingTierUnits.length < 3) {
      bookingTierUnits.add(
          selectedBookingUnit.value.isEmpty ? 'Ton' : selectedBookingUnit.value);
    }
    regenerateBatchCodeForNewProduct();
    _attachFormListeners();
    ever(selectedListingType, (_) => _recomputeHasFormInput());
    ever(selectedCategory, (_) => _recomputeHasFormInput());
    ever(selectedSubCategory, (_) => _recomputeHasFormInput());
    ever(selectedCountry, (_) => _recomputeHasFormInput());
    ever(selectedRegion, (_) => _recomputeHasFormInput());
    ever(selectedCity, (_) => _recomputeHasFormInput());
    ever(selectedUnit, (_) => _recomputeHasFormInput());
    ever(selectedCurrency, (_) => _recomputeHasFormInput());
    ever(selectedBookingUnit, (_) => _recomputeHasFormInput());
    ever(selectedBookingCurrency, (_) => _recomputeHasFormInput());
    ever(selectedAuctionUnit, (_) => _recomputeHasFormInput());
    ever(selectedAuctionCurrency, (_) => _recomputeHasFormInput());
    ever(selectedDeliveryOption, (_) => _recomputeHasFormInput());
    ever(selectedDispatchTime, (_) => _recomputeHasFormInput());
    ever(selectedDeliveryCoveredBy, (_) => _recomputeHasFormInput());
    ever(selectedSampleUnit, (_) => _recomputeHasFormInput());
    ever(productImages, (_) => _recomputeHasFormInput());
    ever(uploadedImageUrls, (_) => _recomputeHasFormInput());
    ever(harvestDate, (_) => _recomputeHasFormInput());
    ever(bookingDeadline, (_) => _recomputeHasFormInput());
    ever(estimatedDeliveryDate, (_) => _recomputeHasFormInput());
    ever(auctionEndDateTime, (_) => _recomputeHasFormInput());
    ever(auctionStartDateTime, (_) => _recomputeHasFormInput());
    ever(auctionAutoExtend, (_) => _recomputeHasFormInput());
    _recomputeHasFormInput();
  }

  @override
  void onClose() {
    _cancelProductPickerUnfocusDebounce();
    closeFormListPickers();
    closeAllCatalogPickers();
    listPickerOverlayFocus.dispose();
    productPickerSearchController.dispose();
    productPickerSearchFocus.dispose();
    categoryPickerSearchController.dispose();
    categoryPickerSearchFocus.dispose();
    subCategoryPickerSearchController.dispose();
    subCategoryPickerSearchFocus.dispose();
    varietyPickerSearchController.dispose();
    varietyPickerSearchFocus.dispose();
    productNameController.dispose();
    productNameFocusNode.dispose();
    descriptionController.dispose();
    varietyController.dispose();
    moistureController.dispose();
    batchCodeController.dispose();
    cropYearController.dispose();
    for (final x in specNameControllers) {
      x.dispose();
    }
    for (final x in specValueControllers) {
      x.dispose();
    }

    tagInputController.dispose();

    sampleQtyController.dispose();
    samplePriceController.dispose();

    priceController.dispose();
    quantityController.dispose();
    moqController.dispose();

    bookingPriceController.dispose();
    totalEstimatedPriceController.dispose();
    bookingQtyController.dispose();
    bookingMoqController.dispose();

    startingBidController.dispose();
    lotSizeController.dispose();
    reservePriceController.dispose();
    bidIncrementController.dispose();
    maxBiddersController.dispose();
    advancePaymentPercentController.dispose();

    supplierNameController.dispose();
    supplierContactController.dispose();
    supplierLocationController.dispose();

    deliveryTimeController.dispose();

    for (final x in marketplaceTierQtyControllers) {
      x.dispose();
    }
    for (final x in marketplaceTierMaxQtyControllers) {
      x.dispose();
    }
    for (final x in marketplaceTierPriceControllers) {
      x.dispose();
    }
    for (final x in bookingTierQtyControllers) {
      x.dispose();
    }
    for (final x in bookingTierMaxQtyControllers) {
      x.dispose();
    }
    for (final x in bookingTierPriceControllers) {
      x.dispose();
    }

    super.onClose();
  }

  static Map<String, ({String category, String subCategory})>
      _buildProductMetaByName() {
    final out = <String, ({String category, String subCategory})>{};
    for (final catEntry in productCatalog.entries) {
      final category = catEntry.key;
      for (final subEntry in catEntry.value.entries) {
        final subCategory = subEntry.key;
        for (final product in subEntry.value) {
          out[product] = (category: category, subCategory: subCategory);
        }
      }
    }
    return out;
  }
}


