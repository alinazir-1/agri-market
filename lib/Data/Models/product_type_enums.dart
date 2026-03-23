// product_enums.dart

enum ProductType {
  marketplace,
  liveAuction,
  advanceBooking,
  booking,
  auction;

  @override
  String toString() => name;

  static ProductType fromString(String type) {
    return ProductType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => ProductType.marketplace,
    );
  }
}

enum ProductStatus {
  active,
  inactive,
  deleted,
  pending,
  rejected;

  @override
  String toString() => name;

  static ProductStatus fromString(String status) {
    return ProductStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => ProductStatus.inactive,
    );
  }
}
