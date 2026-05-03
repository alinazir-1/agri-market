class BatchModel {
  final String batchCode;
  final String sourceState;
  final String grade;
  final double quantity;
  final double pricePerUnit;
  final String unit;
  final String status; // 'available' | 'coming_soon' | 'sold_out'
  final Map<String, String> specifications;

  const BatchModel({
    required this.batchCode,
    required this.sourceState,
    required this.grade,
    required this.quantity,
    required this.pricePerUnit,
    required this.unit,
    this.status = 'available',
    this.specifications = const {},
  });

  BatchModel copyWith({
    String? batchCode,
    String? sourceState,
    String? grade,
    double? quantity,
    double? pricePerUnit,
    String? unit,
    String? status,
    Map<String, String>? specifications,
  }) {
    return BatchModel(
      batchCode: batchCode ?? this.batchCode,
      sourceState: sourceState ?? this.sourceState,
      grade: grade ?? this.grade,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      specifications: specifications ?? this.specifications,
    );
  }
}
