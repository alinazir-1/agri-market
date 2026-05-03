import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/data/models/base_product_model.dart';
import 'package:agri_market/data/models/product_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';

class LiveAuctionProductModel extends BaseProductModel {
  final double startingBid;
  final double currentBid;
  final DateTime auctionEndTime;
  final int totalBids;

  LiveAuctionProductModel({
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
    super.price,
    required super.unit,
    required super.location,
    required super.origin,
    required super.specifications,
    required super.currency,
    required super.variety,
    super.minOrderQty,
    required super.stock,
    required this.startingBid,
    required this.currentBid,
    required this.auctionEndTime,
    required this.totalBids,
  }) : super(productType: ProductType.liveAuction);

  LiveAuctionProductModel copyWith({
    double? currentBid,
    int? totalBids,
  }) {
    return LiveAuctionProductModel(
      id: id,
      name: name,
      description: description,
      images: images,
      category: category,
      grade: grade,
      sellerId: sellerId,
      sellerName: sellerName,
      createdAt: createdAt,
      status: status,
      price: price,
      unit: unit,
      location: location,
      origin: origin,
      specifications: specifications,
      currency: currency,
      variety: variety,
      minOrderQty: minOrderQty,
      stock: stock,
      startingBid: startingBid,
      currentBid: currentBid ?? this.currentBid,
      auctionEndTime: auctionEndTime,
      totalBids: totalBids ?? this.totalBids,
    );
  }

  factory LiveAuctionProductModel.fromProductModel(ProductModel p) {
    final endRaw = p.specifications['auctionEnd'];
    final end = endRaw != null
        ? DateTime.tryParse(endRaw) ??
            DateTime.now().add(const Duration(days: 7))
        : DateTime.now().add(const Duration(days: 7));
    final sb =
        double.tryParse(p.specifications['startingBid'] ?? '') ?? p.price ?? 0;
    return LiveAuctionProductModel(
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
      price: p.price,
      stock: p.stock,
      unit: p.unit,
      location: p.location,
      origin: p.origin,
      specifications: p.specifications,
      currency: p.currency,
      variety: p.variety,
      minOrderQty: p.minOrderQty,
      startingBid: sb,
      currentBid: sb,
      auctionEndTime: end,
      totalBids: int.tryParse(p.specifications['totalBids'] ?? '') ?? 0,
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
      price: price ?? startingBid,
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
