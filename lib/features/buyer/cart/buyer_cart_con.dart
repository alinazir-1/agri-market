// lib/features/buyer/cart/buyer_cart_con.dart

import 'package:get/get.dart';

import 'package:agri_market/core/constants/images.dart';

/// One procurement line in the buyer cart (B2B-style dummy data).
class BuyerCartLine {
  BuyerCartLine({
    required this.id,
    required this.sku,
    required this.productName,
    required this.supplierName,
    required this.grade,
    required this.unitLabel,
    required this.moqNote,
    required this.unitPrice,
    required this.quantity,
    required this.currency,
    required this.productImage,
  });

  final String id;
  final String sku;
  final String productName;
  final String supplierName;
  final String grade;
  final String unitLabel;
  final String moqNote;
  final double unitPrice;
  final int quantity;
  final String currency;
  final String productImage;

  double get lineTotal => unitPrice * quantity;

  BuyerCartLine copyWith({int? quantity}) => BuyerCartLine(
        id: id,
        sku: sku,
        productName: productName,
        supplierName: supplierName,
        grade: grade,
        unitLabel: unitLabel,
        moqNote: moqNote,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        currency: currency,
        productImage: productImage,
      );
}

class BuyerCartCon extends GetxController {
  final RxList<BuyerCartLine> lines = <BuyerCartLine>[
    BuyerCartLine(
      id: 'L1',
      sku: 'AG-BAS-25A',
      productName: 'Sella Basmati Rice · Grade A',
      supplierName: 'Al-Rehman Traders',
      grade: 'A',
      unitLabel: 'per MT',
      moqNote: 'MOQ 10 MT · step 1 MT',
      unitPrice: 118000,
      quantity: 25,
      currency: 'PKR',
      productImage: AppImages.p1,
    ),
    BuyerCartLine(
      id: 'L2',
      sku: 'AG-SOY-ORG',
      productName: 'Premium Soybean · container lot',
      supplierName: 'Madinah Agro Supply',
      grade: 'A',
      unitLabel: 'per MT',
      moqNote: 'MOQ 12 MT · step 1 MT',
      unitPrice: 210000,
      quantity: 12,
      currency: 'PKR',
      productImage: AppImages.p5,
    ),
    BuyerCartLine(
      id: 'L3',
      sku: 'AG-MNG-ADV',
      productName: 'Fresh Mangoes · advance booking slot',
      supplierName: 'Sindh Pulse Hub',
      grade: 'B+',
      unitLabel: 'per MT',
      moqNote: 'MOQ 8 MT · step 1 MT',
      unitPrice: 165000,
      quantity: 8,
      currency: 'PKR',
      productImage: AppImages.p4,
    ),
    BuyerCartLine(
      id: 'L4',
      sku: 'AG-POT-DES',
      productName: 'Desiree Potato · bulk pallet',
      supplierName: 'Pak Harvest Co.',
      grade: 'A',
      unitLabel: 'per MT',
      moqNote: 'MOQ 15 MT · step 1 MT',
      unitPrice: 92000,
      quantity: 15,
      currency: 'PKR',
      productImage: AppImages.p2,
    ),
  ].obs;

  final RxBool checkoutBusy = false.obs;

  int get lineCount => lines.length;

  double get subtotal =>
      lines.fold(0.0, (s, e) => s + e.lineTotal);

  /// Placeholder logistics estimate (UI-only).
  double get estimatedLogistics => subtotal > 0 ? 185000 : 0;

  double get grandTotal => subtotal + estimatedLogistics;

  void incrementQty(String id) {
    final i = lines.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final o = lines[i];
    lines[i] = o.copyWith(quantity: o.quantity + 1);
    lines.refresh();
  }

  void decrementQty(String id) {
    final i = lines.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final o = lines[i];
    if (o.quantity <= 1) return;
    lines[i] = o.copyWith(quantity: o.quantity - 1);
    lines.refresh();
  }

  void removeLine(String id) {
    lines.removeWhere((e) => e.id == id);
  }

  Future<void> onCheckoutTap() async {
    if (lines.isEmpty || checkoutBusy.value) return;
    checkoutBusy.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 400));
    checkoutBusy.value = false;
  }

  Future<void> onRequestRevisionTap() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
