enum PartnerType { domestic, international, freight }

enum PartnerStatus { active, inactive }

class DeliveryPartnerModel {
  final String id;
  final String name;
  final String emoji;
  final String? logoBgHex;
  final PartnerType type;
  final PartnerStatus status;
  final int totalShipments;
  final double onTimePercent;
  final double rating;
  final String coverage;

  const DeliveryPartnerModel({
    required this.id,
    required this.name,
    required this.emoji,
    this.logoBgHex,
    required this.type,
    required this.status,
    required this.totalShipments,
    required this.onTimePercent,
    required this.rating,
    required this.coverage,
  });

  String get typeLabel {
    switch (type) {
      case PartnerType.domestic:
        return 'Courier · Domestic';
      case PartnerType.international:
        return 'Courier · International';
      case PartnerType.freight:
        return 'Freight · International';
    }
  }
}
