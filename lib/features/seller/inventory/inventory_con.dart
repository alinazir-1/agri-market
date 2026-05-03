import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/utils/product_image_storage.dart';
import 'package:agri_market/data/models/inventory_model.dart';
import 'package:agri_market/data/models/product_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/data/models/stock_batch_model.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/features/seller/products/my_products_con.dart';
class ActivityEntry {
  final String message;
  final String timeAgo;
  final ActivityType type;

  const ActivityEntry({
    required this.message,
    required this.timeAgo,
    required this.type,
  });
}

enum ActivityType { restock, outOfStock, lowStock, update, booking, sale }

enum InventoryFilter {
  all,
  marketplace,
  liveAuction,
  advanceBooking,
  lowStock,
  outOfStock
}

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String image;
  final String unit;

  /// When true, stock changes sync with in-memory seller catalog.
  final bool hiveLinked;

  final RxSet<ProductType> listedIn;
  final RxList<StockBatch> batches;
  final RxDouble soldMarketplace;
  final RxDouble soldAuction;
  final RxDouble soldBooking;
  final RxDouble sellingPrice;
  final RxBool isExpanded;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.unit,
    this.hiveLinked = false,
    List<StockBatch>? batches,
    Set<ProductType>? listedIn,
    double soldMarketplace = 0,
    double soldAuction = 0,
    double soldBooking = 0,
    double sellingPrice = 0,
  })  : batches = (batches ?? []).obs,
        listedIn = (listedIn ?? {}).obs,
        soldMarketplace = soldMarketplace.obs,
        soldAuction = soldAuction.obs,
        soldBooking = soldBooking.obs,
        sellingPrice = sellingPrice.obs,
        isExpanded = false.obs;

  double get totalInitialStock => batches.fold(0.0, (s, b) => s + b.initialQty);
  double get currentStock => batches.fold(0.0, (s, b) => s + b.currentQty);
  double get soldQty =>
      soldMarketplace.value + soldAuction.value + soldBooking.value;

  int get activeBatchCount => batches.where((b) => b.isActive).length;
  int get expiredBatchCount => batches.where((b) => b.isExpired).length;
  int get depletedBatchCount => batches.where((b) => b.isDepleted).length;

  String get topGrade {
    final active = batches.where((b) => b.isActive).toList();
    if (active.isEmpty) return batches.isNotEmpty ? batches.last.grade : 'N/A';
    const order = ['A+', 'A', 'B+', 'B', 'C'];
    for (final g in order) {
      if (active.any((b) => b.grade == g)) return g;
    }
    return active.first.grade;
  }

  bool get isOutOfStock => currentStock <= 0;
  bool get isLowStock =>
      !isOutOfStock &&
      totalInitialStock > 0 &&
      (currentStock / totalInitialStock) <= 0.2;
  bool get isHealthy => !isOutOfStock && !isLowStock;
  double get progressValue => totalInitialStock == 0
      ? 0
      : (soldQty / totalInitialStock).clamp(0.0, 1.0);
  double get totalSellingValue =>
      batches.fold(0.0, (s, b) => s + b.totalSellingValue);
  double get totalCostValue =>
      batches.fold(0.0, (s, b) => s + b.totalCostValue);
  bool get hasExpiringBatches =>
      batches.any((b) => b.isActive && b.isNearExpiry);
  bool get hasExpiredBatches => batches.any((b) => b.isExpired);
}

class InventoryCon extends GetxController {
  static const _uuid = Uuid();

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<InventoryFilter> selectedFilter = InventoryFilter.all.obs;

  final RxList<InventoryItem> items = <InventoryItem>[].obs;
  final RxList<ActivityEntry> activityLog = <ActivityEntry>[].obs;
  final RxList<StockMovement> allMovements = <StockMovement>[].obs;
  final RxBool isBackendLoading = false.obs;

  /// Per inventory row: `"$itemId|delete"` while running.
  final RxnString inventoryRowActionKey = RxnString();

  bool isInventoryRowActionLoading(String itemId, String slug) =>
      inventoryRowActionKey.value == '$itemId|$slug';

  Future<void> deleteItemWithLoading(String id) async {
    if (inventoryRowActionKey.value != null) return;
    inventoryRowActionKey.value = '$id|delete';
    try {
      await deleteItem(id);
    } finally {
      inventoryRowActionKey.value = null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    refreshNow();
  }

  void _syncFromBackend(
    List<InventoryModel> inventoryRows,
    List<ProductModel> products,
  ) {
    items.clear();
    final productMap = {for (final p in products) p.id: p};
    final rows = List<InventoryModel>.from(inventoryRows)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    for (final inv in rows) {
      final rem = (inv.stockQty - inv.sold).clamp(0.0, inv.stockQty);
      final sold = inv.stockQty - rem.toDouble();
      final invNorm = inv.copyWith(
        sold: sold.clamp(0.0, inv.stockQty),
        remaining: rem.toDouble(),
      );
      final product = productMap[inv.productId];
      items.add(_buildItemFromHive(invNorm, product));
    }
    items.refresh();
  }

  Future<void> refreshNow() async {
    if (!Get.isRegistered<MyProductsCon>()) return;
    final mp = Get.find<MyProductsCon>();
    _syncFromBackend(mp.snapshotInventory(), mp.snapshotProducts());
  }

  InventoryItem _buildItemFromHive(InventoryModel inv, ProductModel? product) {
    final raw = inv.imageUrls.isNotEmpty
        ? inv.imageUrls.first.trim()
        : (inv.imageUrl?.trim().isNotEmpty == true
            ? inv.imageUrl!.trim()
            : ProductImageStorage.firstOrEmpty(product?.images ?? []));
    final img = raw.isEmpty ? AppImages.p1 : raw;
    final price = product?.price ?? 0.0;
    final batch = StockBatch(
      id: inv.id,
      productId: inv.productId,
      productName: inv.productName,
      batchNumber: inv.batchCode.isEmpty ? 'BATCH' : inv.batchCode,
      supplierName: '',
      supplierContact: inv.supplierId ?? '',
      supplierLocation: '',
      purchaseDate: inv.updatedAt,
      initialQty: inv.stockQty,
      currentQty: inv.remaining,
      unit: inv.unit,
      costPerUnit: 0,
      sellingPrice: price,
      addedDate: inv.updatedAt,
      grade: product?.grade ?? 'A',
      qualityParams: const {},
      certifications: const [],
      storageCondition: '',
      storageLocation: '',
      source: _batchSource(inv.listingType),
    );
    double sm = 0, sa = 0, sb = 0;
    switch (inv.listingType) {
      case ProductType.marketplace:
        sm = inv.sold;
        break;
      case ProductType.liveAuction:
      case ProductType.auction:
        sa = inv.sold;
        break;
      case ProductType.advanceBooking:
      case ProductType.booking:
        sb = inv.sold;
        break;
    }
    return InventoryItem(
      id: inv.productId,
      name: inv.productName,
      category: inv.category.isEmpty ? (product?.category ?? '') : inv.category,
      image: img,
      unit: inv.unit,
      hiveLinked: true,
      listedIn: {inv.listingType},
      sellingPrice: price,
      soldMarketplace: sm,
      soldAuction: sa,
      soldBooking: sb,
      batches: [batch],
    );
  }

  BatchSource _batchSource(ProductType t) {
    switch (t) {
      case ProductType.marketplace:
        return BatchSource.marketplace;
      case ProductType.liveAuction:
      case ProductType.auction:
        return BatchSource.liveAuction;
      case ProductType.advanceBooking:
      case ProductType.booking:
        return BatchSource.advanceBooking;
    }
  }

  int get totalProducts => items.length;
  int get inStockCount => items.where((i) => i.isHealthy).length;
  int get lowStockCount => items.where((i) => i.isLowStock).length;
  int get outOfStockCount => items.where((i) => i.isOutOfStock).length;
  int get totalBatches => items.fold(0, (s, i) => s + i.batches.length);
  double get totalValue => items.fold(0.0, (s, i) => s + i.totalSellingValue);

  List<InventoryItem> get alerts {
    return items
        .where((i) =>
            i.isLowStock ||
            i.isOutOfStock ||
            i.hasExpiringBatches ||
            i.hasExpiredBatches)
        .toList()
      ..sort((a, b) {
        if (a.isOutOfStock && !b.isOutOfStock) return -1;
        if (!a.isOutOfStock && b.isOutOfStock) return 1;
        return 0;
      });
  }

  List<InventoryItem> get filteredItems {
    List<InventoryItem> list = List.from(items);
    switch (selectedFilter.value) {
      case InventoryFilter.marketplace:
        list = list
            .where((i) => i.listedIn.contains(ProductType.marketplace))
            .toList();
        break;
      case InventoryFilter.liveAuction:
        list = list
            .where((i) => i.listedIn.contains(ProductType.liveAuction))
            .toList();
        break;
      case InventoryFilter.advanceBooking:
        list = list
            .where((i) => i.listedIn.contains(ProductType.advanceBooking))
            .toList();
        break;
      case InventoryFilter.lowStock:
        list = list.where((i) => i.isLowStock).toList();
        break;
      case InventoryFilter.outOfStock:
        list = list.where((i) => i.isOutOfStock).toList();
        break;
      case InventoryFilter.all:
        break;
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((i) =>
              i.name.toLowerCase().contains(q) ||
              i.category.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void setFilter(InventoryFilter f) => selectedFilter.value = f;
  void onSearch(String val) => searchQuery.value = val;
  void toggleExpanded(String id) {
    final item = items.firstWhereOrNull((i) => i.id == id);
    if (item != null) item.isExpanded.value = !item.isExpanded.value;
  }

  void addBatch(String itemId, StockBatch batch) {
    final idx = items.indexWhere((i) => i.id == itemId);
    if (idx == -1) return;

    items[idx].batches.add(batch);
    allMovements.insert(
        0,
        StockMovement(
            id: _uuid.v4(),
            batchId: batch.id,
            batchNumber: batch.batchNumber,
            productId: itemId,
            productName: items[idx].name,
            type: MovementType.addition,
            quantity: batch.initialQty,
            pricePerUnit: batch.costPerUnit,
            timestamp: DateTime.now(),
            note: 'Batch added: ${batch.batchNumber}'));
    activityLog.insert(
        0,
        ActivityEntry(
            message:
                '${items[idx].name} · ${batch.batchNumber} added +${batch.initialQty.toStringAsFixed(0)} ${batch.unit}',
            timeAgo: 'Just now',
            type: ActivityType.restock));
    items.refresh();
  }

  Future<bool> sellFromBatch(
      {required String itemId,
      required String batchId,
      required double qty,
      required MovementType movementType,
      required double pricePerUnit,
      String? orderId}) async {
    final itemIdx = items.indexWhere((i) => i.id == itemId);
    if (itemIdx == -1) return false;
    final item = items[itemIdx];

    final bIndex = item.batches.indexWhere((b) => b.id == batchId);
    if (bIndex == -1) return false;

    final oldBatch = item.batches[bIndex];
    if (qty > oldBatch.currentQty) return false;

    if (item.hiveLinked) {
      try {
        if (Get.isRegistered<MyProductsCon>()) {
          Get.find<MyProductsCon>().applySoldDelta(itemId, qty);
        }
        await refreshNow();
      } catch (e) {
        Get.snackbar(
          'Stock update failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.badgeErrorBg,
          colorText: AppColors.badgeErrorText,
        );
        return false;
      }

      final mov = StockMovement(
          id: _uuid.v4(),
          batchId: batchId,
          batchNumber: oldBatch.batchNumber,
          productId: itemId,
          productName: item.name,
          type: movementType,
          quantity: qty,
          pricePerUnit: pricePerUnit,
          timestamp: DateTime.now(),
          orderId: orderId);
      allMovements.insert(0, mov);
      activityLog.insert(
          0,
          ActivityEntry(
              message:
                  '${item.name} sold ${qty.toStringAsFixed(0)} ${item.unit} via ${mov.typeLabel}',
              timeAgo: 'Just now',
              type: ActivityType.sale));

      final refreshed = items.firstWhereOrNull((i) => i.id == itemId);
      if (refreshed != null) {
        if (refreshed.isOutOfStock) {
          activityLog.insert(
              0,
              ActivityEntry(
                  message: '${refreshed.name} is now out of stock',
                  timeAgo: 'Just now',
                  type: ActivityType.outOfStock));
        } else if (refreshed.isLowStock) {
          activityLog.insert(
              0,
              ActivityEntry(
                  message: '${refreshed.name} reached low stock threshold',
                  timeAgo: 'Just now',
                  type: ActivityType.lowStock));
        }
      }
      return true;
    }

    item.batches[bIndex] =
        oldBatch.copyWith(currentQty: oldBatch.currentQty - qty);

    switch (movementType) {
      case MovementType.saleMarketplace:
        item.soldMarketplace.value += qty;
        break;
      case MovementType.saleAuction:
        item.soldAuction.value += qty;
        break;
      case MovementType.saleBooking:
        item.soldBooking.value += qty;
        break;
      default:
        break;
    }

    final mov = StockMovement(
        id: _uuid.v4(),
        batchId: batchId,
        batchNumber: oldBatch.batchNumber,
        productId: itemId,
        productName: item.name,
        type: movementType,
        quantity: qty,
        pricePerUnit: pricePerUnit,
        timestamp: DateTime.now(),
        orderId: orderId);
    allMovements.insert(0, mov);
    activityLog.insert(
        0,
        ActivityEntry(
            message:
                '${item.name} sold ${qty.toStringAsFixed(0)} ${item.unit} via ${mov.typeLabel}',
            timeAgo: 'Just now',
            type: ActivityType.sale));

    if (item.isOutOfStock) {
      activityLog.insert(
          0,
          ActivityEntry(
              message: '${item.name} is now out of stock',
              timeAgo: 'Just now',
              type: ActivityType.outOfStock));
    } else if (item.isLowStock) {
      activityLog.insert(
          0,
          ActivityEntry(
              message: '${item.name} reached low stock threshold',
              timeAgo: 'Just now',
              type: ActivityType.lowStock));
    }

    items.refresh();
    return true;
  }

  void addProductToInventory(
      {required String name,
      required String category,
      required String image,
      required String unit,
      required ProductType listingType,
      required StockBatch initialBatch,
      double sellingPrice = 0}) {
    final existing = items.firstWhereOrNull(
          (i) => i.id == initialBatch.productId,
        ) ??
        items.firstWhereOrNull((i) => i.name.toLowerCase() == name.toLowerCase());

    if (existing != null) {
      existing.listedIn.add(listingType);
      existing.batches.add(initialBatch);
      activityLog.insert(
          0,
          ActivityEntry(
              message:
                  '${existing.name} linked to new ${_channelName(listingType)} listing · ${initialBatch.batchNumber}',
              timeAgo: 'Just now',
              type: ActivityType.restock));
    } else {
      final newItem = InventoryItem(
          // Keep inventory item keyed by productId so publish/inventory linkage stays stable.
          id: initialBatch.productId,
          name: name,
          category: category,
          image: image,
          unit: unit,
          listedIn: {listingType},
          sellingPrice: sellingPrice);
      newItem.batches.add(initialBatch);
      items.add(newItem);
      activityLog.insert(
          0,
          ActivityEntry(
              message:
                  'New product added to inventory: $name · ${initialBatch.batchNumber}',
              timeAgo: 'Just now',
              type: ActivityType.update));
    }
  }

  Future<void> deleteItem(String id) async {
    final row = items.firstWhereOrNull((i) => i.id == id);
    if (row?.hiveLinked == true) {
      if (Get.isRegistered<MyProductsCon>()) {
        Get.find<MyProductsCon>().removeProductAndInventory(id);
      }
      await refreshNow();
      return;
    }
    items.removeWhere((i) => i.id == id);
  }

  String _channelName(ProductType type) {
    switch (type) {
      case ProductType.marketplace:
        return 'Marketplace';
      case ProductType.liveAuction:
        return 'Live Auction';
      case ProductType.advanceBooking:
        return 'Advance Booking';
      default:
        return 'Listing';
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
