// lib/data/models/stock_batch_model.dart

enum BatchSource { manual, marketplace, liveAuction, advanceBooking }

enum BatchStatus { active, depleted, expired }

enum MovementType { addition, saleMarketplace, saleAuction, saleBooking }

// ── StockBatch ────────────────────────────────────────────────────────────────

class StockBatch {
  final String id;
  final String productId;
  final String productName;
  final String batchNumber;
  final String supplierName;
  final String supplierContact;
  final String supplierLocation;
  final DateTime purchaseDate;
  final double initialQty;
  final double currentQty;
  final String unit;
  final double costPerUnit;
  final double sellingPrice;
  final DateTime addedDate;
  final DateTime? productionDate;
  final DateTime? expiryDate;
  final String grade;
  final Map<String, String> qualityParams;
  final List<String> certifications;
  final String storageCondition;
  final String storageLocation;
  final BatchSource source;
  final String? sourceListingId;
  final String notes;

  const StockBatch({
    required this.id,
    required this.productId,
    this.productName = '',
    this.batchNumber = '',
    this.supplierName = '',
    this.supplierContact = '',
    this.supplierLocation = '',
    required this.purchaseDate,
    required this.initialQty,
    required this.currentQty,
    required this.unit,
    this.costPerUnit = 0,
    this.sellingPrice = 0,
    required this.addedDate,
    this.productionDate,
    this.expiryDate,
    this.grade = 'A',
    this.qualityParams = const {},
    this.certifications = const [],
    this.storageCondition = '',
    this.storageLocation = '',
    this.source = BatchSource.manual,
    this.sourceListingId,
    this.notes = '',
  });

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  bool get isDepleted => currentQty <= 0;

  bool get isActive => !isDepleted && !isExpired;

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysLeft = expiryDate!.difference(DateTime.now()).inDays;
    return daysLeft >= 0 && daysLeft <= 30;
  }

  bool get isNearExpiry => isExpiringSoon;

  BatchStatus get status {
    if (isExpired) return BatchStatus.expired;
    if (isDepleted) return BatchStatus.depleted;
    return BatchStatus.active;
  }

  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  double get totalSellingValue => currentQty * sellingPrice;

  double get totalCostValue => currentQty * costPerUnit;

  String get sourceLabel {
    switch (source) {
      case BatchSource.manual:
        return 'Manual Entry';
      case BatchSource.marketplace:
        return 'Marketplace';
      case BatchSource.liveAuction:
        return 'Live Auction';
      case BatchSource.advanceBooking:
        return 'Adv. Booking';
    }
  }

  StockBatch copyWith({
    double? currentQty,
    double? sellingPrice,
    BatchSource? source,
  }) {
    return StockBatch(
      id: id,
      productId: productId,
      productName: productName,
      batchNumber: batchNumber,
      supplierName: supplierName,
      supplierContact: supplierContact,
      supplierLocation: supplierLocation,
      purchaseDate: purchaseDate,
      initialQty: initialQty,
      currentQty: currentQty ?? this.currentQty,
      unit: unit,
      costPerUnit: costPerUnit,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      addedDate: addedDate,
      productionDate: productionDate,
      expiryDate: expiryDate,
      grade: grade,
      qualityParams: qualityParams,
      certifications: certifications,
      storageCondition: storageCondition,
      storageLocation: storageLocation,
      source: source ?? this.source,
      sourceListingId: sourceListingId,
      notes: notes,
    );
  }
}

// ── StockMovement ─────────────────────────────────────────────────────────────

class StockMovement {
  final String id;
  final String batchId;
  final String batchNumber;
  final String productId;
  final String productName;
  final MovementType type;
  final double quantity;
  final double pricePerUnit;
  final DateTime timestamp;
  final String? orderId;
  final String? note;

  const StockMovement({
    required this.id,
    required this.batchId,
    required this.batchNumber,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.pricePerUnit,
    required this.timestamp,
    this.orderId,
    this.note,
  });

  String get typeLabel {
    switch (type) {
      case MovementType.addition:
        return 'Addition';
      case MovementType.saleMarketplace:
        return 'Marketplace';
      case MovementType.saleAuction:
        return 'Live Auction';
      case MovementType.saleBooking:
        return 'Adv. Booking';
    }
  }
}
