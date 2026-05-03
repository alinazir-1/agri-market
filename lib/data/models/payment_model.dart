import 'package:agri_market/data/models/product_type_enums.dart';

enum PaymentStatus { paid, pending, partial, failed }

enum PaymentFilter { all, paid, pending, partial, failed }

enum PaymentSort { latest, oldest, highestAmount, lowestAmount }

class PaymentModel {
  final String id;
  final String orderId;
  final String buyerId;
  final String buyerName;
  final String buyerEmail;
  final String? avatarHex;
  final String productName;
  final String quantity;
  final String unit;
  final ProductType productType;
  final double amount;
  final PaymentStatus status;
  final DateTime date;
  final DateTime? dueDate;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    this.avatarHex,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.productType,
    required this.amount,
    required this.status,
    required this.date,
    this.dueDate,
  });

  String get initials {
    final parts = buyerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return buyerName.substring(0, 2).toUpperCase();
  }
}

class MonthlyRevenue {
  final String month;
  final double amount;
  final bool isCurrent;

  const MonthlyRevenue({
    required this.month,
    required this.amount,
    required this.isCurrent,
  });
}
