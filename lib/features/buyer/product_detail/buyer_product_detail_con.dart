// buyer_product_detail_con.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';

/// Product context for the buyer product detail route ([Get.put] with a unique tag).
class BuyerProductDetailCon extends GetxController {
  BuyerProductDetailCon({
    required this.product,
    required this.sectionType,
  });

  final DummyProduct product;
  final int sectionType;

  /// Unique per detail route — [BuyerTopBar] anchor so home overlay does not share the same key.
  final GlobalKey categoriesMenuAnchorKey =
      GlobalKey(debugLabel: 'buyerDetailCategoriesMenu');

  /// Gallery selection (thumbnails + main image).
  final RxInt selectedGalleryIndex = 0.obs;

  /// Wishlist heart on main gallery image.
  final RxBool wishlisted = false.obs;

  /// Order quantity stepper (KGS) — dummy UX.
  final RxInt orderQtyKgs = 10000.obs;

  /// Product detail title + grade (dummy copy matches reference style).
  String get displayProductTitle {
    final t = product.name.trim();
    return t.isEmpty ? 'Product' : t;
  }

  String get detailHeading {
    final g = product.grade.trim();
    if (g.isEmpty) return displayProductTitle;
    return '$displayProductTitle - $g';
  }

  /// Seller strip (dummy until API).
  static const String kSellerName = 'ABC Traders';
  static const String kSellerTenure = '1 yr';
  static const String kTransactionLabel = '116 Transactions';

  static const double kDisplayRating = 4.0;

  double get displayRating => kDisplayRating;

  /// Tier pricing labels (KES / KG dummy).
  static const String kTier1RangeLabel = '10 - 49 tons';
  static const String kTier2RangeLabel = '50+ tons';
  static const int kPriceTier1PerKg = 42;
  static const int kPriceTier2PerKg = 41;

  /// Break between tiers at 50,000 KGS (50 tons).
  static const int kTierBreakKg = 50000;

  int get unitPricePerKg =>
      orderQtyKgs.value >= kTierBreakKg ? kPriceTier2PerKg : kPriceTier1PerKg;

  int get itemSubtotalKes => orderQtyKgs.value * unitPricePerKg;

  static const int kOrderStepKgs = 1000;
  static const int kOrderMinKgs = 1000;

  /// Stock / location dummy (override from product where useful).
  String get locationLine =>
      product.location.trim().isEmpty ? 'Kitale, Kenya' : product.location.trim();

  static const String kStockLabel = 'Available Qty: 140,000 KGS';

  /// Attributes table — dummy rows.
  static const List<(String, String)> kSpecRows = [
    ('Grade', '2'),
    ('Moisture %', 'max. 13%'),
    ('Crude Fat %', 'n/a'),
    ('Protein %', 'min. 8.5%'),
    ('Ash %', 'max. 2%'),
    ('Fiber %', 'max. 4%'),
  ];

  final RxBool specsExpanded = false.obs;

  void toggleWishlist() => wishlisted.value = !wishlisted.value;

  void incrementQty() =>
      orderQtyKgs.value = orderQtyKgs.value + kOrderStepKgs;

  void decrementQty() {
    final next = orderQtyKgs.value - kOrderStepKgs;
    orderQtyKgs.value = next < kOrderMinKgs ? kOrderMinKgs : next;
  }

  String formattedQtySelected() =>
      '${_formatThousands(orderQtyKgs.value)} KGS';

  String formattedSubtotal() => 'KES ${_formatThousands(itemSubtotalKes)}';

  String formattedOrderQtyField() => _formatThousands(orderQtyKgs.value);

  List<String> galleryAssetPaths() {
    final primary = product.imagePath.trim();
    final first =
        primary.isNotEmpty ? primary : AppImages.p1;
    return <String>[
      first,
      AppImages.p2,
      AppImages.p3,
      AppImages.p4,
      AppImages.p5,
    ];
  }

  void setGalleryIndex(int i) {
    final paths = galleryAssetPaths();
    if (paths.isEmpty) return;
    selectedGalleryIndex.value = i.clamp(0, paths.length - 1);
  }

  void galleryPrevious() {
    final paths = galleryAssetPaths();
    if (paths.length <= 1) return;
    final i = selectedGalleryIndex.value;
    setGalleryIndex(i <= 0 ? paths.length - 1 : i - 1);
  }

  void galleryNext() {
    final paths = galleryAssetPaths();
    if (paths.length <= 1) return;
    final i = selectedGalleryIndex.value;
    setGalleryIndex(i >= paths.length - 1 ? 0 : i + 1);
  }

  String get unitLabel =>
      product.unit.trim().isEmpty ? 'KGS' : product.unit.trim();

  // Legacy widget files (not used by current [BuyerProductDetailScr]) still reference these.
  String formattedMainPricePkr() =>
      'KES ${_formatThousands(product.price.round())}';

  String formattedSamplePricePkr() {
    final sample = (product.price * 2).round().clamp(1000, 999999999);
    return 'KES ${_formatThousands(sample)}';
  }

  static const String kPaymentMethods = 'Swift transfer, L/C, Paypal';
  static const String kTradingAreas = 'International market';
  static const String kShippingInfo = 'EXW, FOB';

  String get displaySupplierName => kSellerName;

  static const int kDisplayReviewCount = 10;
  static const String kDisplaySoldLabel = '5000 ton sold';

  int get displayReviewCount => kDisplayReviewCount;
  String get displaySoldLabel => kDisplaySoldLabel;

  /// About seller — dummy copy.
  static const String kAboutSellerParagraph1 =
      'ABC Traders is committed to consistent quality and reliable bulk supply for '
      'regional processors and distributors. Every lot is checked against grade '
      'specifications before dispatch.';

  static const String kAboutSellerParagraph2 =
      'We work closely with producers and logistics partners to keep lead times '
      'predictable and documentation complete for cross-border trade.';

  @override
  void onClose() {
    // No [TextEditingController] / timers; [categoriesMenuAnchorKey] follows widget disposal.
    super.onClose();
  }
}

String _formatThousands(int value) {
  final neg = value < 0;
  final digits = (neg ? -value : value).toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return neg ? '-$buf' : buf.toString();
}
