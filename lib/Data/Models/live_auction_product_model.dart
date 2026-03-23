import 'package:agri_market/Data/Models/product_type_enums.dart';

import 'base_product_model.dart';

class LiveAuctionProductModel extends BaseProductModel {
  final double startingBid;
  double currentBid;
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
    required super.status,
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

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      'startingBid': startingBid,
      'currentBid': currentBid,
      'auctionEndTime': auctionEndTime.toIso8601String(),
      'totalBids': totalBids,
    });
    return map;
  }

  factory LiveAuctionProductModel.fromJson(Map<String, dynamic> json) {
    return LiveAuctionProductModel(
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
      startingBid: (json['startingBid'] ?? 0.0).toDouble(),
      currentBid: (json['currentBid'] ?? 0.0).toDouble(),
      auctionEndTime: DateTime.parse(json['auctionEndTime']),
      totalBids: json['totalBids'] ?? 0,
    );
  }
}
