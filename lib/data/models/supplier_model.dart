// lib/data/models/supplier_model.dart

enum SupplierStatus {
  active,
  pending,
  inactive,
  blocked,
}

enum SupplierCategory {
  grains,
  vegetables,
  fruits,
  livestock,
  dairy,
}

class SupplierModel {
  String id;
  String name;
  String contactPerson;
  String email;
  String phone;
  String location;
  SupplierCategory category;
  SupplierStatus status;
  double rating;
  double totalSupplied;
  int totalOrders;
  DateTime joinDate;
  String avatarHex;

  SupplierModel({
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
    required this.avatarHex,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  SupplierModel copyWith({
    SupplierStatus? status,
    String? avatarHex,
    String? name,
    double? rating,
  }) {
    return SupplierModel(
      id: id,
      name: name ?? this.name,
      contactPerson: contactPerson,
      email: email,
      phone: phone,
      location: location,
      category: category,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      totalSupplied: totalSupplied,
      totalOrders: totalOrders,
      joinDate: joinDate,
      avatarHex: avatarHex ?? this.avatarHex,
    );
  }
}
