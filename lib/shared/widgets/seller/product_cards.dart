import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import '../common/app_container.dart';
import '../common/app_text.dart';

class ProductCards extends StatelessWidget {
  final dynamic product;
  final ProductType type;

  const ProductCards({
    super.key,
    required this.product,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      borderRadius: BorderRadius.circular(AppSize.radius20),
      backgroundColor: context.cardBg,
      border: Border.all(
        width: AppSize.borderWidth1,
        color: AppColors.borderGray,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(context),
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSize.radius20),
            ),
            child: Image.asset(
              product.images.isNotEmpty ? product.images.first : '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => AppContainer(
                backgroundColor: AppColors.emerald100,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: AppSize.icon32,
                    color: AppColors.iconEmeraldGreen,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AppContainer(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  AppColors.shadowBase.withValues(alpha: 0.6),
                  AppColors.backGroundTransparent,
                ],
              ),
            ),
          ),
          Positioned(
            top: AppSize.space8, // Closest to 10
            left: AppSize.space8,
            child: _buildTopLeftTag(),
          ),
          Positioned(
            left: AppSize.space8,
            bottom: AppSize.space8,
            right: AppSize.space64, // Closest to 80
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: product.name,
                  color: AppColors.textWhite,
                  fontSize: AppSize.font16,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: AppSize.icon16,
                      color: AppColors.iconWhite,
                    ),
                    const SizedBox(width: AppSize.space2),
                    Expanded(
                      child: AppText(
                        text: '${product.origin} ${product.location}',
                        color: AppColors.textWhite,
                        fontSize: AppSize.font10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: AppContainer(
              margin: const EdgeInsets.all(AppSize.space8),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8,
                vertical: AppSize.space4, // Closest to 5
              ),
              borderRadius:
                  BorderRadius.circular(AppSize.radius8), // Closest to 10
              backgroundColor: AppColors.emeraldGreen,
              child: AppText(
                text: 'Grade: ${product.grade}',
                color: AppColors.textWhite,
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopLeftTag() {
    if (type == ProductType.liveAuction) {
      return AppContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space8,
          vertical: AppSize.space4,
        ),
        borderRadius: BorderRadius.circular(AppSize.radius8),
        backgroundColor: AppColors.emerald100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.circle,
              size: AppSize.space8,
              color: AppColors.notificationDot,
            ),
            SizedBox(width: AppSize.space4),
            AppText(
              text: 'LIVE',
              color: AppColors.notificationDot,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      );
    }

    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space4,
      ),
      borderRadius: BorderRadius.circular(AppSize.radius8),
      backgroundColor: AppColors.emerald100,
      child: AppText(
        text: product.status == ProductStatus.active ? 'Active' : 'Pending',
        color: product.status == ProductStatus.active
            ? AppColors.textEmeraldGreen
            : AppColors.notificationDot,
        fontSize: AppSize.font10,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    if (type == ProductType.liveAuction) {
      return _buildAuctionContent(context);
    } else if (type == ProductType.advanceBooking) {
      return _buildBookingContent(context);
    } else {
      return _buildMarketplaceContent(context);
    }
  }

  Widget _buildMarketplaceContent(BuildContext context) {
    return _commonStockLayout(
      context: context,
      priceLabel: 'PRICE',
      stockLabel: 'TOTAL STOCK',
      moqLabel: 'MOQ',
    );
  }

  Widget _buildBookingContent(BuildContext context) {
    return _commonStockLayout(
      context: context,
      priceLabel: 'BOOKING PRICE',
      stockLabel: 'TOTAL SLOTS',
      moqLabel: 'MIN BOOKING',
    );
  }

  Widget _commonStockLayout({
    required BuildContext context,
    required String priceLabel,
    required String stockLabel,
    required String moqLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.space8),
      child: Column(
        children: [
          _row(context, priceLabel, '\$${product.price}/${product.unit}'),
          _row(context, stockLabel, '${product.stock} ${product.unit}'),
          _row(context, moqLabel, '${product.minOrderQty} ${product.unit}'),
          const SizedBox(height: AppSize.space4), // Closest to 5
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.radius24),
            child: LinearProgressIndicator(
              value: 0.3,
              minHeight: AppSize.space4, // Closest to 6
              backgroundColor: AppColors.borderGray,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.emeraldGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: '\$${product.currentBid}',
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w700,
            color: AppColors.textEmeraldGreen,
          ),
          const SizedBox(height: AppSize.space4),
          AppText(
            text: 'Starting: \$${product.startingBid}',
            fontSize: AppSize.font10,
            color: context.txtSecondary,
          ),
          AppText(
            text: '${product.totalBids} bids',
            fontSize: AppSize.font10,
            color: context.txtSecondary,
          ),
          AppText(
            text: '2h left',
            fontSize: AppSize.font10,
            color: AppColors.textWarning,
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: title,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w900,
            color: context.txtPrimary,
          ),
          AppText(
            text: value,
            fontSize: AppSize.font10,
            color: context.txtSecondary,
          ),
        ],
      ),
    );
  }
}
