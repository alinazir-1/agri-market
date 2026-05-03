import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/product_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/features/seller/add_product/add_new_product_con.dart';
import 'package:agri_market/features/seller/products/my_products_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_url_or_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Use [AddNewProductCon] fields only while this screen is editing that draft
/// (`editingProductId == productModel.id`). After publish the controller stays
/// registered but is reset — then we must show [productModel] instead.
bool _detailLiveFormOverlayActive(ProductModel pm) {
  if (!Get.isRegistered<AddNewProductCon>()) return false;
  final eid = Get.find<AddNewProductCon>().editingProductId.value;
  if (eid == null || eid.isEmpty || pm.id.isEmpty) return false;
  return eid == pm.id;
}

AddListingType? _addListingTypeFromProductType(ProductType t) {
  switch (t) {
    case ProductType.marketplace:
      return AddListingType.marketplace;
    case ProductType.advanceBooking:
    case ProductType.booking:
      return AddListingType.advanceBooking;
    case ProductType.liveAuction:
    case ProductType.auction:
      return AddListingType.liveAuctions;
  }
}

bool _detailPublishedSpecKeyHidden(String k) {
  if (k.startsWith('tier_') || k.startsWith('booking_tier_')) return true;
  const hidden = <String>{
    'moisture',
    'batchCode',
    'cropYear',
    'deliveryOption',
    'deliveryTime',
    'tags',
    'subCategory',
    'harvestDate',
    'advancePaymentPercent',
    'bookingDeadline',
    'estimatedDeliveryDate',
    'startingBid',
    'auctionEnd',
    'auctionStart',
    'reservePrice',
    'bidIncrement',
    'maxBidders',
    'auctionAutoExtend',
    'auctionReserveVisible',
    'samplePrice',
  };
  return hidden.contains(k);
}

String _detailCategoryLine(String category, String subCategory) {
  final c = category.trim();
  final s = subCategory.trim();
  if (c.isEmpty && s.isEmpty) return '';
  if (s.isEmpty) return c;
  return '$c > $s';
}

List<String> _publishedTagsFromProduct(ProductModel pm) {
  final raw = pm.specifications['tags']?.trim() ?? '';
  if (raw.isEmpty) return const <String>[];
  return raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList();
}

List<Map<String, String>> _publishedQualitySpecsChips(ProductModel pm) {
  final out = <Map<String, String>>[];
  final m = pm.specifications;
  for (final e in m.entries) {
    if (_detailPublishedSpecKeyHidden(e.key)) continue;
    final v = e.value.trim();
    if (v.isEmpty) continue;
    out.add({'name': e.key, 'value': v, 'unit': ''});
  }
  final moist = m['moisture']?.trim();
  if (moist != null && moist.isNotEmpty) {
    out.insert(0, {'name': 'Moisture', 'value': moist, 'unit': ''});
  }
  return out;
}

class _TierViewItem {
  const _TierViewItem({
    required this.label,
    required this.price,
    required this.unit,
  });

  final String label;
  final String price;
  final String unit;
}

List<_TierViewItem> _detailTierRowsFromPublishedSpecs(ProductModel pm) {
  final specs = pm.specifications;
  final isBooking = pm.productType == ProductType.advanceBooking ||
      pm.productType == ProductType.booking;
  final out = <_TierViewItem>[];
  final rows = <({String qty, String maxQ, String price, String unit})>[];
  for (var i = 0; i < 3; i++) {
    String qty;
    String maxQ;
    String price;
    String unit;
    if (isBooking) {
      qty = (specs['booking_tier_qty_$i'] ?? specs['tier_qty_$i'] ?? '')
          .trim();
      maxQ = (specs['booking_tier_max_$i'] ?? specs['tier_max_$i'] ?? '')
          .trim();
      price =
          (specs['booking_tier_price_$i'] ?? specs['tier_price_$i'] ?? '').trim();
      unit = (specs['booking_tier_unit_$i'] ?? specs['tier_unit_$i'] ?? '')
          .trim();
    } else {
      qty = (specs['tier_qty_$i'] ?? '').trim();
      maxQ = (specs['tier_max_$i'] ?? '').trim();
      price = (specs['tier_price_$i'] ?? '').trim();
      unit = (specs['tier_unit_$i'] ?? '').trim();
    }
    if (qty.isEmpty) continue;
    rows.add((qty: qty, maxQ: maxQ, price: price, unit: unit));
  }
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    final isLast = i == rows.length - 1;
    final label =
        isLast ? '>= ${r.qty}' : (r.maxQ.isNotEmpty ? '${r.qty} - ${r.maxQ}' : '>= ${r.qty}');
    final u = r.unit.isEmpty ? pm.unit.trim() : r.unit;
    out.add(
      _TierViewItem(
        label: label,
        price: r.price,
        unit: u,
      ),
    );
  }
  return out;
}

Widget _detailTierHorizontalCard(List<_TierViewItem> items) {
  return AppContainer(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.borderLight),
    clipBehavior: Clip.hardEdge,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: List<Widget>.generate(items.length, (index) {
          final item = items[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12),
              child: _TierInlineItemView(item: item),
            ),
          );
        }),
      ),
    ),
  );
}

Widget _detailPricingCardFromProductModel(ProductModel pm) {
  final tierFromModels = pm.tierPrices;
  if (tierFromModels.isNotEmpty) {
    final rows = <_TierViewItem>[];
    for (var i = 0; i < tierFromModels.length; i++) {
      final t = tierFromModels[i];
      final minQ = t.minQty.trim();
      if (minQ.isEmpty) continue;
      final isLast = i == tierFromModels.length - 1;
      final label = isLast ? '>= $minQ' : minQ;
      rows.add(
        _TierViewItem(
          label: label,
          price: t.price.trim(),
          unit: t.unit.trim().isEmpty ? pm.unit : t.unit.trim(),
        ),
      );
    }
    if (rows.isNotEmpty) {
      return _detailTierHorizontalCard(rows);
    }
  }
  final specRows = _detailTierRowsFromPublishedSpecs(pm);
  if (specRows.isNotEmpty) {
    return _detailTierHorizontalCard(specRows);
  }
  final p = pm.price ?? 0;
  final priceStr = (p == p.roundToDouble()) ? p.round().toString() : p.toString();
  final u = pm.unit.trim().isEmpty ? 'Ton' : pm.unit.trim();
  return AppContainer(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.borderLight),
    clipBehavior: Clip.hardEdge,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: AppText(
        text: 'Rs. $priceStr / $u',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

Widget _publishedPricingAndSampleColumn(ProductModel pm) {
  final pricing = _detailPricingCardFromProductModel(pm);
  final sample = pm.specifications['samplePrice']?.trim() ?? '';
  if (sample.isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [pricing],
    );
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      pricing,
      const SizedBox(height: 10),
      AppContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        borderRadius: BorderRadius.circular(AppSize.radius8),
        backgroundColor: AppColors.backgroundSurface,
        border: Border.all(color: AppColors.borderLight),
        child: Row(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: AppSize.icon20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  const AppText(
                    text: 'Sample price: ',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  AppText(
                    text: 'PKR $sample',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

List<Map<String, String>> _liveSpecsFromAddProductCon(AddNewProductCon con) {
  con.specLayoutRevision.value;
  final out = <Map<String, String>>[];
  for (var i = 0; i < con.specNameControllers.length; i++) {
    final n = con.specNameControllers[i].text.trim();
    final v = con.specValueControllers[i].text.trim();
    final u = i < con.specUnits.length ? con.specUnits[i] : '%';
    if (n.isEmpty && v.isEmpty) continue;
    out.add({'name': n, 'value': v, 'unit': u});
  }
  final moist = con.moistureController.text.trim();
  if (moist.isNotEmpty) {
    out.insert(0, {'name': 'Moisture', 'value': moist, 'unit': '%'});
  }
  return out;
}

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({
    super.key,
    required this.productModel,
    required this.isSeller,
  });

  /// Avoid naming this field `product` — can clash with GetX / navigation on web.
  final ProductModel productModel;
  final bool isSeller;
  final RxInt selectedImageIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      body: Column(
        children: [
          _TopBar(isSeller: isSeller),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _MainSection(
                      selectedImageIndex: selectedImageIndex,
                      productModel: productModel,
                      isSeller: isSeller,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isSeller});

  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(
        bottom: BorderSide(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back<void>(),
            child: AppContainer(
              width: 34,
              height: 34,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: AppText(
              text: 'Product Detail',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColors.textPrimary,
            ),
          ),
          if (isSeller)
            AppContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
              child: const AppText(
                text: 'Seller View',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _MainSection extends StatelessWidget {
  const _MainSection({
    required this.selectedImageIndex,
    required this.productModel,
    required this.isSeller,
  });

  final RxInt selectedImageIndex;
  final ProductModel productModel;
  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImagesBlock(
                selectedImageIndex: selectedImageIndex,
                productModel: productModel,
              ),
              const SizedBox(height: 12),
              _SpecsSection(productModel: productModel),
              const SizedBox(height: 20),
              _InfoBlock(productModel: productModel, isSeller: isSeller),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 460,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ImagesBlock(
                    selectedImageIndex: selectedImageIndex,
                    productModel: productModel,
                  ),
                  const SizedBox(height: 12),
                  _SpecsSection(productModel: productModel),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _ScrollableInfoPanel(
                productModel: productModel,
                isSeller: isSeller,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Wide layout: right column scrolls independently so long content does not stretch the page awkwardly.
class _ScrollableInfoPanel extends StatefulWidget {
  const _ScrollableInfoPanel({
    required this.productModel,
    required this.isSeller,
  });

  final ProductModel productModel;
  final bool isSeller;

  @override
  State<_ScrollableInfoPanel> createState() => _ScrollableInfoPanelState();
}

class _ScrollableInfoPanelState extends State<_ScrollableInfoPanel> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final panelH = (screenH - 130).clamp(360.0, 820.0);
    return SizedBox(
      height: panelH,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(right: 6, bottom: 8),
          child: _InfoBlock(
            productModel: widget.productModel,
            isSeller: widget.isSeller,
          ),
        ),
      ),
    );
  }
}

List<String> _mergedDetailImagePaths(ProductModel pm, AddNewProductCon? con) {
  if (con != null) {
    final out = <String>[];
    for (final u in con.uploadedImageUrls) {
      final t = u.trim();
      if (t.isNotEmpty) out.add(t);
    }
    for (final f in con.productImages) {
      final p = f.path.trim();
      if (p.isNotEmpty) out.add(p);
    }
    return out.take(5).toList();
  }
  return List<String>.from(pm.images)
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .take(5)
      .toList();
}

Widget _detailImageSlot(
  String? path, {
  double? width,
  required double height,
}) {
  if (path == null || path.isEmpty) {
    return AppContainer(
      width: width,
      height: height,
      backgroundColor: AppColors.backGroundLightGrey,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 28,
        color: AppColors.iconSecondary,
      ),
    );
  }
  return AppUrlOrAssetImage(
    path: path,
    fit: BoxFit.cover,
    width: width,
    height: height,
  );
}

class _ImagesBlock extends StatelessWidget {
  const _ImagesBlock({
    required this.selectedImageIndex,
    required this.productModel,
  });

  final RxInt selectedImageIndex;
  final ProductModel productModel;

  static const int _thumbCount = 4;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.borderLight),
      backgroundColor: AppColors.backGroundWhite,
      child: Obx(() {
        AddNewProductCon? con;
        if (_detailLiveFormOverlayActive(productModel)) {
          con = Get.find<AddNewProductCon>();
          _obxReadAddProductFormDeps(con);
        }
        final paths = _mergedDetailImagePaths(productModel, con);
        final n = paths.length;
        final selRaw = selectedImageIndex.value;
        final safeSel = n <= 0 ? 0 : selRaw.clamp(0, n - 1);
        final mainPath = n <= 0 ? null : paths[safeSel];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List<Widget>.generate(_thumbCount, (index) {
                final active = safeSel == index;
                final slotPath = index < n ? paths[index] : null;
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index == _thumbCount - 1 ? 0 : 6),
                  child: GestureDetector(
                    onTap: () => selectedImageIndex.value = index,
                    child: AppContainer(
                      width: 64,
                      height: 64,
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      border: Border.all(
                        color: active
                            ? AppColors.emeraldGreen
                            : AppColors.borderLight,
                        width: active
                            ? AppSize.borderWidth2
                            : AppSize.borderWidth05,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: _detailImageSlot(
                        slotPath,
                        width: 64,
                        height: 64,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppContainer(
                height: 274,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                border: Border.all(color: AppColors.borderLight),
                clipBehavior: Clip.hardEdge,
                child: _detailImageSlot(
                  mainPath,
                  height: 274,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoProductName extends StatelessWidget {
  const _InfoProductName({required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      return AppText(
        text: productModel.name,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);
      return AppText(
        text: con.productNameController.text,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    });
  }
}

class _InfoCategoryLine extends StatelessWidget {
  const _InfoCategoryLine({required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      final sub = productModel.subCategory.trim().isNotEmpty
          ? productModel.subCategory
          : (productModel.specifications['subCategory'] ?? '');
      final line = _detailCategoryLine(
        productModel.category,
        sub,
      );
      return AppText(
        text: line,
        fontSize: 13,
        color: AppColors.textSecondary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);
      final line = _detailCategoryLine(
        con.selectedCategory.value,
        con.selectedSubCategory.value,
      );
      return AppText(
        text: line,
        fontSize: 13,
        color: AppColors.textSecondary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    });
  }
}

class _InfoLocationLine extends StatelessWidget {
  const _InfoLocationLine({required this.productModel});

  final ProductModel productModel;

  static String _locFromCon(AddNewProductCon con) {
    final parts = <String>[
      if (con.selectedCity.value.trim().isNotEmpty)
        con.selectedCity.value.trim(),
      if (con.selectedRegion.value.trim().isNotEmpty)
        con.selectedRegion.value.trim(),
      if (con.selectedCountry.value.trim().isNotEmpty)
        con.selectedCountry.value.trim(),
    ];
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      final locParts = <String>[
        if (productModel.city.isNotEmpty) productModel.city,
        if (productModel.state.isNotEmpty) productModel.state,
        if (productModel.country.isNotEmpty) productModel.country,
      ];
      final loc = locParts.isEmpty
          ? productModel.location
          : locParts.join(', ');
      return Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: AppText(
              text: loc,
              fontSize: 13,
              color: AppColors.textSecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);
      final loc = _locFromCon(con);
      return Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: AppText(
              text: loc,
              fontSize: 13,
              color: AppColors.textSecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });
  }
}

class _InfoDescription extends StatelessWidget {
  const _InfoDescription({required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    Widget descCard(String text) {
      return AppContainer(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        borderRadius: BorderRadius.circular(AppSize.radius8),
        backgroundColor: AppColors.backGroundWhite,
        border: Border.all(color: AppColors.borderLight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppContainer(
              width: 3,
              height: 96,
              borderRadius: BorderRadius.circular(AppSize.radiusCircular),
              backgroundColor: AppColors.emeraldGreen,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Description',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 92,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: AppText(
                        text: text,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      return descCard(productModel.description);
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);
      return descCard(con.descriptionController.text);
    });
  }
}

class _TagsFromControllerRow extends StatelessWidget {
  const _TagsFromControllerRow({required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      final tags = _publishedTagsFromProduct(productModel);
      if (tags.isEmpty) return const SizedBox.shrink();
      return Wrap(
        spacing: AppSize.space8,
        runSpacing: AppSize.space8,
        children: tags
            .map(
              (t) => _StatusPill(text: t, emphasized: false),
            )
            .toList(),
      );
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);
      if (con.tags.isEmpty) {
        return const SizedBox.shrink();
      }
      return Wrap(
        spacing: AppSize.space8,
        runSpacing: AppSize.space8,
        children: con.tags
            .map(
              (t) => _StatusPill(text: t, emphasized: false),
            )
            .toList(),
      );
    });
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.productModel, required this.isSeller});

  final ProductModel productModel;
  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoProductName(productModel: productModel),
            ),
            AppContainer(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              borderRadius: BorderRadius.circular(AppSize.radiusCircular),
              backgroundColor: AppColors.emeraldGreen,
              child: const AppText(
                text: 'Active',
                fontSize: 12,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _InfoCategoryLine(productModel: productModel),
        const SizedBox(height: 10),
        _InfoLocationLine(productModel: productModel),
        const SizedBox(height: 10),
        _InfoDescription(productModel: productModel),
        const SizedBox(height: 10),
        _TagsFromControllerRow(productModel: productModel),
        const SizedBox(height: 10),
        _PricingAndSampleBlock(productModel: productModel),
        const SizedBox(height: 10),
        _StockSoldStatusBar(productModel: productModel, isSeller: isSeller),
        const SizedBox(height: 16),
        _KeyAttributesSection(productModel: productModel),
      ],
    );
  }
}

void _obxReadAddProductFormDeps(AddNewProductCon c) {
  c.editingProductId.value;
  c.isFormValid.value;
  c.listingActionsEnabled.value;
  c.selectedListingType.value;
  c.selectedGrade.value;
  c.selectedDeliveryOption.value;
  c.selectedVarietyDisplay.value;
  c.marketplaceTierRevision.value;
  c.bookingTierRevision.value;
  c.specLayoutRevision.value;
  c.tierPricingEnabled.value;
  c.sampleAvailable.value;
  c.selectedUnit.value;
  c.selectedBookingUnit.value;
  c.selectedAuctionUnit.value;
  c.selectedCategory.value;
  c.selectedSubCategory.value;
  c.selectedCity.value;
  c.selectedRegion.value;
  c.selectedCountry.value;
  c.tags.length;
  c.marketplaceTierUnits.length;
  c.bookingTierUnits.length;
  c.uploadedImageUrls.length;
  c.productImages.length;
}

double _detailListedQtyFromAddProductCon(AddNewProductCon con) {
  final t = con.selectedListingType.value;
  if (t == AddListingType.advanceBooking) {
    return double.tryParse(con.bookingQtyController.text.trim()) ?? 0;
  }
  if (t == AddListingType.liveAuctions) {
    return double.tryParse(con.lotSizeController.text.trim()) ?? 0;
  }
  return double.tryParse(con.quantityController.text.trim()) ?? 0;
}

String _detailListedUnitFromAddProductCon(AddNewProductCon con) {
  final t = con.selectedListingType.value;
  if (t == AddListingType.advanceBooking) {
    return con.selectedBookingUnit.value.trim();
  }
  if (t == AddListingType.liveAuctions) {
    return con.selectedAuctionUnit.value.trim();
  }
  return con.selectedUnit.value.trim();
}

String _detailSinglePriceLine(AddNewProductCon con) {
  final t = con.selectedListingType.value;
  if (t == AddListingType.advanceBooking) {
    final p = con.bookingPriceController.text.trim();
    final u = con.selectedBookingUnit.value.trim();
    return 'Rs. $p / $u';
  }
  if (t == AddListingType.liveAuctions) {
    final p = con.startingBidController.text.trim();
    final u = con.selectedAuctionUnit.value.trim();
    return 'Rs. $p / $u';
  }
  final p = con.priceController.text.trim();
  final u = con.selectedUnit.value.trim();
  return 'Rs. $p / $u';
}

List<_TierViewItem> _detailTierDataRows(AddNewProductCon con) {
  final isBooking = con.selectedListingType.value == AddListingType.advanceBooking;
  final qtyCtrls = isBooking
      ? con.bookingTierQtyControllers
      : con.marketplaceTierQtyControllers;
  final maxCtrls = isBooking
      ? con.bookingTierMaxQtyControllers
      : con.marketplaceTierMaxQtyControllers;
  final priceCtrls = isBooking
      ? con.bookingTierPriceControllers
      : con.marketplaceTierPriceControllers;
  final units = isBooking ? con.bookingTierUnits : con.marketplaceTierUnits;

  final out = <_TierViewItem>[];
  final rows = <({String qty, String maxQ, String price, String unit})>[];
  final n = qtyCtrls.length < 3 ? qtyCtrls.length : 3;
  for (var i = 0; i < n; i++) {
    final minQ = qtyCtrls[i].text.trim();
    if (minQ.isEmpty) continue;
    final maxQ = maxCtrls[i].text.trim();
    final price = priceCtrls[i].text.trim();
    final unit = i < units.length
        ? units[i]
        : (isBooking ? con.selectedBookingUnit.value : con.selectedUnit.value);
    rows.add((qty: minQ, maxQ: maxQ, price: price, unit: unit.trim()));
  }
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    final isLast = i == rows.length - 1;
    final label =
        isLast ? '>= ${r.qty}' : (r.maxQ.isNotEmpty ? '${r.qty} - ${r.maxQ}' : '>= ${r.qty}');
    out.add(_TierViewItem(label: label, price: r.price, unit: r.unit));
  }
  return out;
}

Widget _detailPricingCardForCon(AddNewProductCon con) {
  if (con.tierPricingEnabled.value) {
    final rows = _detailTierDataRows(con);
    if (rows.isNotEmpty) return _detailTierHorizontalCard(rows);
  }

  return AppContainer(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.borderLight),
    clipBehavior: Clip.hardEdge,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: AppText(
        text: _detailSinglePriceLine(con),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

class _TierInlineItemView extends StatelessWidget {
  const _TierInlineItemView({required this.item});

  final _TierViewItem item;

  @override
  Widget build(BuildContext context) {
    final unit = item.unit.trim().isEmpty ? 'Ton' : item.unit.trim();
    final price = item.price.trim().isEmpty ? '-' : item.price.trim();
    final qtyWithUnit = '${item.label} $unit';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: qtyWithUnit,
          fontSize: 12,
          color: AppColors.textSecondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        AppText(
          text: 'PKR $price',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _PricingAndSampleBlock extends StatelessWidget {
  const _PricingAndSampleBlock({required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      return _publishedPricingAndSampleColumn(productModel);
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);

      final pricing = _detailPricingCardForCon(con);
      final sampleText = con.samplePriceController.text.trim();
      final shouldShowSample = con.sampleAvailable.value || sampleText.isNotEmpty;
      if (!shouldShowSample) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [pricing],
        );
      }

      if (sampleText.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [pricing],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pricing,
          const SizedBox(height: 10),
          AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            borderRadius: BorderRadius.circular(AppSize.radius8),
            backgroundColor: AppColors.backgroundSurface,
            border: Border.all(color: AppColors.borderLight),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: AppSize.icon20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      const AppText(
                        text: 'Sample price: ',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      AppText(
                        text: 'PKR $sampleText',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

({Color bg, Color fg}) _listingTypePillColors(AddListingType? t) {
  switch (t) {
    case AddListingType.marketplace:
      return (bg: AppColors.backgroundSurface, fg: AppColors.textPrimary);
    case AddListingType.advanceBooking:
      return (bg: AppColors.badgeInfoBg, fg: AppColors.badgeInfoText);
    case AddListingType.liveAuctions:
      return (bg: AppColors.badgeWarningBg, fg: AppColors.badgeWarningText);
    case null:
      return (bg: AppColors.backgroundSurface, fg: AppColors.textSecondary);
  }
}

class _KeyAttributesSection extends StatelessWidget {
  const _KeyAttributesSection({required this.productModel});

  final ProductModel productModel;

  static Widget _textValueCell(String text) {
    return AppText(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget _row(
    int index,
    int total,
    String label,
    Widget valueWidget,
  ) {
    final zebra = index.isEven
        ? AppColors.backgroundSurface
        : AppColors.backGroundWhite;
    return Column(
      children: [
        AppContainer(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          backgroundColor: zebra,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  text: label,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: valueWidget,
              ),
            ],
          ),
        ),
        if (index < total - 1)
          const Divider(height: 1, color: AppColors.borderLight),
      ],
    );
  }

  static Widget publishedFromProduct(ProductModel pm) {
    final lt = _addListingTypeFromProductType(pm.productType);
    final pill = _listingTypePillColors(lt);
    final listingName = pm.listingType.trim().isNotEmpty
        ? pm.listingType.trim()
        : pm.productType.name;
    final listingValue = AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: BorderRadius.circular(999),
      backgroundColor: pill.bg,
      child: AppText(
        text: listingName,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: pill.fg,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
    final rows = <Widget>[
      _row(0, 9, 'Listing type', listingValue),
      _row(1, 9, 'Batch code', _textValueCell(pm.specifications['batchCode'] ?? '')),
      _row(2, 9, 'Grade', _textValueCell(pm.grade)),
      _row(3, 9, 'Variety', _textValueCell(pm.variety)),
      _row(4, 9, 'Crop year', _textValueCell(pm.specifications['cropYear'] ?? '')),
      _row(5, 9, 'Available quantity', _textValueCell(pm.stock.toString())),
      _row(
        6,
        9,
        'Minimum Order Quantity (MOQ)',
        _textValueCell((pm.minOrderQty ?? 0).toString()),
      ),
      _row(
        7,
        9,
        'Delivery option',
        _textValueCell(pm.specifications['deliveryOption'] ?? ''),
      ),
      _row(
        8,
        9,
        'Delivery time',
        _textValueCell(pm.specifications['deliveryTime'] ?? ''),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppText(
          text: 'Key Attributes',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        AppContainer(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          backgroundColor: AppColors.backGroundWhite,
          clipBehavior: Clip.antiAlias,
          child: Column(children: rows),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      return publishedFromProduct(productModel);
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);

      final listingName = con.selectedListingType.value?.name ?? '';
      final batch = con.batchCodeController.text;
      final grade = con.selectedGrade.value;
      final variety = con.varietyController.text;
      final cropYear = con.cropYearController.text;
      final availQty = con.quantityController.text;
      final moq = con.moqController.text;
      final deliveryOpt = con.selectedDeliveryOption.value;
      final deliveryTime = con.deliveryTimeController.text;

      final lt = con.selectedListingType.value;
      final pill = _listingTypePillColors(lt);
      final listingValue = AppContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        borderRadius: BorderRadius.circular(999),
        backgroundColor: pill.bg,
        child: AppText(
          text: listingName,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: pill.fg,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );

      final rows = <Widget>[
        _row(0, 9, 'Listing type', listingValue),
        _row(1, 9, 'Batch code', _textValueCell(batch)),
        _row(2, 9, 'Grade', _textValueCell(grade)),
        _row(3, 9, 'Variety', _textValueCell(variety)),
        _row(4, 9, 'Crop year', _textValueCell(cropYear)),
        _row(5, 9, 'Available quantity', _textValueCell(availQty)),
        _row(
          6,
          9,
          'Minimum Order Quantity (MOQ)',
          _textValueCell(moq),
        ),
        _row(7, 9, 'Delivery option', _textValueCell(deliveryOpt)),
        _row(8, 9, 'Delivery time', _textValueCell(deliveryTime)),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppText(
            text: 'Key Attributes',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          AppContainer(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            backgroundColor: AppColors.backGroundWhite,
            clipBehavior: Clip.antiAlias,
            child: Column(children: rows),
          ),
        ],
      );
    });
  }
}

/// Seller-only: sold quantity vs listed stock (same source as My Products / inventory).
class _StockSoldStatusBar extends StatelessWidget {
  const _StockSoldStatusBar({
    required this.productModel,
    required this.isSeller,
  });

  final ProductModel productModel;
  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    if (!isSeller) return const SizedBox.shrink();
    if (Get.isRegistered<AddNewProductCon>() &&
        _detailLiveFormOverlayActive(productModel)) {
      return Obx(() {
        final con = Get.find<AddNewProductCon>();
        _obxReadAddProductFormDeps(con);
        final listedQty = _detailListedQtyFromAddProductCon(con);
        final unit = _detailListedUnitFromAddProductCon(con);
        return _StockSoldStatusInner(
          sold: 0,
          listedQty: listedQty,
          unitLabel: unit.isEmpty ? productModel.unit : unit,
        );
      });
    }
    if (!Get.isRegistered<MyProductsCon>()) {
      return _StockSoldStatusInner(
        sold: 0,
        listedQty: productModel.stock.toDouble(),
        unitLabel: productModel.unit,
      );
    }
    return Obx(() {
      final c = Get.find<MyProductsCon>();
      final isBooking =
          productModel.productType == ProductType.advanceBooking ||
              productModel.productType == ProductType.booking;
      final sold = (isBooking
              ? (c.bookedQtyMap[productModel.id] ?? 0)
              : (c.soldQtyMap[productModel.id] ?? 0))
          .clamp(0.0, double.infinity);
      return _StockSoldStatusInner(
        sold: sold,
        listedQty: productModel.stock.toDouble(),
        unitLabel: productModel.unit,
      );
    });
  }
}

class _StockSoldStatusInner extends StatelessWidget {
  const _StockSoldStatusInner({
    required this.sold,
    required this.listedQty,
    required this.unitLabel,
  });

  final double sold;
  final double listedQty;
  final String unitLabel;

  static String _fmtQty(double q) {
    if (q.isNaN || q.isInfinite) return '0';
    final r = q.roundToDouble();
    if ((q - r).abs() < 0.001) return r.toInt().toString();
    return q.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final listed = listedQty <= 0 ? 1.0 : listedQty;
    final progress = (sold / listed).clamp(0.0, 1.0);

    return AppContainer(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      borderRadius: BorderRadius.circular(AppSize.radius8),
      backgroundColor: AppColors.backgroundSurface,
      border: Border.all(color: AppColors.borderLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                size: AppSize.icon20,
                color: AppColors.emeraldGreen,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: AppText(
                  text: 'Stock sold',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppText(
                text:
                    '${_fmtQty(sold)} / ${_fmtQty(listed)} ${unitLabel.trim()}',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.isNaN ? 0 : progress,
              minHeight: 8,
              backgroundColor: AppColors.borderLight,
              color: AppColors.emeraldGreen,
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            text:
                '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}% of listed stock sold',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.emphasized});

  final String text;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: BorderRadius.circular(AppSize.radiusCircular),
      backgroundColor: AppColors.backgroundSurface,
      border: Border.all(color: AppColors.borderLight),
      child: AppText(
        text: text,
        fontSize: AppSize.font12,
        fontWeight: emphasized ? FontWeight.w600 : FontWeight.w500,
        color: emphasized ? AppColors.textPrimary : AppColors.textSecondary,
      ),
    );
  }
}

class _SpecsSection extends StatelessWidget {
  const _SpecsSection({required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddNewProductCon>() ||
        !_detailLiveFormOverlayActive(productModel)) {
      final chips = _publishedQualitySpecsChips(productModel);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'Product Specifications',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 8),
          if (chips.isEmpty)
            const AppText(
              text: 'No specifications added',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            )
          else
            _SpecWrap(specs: chips),
        ],
      );
    }
    return Obx(() {
      final con = Get.find<AddNewProductCon>();
      _obxReadAddProductFormDeps(con);
      final chips = _liveSpecsFromAddProductCon(con);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'Product Specifications',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 8),
          if (chips.isEmpty)
            const AppText(
              text: 'No specifications added',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            )
          else
            _SpecWrap(specs: chips),
        ],
      );
    });
  }
}

class _SpecWrap extends StatelessWidget {
  const _SpecWrap({required this.specs});

  final List<Map<String, String>> specs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chipWidth = (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: specs.map((spec) {
            return SizedBox(
              width: chipWidth > 0 ? chipWidth : constraints.maxWidth,
              child: AppContainer(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
                backgroundColor: AppColors.backgroundSurface,
                child: AppText(
                  text: '${spec['name']}: ${spec['value']}${spec['unit']}',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}


