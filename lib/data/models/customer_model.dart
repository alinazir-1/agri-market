// lib/data/models/customer_model.dart

import 'package:agri_market/data/models/product_type_enums.dart';

enum CustomerStatus {
  active,
  inactive,
  vip,
}

class CustomerModel {
  String id;
  String name;
  String email;
  String location;
  String? avatarHex;
  CustomerStatus status;
  ProductType primaryBuyType;
  int totalOrders;
  double totalSpent;
  DateTime lastOrderDate;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    this.avatarHex,
    required this.status,
    required this.primaryBuyType,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrderDate,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? location,
    String? avatarHex,
    CustomerStatus? status,
    ProductType? primaryBuyType,
    int? totalOrders,
    double? totalSpent,
    DateTime? lastOrderDate,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      avatarHex: avatarHex ?? this.avatarHex,
      status: status ?? this.status,
      primaryBuyType: primaryBuyType ?? this.primaryBuyType,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
    );
  }
}
