import 'package:agri_market/data/models/product_type_enums.dart';

abstract class BaseProductModel {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final String sellerId;
  final String sellerName;
  final DateTime createdAt;
  final ProductStatus? status;
  final ProductType productType;
  final String location;
  final String origin;
  final Map<String, String> specifications;
  final String grade;
  final String currency;
  final String variety;
  final double? minOrderQty;
  final double? price;
  final String unit;
  final int stock;

  BaseProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.createdAt,
    this.status,
    required this.productType,
    required this.location,
    required this.origin,
    required this.specifications,
    required this.grade,
    required this.currency,
    required this.variety,
    this.minOrderQty,
    this.price,
    required this.unit,
    required this.stock,
  });
}
