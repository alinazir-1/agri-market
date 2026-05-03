import '../lib/features/seller/add_product/product_catalog_data.dart';

void main() {
  var n = 0;
  for (final sub in ProductCatalogData.catalog.values) {
    for (final list in sub.values) {
      n += list.length;
    }
  }
  print(n);
}
