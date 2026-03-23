import 'package:agri_market/Data/Models/product_type_enums.dart';

import 'base_product_model.dart';

class AdvanceBookingProductModel extends BaseProductModel {
  final String harvestDate;
  final double bookingPrice;
  final double totalEstimatedPrice;

  AdvanceBookingProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.images,
    required super.category,
    required super.grade,
    required super.sellerId,
    required super.sellerName,
    required super.createdAt,
    super.status,
    required super.price,
    required super.unit,
    required super.location,
    required super.origin,
    required super.specifications,
    required super.currency,
    required super.variety,
    required super.minOrderQty,
    required super.stock,
    required this.harvestDate,
    required this.bookingPrice,
    required this.totalEstimatedPrice,
  }) : super(productType: ProductType.advanceBooking);

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      'harvestDate': harvestDate,
      'bookingPrice': bookingPrice,
      'totalEstimatedPrice': totalEstimatedPrice,
    });
    return map;
  }

  factory AdvanceBookingProductModel.fromJson(Map<String, dynamic> json) {
    return AdvanceBookingProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      category: json['category'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      createdAt: DateTime.parse(json['createdAt']),
      status: ProductStatus.fromString(json['status']),
      price: (json['price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? 0),
      unit: json['unit'],
      location: json['location'],
      origin: json['origin'],
      grade: json['grade'],
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      currency: json['currency'],
      variety: json['variety'],
      minOrderQty: (json['minOrderQty'] ?? 0.0).toDouble(),
      harvestDate: (json['harvestDate']),
      bookingPrice: (json['bookingPrice'] ?? 0.0).toDouble(),
      totalEstimatedPrice: (json['totalEstimatedPrice'] ?? 0.0).toDouble(),
    );
  }
}
