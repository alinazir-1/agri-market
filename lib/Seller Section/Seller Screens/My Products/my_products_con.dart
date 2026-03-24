import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/images.dart';
import '../../../Data/Models/advance_booking_product_model.dart';
import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/live_auction_product_model.dart';
import '../../../Data/Models/marketplace_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';

enum MyProductsTab { marketplace, advanceBooking, liveAuctions }

enum ViewMode { list, grid }

enum MarketplaceFilter { all, active, pending, lowStock, outOfStock }

enum AdvanceBookingFilter2 { all, active, inactive, almostFull }

enum LiveAuctionFilter2 { all, active, ended, highBids }

enum MyProductsSort { latest, oldest, highestStock, lowestStock }

class MyProductsCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ScrollController categoryScrollController = ScrollController();

  final RxString searchQuery = ''.obs;
  final Rx<MyProductsTab> activeTab = MyProductsTab.marketplace.obs;
  final Rx<ViewMode> viewMode = ViewMode.list.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  final Rx<MarketplaceFilter> mpFilter = MarketplaceFilter.all.obs;
  final Rx<AdvanceBookingFilter2> abFilter = AdvanceBookingFilter2.all.obs;
  final Rx<LiveAuctionFilter2> laFilter = LiveAuctionFilter2.all.obs;
  final Rx<MyProductsSort> mpSort = MyProductsSort.latest.obs;
  final Rx<MyProductsSort> abSort = MyProductsSort.latest.obs;
  final Rx<MyProductsSort> laSort = MyProductsSort.latest.obs;

  // ── soldQty / bookedQty ───────────────────────────────────────────────────
  final Map<String, double> soldQtyMap = {
    'MP1': 270,
    'MP2': 820,
    'MP3': 220,
    'MP4': 150,
    'MP5': 500,
    'MP6': 300
  };
  final Map<String, double> bookedQtyMap = {
    'AB1': 44,
    'AB2': 680,
    'AB3': 150,
    'AB4': 150
  };

  // ── Categories ────────────────────────────────────────────────────────────
  final List<CategoryModel> categories = [
    CategoryModel(
        name: 'All Products', image: CImages.grainsAndCereals, id: '0'),
    CategoryModel(
        name: 'Grains & Cereals', image: CImages.grainsAndCereals, id: '1'),
    CategoryModel(name: 'Fresh Produce', image: CImages.freshProduce, id: '2'),
    CategoryModel(name: 'Legumes', image: CImages.legumes, id: '3'),
    CategoryModel(name: 'Oil Seeds', image: CImages.oilSeeds, id: '4'),
    CategoryModel(name: 'Live Stock', image: CImages.livestock, id: '5'),
    CategoryModel(name: 'Animal Feed', image: CImages.animalFeeds, id: '6'),
    CategoryModel(
        name: 'Fodder / Forage', image: CImages.fodderForage, id: '7'),
    CategoryModel(name: 'By Products', image: CImages.byProducts, id: '8'),
  ];

  // ── Marketplace Products ──────────────────────────────────────────────────
  final RxList<MarketplaceProductModel> mpProducts = <MarketplaceProductModel>[
    MarketplaceProductModel(
        id: 'MP1',
        name: 'Sella Basmati Rice',
        description: '',
        images: [CImages.p1],
        category: 'Grains & Cereals',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now(),
        status: ProductStatus.active,
        price: 148,
        unit: 'Ton',
        location: 'Kenya',
        origin: 'Nairobi',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 500,
        stock: 900),
    MarketplaceProductModel(
        id: 'MP2',
        name: 'Desiree Potato',
        description: '',
        images: [CImages.p2],
        category: 'Grains & Cereals',
        grade: 'C',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: ProductStatus.pending,
        price: 95,
        unit: 'kg',
        location: 'Pakistan',
        origin: 'Sindh',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 500,
        stock: 1000),
    MarketplaceProductModel(
        id: 'MP3',
        name: 'Diamond Potato',
        description: '',
        images: [CImages.p3],
        category: 'Fresh Produce',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        status: ProductStatus.active,
        price: 60,
        unit: 'box',
        location: 'Pakistan',
        origin: 'Multan',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 500,
        stock: 1000),
    MarketplaceProductModel(
        id: 'MP4',
        name: 'Apple',
        description: '',
        images: [CImages.p4],
        category: 'Fresh Produce',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: ProductStatus.active,
        price: 148,
        unit: 'Ton',
        location: 'Pakistan',
        origin: 'KPK',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 500,
        stock: 1000),
    MarketplaceProductModel(
        id: 'MP5',
        name: 'Premium Soybean',
        description: '',
        images: [CImages.p5],
        category: 'Oil Seeds',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        status: ProductStatus.active,
        price: 148,
        unit: 'Ton',
        location: 'Pakistan',
        origin: 'Punjab',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 500,
        stock: 1000),
    MarketplaceProductModel(
        id: 'MP6',
        name: 'Premium Soybean 2',
        description: '',
        images: [CImages.p6],
        category: 'Oil Seeds',
        grade: 'B',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        status: ProductStatus.active,
        price: 130,
        unit: 'Ton',
        location: 'Pakistan',
        origin: 'Lahore',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 300,
        stock: 1000),
  ].obs;

  // ── Advance Booking Products ──────────────────────────────────────────────
  final RxList<AdvanceBookingProductModel> abProducts =
      <AdvanceBookingProductModel>[
    AdvanceBookingProductModel(
        id: 'AB1',
        name: 'Fresh Mangoes',
        description: '',
        images: [CImages.p3],
        category: 'Fresh Produce',
        grade: 'A+',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now(),
        status: ProductStatus.active,
        price: 55,
        unit: 'box',
        location: 'Pakistan',
        origin: 'Multan',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 20,
        harvestDate: '2026, 08, 12',
        totalEstimatedPrice: 55,
        bookingPrice: 48,
        stock: 200),
    AdvanceBookingProductModel(
        id: 'AB2',
        name: 'Sella Basmati Rice',
        description: '',
        images: [CImages.p1],
        category: 'Grains & Cereals',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: ProductStatus.active,
        price: 180,
        unit: 'Ton',
        location: 'Pakistan',
        origin: 'Okara',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 50,
        harvestDate: '2026, 06, 20',
        totalEstimatedPrice: 180,
        bookingPrice: 130,
        stock: 800),
    AdvanceBookingProductModel(
        id: 'AB3',
        name: 'Apple',
        description: '',
        images: [CImages.p4],
        category: 'Fresh Produce',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: ProductStatus.inactive,
        price: 140,
        unit: 'Ton',
        location: 'Pakistan',
        origin: 'KPK',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 100,
        harvestDate: '2026, 09, 01',
        totalEstimatedPrice: 140,
        bookingPrice: 120,
        stock: 500),
    AdvanceBookingProductModel(
        id: 'AB4',
        name: 'Premium Soybean',
        description: '',
        images: [CImages.p5],
        category: 'Oil Seeds',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        status: ProductStatus.active,
        price: 148,
        unit: 'Ton',
        location: 'Pakistan',
        origin: 'Punjab',
        specifications: {},
        currency: 'USD',
        variety: '',
        minOrderQty: 200,
        harvestDate: '2026, 07, 15',
        totalEstimatedPrice: 148,
        bookingPrice: 120,
        stock: 600),
  ].obs;

  // ── Live Auction Products ─────────────────────────────────────────────────
  final RxList<LiveAuctionProductModel> laProducts = <LiveAuctionProductModel>[
    LiveAuctionProductModel(
        id: 'LA1',
        name: 'Apple',
        description: '',
        images: [CImages.p4],
        category: 'Fresh Produce',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
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
        auctionEndTime:
            DateTime.now().add(const Duration(hours: 5, minutes: 24)),
        totalBids: 18),
    LiveAuctionProductModel(
        id: 'LA2',
        name: 'Premium Soybean',
        description: '',
        images: [CImages.p5],
        category: 'Oil Seeds',
        grade: 'A',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
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
        auctionEndTime: DateTime.now().add(const Duration(minutes: 42)),
        totalBids: 7),
    LiveAuctionProductModel(
        id: 'LA3',
        name: 'Diamond Potato',
        description: '',
        images: [CImages.p2],
        category: 'Grains & Cereals',
        grade: 'B',
        sellerId: 's1',
        sellerName: 'AS',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
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
        startingBid: 80,
        currentBid: 130,
        auctionEndTime: DateTime.now().subtract(const Duration(hours: 2)),
        totalBids: 15),
  ].obs;

  // ── Helpers ───────────────────────────────────────────────────────────────
  double mpSoldQty(MarketplaceProductModel p) => soldQtyMap[p.id] ?? 0;
  double mpProgress(MarketplaceProductModel p) =>
      ((soldQtyMap[p.id] ?? 0) / (p.stock == 0 ? 1 : p.stock)).clamp(0.0, 1.0);
  bool mpIsLow(MarketplaceProductModel p) => mpProgress(p) >= 0.8;
  bool mpIsOut(MarketplaceProductModel p) => p.stock == 0;

  double abBookedQty(AdvanceBookingProductModel p) => bookedQtyMap[p.id] ?? 0;
  double abProgress(AdvanceBookingProductModel p) =>
      ((bookedQtyMap[p.id] ?? 0) / (p.stock == 0 ? 1 : p.stock))
          .clamp(0.0, 1.0);
  bool abIsAlmostFull(AdvanceBookingProductModel p) => abProgress(p) >= 0.8;

  bool laIsEnded(LiveAuctionProductModel p) =>
      p.auctionEndTime.difference(DateTime.now()).isNegative;
  bool laIsEndingSoon(LiveAuctionProductModel p) {
    final r = p.auctionEndTime.difference(DateTime.now());
    return !r.isNegative && r.inMinutes <= 60;
  }

  String laTimerText(LiveAuctionProductModel p) {
    final r = p.auctionEndTime.difference(DateTime.now());
    if (r.isNegative) return 'Ended';
    return '${r.inHours.toString().padLeft(2, '0')}:${(r.inMinutes % 60).toString().padLeft(2, '0')}:${(r.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  // ── Filtered Lists ────────────────────────────────────────────────────────
  List<MarketplaceProductModel> get filteredMp {
    List<MarketplaceProductModel> list = List.from(mpProducts);
    if (selectedCategoryIndex.value != 0) {
      final cat = categories[selectedCategoryIndex.value].name;
      list = list.where((p) => p.category == cat).toList();
    }
    switch (mpFilter.value) {
      case MarketplaceFilter.active:
        list = list.where((p) => p.status == ProductStatus.active).toList();
        break;
      case MarketplaceFilter.pending:
        list = list.where((p) => p.status == ProductStatus.pending).toList();
        break;
      case MarketplaceFilter.lowStock:
        list = list.where((p) => mpIsLow(p) && !mpIsOut(p)).toList();
        break;
      case MarketplaceFilter.outOfStock:
        list = list.where((p) => mpIsOut(p)).toList();
        break;
      default:
        break;
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }
    switch (mpSort.value) {
      case MyProductsSort.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case MyProductsSort.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case MyProductsSort.highestStock:
        list.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case MyProductsSort.lowestStock:
        list.sort((a, b) => a.stock.compareTo(b.stock));
        break;
    }
    return list;
  }

  List<AdvanceBookingProductModel> get filteredAb {
    List<AdvanceBookingProductModel> list = List.from(abProducts);
    if (selectedCategoryIndex.value != 0) {
      final cat = categories[selectedCategoryIndex.value].name;
      list = list.where((p) => p.category == cat).toList();
    }
    switch (abFilter.value) {
      case AdvanceBookingFilter2.active:
        list = list.where((p) => p.status == ProductStatus.active).toList();
        break;
      case AdvanceBookingFilter2.inactive:
        list = list.where((p) => p.status == ProductStatus.inactive).toList();
        break;
      case AdvanceBookingFilter2.almostFull:
        list = list.where((p) => abIsAlmostFull(p)).toList();
        break;
      default:
        break;
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    switch (abSort.value) {
      case MyProductsSort.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case MyProductsSort.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case MyProductsSort.highestStock:
        list.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case MyProductsSort.lowestStock:
        list.sort((a, b) => a.harvestDate.compareTo(b.harvestDate));
        break;
    }
    return list;
  }

  List<LiveAuctionProductModel> get filteredLa {
    List<LiveAuctionProductModel> list = List.from(laProducts);
    if (selectedCategoryIndex.value != 0) {
      final cat = categories[selectedCategoryIndex.value].name;
      list = list.where((p) => p.category == cat).toList();
    }
    switch (laFilter.value) {
      case LiveAuctionFilter2.active:
        list = list.where((p) => !laIsEnded(p)).toList();
        break;
      case LiveAuctionFilter2.ended:
        list = list.where((p) => laIsEnded(p)).toList();
        break;
      case LiveAuctionFilter2.highBids:
        list = list.where((p) => p.totalBids >= 15).toList();
        break;
      default:
        break;
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    switch (laSort.value) {
      case MyProductsSort.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case MyProductsSort.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case MyProductsSort.highestStock:
        list.sort((a, b) => b.currentBid.compareTo(a.currentBid));
        break;
      case MyProductsSort.lowestStock:
        list.sort((a, b) => a.auctionEndTime.compareTo(b.auctionEndTime));
        break;
    }
    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  void setTab(MyProductsTab t) {
    activeTab.value = t;
    selectedCategoryIndex.value = 0;
  }

  void setViewMode(ViewMode m) => viewMode.value = m;
  void setMpFilter(MarketplaceFilter f) => mpFilter.value = f;
  void setAbFilter(AdvanceBookingFilter2 f) => abFilter.value = f;
  void setLaFilter(LiveAuctionFilter2 f) => laFilter.value = f;
  void setMpSort(MyProductsSort s) => mpSort.value = s;
  void setAbSort(MyProductsSort s) => abSort.value = s;
  void setLaSort(MyProductsSort s) => laSort.value = s;
  void onSearch(String v) => searchQuery.value = v;

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    if (!categoryScrollController.hasClients) return;
    categoryScrollController.animateTo(
      (index * 140.0)
          .clamp(0.0, categoryScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollCategoryNext() {
    if (selectedCategoryIndex.value < categories.length - 1)
      selectCategory(selectedCategoryIndex.value + 1);
  }

  void scrollCategoryPrev() {
    if (selectedCategoryIndex.value > 0)
      selectCategory(selectedCategoryIndex.value - 1);
  }

  void deleteMp(String id) => mpProducts.removeWhere((p) => p.id == id);
  void deleteAb(String id) => abProducts.removeWhere((p) => p.id == id);
  void deleteLa(String id) => laProducts.removeWhere((p) => p.id == id);
  void editProduct(String id) {/* navigate to edit */}

  @override
  void onClose() {
    searchController.dispose();
    categoryScrollController.dispose();
    super.onClose();
  }
}
