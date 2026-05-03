// lib/data/models/product_model.dart

import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/data/models/tier_price_model.dart';

class ProductModel {
  String id;
  String name;
  String description;
  List<String> images;
  String category;
  String sellerId;
  String sellerName;
  DateTime createdAt;
  ProductStatus? status;
  ProductType productType;
  String location;
  String origin;
  Map<String, String> specifications;
  String grade;
  String currency;
  String variety;
  double? minOrderQty;
  double? price;
  String unit;
  int stock;
  String listingType;
  String subCategory;
  final String country;
  final String state;
  final String city;
  final List<TierPriceModel> tierPrices;

  ProductModel({
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
    this.listingType = 'marketplace',
    this.subCategory = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.tierPrices = const <TierPriceModel>[],
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    String? category,
    String? sellerId,
    String? sellerName,
    DateTime? createdAt,
    ProductStatus? status,
    ProductType? productType,
    String? location,
    String? origin,
    Map<String, String>? specifications,
    String? grade,
    String? currency,
    String? variety,
    double? minOrderQty,
    double? price,
    String? unit,
    int? stock,
    String? listingType,
    String? subCategory,
    String? country,
    String? state,
    String? city,
    List<TierPriceModel>? tierPrices,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      productType: productType ?? this.productType,
      location: location ?? this.location,
      origin: origin ?? this.origin,
      specifications: specifications ?? this.specifications,
      grade: grade ?? this.grade,
      currency: currency ?? this.currency,
      variety: variety ?? this.variety,
      minOrderQty: minOrderQty ?? this.minOrderQty,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      listingType: listingType ?? this.listingType,
      subCategory: subCategory ?? this.subCategory,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      tierPrices: tierPrices ?? this.tierPrices,
    );
  }
}
