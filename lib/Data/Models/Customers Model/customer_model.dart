import 'package:flutter/material.dart';
import '../../../Data/Models/product_type_enums.dart';

enum CustomerStatus { active, inactive, vip }

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String location;
  final Color avatarColor;
  final CustomerStatus status;
  final ProductType primaryBuyType;
  final int totalOrders;
  final double totalSpent;
  final DateTime lastOrderDate;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.avatarColor,
    required this.status,
    required this.primaryBuyType,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrderDate,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}
