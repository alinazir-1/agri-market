// lib/features/seller/products/my_products_con.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/data/models/advance_booking_product_model.dart';
import 'package:agri_market/data/models/category_model.dart';
import 'package:agri_market/data/models/live_auction_product_model.dart';
import 'package:agri_market/data/models/marketplace_product_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/data/models/inventory_model.dart';
import 'package:agri_market/data/models/product_model.dart';
import 'package:agri_market/features/seller/add_product/add_new_product_con.dart';
import 'package:agri_market/features/seller/add_product/product_catalog_data.dart';
import 'package:agri_market/features/seller/add_product/product_form_screen.dart';
import 'package:agri_market/features/shared/product_detail/product_detail_screen.dart';

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

  final RxMap<String, double> soldQtyMap = <String, double>{}.obs;
  final RxMap<String, double> bookedQtyMap = <String, double>{}.obs;

  static const String fakeSellerId = 'demo-seller';

  final List<ProductModel> _storedProducts = <ProductModel>[];
  final List<InventoryModel> _storedInventory = <InventoryModel>[];

  final List<CategoryModel> categories = [
    CategoryModel(
      name: 'All Products',
      image: AppImages.categoryCatalogJpeg('Grains & Cereals'),
      id: '0',
    ),
    ...(() {
      final keys = List<String>.from(ProductCatalogData.catalog.keys)..sort();
      return List<CategoryModel>.generate(
        keys.length,
        (i) => CategoryModel(
          id: '${i + 1}',
          name: keys[i],
          image: AppImages.categoryCatalogJpeg(keys[i]),
        ),
      );
    })(),
  ];

  final RxList<MarketplaceProductModel> mpProducts =
      <MarketplaceProductModel>[].obs;

  final RxList<AdvanceBookingProductModel> abProducts =
      <AdvanceBookingProductModel>[].obs;

  final RxList<LiveAuctionProductModel> laProducts =
      <LiveAuctionProductModel>[].obs;

  final RxList<MarketplaceProductModel> _cachedMp =
      <MarketplaceProductModel>[].obs;
  final RxList<AdvanceBookingProductModel> _cachedAb =
      <AdvanceBookingProductModel>[].obs;
  final RxList<LiveAuctionProductModel> _cachedLa =
      <LiveAuctionProductModel>[].obs;

  List<MarketplaceProductModel> get filteredMp => _cachedMp;
  List<AdvanceBookingProductModel> get filteredAb => _cachedAb;
  List<LiveAuctionProductModel> get filteredLa => _cachedLa;
  /// True if Marketplace, Advance Booking, or Live Auctions has at least one product.
  bool get hasAnyProduct =>
      mpProducts.isNotEmpty || abProducts.isNotEmpty || laProducts.isNotEmpty;

  ProductModel? getProductById(String id) {
    for (final p in _storedProducts) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<ProductModel> snapshotProducts() =>
      List<ProductModel>.from(_storedProducts);

  List<InventoryModel> snapshotInventory() =>
      List<InventoryModel>.from(_storedInventory);

  void upsertPublishedProduct({
    required ProductModel product,
    required InventoryModel inventory,
  }) {
    final pi = _storedProducts.indexWhere((p) => p.id == product.id);
    if (pi >= 0) {
      _storedProducts[pi] = product;
    } else {
      _storedProducts.add(product);
    }
    final ii = _storedInventory.indexWhere((i) =>
        i.productId == inventory.productId &&
        i.sellerId == inventory.sellerId);
    if (ii >= 0) {
      _storedInventory[ii] =
          inventory.copyWith(id: _storedInventory[ii].id);
    } else {
      _storedInventory.add(inventory);
    }
    _syncProductLists(
      List<ProductModel>.from(_storedProducts),
      List<InventoryModel>.from(_storedInventory),
    );
  }

  void upsertInventoryRow(InventoryModel inv) {
    final ii = _storedInventory.indexWhere((i) =>
        i.productId == inv.productId && i.sellerId == inv.sellerId);
    if (ii >= 0) {
      _storedInventory[ii] =
          inv.copyWith(id: _storedInventory[ii].id);
    } else {
      _storedInventory.add(inv);
    }
    _syncProductLists(
      List<ProductModel>.from(_storedProducts),
      List<InventoryModel>.from(_storedInventory),
    );
  }

  void removeProductAndInventory(String productId) {
    _storedProducts.removeWhere((p) => p.id == productId);
    _storedInventory.removeWhere((i) => i.productId == productId);
    _syncProductLists(
      List<ProductModel>.from(_storedProducts),
      List<InventoryModel>.from(_storedInventory),
    );
  }

  void applySoldDelta(String productId, double qty) {
    final idx = _storedInventory.indexWhere((i) => i.productId == productId);
    if (idx < 0) throw StateError('Inventory not found');
    final inv = _storedInventory[idx];
    final newSold = inv.sold + qty;
    if (newSold > inv.stockQty) throw StateError('Cannot oversell inventory');
    final newRemaining = inv.stockQty - newSold;
    _storedInventory[idx] = inv.copyWith(
      sold: newSold,
      remaining: newRemaining,
      updatedAt: DateTime.now(),
    );
    final pi = _storedProducts.indexWhere((p) => p.id == productId);
    if (pi >= 0) {
      final p = _storedProducts[pi];
      _storedProducts[pi] = p.copyWith(
        stock: newRemaining.round().clamp(0, 1 << 30),
      );
    }
    _syncProductLists(
      List<ProductModel>.from(_storedProducts),
      List<InventoryModel>.from(_storedInventory),
    );
  }

  void _ensureSeedData() {
    if (_storedProducts.isNotEmpty) return;
    final now = DateTime.now();
    void addPair(ProductModel p, InventoryModel inv) {
      _storedProducts.add(p);
      _storedInventory.add(inv);
    }

    addPair(
      ProductModel(
        id: 'seed-mp-1',
        name: 'Basmati Rice',
        description: 'Premium long grain',
        images: [AppImages.p1],
        category: 'Grains & Cereals',
        sellerId: fakeSellerId,
        sellerName: 'Demo Seller',
        createdAt: now.subtract(const Duration(days: 2)),
        status: ProductStatus.active,
        productType: ProductType.marketplace,
        location: 'Lahore, Punjab, Pakistan',
        origin: 'Pakistan',
        specifications: const {},
        grade: 'A',
        currency: 'PKR',
        variety: '1121',
        price: 120,
        unit: 'Ton',
        stock: 40,
        country: 'Pakistan',
        state: 'Punjab',
        city: 'Lahore',
      ),
      InventoryModel(
        id: 'inv-seed-mp-1',
        productId: 'seed-mp-1',
        sellerId: fakeSellerId,
        productName: 'Basmati Rice',
        stockQty: 40,
        unit: 'Ton',
        updatedAt: now,
        listingType: ProductType.marketplace,
        imageUrl: AppImages.p1,
        imageUrls: [AppImages.p1],
        category: 'Grains & Cereals',
        sold: 5,
        remaining: 35,
        batchCode: 'B001',
      ),
    );

    addPair(
      ProductModel(
        id: 'seed-ab-1',
        name: 'Yellow Corn',
        description: 'Advance booking harvest',
        images: [AppImages.p2],
        category: 'Grains & Cereals',
        sellerId: fakeSellerId,
        sellerName: 'Demo Seller',
        createdAt: now.subtract(const Duration(days: 5)),
        status: ProductStatus.active,
        productType: ProductType.advanceBooking,
        location: 'Karachi, Sindh, Pakistan',
        origin: 'Pakistan',
        specifications: const {'harvestDate': '2026-06-01'},
        grade: 'A',
        currency: 'PKR',
        variety: 'Hybrid',
        price: 85,
        unit: 'Ton',
        stock: 100,
        country: 'Pakistan',
        state: 'Sindh',
        city: 'Karachi',
      ),
      InventoryModel(
        id: 'inv-seed-ab-1',
        productId: 'seed-ab-1',
        sellerId: fakeSellerId,
        productName: 'Yellow Corn',
        stockQty: 100,
        unit: 'Ton',
        updatedAt: now,
        listingType: ProductType.advanceBooking,
        imageUrl: AppImages.p2,
        imageUrls: [AppImages.p2],
        category: 'Grains & Cereals',
        sold: 20,
        remaining: 80,
        batchCode: 'B002',
      ),
    );

    addPair(
      ProductModel(
        id: 'seed-la-1',
        name: 'Organic Wheat',
        description: 'Live auction lot',
        images: [AppImages.p3],
        category: 'Grains & Cereals',
        sellerId: fakeSellerId,
        sellerName: 'Demo Seller',
        createdAt: now.subtract(const Duration(days: 1)),
        status: ProductStatus.active,
        productType: ProductType.liveAuction,
        location: 'Islamabad, Pakistan',
        origin: 'Pakistan',
        specifications: {
          'startingBid': '500',
          'auctionEnd': now.add(const Duration(days: 3)).toIso8601String(),
          'totalBids': '8',
        },
        grade: 'A+',
        currency: 'PKR',
        variety: 'Local',
        price: 900,
        unit: 'Ton',
        stock: 25,
        country: 'Pakistan',
        state: 'Federal',
        city: 'Islamabad',
      ),
      InventoryModel(
        id: 'inv-seed-la-1',
        productId: 'seed-la-1',
        sellerId: fakeSellerId,
        productName: 'Organic Wheat',
        stockQty: 25,
        unit: 'Ton',
        updatedAt: now,
        listingType: ProductType.liveAuction,
        imageUrl: AppImages.p3,
        imageUrls: [AppImages.p3],
        category: 'Grains & Cereals',
        sold: 2,
        remaining: 23,
        batchCode: 'B003',
      ),
    );
  }

  void _syncProductLists(
    List<ProductModel> products,
    List<InventoryModel> inventoryRows,
  ) {
    soldQtyMap.clear();
    bookedQtyMap.clear();
    final mine = List<ProductModel>.from(products)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (final inv in inventoryRows) {
      soldQtyMap[inv.productId] = inv.sold;
      bookedQtyMap[inv.productId] = inv.sold;
    }
    final mp = <MarketplaceProductModel>[];
    final ab = <AdvanceBookingProductModel>[];
    final la = <LiveAuctionProductModel>[];
    for (final p in mine) {
      switch (p.productType) {
        case ProductType.marketplace:
          mp.add(MarketplaceProductModel.fromProductModel(p));
          break;
        case ProductType.advanceBooking:
        case ProductType.booking:
          ab.add(AdvanceBookingProductModel.fromProductModel(p));
          break;
        case ProductType.liveAuction:
        case ProductType.auction:
          la.add(LiveAuctionProductModel.fromProductModel(p));
          break;
      }
    }
    mpProducts.assignAll(mp);
    abProducts.assignAll(ab);
    laProducts.assignAll(la);
    _recomputeAll();
  }

  Future<void> refreshNow() async {
    _syncProductLists(
      List<ProductModel>.from(_storedProducts),
      List<InventoryModel>.from(_storedInventory),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _ensureSeedData();
    _syncProductLists(
      List<ProductModel>.from(_storedProducts),
      List<InventoryModel>.from(_storedInventory),
    );
    debounce(searchQuery, (_) => _recomputeAll(),
        time: const Duration(milliseconds: 300));

    ever(mpFilter, (_) => _recomputeMp());
    ever(abFilter, (_) => _recomputeAb());
    ever(laFilter, (_) => _recomputeLa());
    ever(mpSort, (_) => _recomputeMp());
    ever(abSort, (_) => _recomputeAb());
    ever(laSort, (_) => _recomputeLa());
    ever(selectedCategoryIndex, (_) => _recomputeAll());
    ever(activeTab, (_) => _recomputeAll());
    ever(mpProducts, (_) => _recomputeMp());
    ever(abProducts, (_) => _recomputeAb());
    ever(laProducts, (_) => _recomputeLa());
    _bootstrapLoading();
  }

  Future<void> _bootstrapLoading() async {
    isBackendLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 180));
    isBackendLoading.value = false;
  }

  void _recomputeAll() {
    _recomputeMp();
    _recomputeAb();
    _recomputeLa();
  }

  void _recomputeMp() {
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
      case MarketplaceFilter.all:
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
    _cachedMp.assignAll(list);
  }

  void _recomputeAb() {
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
      case AdvanceBookingFilter2.all:
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
    _cachedAb.assignAll(list);
  }

  void _recomputeLa() {
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
      case LiveAuctionFilter2.all:
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
    _cachedLa.assignAll(list);
  }

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
    final remaining = p.auctionEndTime.difference(DateTime.now());
    return !remaining.isNegative && remaining.inMinutes <= 60;
  }

  String laTimerText(LiveAuctionProductModel p) {
    final remaining = p.auctionEndTime.difference(DateTime.now());
    if (remaining.isNegative) return 'Ended';
    final h = remaining.inHours.toString().padLeft(2, '0');
    final m = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

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
    if (selectedCategoryIndex.value < categories.length - 1) {
      selectCategory(selectedCategoryIndex.value + 1);
    }
  }

  void scrollCategoryPrev() {
    if (selectedCategoryIndex.value > 0) {
      selectCategory(selectedCategoryIndex.value - 1);
    }
  }

  void deleteMp(String id) {
    removeProductAndInventory(id);
  }

  void deleteAb(String id) {
    removeProductAndInventory(id);
  }

  void deleteLa(String id) {
    removeProductAndInventory(id);
  }
  void openCreateProduct() {
    Get.toNamed(AppRoutes.productForm);
  }

  void editProduct(String id) {
    final form = Get.isRegistered<AddNewProductCon>()
        ? Get.find<AddNewProductCon>()
        : Get.put(AddNewProductCon(), permanent: true);
    form.openForEdit(id);
    Get.to(() => ProductFormScreen());
  }

  void openMarketplaceDetail(MarketplaceProductModel p) {
    final detail = p.toProductModel();
    Get.to(
      () => ProductDetailScreen(
        productModel: detail,
        isSeller: true,
      ),
    );
  }

  void openAdvanceBookingDetail(AdvanceBookingProductModel p) {
    Get.to(
      () => ProductDetailScreen(
        productModel: p.toProductModel(),
        isSeller: true,
      ),
    );
  }

  void openLiveAuctionDetail(LiveAuctionProductModel p) {
    Get.to(
      () => ProductDetailScreen(
        productModel: p.toProductModel(),
        isSeller: true,
      ),
    );
  }

  final RxBool isBackendLoading = false.obs;

  /// Grid card hover (single key: `mp_<id>`, `ab_<id>`, `la_<id>`).
  final hoveredGridCardKey = Rxn<String>();

  /// List table row hover per tab (debounced clear on exit).
  final mpHoverRow = Rxn<int>();
  final abHoverRow = Rxn<int>();
  final laHoverRow = Rxn<int>();
  Timer? _mpHoverTimer;
  Timer? _abHoverTimer;
  Timer? _laHoverTimer;

  void onMpTableRowEnter(int row) {
    _mpHoverTimer?.cancel();
    mpHoverRow.value = row;
  }

  void onMpTableRowExit(int row) {
    _mpHoverTimer?.cancel();
    _mpHoverTimer = Timer(const Duration(milliseconds: 80), () {
      if (mpHoverRow.value == row) mpHoverRow.value = null;
    });
  }

  void onAbTableRowEnter(int row) {
    _abHoverTimer?.cancel();
    abHoverRow.value = row;
  }

  void onAbTableRowExit(int row) {
    _abHoverTimer?.cancel();
    _abHoverTimer = Timer(const Duration(milliseconds: 80), () {
      if (abHoverRow.value == row) abHoverRow.value = null;
    });
  }

  void onLaTableRowEnter(int row) {
    _laHoverTimer?.cancel();
    laHoverRow.value = row;
  }

  void onLaTableRowExit(int row) {
    _laHoverTimer?.cancel();
    _laHoverTimer = Timer(const Duration(milliseconds: 80), () {
      if (laHoverRow.value == row) laHoverRow.value = null;
    });
  }

  @override
  void onClose() {
    _mpHoverTimer?.cancel();
    _abHoverTimer?.cancel();
    _laHoverTimer?.cancel();
    searchController.dispose();
    categoryScrollController.dispose();
    super.onClose();
  }
}
