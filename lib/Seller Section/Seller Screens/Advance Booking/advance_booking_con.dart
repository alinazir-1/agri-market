// import 'package:agri/Data/Models/product_type_enums.dart';
// import 'package:get/get.dart';
// import '../../../Core/Constant/images.dart';
// import '../../../Data/Models/advance_booking_product_model.dart';
//
// class AdvanceBookingCon extends GetxController {
//   RxDouble rating = 4.5.obs;
//
//   ///Products List
//   RxList<AdvanceBookingProductModel> products = <AdvanceBookingProductModel>[
//     AdvanceBookingProductModel(
//       id: '1',
//       name: 'Sella Basmati Rice',
//       description: '',
//       images: [CImages.p1],
//       category: 'Grains',
//       grade: 'A',
//       sellerId: '123AD',
//       sellerName: 'aBCD123',
//       createdAt: DateTime.now(),
//       status: ProductStatus.inactive,
//       price: 230,
//       unit: 'Ton',
//       location: 'Pakistan',
//       origin: 'Okara',
//       specifications: {},
//       currency: 'USD',
//       variety: '',
//       minOrderQty: 50,
//       harvestDate: "2026, 08, 12",
//       totalEstimatedPrice: 180,
//       bookingPrice: 130,
//       stock: 800,
//     ),
//   ].obs;
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/images.dart';
import '../../../Data/Models/advance_booking_product_model.dart';
import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/product_type_enums.dart';

enum AdvanceBookingFilter { all, active, inactive, almostFull }

enum AdvanceBookingSortOption { latest, oldest, harvestSoon, highestStock }

class AdvanceBookingCon extends GetxController {
  // ── Category ───────────────────────────────────────────────────────────────
  final RxInt selectedCategoryIndex = 0.obs;
  final ScrollController categoryScrollController = ScrollController();
  RxBool showBackArrow = false.obs;
  RxBool showForwardArrow = true.obs;

  // ── Filters ────────────────────────────────────────────────────────────────
  final Rx<AdvanceBookingFilter> selectedFilter = AdvanceBookingFilter.all.obs;
  final Rx<AdvanceBookingSortOption> selectedSort =
      AdvanceBookingSortOption.latest.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // ── Categories ─────────────────────────────────────────────────────────────
  final List<CategoryModel> categories = [
    CategoryModel(
      name: "All Products",
      image: CImages.grainsAndCereals,
      id: "0",
    ),
    CategoryModel(
      name: "Grains & Cereals",
      image: CImages.grainsAndCereals,
      id: "1",
    ),
    CategoryModel(name: "Fresh Produce", image: CImages.freshProduce, id: "2"),
    CategoryModel(name: "Legumes", image: CImages.legumes, id: "3"),
    CategoryModel(name: "Oil Seeds", image: CImages.oilSeeds, id: "4"),
    CategoryModel(name: "Live Stock", image: CImages.livestock, id: "5"),
    CategoryModel(name: "Animal Feed", image: CImages.animalFeeds, id: "6"),
    CategoryModel(
      name: "Fodder / Forage",
      image: CImages.fodderForage,
      id: "7",
    ),
    CategoryModel(name: "By Products", image: CImages.byProducts, id: "8"),
  ];

  // ── Products ───────────────────────────────────────────────────────────────
  RxList<AdvanceBookingProductModel> products = <AdvanceBookingProductModel>[
    AdvanceBookingProductModel(
      id: '1',
      name: 'Sella Basmati Rice',
      description: '',
      images: [CImages.p1],
      category: 'Grains & Cereals',
      grade: 'A',
      sellerId: '123AD',
      sellerName: 'aBCD123',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 230,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'Okara',
      specifications: {},
      currency: 'USD',
      variety: '',
      minOrderQty: 50,
      harvestDate: "2026, 08, 12",
      totalEstimatedPrice: 180,
      bookingPrice: 130,
      stock: 800,
    ),
    AdvanceBookingProductModel(
      id: '2',
      name: 'Desiree Potato',
      description: '',
      images: [CImages.p2],
      category: 'Grains & Cereals',
      grade: 'C',
      sellerId: '123AD',
      sellerName: 'aBCD123',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 95,
      unit: 'kg',
      location: 'Pakistan',
      origin: 'Sindh',
      specifications: {},
      currency: 'USD',
      variety: '',
      minOrderQty: 100,
      harvestDate: "2026, 06, 20",
      totalEstimatedPrice: 90,
      bookingPrice: 80,
      stock: 1000,
    ),
    AdvanceBookingProductModel(
      id: '3',
      name: 'Fresh Mangoes',
      description: '',
      images: [CImages.p3],
      category: 'Fresh Produce',
      grade: 'A+',
      sellerId: '123AD',
      sellerName: 'aBCD123',
      createdAt: DateTime.now(),
      status: ProductStatus.inactive,
      price: 60,
      unit: 'box',
      location: 'Pakistan',
      origin: 'Multan',
      specifications: {},
      currency: 'USD',
      variety: '',
      minOrderQty: 20,
      harvestDate: "2026, 05, 10",
      totalEstimatedPrice: 55,
      bookingPrice: 48,
      stock: 200,
    ),
    AdvanceBookingProductModel(
      id: '4',
      name: 'Apple',
      description: '',
      images: [CImages.p4],
      category: 'Fresh Produce',
      grade: 'A',
      sellerId: '123AD',
      sellerName: 'aBCD123',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 148,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'KPK',
      specifications: {},
      currency: 'USD',
      variety: '',
      minOrderQty: 500,
      harvestDate: "2026, 09, 01",
      totalEstimatedPrice: 140,
      bookingPrice: 120,
      stock: 1000,
    ),
    AdvanceBookingProductModel(
      id: '5',
      name: 'Premium Soybean',
      description: '',
      images: [CImages.p5],
      category: 'Oil Seeds',
      grade: 'A',
      sellerId: '123AD',
      sellerName: 'aBCD123',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 148,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'Punjab',
      specifications: {},
      currency: 'USD',
      variety: '',
      minOrderQty: 500,
      harvestDate: "2026, 07, 15",
      totalEstimatedPrice: 140,
      bookingPrice: 120,
      stock: 1000,
    ),
    AdvanceBookingProductModel(
      id: '6',
      name: 'Premium Soybean 2',
      description: '',
      images: [CImages.p6],
      category: 'Oil Seeds',
      grade: 'B',
      sellerId: '123AD',
      sellerName: 'aBCD123',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 130,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'Lahore',
      specifications: {},
      currency: 'USD',
      variety: '',
      minOrderQty: 300,
      harvestDate: "2026, 10, 05",
      totalEstimatedPrice: 120,
      bookingPrice: 110,
      stock: 1000,
    ),
  ].obs;

  // Hardcoded bookedQty — replace with product.bookedQty when available
  final Map<String, double> bookedQtyMap = {
    '1': 150,
    '2': 820,
    '3': 44,
    '4': 150,
    '5': 500,
    '6': 300,
  };

  // ── Computed ───────────────────────────────────────────────────────────────

  double bookedQty(String id) => bookedQtyMap[id] ?? 0;

  double progress(AdvanceBookingProductModel p) =>
      (bookedQty(p.id) / (p.stock == 0 ? 1 : p.stock)).clamp(0.0, 1.0);

  bool isAlmostFull(AdvanceBookingProductModel p) => progress(p) >= 0.8;

  // ── Filtered List ──────────────────────────────────────────────────────────

  List<AdvanceBookingProductModel> get filteredProducts {
    List<AdvanceBookingProductModel> list = List.from(products);

    // Category
    if (selectedCategoryIndex.value != 0) {
      final catName = categories[selectedCategoryIndex.value].name;
      list = list.where((p) => p.category == catName).toList();
    }

    // Status / booking filter
    switch (selectedFilter.value) {
      case AdvanceBookingFilter.active:
        list = list.where((p) => p.status == ProductStatus.active).toList();
        break;
      case AdvanceBookingFilter.inactive:
        list = list.where((p) => p.status == ProductStatus.inactive).toList();
        break;
      case AdvanceBookingFilter.almostFull:
        list = list.where((p) => isAlmostFull(p)).toList();
        break;
      case AdvanceBookingFilter.all:
        break;
    }

    // Search
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q) ||
                p.location.toLowerCase().contains(q),
          )
          .toList();
    }

    // Sort
    switch (selectedSort.value) {
      case AdvanceBookingSortOption.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case AdvanceBookingSortOption.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case AdvanceBookingSortOption.harvestSoon:
        list.sort((a, b) => a.harvestDate.compareTo(b.harvestDate));
        break;
      case AdvanceBookingSortOption.highestStock:
        list.sort((a, b) => b.stock.compareTo(a.stock));
        break;
    }

    return list;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    _scrollToCategory(index);
  }

  void _scrollToCategory(int index) {
    if (!categoryScrollController.hasClients) return;
    const double itemWidth = 140;
    categoryScrollController.animateTo(
      (index * itemWidth).clamp(
        0.0,
        categoryScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollCategoryNext() {
    if (selectedCategoryIndex.value < categories.length - 1) {
      selectedCategoryIndex.value++;
      _scrollToCategory(selectedCategoryIndex.value);
    }
  }

  void scrollCategoryPrev() {
    if (selectedCategoryIndex.value > 0) {
      selectedCategoryIndex.value--;
      _scrollToCategory(selectedCategoryIndex.value);
    }
  }

  void setFilter(AdvanceBookingFilter filter) => selectedFilter.value = filter;
  void setSort(AdvanceBookingSortOption sort) => selectedSort.value = sort;
  void onSearch(String val) => searchQuery.value = val;

  void deleteProduct(String id) => products.removeWhere((p) => p.id == id);

  void editProduct(AdvanceBookingProductModel product) {
    // add your navigation logic here
  }

  @override
  void onInit() {
    super.onInit();
    categoryScrollController.addListener(_updateArrows);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrows());
  }

  void _updateArrows() {
    if (!categoryScrollController.hasClients) return;
    final pos = categoryScrollController.position;
    showBackArrow.value = pos.pixels > 0;
    showForwardArrow.value = pos.pixels < pos.maxScrollExtent;
  }

  @override
  void onClose() {
    categoryScrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
