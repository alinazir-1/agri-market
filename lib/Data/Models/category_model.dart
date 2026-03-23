class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.productCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      productCount: json['productCount'] ?? 0,
    );
  }
}
