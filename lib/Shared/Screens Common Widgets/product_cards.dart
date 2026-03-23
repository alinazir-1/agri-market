import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/sizes.dart';
import '../../Data/Models/product_type_enums.dart';
import '../Common Widgets/c_container.dart';
import '../Common Widgets/c_text.dart';

class ProductCards extends StatelessWidget {
  final dynamic product; // ya BaseProduct use karo
  final ProductType type;

  const ProductCards({super.key, required this.product, required this.type});

  @override
  Widget build(BuildContext context) {
    return CContainer(
      borderRadius: BorderRadius.circular(CSize.radius20Large),
      backgroundColor: CColors.backGroundWhite,
      border: Border.all(width: CSize.borderWidth1, color: CColors.borderGray),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImageSection(), _buildBottomSection()],
      ),
    );
  }

  /// ================= IMAGE SECTION =================
  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(CSize.radius20Large),
            ),
            child: Image.network(
              product.images.first,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          /// Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ),

          /// Top Left Tag
          Positioned(top: 10, left: 10, child: _buildTopLeftTag()),

          /// Name + Location
          Positioned(
            left: 10,
            bottom: 10,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  text: product.name,
                  color: CColors.textWhite,
                  fontSize: CSize.font16Medium,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: CSize.icon16Small,
                      color: CColors.iconWhite,
                    ),
                    const SizedBox(width: CSize.space2),
                    Expanded(
                      child: CText(
                        text: "${product.origin} ${product.location}",
                        color: CColors.textWhite,
                        fontSize: CSize.font10XSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Grade
          Align(
            alignment: Alignment.topRight,
            child: CContainer(
              margin: const EdgeInsets.all(CSize.space10),
              padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8,
                vertical: CSize.space5,
              ),
              borderRadius: BorderRadius.circular(CSize.space10),
              backgroundColor: CColors.backGroundEmeraldGreen,
              child: CText(
                text: "Grade: ${product.grade}",
                color: CColors.textWhite,
                fontSize: CSize.font10XSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= TOP LEFT TAG =================
  Widget _buildTopLeftTag() {
    if (type == ProductType.auction) {
      return CContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: CColors.backgroundEmerald100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.circle, size: 8, color: Colors.red),
            SizedBox(width: 4),
            CText(
              text: "LIVE",
              color: CColors.textRichRed,
              fontSize: CSize.font10XSmall,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      );
    }

    return CContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: CColors.backgroundEmerald100,
      child: CText(
        text: product.status == ProductStatus.active ? "Active" : "Pending",
        color: product.status == ProductStatus.active
            ? CColors.textEmeraldGreen
            : CColors.textRichRed,
        fontSize: CSize.font10XSmall,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// ================= BOTTOM SECTION =================
  Widget _buildBottomSection() {
    if (type == ProductType.auction) {
      return _buildAuctionContent();
    } else if (type == ProductType.booking) {
      return _buildBookingContent();
    } else {
      return _buildMarketplaceContent();
    }
  }

  /// ================= MARKETPLACE =================
  Widget _buildMarketplaceContent() {
    return _commonStockLayout(
      priceLabel: "PRICE",
      stockLabel: "TOTAL STOCK",
      moqLabel: "MOQ",
    );
  }

  /// ================= BOOKING =================
  Widget _buildBookingContent() {
    return _commonStockLayout(
      priceLabel: "BOOKING PRICE",
      stockLabel: "TOTAL SLOTS",
      moqLabel: "MIN BOOKING",
    );
  }

  /// ================= COMMON STOCK UI =================
  Widget _commonStockLayout({
    required String priceLabel,
    required String stockLabel,
    required String moqLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.all(CSize.space8),
      child: Column(
        children: [
          _row(priceLabel, "\$${product.price}/${product.unit}"),
          _row(stockLabel, "${product.stock} ${product.unit}"),
          _row(moqLabel, "${product.minOrderQty} ${product.unit}"),

          const SizedBox(height: CSize.space5),

          LinearProgressIndicator(value: 0.3, minHeight: 6),
        ],
      ),
    );
  }

  /// ================= AUCTION =================
  Widget _buildAuctionContent() {
    return Padding(
      padding: const EdgeInsets.all(CSize.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CText(
            text: "\$${product.currentBid}",
            fontSize: CSize.font16Medium,
            fontWeight: FontWeight.w700,
            color: CColors.textEmeraldGreen,
          ),

          const SizedBox(height: 4),

          CText(
            text: "Starting: \$${product.startingBid}",
            fontSize: CSize.font10XSmall,
          ),

          CText(
            text: "${product.totalBids} bids",
            fontSize: CSize.font10XSmall,
          ),

          CText(text: "2h left", fontSize: CSize.font10XSmall),
        ],
      ),
    );
  }

  /// ================= ROW HELPER =================
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CSize.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CText(
            text: title,
            fontSize: CSize.font10XSmall,
            fontWeight: FontWeight.w900,
          ),
          CText(text: value, fontSize: CSize.font10XSmall),
        ],
      ),
    );
  }
}
