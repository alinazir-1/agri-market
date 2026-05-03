// lib/data/models/category_model.dart

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
}
