import 'package:agri_market/data/models/product_type_enums.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled;

  @override
  String toString() => name;

  static OrderStatus fromString(String s) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => OrderStatus.pending,
    );
  }
}

enum OrderPaymentStatus {
  paid,
  pending,
  partial,
  failed;

  @override
  String toString() => name;

  static OrderPaymentStatus fromString(String s) {
    return OrderPaymentStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => OrderPaymentStatus.pending,
    );
  }
}

enum SampleStatus {
  newRequest,
  accepted,
  dispatched,
  delivered,
  rejected,
  cancelled;

  @override
  String toString() => name;

  static SampleStatus fromString(String s) {
    return SampleStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => SampleStatus.newRequest,
    );
  }
}

class OrderModel {
  final String orderId;
  final String productId;
  final String productName;
  final String productImage;
  final String productGrade;
  final ProductType productType;
  final String buyerId;
  final String buyerName;
  final String buyerLocation;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double totalAmount;
  final String currency;
  final OrderStatus orderStatus;
  final OrderPaymentStatus orderPaymentStatus;
  final DateTime orderDate;
  final DateTime? estimatedDeliveryDate;
  final String deliveryOption;
  final String deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productGrade,
    required this.productType,
    required this.buyerId,
    required this.buyerName,
    required this.buyerLocation,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.currency,
    required this.orderStatus,
    required this.orderDate,
    this.estimatedDeliveryDate,
    required this.deliveryOption,
    required this.deliveryAddress,
    required this.orderPaymentStatus,
  });
}

class SampleRequestModel {
  final String sampleId;
  final String productId;
  final String productName;
  final String productImage;
  final String buyerId;
  final String buyerName;
  final String buyerLocation;
  final double sampleQty;
  final String sampleUnit;
  final double samplePrice;
  final bool isDeliveryBySeller;
  final SampleStatus status;
  final DateTime requestDate;

  SampleRequestModel({
    required this.sampleId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.buyerId,
    required this.buyerName,
    required this.buyerLocation,
    required this.sampleQty,
    required this.sampleUnit,
    required this.samplePrice,
    required this.isDeliveryBySeller,
    required this.status,
    required this.requestDate,
  });
}
