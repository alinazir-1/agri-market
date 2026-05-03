import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/features/seller/add_product/product_catalog_data.dart';

/// One row item: seller [ProductCatalogData] category + display image.
class BuyerCategoryStripEntry {
  const BuyerCategoryStripEntry({
    required this.name,
    required this.imagePath,
  });

  final String name;
  final String imagePath;
}

/// Builds strip data from the same catalog used in the seller add-product form.
///
/// Images: [AppImages.categoryCatalogJpeg] → `assets/category/<category name>.jpg`
/// (must match each top-level catalog key). [Image.asset] uses [errorBuilder] in the strip UI if missing.
class BuyerCategoryStripCatalog {
  BuyerCategoryStripCatalog._();

  static List<BuyerCategoryStripEntry> get entries {
    final keys = List<String>.from(ProductCatalogData.catalog.keys)..sort();
    return keys
        .map(
          (name) => BuyerCategoryStripEntry(
            name: name,
            imagePath: AppImages.categoryCatalogJpeg(name),
          ),
        )
        .toList();
  }
}
