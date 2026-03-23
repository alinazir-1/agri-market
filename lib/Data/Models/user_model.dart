class UserModel {
  final String id;
  final String fullName;
  final String brandName;
  final String profilePic;

  UserModel({
    required this.id,
    required this.fullName,
    required this.brandName,
    this.profilePic = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['uid'] ?? '',
      fullName: json['fullName'] ?? 'User',
      brandName: json['brandName'] ?? 'My Brand',
      profilePic: json['profilePic'] ?? '',
    );
  }
}
