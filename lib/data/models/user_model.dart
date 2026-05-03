// lib/data/models/user_model.dart

class UserModel {
  String id;
  String email;
  String password;
  String role;
  DateTime createdAt;
  String fullName;
  String brandName;
  String profilePic;
  String phone;
  bool emailVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    this.fullName = '',
    this.brandName = '',
    this.profilePic = '',
    this.phone = '',
    this.emailVerified = false,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? role,
    DateTime? createdAt,
    String? fullName,
    String? brandName,
    String? profilePic,
    String? phone,
    bool? emailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      fullName: fullName ?? this.fullName,
      brandName: brandName ?? this.brandName,
      profilePic: profilePic ?? this.profilePic,
      phone: phone ?? this.phone,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
