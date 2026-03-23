import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/images.dart';
import '../../../Data/Models/product_type_enums.dart';

// ── Inventory Item Model (lightweight — no inheritance needed) ────────────────

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String image;
  final String grade;
  final ProductType productType;
  final ProductStatus status;
  final String unit;
  final double price;
  final int totalStock;
  final RxInt currentStock;
  final RxDouble soldQty;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.grade,
    required this.productType,
    required this.status,
    required this.unit,
    required this.price,
    required this.totalStock,
    required int currentStock,
    required double soldQty,
  })  : currentStock = currentStock.obs,
        soldQty = soldQty.obs;

  double get progressValue =>
      totalStock == 0 ? 0 : (soldQty.value / totalStock).clamp(0.0, 1.0);

  bool get isOutOfStock => currentStock.value == 0;
  bool get isLowStock => !isOutOfStock && progressValue >= 0.8;
  bool get isHealthy => !isOutOfStock && !isLowStock;

  double get totalValue => price * currentStock.value;
}

// ── Activity Log Entry ────────────────────────────────────────────────────────

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

enum ActivityType { restock, outOfStock, lowStock, update, booking }

// ── Stock Filter ──────────────────────────────────────────────────────────────

enum InventoryFilter {
  all,
  marketplace,
  liveAuction,
  advanceBooking,
  lowStock,
  outOfStock
}

// ── Controller ───────────────────────────────────────────────────────────────

class InventoryCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<InventoryFilter> selectedFilter = InventoryFilter.all.obs;

  // ── Restock dialog state ──────────────────────────────────────────────────
  final TextEditingController restockController = TextEditingController();

  // ── Inventory Data ────────────────────────────────────────────────────────
  final RxList<InventoryItem> items = <InventoryItem>[
    InventoryItem(
      id: '1',
      name: 'Sella Basmati Rice',
      category: 'Grains & Cereals',
      image: CImages.p1,
      grade: 'A',
      productType: ProductType.marketplace,
      status: ProductStatus.active,
      unit: 'Ton',
      price: 148,
      totalStock: 1200,
      currentStock: 900,
      soldQty: 270,
    ),
    InventoryItem(
      id: '2',
      name: 'Desiree Potato',
      category: 'Grains & Cereals',
      image: CImages.p2,
      grade: 'C',
      productType: ProductType.liveAuction,
      status: ProductStatus.active,
      unit: 'Ton',
      price: 95,
      totalStock: 1000,
      currentStock: 180,
      soldQty: 820,
    ),
    InventoryItem(
      id: '3',
      name: 'Fresh Mangoes',
      category: 'Fresh Produce',
      image: CImages.p3,
      grade: 'A+',
      productType: ProductType.advanceBooking,
      status: ProductStatus.active,
      unit: 'box',
      price: 60,
      totalStock: 200,
      currentStock: 156,
      soldQty: 44,
    ),
    InventoryItem(
      id: '4',
      name: 'Apple',
      category: 'Fresh Produce',
      image: CImages.p4,
      grade: 'A',
      productType: ProductType.marketplace,
      status: ProductStatus.active,
      unit: 'Ton',
      price: 148,
      totalStock: 1000,
      currentStock: 0,
      soldQty: 1000,
    ),
    InventoryItem(
      id: '5',
      name: 'Premium Soybean',
      category: 'Oil Seeds',
      image: CImages.p5,
      grade: 'A',
      productType: ProductType.liveAuction,
      status: ProductStatus.active,
      unit: 'Ton',
      price: 148,
      totalStock: 1000,
      currentStock: 500,
      soldQty: 500,
    ),
    InventoryItem(
      id: '6',
      name: 'Diamond Potato',
      category: 'Grains & Cereals',
      image: CImages.p6,
      grade: 'B',
      productType: ProductType.marketplace,
      status: ProductStatus.active,
      unit: 'box',
      price: 60,
      totalStock: 1000,
      currentStock: 220,
      soldQty: 300,
    ),
  ].obs;

  // ── Activity Log ──────────────────────────────────────────────────────────
  final RxList<ActivityEntry> activityLog = <ActivityEntry>[
    ActivityEntry(
        message: 'Sella Basmati Rice restocked +200 Ton',
        timeAgo: '2 hours ago',
        type: ActivityType.restock),
    ActivityEntry(
        message: 'Apple went out of stock',
        timeAgo: '5 hours ago',
        type: ActivityType.outOfStock),
    ActivityEntry(
        message: 'Desiree Potato reached low stock threshold',
        timeAgo: 'Yesterday',
        type: ActivityType.lowStock),
    ActivityEntry(
        message: 'Premium Soybean stock updated',
        timeAgo: 'Yesterday',
        type: ActivityType.update),
    ActivityEntry(
        message: 'Fresh Mangoes booking confirmed 44 box',
        timeAgo: '2 days ago',
        type: ActivityType.booking),
  ].obs;

  // ── Computed Stats ────────────────────────────────────────────────────────

  int get totalProducts => items.length;
  int get inStockCount => items.where((i) => i.isHealthy).length;
  int get lowStockCount => items.where((i) => i.isLowStock).length;
  int get outOfStockCount => items.where((i) => i.isOutOfStock).length;
  double get totalValue => items.fold(0.0, (sum, i) => sum + i.totalValue);

  List<InventoryItem> get alerts =>
      items.where((i) => i.isLowStock || i.isOutOfStock).toList()
        ..sort((a, b) => a.isOutOfStock ? -1 : 1);

  // ── Filtered Items ────────────────────────────────────────────────────────

  List<InventoryItem> get filteredItems {
    List<InventoryItem> list = List.from(items);

    switch (selectedFilter.value) {
      case InventoryFilter.marketplace:
        list = list
            .where((i) => i.productType == ProductType.marketplace)
            .toList();
        break;
      case InventoryFilter.liveAuction:
        list = list
            .where((i) => i.productType == ProductType.liveAuction)
            .toList();
        break;
      case InventoryFilter.advanceBooking:
        list = list
            .where((i) => i.productType == ProductType.advanceBooking)
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

  // ── Actions ───────────────────────────────────────────────────────────────

  void setFilter(InventoryFilter f) => selectedFilter.value = f;
  void onSearch(String val) => searchQuery.value = val;

  void restockItem(String id) {
    final qty = int.tryParse(restockController.text.trim());
    if (qty == null || qty <= 0) return;
    final i = items.indexWhere((item) => item.id == id);
    if (i == -1) return;
    items[i].currentStock.value += qty;
    activityLog.insert(
        0,
        ActivityEntry(
          message: '${items[i].name} restocked +$qty ${items[i].unit}',
          timeAgo: 'Just now',
          type: ActivityType.restock,
        ));
    restockController.clear();
  }

  void deleteItem(String id) {
    items.removeWhere((i) => i.id == id);
  }

  void editItem(InventoryItem item) {
    // navigate to edit screen
  }

  @override
  void onClose() {
    searchController.dispose();
    restockController.dispose();
    super.onClose();
  }
}
