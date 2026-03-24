import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum AddListingType { marketplace, advanceBooking, liveAuctions }

class AddNewProductCon extends GetxController {
  // ── Listing Type (mandatory) ─────────────────────────────────────────────
  final Rx<AddListingType?> selectedListingType = Rx<AddListingType?>(null);

  void selectListingType(AddListingType type) {
    selectedListingType.value = type;
  }

  // ── Common Basic Info ────────────────────────────────────────────────────
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;

  // ── Marketplace extra basic ──────────────────────────────────────────────
  final varietyController = TextEditingController();
  final skuController = TextEditingController();

  // ── Quality & Harvest ────────────────────────────────────────────────────
  final RxString selectedGrade = ''.obs;
  final RxString selectedStorageCondition = ''.obs;
  final Rx<DateTime?> harvestDate = Rx<DateTime?>(null);
  final certificationsController = TextEditingController();
  final cropYearController = TextEditingController();

  // ── Specifications (Marketplace) ─────────────────────────────────────────
  final RxList<Map<String, String>> specifications = <Map<String, String>>[
    {'name': '', 'value': '', 'unit': '%'},
  ].obs;
  final List<TextEditingController> specNameControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> specValueControllers = [
    TextEditingController(),
  ];
  final RxList<String> specUnits = <String>['%'].obs;
  final List<String> quickSpecChips = [
    'Moisture',
    'Protein',
    'Fiber',
    'Fat',
    'Ash Content',
    'Carbohydrates',
    'Gluten',
    'Iron',
    'Calcium',
    'Starch',
  ];
  final List<String> unitOptions = ['%', 'g/100g', 'mg/kg', 'ppm', 'custom'];

  // ── Sample Availability (Marketplace only) ───────────────────────────────
  final RxBool sampleAvailable = true.obs;
  final sampleQtyController = TextEditingController();
  final samplePriceController = TextEditingController();
  final RxString selectedSampleUnit = 'kg'.obs;
  final RxString selectedDispatchTime = ''.obs;
  final RxString selectedDeliveryCoveredBy = ''.obs;

  // ── Pricing & Quantity (Common) ──────────────────────────────────────────
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final moqController = TextEditingController();
  final RxString selectedUnit = ''.obs;
  final RxString selectedCurrency = 'USD (\$)'.obs;

  // ── Advance Booking specific ─────────────────────────────────────────────
  final bookingPriceController = TextEditingController();
  final totalEstimatedPriceController = TextEditingController();

  // ── Live Auction specific ────────────────────────────────────────────────
  final startingBidController = TextEditingController();
  final Rx<DateTime?> auctionEndDateTime = Rx<DateTime?>(null);

  // ── Location & Delivery ──────────────────────────────────────────────────
  final regionController = TextEditingController();
  final cityController = TextEditingController();
  final deliveryTimeController = TextEditingController();
  final RxString selectedCountry = ''.obs;
  final RxString selectedDeliveryOption = ''.obs;

  // ── Tags ──────────────────────────────────────────────────────────────────
  final tagInputController = TextEditingController();
  final RxList<String> tags = <String>[
    'Organic',
    'Premium',
    'Export Quality',
  ].obs;

  // ── Images ───────────────────────────────────────────────────────────────
  final RxList<String> images = <String>[].obs;

  // ── Sub-Category map ─────────────────────────────────────────────────────
  final Map<String, List<String>> subCategoryMap = {
    'Grains & Cereals': [
      'Wheat',
      'Rice',
      'Maize / Corn',
      'Barley',
      'Sorghum',
      'Oats',
      'Millet',
    ],
    'Fruits': [
      'Citrus',
      'Tropical Fruits',
      'Stone Fruits',
      'Berries',
      'Melons',
    ],
    'Vegetables': [
      'Leafy Greens',
      'Root Vegetables',
      'Gourds',
      'Brassicas',
      'Alliums',
    ],
    'Spices': [
      'Dried Spices',
      'Fresh Herbs',
      'Blended Spices',
      'Seeds & Pods',
    ],
  };

  List<String> get currentSubCategories =>
      subCategoryMap[selectedCategory.value] ?? [];

  void onCategoryChanged(String cat) {
    selectedCategory.value = cat;
    selectedSubCategory.value = '';
  }

  // ── Spec helpers ─────────────────────────────────────────────────────────
  void addSpecFromChip(String name) {
    specNameControllers.add(TextEditingController(text: name));
    specValueControllers.add(TextEditingController());
    specUnits.add('%');
    specifications.add({'name': name, 'value': '', 'unit': '%'});
  }

  void addEmptySpec() {
    specNameControllers.add(TextEditingController());
    specValueControllers.add(TextEditingController());
    specUnits.add('%');
    specifications.add({'name': '', 'value': '', 'unit': '%'});
  }

  void removeSpec(int index) {
    if (specifications.length <= 1) return;
    specNameControllers[index].dispose();
    specValueControllers[index].dispose();
    specNameControllers.removeAt(index);
    specValueControllers.removeAt(index);
    specUnits.removeAt(index);
    specifications.removeAt(index);
  }

  void updateSpecUnit(int index, String unit) {
    specUnits[index] = unit;
    final updated = Map<String, String>.from(specifications[index]);
    updated['unit'] = unit;
    specifications[index] = updated;
  }

  // ── Tag helpers ───────────────────────────────────────────────────────────
  void addTag(String tag) {
    if (tag.trim().isNotEmpty && !tags.contains(tag.trim())) {
      tags.add(tag.trim());
      tagInputController.clear();
    }
  }

  void removeTag(String tag) => tags.remove(tag);

  void saveDraft() {}
  void publishProduct() {}

  @override
  void onClose() {
    productNameController.dispose();
    varietyController.dispose();
    skuController.dispose();
    descriptionController.dispose();
    certificationsController.dispose();
    cropYearController.dispose();
    sampleQtyController.dispose();
    samplePriceController.dispose();
    priceController.dispose();
    quantityController.dispose();
    moqController.dispose();
    bookingPriceController.dispose();
    totalEstimatedPriceController.dispose();
    startingBidController.dispose();
    regionController.dispose();
    cityController.dispose();
    deliveryTimeController.dispose();
    tagInputController.dispose();
    for (final c in specNameControllers) c.dispose();
    for (final c in specValueControllers) c.dispose();
    super.onClose();
  }
}
