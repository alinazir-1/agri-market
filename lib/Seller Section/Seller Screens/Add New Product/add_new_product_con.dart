import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddNewProductCon extends GetxController {
  // ── Basic Info ──
  final productNameController = TextEditingController();
  final varietyController = TextEditingController();
  final skuController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxString selectedCategory = ''.obs;

  // ── Quality & Harvest ──
  final RxString selectedGrade = ''.obs;
  final RxString selectedStorageCondition = ''.obs;
  final Rx<DateTime?> harvestDate = Rx<DateTime?>(null);
  final certificationsController = TextEditingController();
  final cropYearController = TextEditingController();

  // ── Specifications ──
  // Controllers are stored separately so they survive Obx rebuilds
  final RxList<Map<String, String>> specifications = <Map<String, String>>[
    {'name': '', 'value': '', 'unit': '%'},
  ].obs;

  // Parallel lists for TextEditingControllers — 1 name + 1 value per row
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

  void addSpecFromChip(String name) {
    final nameC = TextEditingController(text: name);
    final valueC = TextEditingController();
    specNameControllers.add(nameC);
    specValueControllers.add(valueC);
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

  // ── Sample Availability ──
  final RxBool sampleAvailable = true.obs;
  final sampleQtyController = TextEditingController();
  final samplePriceController = TextEditingController();
  final RxString selectedSampleUnit = 'kg'.obs;
  final RxString selectedDispatchTime = ''.obs;
  final RxString selectedDeliveryCoveredBy = ''.obs;

  // ── Pricing & Quantity ──
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final moqController = TextEditingController();
  final RxString selectedUnit = ''.obs;
  final RxString selectedCurrency = 'USD (\$)'.obs;

  // ── Location & Delivery ──
  final regionController = TextEditingController();
  final cityController = TextEditingController();
  final deliveryTimeController = TextEditingController();
  final RxString selectedCountry = ''.obs;
  final RxString selectedDeliveryOption = ''.obs;

  // ── Tags ──
  final tagInputController = TextEditingController();
  final RxList<String> tags = <String>[
    'Organic',
    'Premium',
    'Export Quality',
  ].obs;

  void addTag(String tag) {
    if (tag.trim().isNotEmpty && !tags.contains(tag.trim())) {
      tags.add(tag.trim());
      tagInputController.clear();
    }
  }

  void removeTag(String tag) => tags.remove(tag);

  // ── Images ──
  final RxList<String> images =
      <String>[].obs; // replace String with File/XFile

  // ── Form completion ──
  RxDouble get formCompletion {
    int filled = 0;
    if (productNameController.text.isNotEmpty) filled++;
    if (selectedCategory.isNotEmpty) filled++;
    if (varietyController.text.isNotEmpty) filled++;
    if (descriptionController.text.isNotEmpty) filled++;
    if (selectedGrade.isNotEmpty) filled++;
    if (harvestDate.value != null) filled++;
    if (selectedStorageCondition.isNotEmpty) filled++;
    if (certificationsController.text.isNotEmpty) filled++;
    if (specifications.isNotEmpty) filled++;
    if (priceController.text.isNotEmpty) filled++;
    if (selectedUnit.isNotEmpty) filled++;
    if (quantityController.text.isNotEmpty) filled++;
    if (moqController.text.isNotEmpty) filled++;
    if (selectedCountry.isNotEmpty) filled++;
    if (regionController.text.isNotEmpty) filled++;
    if (selectedDeliveryOption.isNotEmpty) filled++;
    if (images.isNotEmpty) filled++;
    if (tags.isNotEmpty) filled++;
    return (filled / 18.0).obs;
  }

  void saveDraft() {
    // your draft logic here
  }

  void publishProduct() {
    // your publish logic here
  }

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
    regionController.dispose();
    cityController.dispose();
    deliveryTimeController.dispose();
    tagInputController.dispose();
    for (final c in specNameControllers) {
      c.dispose();
    }
    for (final c in specValueControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
