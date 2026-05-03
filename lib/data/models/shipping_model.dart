enum ShipmentStatus {
  pending,
  processing,
  shipped,
  inTransit,
  delivered,
  cancelled
}

enum DeliveryMethod { self, thirdParty, buyerPickup }

enum ShippingFilter {
  all,
  pending,
  processing,
  shipped,
  inTransit,
  delivered,
  cancelled
}

enum ShippingSort { latest, oldest, deliverySoon, deliveryLate }

enum ShippingTab { shipments, deliveryPartners }

class ShipmentModel {
  final String id;
  final String orderId;
  final String buyerName;
  final String buyerLocation;
  final String? avatarHex;
  final String productName;
  final String quantity;
  final String unit;
  final DeliveryMethod deliveryMethod;
  final String? partnerName;
  final String? trackingNumber;
  final ShipmentStatus status;
  final DateTime orderDate;
  final DateTime? estimatedDelivery;
  final bool isDelayed;
  final String? delayReason;

  const ShipmentModel({
    required this.id,
    required this.orderId,
    required this.buyerName,
    required this.buyerLocation,
    this.avatarHex,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.deliveryMethod,
    required this.status,
    required this.orderDate,
    this.partnerName,
    this.trackingNumber,
    this.estimatedDelivery,
    this.isDelayed = false,
    this.delayReason,
  });

  String get initials {
    final parts = buyerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return buyerName.substring(0, 2).toUpperCase();
  }

  int get progressStep {
    switch (status) {
      case ShipmentStatus.pending:
      case ShipmentStatus.processing:
        return 0;
      case ShipmentStatus.shipped:
        return 1;
      case ShipmentStatus.inTransit:
        return 2;
      case ShipmentStatus.delivered:
        return 3;
      case ShipmentStatus.cancelled:
        return 0;
    }
  }

  ShipmentModel copyWith(
      {ShipmentStatus? status, bool? isDelayed, String? partnerName}) {
    return ShipmentModel(
      id: id,
      orderId: orderId,
      buyerName: buyerName,
      buyerLocation: buyerLocation,
      avatarHex: avatarHex,
      productName: productName,
      quantity: quantity,
      unit: unit,
      deliveryMethod: deliveryMethod,
      partnerName: partnerName ?? this.partnerName,
      trackingNumber: trackingNumber,
      status: status ?? this.status,
      orderDate: orderDate,
      estimatedDelivery: estimatedDelivery,
      isDelayed: isDelayed ?? this.isDelayed,
      delayReason: delayReason,
    );
  }
}
