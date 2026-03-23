// import 'package:agri/Data/Models/product_type_enums.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Core/Constant/images.dart';
// import '../../../Data/Models/category_model.dart';
// import '../../../Data/Models/marketplace_product_model.dart';
//
// class MarketplaceCon extends GetxController {
//   RxInt selectedIndex = 0.obs;
//   RxDouble rating = 4.5.obs;
//
//   final ScrollController categoryScrollController = ScrollController();
//
//   RxBool showBackArrow = false.obs;
//   RxBool showForwardArrow = true.obs;
//
//   RxList<MarketplaceProductModel> products = <MarketplaceProductModel>[
//     MarketplaceProductModel(
//       id: '1',
//       name: 'Sella Basmati Rice',
//       description: '',
//       images: [CImages.p1],
//       category: 'Grains',
//       grade: 'A',
//       sellerId: '12345',
//       sellerName: 'ABC',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: 148,
//       unit: 'Ton',
//       location: 'Kenya',
//       origin: 'Nairobi',
//       specifications: {},
//       currency: 'USD',
//       variety: 'Glycine Max',
//       minOrderQty: 500,
//       stock: 900,
//     ),
//     MarketplaceProductModel(
//       id: '2',
//       name: 'Desiree Potato',
//       description: '',
//       images: [CImages.p2],
//       category: 'Grains',
//       grade: 'C',
//       sellerId: '12345',
//       sellerName: 'ABC',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: 148,
//       unit: 'Ton',
//       location: 'Kenya',
//       origin: 'Nairobi',
//       specifications: {},
//       currency: 'USD',
//       variety: 'Glycine Max',
//       minOrderQty: 500,
//       stock: 1000,
//     ),
//     MarketplaceProductModel(
//       id: '3',
//       name: 'Diamond Potato',
//       description: '',
//       images: [CImages.p3],
//       category: 'Grains',
//       grade: 'A',
//       sellerId: '12345',
//       sellerName: 'ABC',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: 148,
//       unit: 'Ton',
//       location: 'Kenya',
//       origin: 'Nairobi',
//       specifications: {},
//       currency: 'USD',
//       variety: 'Glycine Max',
//       minOrderQty: 500,
//       stock: 1000,
//     ),
//     MarketplaceProductModel(
//       id: '4',
//       name: 'Apple',
//       description: '',
//       images: [CImages.p4],
//       category: 'Grains',
//       grade: 'A',
//       sellerId: '12345',
//       sellerName: 'ABC',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: 148,
//       unit: 'Ton',
//       location: 'Kenya',
//       origin: 'Nairobi',
//       specifications: {},
//       currency: 'USD',
//       variety: 'Glycine Max',
//       minOrderQty: 500,
//       stock: 1000,
//     ),
//     MarketplaceProductModel(
//       id: '5',
//       name: 'Premium Soybean',
//       description: '',
//       images: [CImages.p5],
//       category: 'Grains',
//       grade: 'A',
//       sellerId: '12345',
//       sellerName: 'ABC',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: 148,
//       unit: 'Ton',
//       location: 'Kenya',
//       origin: 'Nairobi',
//       specifications: {},
//       currency: 'USD',
//       variety: 'Glycine Max',
//       minOrderQty: 500,
//       stock: 1000,
//     ),
//     MarketplaceProductModel(
//       id: '6',
//       name: 'Premium Soybean',
//       description: '',
//       images: [CImages.p6],
//       category: 'Grains',
//       grade: 'A',
//       sellerId: '12345',
//       sellerName: 'ABC',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: 148,
//       unit: 'Ton',
//       location: 'Kenya',
//       origin: 'Nairobi',
//       specifications: {},
//       currency: 'USD',
//       variety: 'Glycine Max',
//       minOrderQty: 500,
//       stock: 1000,
//     ),
//   ].obs;
//
//   RxList<CategoryModel> category = <CategoryModel>[
//     CategoryModel(
//       name: "Grains And Cereals",
//       image: CImages.grainsAndCereals,
//       id: "0",
//     ),
//     CategoryModel(name: "Fresh Produce", image: CImages.freshProduce, id: "1"),
//     CategoryModel(name: "Legumes", image: CImages.legumes, id: "2"),
//     CategoryModel(name: "Oil Seeds", image: CImages.oilSeeds, id: "3"),
//     CategoryModel(name: "Live Stock", image: CImages.livestock, id: "4"),
//     CategoryModel(name: "Animal Feed", image: CImages.animalFeeds, id: "5"),
//     CategoryModel(name: "Fodder/Forage", image: CImages.fodderForage, id: "6"),
//     CategoryModel(name: "By Products", image: CImages.byProducts, id: "7"),
//   ].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     categoryScrollController.addListener(_updateArrowVisibility);
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) => _updateArrowVisibility(),
//     );
//   }
//
//   void _updateArrowVisibility() {
//     if (!categoryScrollController.hasClients) return;
//     final position = categoryScrollController.position;
//     showBackArrow.value = position.pixels > 0;
//     showForwardArrow.value = position.pixels < position.maxScrollExtent;
//   }
//
//   void selectCategory(int index) {
//     selectedIndex.value = index;
//     scrollToCategory(index);
//   }
//
//   void scrollToCategory(int index) {
//     if (!categoryScrollController.hasClients) return;
//     const double itemWidth = 150;
//     final double targetOffset = index * itemWidth;
//     categoryScrollController.animateTo(
//       targetOffset.clamp(
//         0.0,
//         categoryScrollController.position.maxScrollExtent,
//       ),
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void scrollNext() {
//     if (selectedIndex.value < category.length - 1) {
//       selectedIndex.value++;
//       scrollToCategory(selectedIndex.value);
//     }
//   }
//
//   void scrollPrevious() {
//     if (selectedIndex.value > 0) {
//       selectedIndex.value--;
//       scrollToCategory(selectedIndex.value);
//     }
//   }
//
//   @override
//   void onClose() {
//     categoryScrollController.dispose();
//     super.onClose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/images.dart';
import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/marketplace_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';

enum StockFilter { all, active, pending, lowStock, outOfStock }

enum SortOption { latest, oldest, highestStock, lowestStock }

class MarketplaceCon extends GetxController {
  // ── Category ───────────────────────────────────────────────────────────────
  final RxInt selectedCategoryIndex = 0.obs;
  final ScrollController categoryScrollController = ScrollController();
  RxBool showBackArrow = false.obs;
  RxBool showForwardArrow = true.obs;

  // ── Filters ────────────────────────────────────────────────────────────────
  final Rx<StockFilter> selectedFilter = StockFilter.all.obs;
  final Rx<SortOption> selectedSort = SortOption.latest.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // ── Products ───────────────────────────────────────────────────────────────
  RxList<MarketplaceProductModel> products = <MarketplaceProductModel>[
    MarketplaceProductModel(
      id: '1',
      name: 'Sella Basmati Rice',
      description: '',
      images: [CImages.p1],
      category: 'Grains & Cereals',
      grade: 'A',
      sellerId: '12345',
      sellerName: 'ABC',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 148,
      unit: 'Ton',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: 'USD',
      variety: 'Glycine Max',
      minOrderQty: 500,
      stock: 900,
    ),
    MarketplaceProductModel(
      id: '2',
      name: 'Desiree Potato',
      description: '',
      images: [CImages.p2],
      category: 'Grains & Cereals',
      grade: 'C',
      sellerId: '12345',
      sellerName: 'ABC',
      createdAt: DateTime.now(),
      status: ProductStatus.pending,
      price: 95,
      unit: 'Ton',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: 'USD',
      variety: 'Glycine Max',
      minOrderQty: 500,
      stock: 1000,
    ),
    MarketplaceProductModel(
      id: '3',
      name: 'Diamond Potato',
      description: '',
      images: [CImages.p3],
      category: 'Grains & Cereals',
      grade: 'A',
      sellerId: '12345',
      sellerName: 'ABC',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 60,
      unit: 'box',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: 'USD',
      variety: 'Glycine Max',
      minOrderQty: 500,
      stock: 1000,
    ),
    MarketplaceProductModel(
      id: '4',
      name: 'Apple',
      description: '',
      images: [CImages.p4],
      category: 'Fresh Produce',
      grade: 'A',
      sellerId: '12345',
      sellerName: 'ABC',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 148,
      unit: 'Ton',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: 'USD',
      variety: 'Glycine Max',
      minOrderQty: 500,
      stock: 1000,
    ),
    MarketplaceProductModel(
      id: '5',
      name: 'Premium Soybean',
      description: '',
      images: [CImages.p5],
      category: 'Oil Seeds',
      grade: 'A',
      sellerId: '12345',
      sellerName: 'ABC',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 148,
      unit: 'Ton',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: 'USD',
      variety: 'Glycine Max',
      minOrderQty: 500,
      stock: 1000,
    ),
    MarketplaceProductModel(
      id: '6',
      name: 'Premium Soybean',
      description: '',
      images: [CImages.p6],
      category: 'Oil Seeds',
      grade: 'A',
      sellerId: '12345',
      sellerName: 'ABC',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: 148,
      unit: 'Ton',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: 'USD',
      variety: 'Glycine Max',
      minOrderQty: 500,
      stock: 1000,
    ),
  ].obs;

  // Hardcoded soldQty per product — replace with product.soldQty when available
  final Map<String, double> soldQtyMap = {
    '1': 270,
    '2': 820,
    '3': 220,
    '4': 150,
    '5': 500,
    '6': 300,
  };

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

  // ── Computed ───────────────────────────────────────────────────────────────

  double soldQty(String id) => soldQtyMap[id] ?? 0;

  double progress(MarketplaceProductModel p) =>
      ((soldQty(p.id)) / (p.stock == 0 ? 1 : p.stock)).clamp(0.0, 1.0);

  bool isLowStock(MarketplaceProductModel p) => progress(p) >= 0.8;
  bool isOutOfStock(MarketplaceProductModel p) => p.stock == 0;

  List<MarketplaceProductModel> get filteredProducts {
    List<MarketplaceProductModel> list = List.from(products);

    // Category filter
    if (selectedCategoryIndex.value != 0) {
      final catName = categories[selectedCategoryIndex.value].name;
      list = list.where((p) => p.category == catName).toList();
    }

    // Status / stock filter
    switch (selectedFilter.value) {
      case StockFilter.active:
        list = list.where((p) => p.status == ProductStatus.active).toList();
        break;
      case StockFilter.pending:
        list = list.where((p) => p.status == ProductStatus.pending).toList();
        break;
      case StockFilter.lowStock:
        list = list.where((p) => isLowStock(p) && !isOutOfStock(p)).toList();
        break;
      case StockFilter.outOfStock:
        list = list.where((p) => isOutOfStock(p)).toList();
        break;
      case StockFilter.all:
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
      case SortOption.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.highestStock:
        list.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case SortOption.lowestStock:
        list.sort((a, b) => a.stock.compareTo(b.stock));
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

  void setFilter(StockFilter filter) => selectedFilter.value = filter;
  void setSort(SortOption sort) => selectedSort.value = sort;
  void onSearch(String val) => searchQuery.value = val;

  void deleteProduct(String id) => products.removeWhere((p) => p.id == id);

  void editProduct(MarketplaceProductModel product) {
    // Navigate to edit screen — add your navigation logic here
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
