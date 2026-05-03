import 'dart:io';

import '../lib/features/seller/add_product/product_catalog_data.dart';

void main() {
  final names = <String>{};
  for (final sub in ProductCatalogData.catalog.values) {
    for (final list in sub.values) {
      names.addAll(list);
    }
  }
  final sorted = names.toList()..sort();
  final buf = StringBuffer();
  for (final n in sorted) {
    buf.writeln(n);
  }
  File('tool/catalog_names_clean.txt').writeAsStringSync(buf.toString());
  stdout.writeln('Wrote tool/catalog_names_clean.txt (${sorted.length} names)');
}
