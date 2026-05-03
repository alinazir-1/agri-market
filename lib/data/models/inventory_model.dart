// lib/data/models/inventory_model.dart

import 'package:agri_market/data/models/product_type_enums.dart';

class InventoryModel {
  String id;
  String productId;
  String sellerId;
  String productName;
  double stockQty;
  String unit;
  DateTime updatedAt;
  ProductType listingType;
  String? imageUrl;
  List<String> imageUrls;
  String category;
  double sold;
  double remaining;
  String batchCode;
  String? supplierId;

  InventoryModel({
    required this.id,
    required this.productId,
    required this.sellerId,
    required this.productName,
    required this.stockQty,
    required this.unit,
    required this.updatedAt,
    required this.listingType,
    this.imageUrl,
    this.imageUrls = const [],
    this.category = '',
    this.sold = 0,
    required this.remaining,
    this.batchCode = '',
    this.supplierId,
  });

  InventoryModel copyWith({
    String? id,
    String? productId,
    String? sellerId,
    String? productName,
    double? stockQty,
    String? unit,
    DateTime? updatedAt,
    ProductType? listingType,
    String? imageUrl,
    List<String>? imageUrls,
    String? category,
    double? sold,
    double? remaining,
    String? batchCode,
    String? supplierId,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sellerId: sellerId ?? this.sellerId,
      productName: productName ?? this.productName,
      stockQty: stockQty ?? this.stockQty,
      unit: unit ?? this.unit,
      updatedAt: updatedAt ?? this.updatedAt,
      listingType: listingType ?? this.listingType,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      sold: sold ?? this.sold,
      remaining: remaining ?? this.remaining,
      batchCode: batchCode ?? this.batchCode,
      supplierId: supplierId ?? this.supplierId,
    );
  }
}
