import 'package:agri_market/features/seller/add_product/product_varieties_embed.generated.dart';

/// Predefined product varieties keyed by exact catalog product name.
class ProductVarietyCatalog {
  ProductVarietyCatalog._();

  static List<String> varietiesFor(String productName) {
    if (productName.isEmpty) return const [];
    final m = productVarietiesByName();
    return m[productName] ?? const [];
  }
}
