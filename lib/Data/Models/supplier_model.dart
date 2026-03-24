import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Enums
// ─────────────────────────────────────────────────────────────────────────────

enum SupplierStatus { active, pending, inactive, blocked }

extension SupplierStatusX on SupplierStatus {
  String get label => switch (this) {
        SupplierStatus.active => 'Active',
        SupplierStatus.pending => 'Pending',
        SupplierStatus.inactive => 'Inactive',
        SupplierStatus.blocked => 'Blocked',
      };

  Color get color => switch (this) {
        SupplierStatus.active => const Color(0xFF059669),
        SupplierStatus.pending => const Color(0xFFD97706),
        SupplierStatus.inactive => const Color(0xFF6B7280),
        SupplierStatus.blocked => const Color(0xFFDC2626),
      };

  Color get bgColor => switch (this) {
        SupplierStatus.active => const Color(0xFFD1FAE5),
        SupplierStatus.pending => const Color(0xFFFEF3C7),
        SupplierStatus.inactive => const Color(0xFFF3F4F6),
        SupplierStatus.blocked => const Color(0xFFFEE2E2),
      };
}

enum SupplierCategory { grains, vegetables, fruits, livestock, dairy }

extension SupplierCategoryX on SupplierCategory {
  String get label => switch (this) {
        SupplierCategory.grains => 'Grains',
        SupplierCategory.vegetables => 'Vegetables',
        SupplierCategory.fruits => 'Fruits',
        SupplierCategory.livestock => 'Livestock',
        SupplierCategory.dairy => 'Dairy',
      };

  Color get color => switch (this) {
        SupplierCategory.grains => const Color(0xFF92400E),
        SupplierCategory.vegetables => const Color(0xFF065F46),
        SupplierCategory.fruits => const Color(0xFF9D174D),
        SupplierCategory.livestock => const Color(0xFF1E40AF),
        SupplierCategory.dairy => const Color(0xFF5B21B6),
      };

  Color get bgColor => switch (this) {
        SupplierCategory.grains => const Color(0xFFFEF3C7),
        SupplierCategory.vegetables => const Color(0xFFD1FAE5),
        SupplierCategory.fruits => const Color(0xFFFCE7F3),
        SupplierCategory.livestock => const Color(0xFFDBEAFE),
        SupplierCategory.dairy => const Color(0xFFEDE9FE),
      };

  IconData get icon => switch (this) {
        SupplierCategory.grains => Icons.grass_outlined,
        SupplierCategory.vegetables => Icons.eco_outlined,
        SupplierCategory.fruits => Icons.local_florist_outlined,
        SupplierCategory.livestock => Icons.pets_outlined,
        SupplierCategory.dairy => Icons.water_drop_outlined,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────────────────────────────

class SupplierModel {
  final String id;
  final String name;
  final String contactPerson;
  final String email;
  final String phone;
  final String location;
  final SupplierCategory category;
  final SupplierStatus status;
  final double rating; // 0.0 – 5.0
  final double totalSupplied; // tons
  final int totalOrders;
  final DateTime joinDate;
  final Color avatarColor;

  const SupplierModel({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.location,
    required this.category,
    required this.status,
    required this.rating,
    required this.totalSupplied,
    required this.totalOrders,
    required this.joinDate,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  SupplierModel copyWith({SupplierStatus? status}) => SupplierModel(
        id: id,
        name: name,
        contactPerson: contactPerson,
        email: email,
        phone: phone,
        location: location,
        category: category,
        status: status ?? this.status,
        rating: rating,
        totalSupplied: totalSupplied,
        totalOrders: totalOrders,
        joinDate: joinDate,
        avatarColor: avatarColor,
      );
}
