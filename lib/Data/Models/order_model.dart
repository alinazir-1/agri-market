import 'package:agri_market/Data/Models/product_type_enums.dart';

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

// ── Seller Order Model ────────────────────────────────────────────────────────

class OrderModel {
  final String orderId;
  final String productId;
  final String productName;
  final String productImage;
  final String productGrade;
  final ProductType productType; // from your existing enum
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
  final String deliveryOption; // 'Seller Delivers' | 'Buyer Picks Up'
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

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'productGrade': productGrade,
        'productType': productType.toString(),
        'buyerId': buyerId,
        'buyerName': buyerName,
        'buyerLocation': buyerLocation,
        'quantity': quantity,
        'unit': unit,
        'pricePerUnit': pricePerUnit,
        'totalAmount': totalAmount,
        'currency': currency,
        'orderStatus': orderStatus.toString(),
        'OrderPaymentStatus': orderPaymentStatus.toString(),
        'orderDate': orderDate.toIso8601String(),
        'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
        'deliveryOption': deliveryOption,
        'deliveryAddress': deliveryAddress,
      };

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
        orderId: j['orderId'],
        productId: j['productId'],
        productName: j['productName'],
        productImage: j['productImage'],
        productGrade: j['productGrade'],
        productType: ProductType.fromString(j['productType']),
        buyerId: j['buyerId'],
        buyerName: j['buyerName'],
        buyerLocation: j['buyerLocation'],
        quantity: (j['quantity'] ?? 0.0).toDouble(),
        unit: j['unit'],
        pricePerUnit: (j['pricePerUnit'] ?? 0.0).toDouble(),
        totalAmount: (j['totalAmount'] ?? 0.0).toDouble(),
        currency: j['currency'],
        orderStatus: OrderStatus.fromString(j['orderStatus']),
        orderPaymentStatus:
            OrderPaymentStatus.fromString(j['orderPaymentStatus']),
        orderDate: DateTime.parse(j['orderDate']),
        estimatedDeliveryDate: j['estimatedDeliveryDate'] != null
            ? DateTime.parse(j['estimatedDeliveryDate'])
            : null,
        deliveryOption: j['deliveryOption'],
        deliveryAddress: j['deliveryAddress'],
      );
}

// ── Sample Request Model ──────────────────────────────────────────────────────

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
  final double samplePrice; // 0.0 = free
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

  Map<String, dynamic> toJson() => {
        'sampleId': sampleId,
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'buyerId': buyerId,
        'buyerName': buyerName,
        'buyerLocation': buyerLocation,
        'sampleQty': sampleQty,
        'sampleUnit': sampleUnit,
        'samplePrice': samplePrice,
        'isDeliveryBySeller': isDeliveryBySeller,
        'status': status.toString(),
        'requestDate': requestDate.toIso8601String(),
      };

  factory SampleRequestModel.fromJson(Map<String, dynamic> j) =>
      SampleRequestModel(
        sampleId: j['sampleId'],
        productId: j['productId'],
        productName: j['productName'],
        productImage: j['productImage'],
        buyerId: j['buyerId'],
        buyerName: j['buyerName'],
        buyerLocation: j['buyerLocation'],
        sampleQty: (j['sampleQty'] ?? 0.0).toDouble(),
        sampleUnit: j['sampleUnit'],
        samplePrice: (j['samplePrice'] ?? 0.0).toDouble(),
        isDeliveryBySeller: j['isDeliveryBySeller'] ?? false,
        status: SampleStatus.fromString(j['status']),
        requestDate: DateTime.parse(j['requestDate']),
      );
}
