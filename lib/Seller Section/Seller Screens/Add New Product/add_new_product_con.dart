import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Data/country_data.dart';

enum AddListingType { marketplace, advanceBooking, liveAuctions }

class AddNewProductCon extends GetxController {
  // ── Listing Type (mandatory) ─────────────────────────────────────────────
  final Rx<AddListingType?> selectedListingType = Rx<AddListingType?>(null);

  void selectListingType(AddListingType type) {
    selectedListingType.value = type;
  }

  // ── Product name autocomplete ─────────────────────────────────────────────
  final productNameController = TextEditingController();
  final productNameFocusNode = FocusNode();

  static const List<String> productKeywords = [
    // Grains & Cereals
    'Basmati Rice', 'Brown Rice', 'White Rice', 'Jasmine Rice', 'Parboiled Rice',
    'Long Grain Rice', 'Short Grain Rice', 'Sticky Rice', 'Red Rice', 'Black Rice',
    'Arborio Rice', 'Wild Rice', 'Wheat', 'Whole Wheat', 'Durum Wheat',
    'Hard Red Wheat', 'Soft White Wheat', 'Wheat Flour', 'Semolina',
    'Maize', 'Yellow Corn', 'White Corn', 'Sweet Corn', 'Popcorn', 'Corn Flour',
    'Cornmeal', 'Barley', 'Malt Barley', 'Feed Barley', 'Oats', 'Rolled Oats',
    'Steel Cut Oats', 'Pearl Millet', 'Finger Millet', 'Sorghum', 'Grain Sorghum',
    'Quinoa', 'Rye', 'Buckwheat', 'Teff', 'Triticale', 'Flaxseeds',
    // Fruits
    'Apple', 'Red Apple', 'Green Apple', 'Fuji Apple', 'Gala Apple',
    'Mango', 'Alphonso Mango', 'Sindhri Mango', 'Chaunsa Mango',
    'Banana', 'Cavendish Banana', 'Plantain',
    'Orange', 'Navel Orange', 'Valencia Orange',
    'Lemon', 'Lime', 'Persian Lime', 'Key Lime',
    'Pineapple', 'Papaya', 'Guava', 'Watermelon', 'Cantaloupe', 'Honeydew Melon',
    'Strawberry', 'Blueberry', 'Raspberry', 'Blackberry',
    'Grape', 'Red Grape', 'Green Grape', 'Black Grape',
    'Kiwi', 'Pomegranate', 'Fig', 'Date', 'Medjool Date',
    'Peach', 'Plum', 'Apricot', 'Cherry',
    'Coconut', 'Avocado', 'Passion Fruit', 'Lychee', 'Jackfruit',
    'Dragon Fruit', 'Rambutan', 'Longan', 'Mangosteen', 'Durian',
    'Sapodilla', 'Custard Apple', 'Tamarind', 'Starfruit', 'Breadfruit',
    // Vegetables
    'Tomato', 'Cherry Tomato', 'Roma Tomato',
    'Potato', 'Red Potato', 'White Potato', 'Sweet Potato', 'Yam',
    'Onion', 'Red Onion', 'White Onion', 'Yellow Onion',
    'Garlic', 'Carrot', 'Spinach', 'Lettuce', 'Cabbage',
    'Cauliflower', 'Broccoli', 'Cucumber', 'Zucchini', 'Eggplant',
    'Bell Pepper', 'Chili Pepper', 'Peas', 'Green Beans',
    'Celery', 'Asparagus', 'Kale', 'Artichoke', 'Radish',
    'Turnip', 'Beet', 'Pumpkin', 'Squash', 'Okra',
    'Bitter Gourd', 'Bottle Gourd', 'Ridge Gourd', 'Snake Gourd',
    'Drumstick', 'Taro', 'Cassava', 'Ginger', 'Turmeric Root',
    // Spices
    'Black Pepper', 'White Pepper', 'Red Chili', 'Paprika',
    'Turmeric', 'Cumin', 'Coriander', 'Cardamom', 'Cinnamon',
    'Cloves', 'Nutmeg', 'Star Anise', 'Bay Leaves', 'Fenugreek',
    'Mustard Seeds', 'Fennel Seeds', 'Sesame Seeds', 'Caraway Seeds',
    'Saffron', 'Vanilla', 'Ginger Powder', 'Garlic Powder',
    'Onion Powder', 'Oregano', 'Thyme', 'Rosemary', 'Basil',
    'Mint', 'Dill', 'Lemongrass', 'Galangal',
    // Pulses
    'Chickpeas', 'Black Chickpeas', 'Red Lentils', 'Green Lentils',
    'Yellow Lentils', 'Moong Beans', 'Kidney Beans', 'Black Beans',
    'White Beans', 'Pinto Beans', 'Soybeans', 'Black-Eyed Peas',
    'Pigeon Peas', 'Fava Beans', 'Cowpeas', 'Adzuki Beans',
    // Oilseeds
    'Sunflower Seeds', 'Canola Seeds', 'Groundnuts', 'Peanuts',
    'Castor Seeds', 'Niger Seeds', 'Cottonseed',
    // Nuts
    'Almonds', 'Walnuts', 'Cashews', 'Pistachios', 'Hazelnuts',
    'Pecans', 'Macadamia Nuts', 'Pine Nuts', 'Brazil Nuts', 'Chestnuts',
    // Cash crops & others
    'Cotton', 'Cotton Lint', 'Jute', 'Sugarcane', 'Raw Sugar',
    'Brown Sugar', 'Molasses', 'Tea', 'Green Tea', 'Black Tea', 'White Tea',
    'Coffee', 'Arabica Coffee', 'Robusta Coffee',
    'Cocoa', 'Cocoa Beans', 'Tobacco', 'Rubber',
    // Dairy
    'Milk', 'Whole Milk', 'Skimmed Milk', 'Butter', 'Ghee',
    'Cheese', 'Cheddar Cheese', 'Mozzarella', 'Yogurt',
    'Condensed Milk', 'Powdered Milk',
    // Misc
    'Honey', 'Beeswax', 'Eggs',
  ];

  // ── Common Basic Info ────────────────────────────────────────────────────
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
  final RxString selectedCountry = ''.obs;
  final RxString selectedRegion = ''.obs;
  final RxString selectedCity = ''.obs;
  final deliveryTimeController = TextEditingController();
  final RxString selectedDeliveryOption = ''.obs;

  List<String> get allCountries => kAllCountries;

  List<String> get regionsForCountry =>
      kCountryData[selectedCountry.value]?.keys.toList() ?? [];

  List<String> get citiesForRegion =>
      kCountryData[selectedCountry.value]?[selectedRegion.value] ?? [];

  void onCountryChanged(String country) {
    selectedCountry.value = country;
    selectedRegion.value = '';
    selectedCity.value = '';
  }

  void onRegionChanged(String region) {
    selectedRegion.value = region;
    selectedCity.value = '';
  }

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
    productNameFocusNode.dispose();
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
    deliveryTimeController.dispose();
    tagInputController.dispose();
    for (final c in specNameControllers) c.dispose();
    for (final c in specValueControllers) c.dispose();
    super.onClose();
  }
}
