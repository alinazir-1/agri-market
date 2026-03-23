// import 'package:agri/Core/Constant/images.dart';
// import 'package:agri/Data/Models/product_type_enums.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// import '../../../Data/Models/live_auction_product_model.dart';
//
// class LiveAuctionsCon extends GetxController {
//   RxDouble rating = 4.5.obs;
//
//   ///Products List
//   RxList<LiveAuctionProductModel> products = <LiveAuctionProductModel>[
//     LiveAuctionProductModel(
//       id: '1',
//       name: 'Sella Basmati Rice',
//       description: '',
//       images: [CImages.p1],
//       category: '',
//       grade: 'B',
//       sellerId: '',
//       sellerName: '',
//       createdAt: DateTime.now(),
//       status: ProductStatus.active,
//       price: null,
//       unit: 'Ton',
//       location: 'India',
//       origin: 'Gujarat',
//       specifications: {},
//       currency: '',
//       variety: '',
//       minOrderQty: null,
//       stock: 1200,
//       startingBid: 200,
//       currentBid: 340,
//       auctionEndTime: DateTime.now().add(const Duration(hours: 5)),
//       totalBids: 23,
//     ),
//   ].obs;
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/images.dart';
import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/live_auction_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';

enum AuctionFilter { all, active, ended, highBids }

enum AuctionSortOption { latest, oldest, endingSoon, highestBid, mostBids }

class LiveAuctionsCon extends GetxController {
  // ── Category ───────────────────────────────────────────────────────────────
  final RxInt selectedCategoryIndex = 0.obs;
  final ScrollController categoryScrollController = ScrollController();
  RxBool showBackArrow = false.obs;
  RxBool showForwardArrow = true.obs;

  // ── Filters ────────────────────────────────────────────────────────────────
  final Rx<AuctionFilter> selectedFilter = AuctionFilter.all.obs;
  final Rx<AuctionSortOption> selectedSort = AuctionSortOption.latest.obs;
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
  RxList<LiveAuctionProductModel> products = <LiveAuctionProductModel>[
    LiveAuctionProductModel(
      id: '1',
      name: 'Sella Basmati Rice',
      description: '',
      images: [CImages.p1],
      category: 'Grains & Cereals',
      grade: 'B',
      sellerId: '',
      sellerName: '',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: null,
      unit: 'Ton',
      location: 'India',
      origin: 'Gujarat',
      specifications: {},
      currency: '',
      variety: '',
      minOrderQty: null,
      stock: 1200,
      startingBid: 200,
      currentBid: 340,
      auctionEndTime: DateTime.now().add(const Duration(hours: 5)),
      totalBids: 23,
    ),
    LiveAuctionProductModel(
      id: '2',
      name: 'Desiree Potato',
      description: '',
      images: [CImages.p2],
      category: 'Grains & Cereals',
      grade: 'C',
      sellerId: '',
      sellerName: '',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: null,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'Sindh',
      specifications: {},
      currency: '',
      variety: '',
      minOrderQty: null,
      stock: 1000,
      startingBid: 80,
      currentBid: 120,
      auctionEndTime: DateTime.now().add(const Duration(hours: 2)),
      totalBids: 11,
    ),
    LiveAuctionProductModel(
      id: '3',
      name: 'Fresh Mangoes',
      description: '',
      images: [CImages.p3],
      category: 'Fresh Produce',
      grade: 'A+',
      sellerId: '',
      sellerName: '',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: null,
      unit: 'box',
      location: 'Pakistan',
      origin: 'Multan',
      specifications: {},
      currency: '',
      variety: '',
      minOrderQty: null,
      stock: 200,
      startingBid: 50,
      currentBid: 88,
      auctionEndTime: DateTime.now().add(const Duration(minutes: 45)),
      totalBids: 41,
    ),
    LiveAuctionProductModel(
      id: '4',
      name: 'Apple',
      description: '',
      images: [CImages.p4],
      category: 'Fresh Produce',
      grade: 'A',
      sellerId: '',
      sellerName: '',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: null,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'KPK',
      specifications: {},
      currency: '',
      variety: '',
      minOrderQty: null,
      stock: 500,
      startingBid: 120,
      currentBid: 165,
      auctionEndTime: DateTime.now().subtract(const Duration(hours: 1)),
      totalBids: 18,
    ),
    LiveAuctionProductModel(
      id: '5',
      name: 'Premium Soybean',
      description: '',
      images: [CImages.p5],
      category: 'Oil Seeds',
      grade: 'A',
      sellerId: '',
      sellerName: '',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: null,
      unit: 'Ton',
      location: 'Pakistan',
      origin: 'Punjab',
      specifications: {},
      currency: '',
      variety: '',
      minOrderQty: null,
      stock: 1000,
      startingBid: 140,
      currentBid: 210,
      auctionEndTime: DateTime.now().add(const Duration(hours: 8)),
      totalBids: 7,
    ),
    LiveAuctionProductModel(
      id: '6',
      name: 'Diamond Potato',
      description: '',
      images: [CImages.p6],
      category: 'Oil Seeds',
      grade: 'B',
      sellerId: '',
      sellerName: '',
      createdAt: DateTime.now(),
      status: ProductStatus.active,
      price: null,
      unit: 'Ton',
      location: 'Kenya',
      origin: 'Nairobi',
      specifications: {},
      currency: '',
      variety: '',
      minOrderQty: null,
      stock: 800,
      startingBid: 90,
      currentBid: 130,
      auctionEndTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      totalBids: 15,
    ),
  ].obs;

  // ── Computed ───────────────────────────────────────────────────────────────

  bool isEnded(LiveAuctionProductModel p) =>
      p.auctionEndTime.difference(DateTime.now()).isNegative;

  String timerText(LiveAuctionProductModel p) {
    final remaining = p.auctionEndTime.difference(DateTime.now());
    if (remaining.isNegative) return "Ended";
    return "${remaining.inHours.toString().padLeft(2, '0')}:"
        "${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(remaining.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  bool isEndingSoon(LiveAuctionProductModel p) {
    final remaining = p.auctionEndTime.difference(DateTime.now());
    return !remaining.isNegative && remaining.inMinutes <= 60;
  }

  // ── Filtered List ──────────────────────────────────────────────────────────

  List<LiveAuctionProductModel> get filteredProducts {
    List<LiveAuctionProductModel> list = List.from(products);

    // Category
    if (selectedCategoryIndex.value != 0) {
      final catName = categories[selectedCategoryIndex.value].name;
      list = list.where((p) => p.category == catName).toList();
    }

    // Auction filter
    switch (selectedFilter.value) {
      case AuctionFilter.active:
        list = list.where((p) => !isEnded(p)).toList();
        break;
      case AuctionFilter.ended:
        list = list.where((p) => isEnded(p)).toList();
        break;
      case AuctionFilter.highBids:
        list = list.where((p) => p.totalBids >= 20).toList();
        break;
      case AuctionFilter.all:
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
      case AuctionSortOption.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case AuctionSortOption.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case AuctionSortOption.endingSoon:
        list.sort((a, b) => a.auctionEndTime.compareTo(b.auctionEndTime));
        break;
      case AuctionSortOption.highestBid:
        list.sort((a, b) => b.currentBid.compareTo(a.currentBid));
        break;
      case AuctionSortOption.mostBids:
        list.sort((a, b) => b.totalBids.compareTo(a.totalBids));
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

  void setFilter(AuctionFilter filter) => selectedFilter.value = filter;
  void setSort(AuctionSortOption sort) => selectedSort.value = sort;
  void onSearch(String val) => searchQuery.value = val;

  void deleteProduct(String id) => products.removeWhere((p) => p.id == id);

  void editProduct(LiveAuctionProductModel product) {
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
