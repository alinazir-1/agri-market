import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/data/models/base_product_model.dart';
import 'package:agri_market/data/models/product_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';

class MarketplaceProductModel extends BaseProductModel {
  MarketplaceProductModel({
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
  }) : super(productType: ProductType.marketplace);

  factory MarketplaceProductModel.fromProductModel(ProductModel p) {
    return MarketplaceProductModel(
      id: p.id,
      name: p.name,
      description: p.description,
      images: p.images.isEmpty ? [AppImages.p1] : p.images,
      category: p.category,
      grade: p.grade,
      sellerId: p.sellerId,
      sellerName: p.sellerName,
      createdAt: p.createdAt,
      status: p.status,
      price: p.price ?? 0,
      stock: p.stock,
      unit: p.unit,
      location: p.location,
      origin: p.origin,
      specifications: p.specifications,
      currency: p.currency,
      variety: p.variety,
      minOrderQty: p.minOrderQty,
    );
  }

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      images: images,
      category: category,
      sellerId: sellerId,
      sellerName: sellerName,
      createdAt: createdAt,
      status: status,
      productType: productType,
      location: location,
      origin: origin,
      specifications: specifications,
      grade: grade,
      currency: currency,
      variety: variety,
      minOrderQty: minOrderQty,
      price: price,
      unit: unit,
      stock: stock,
      listingType: productType.name,
      subCategory: '',
      country: '',
      state: '',
      city: '',
      tierPrices: const [],
    );
  }
}
