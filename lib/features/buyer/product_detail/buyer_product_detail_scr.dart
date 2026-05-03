import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_top_bar.dart';
import 'package:agri_market/features/buyer/product_detail/buyer_product_detail_con.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_breadcrumb_trail.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_about_seller_card.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_gallery_section.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_header.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_more_listings.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_order_card.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_payment_section.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_recent_orders_card.dart';
import 'package:agri_market/features/buyer/product_detail/widgets/buyer_product_detail_specs_table.dart';

/// Buyer product detail — top bar, breadcrumb, header, then two [Expanded] panes
/// (left: rich red tint; right: indigo — pricing rail).
class BuyerProductDetailScr extends StatelessWidget {
  const BuyerProductDetailScr({super.key, required this.scopeTag});

  final String scopeTag;

  static const double _wideBreakpoint = 1040;

  @override
  Widget build(BuildContext context) {
    final BuyerProductDetailCon controller =
        Get.find<BuyerProductDetailCon>(tag: scopeTag);

    return Scaffold(
      backgroundColor: AppColors.backGroundWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BuyerTopBar(
            categoriesMenuAnchorKey: controller.categoriesMenuAnchorKey,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < _wideBreakpoint;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSize.space32,
                        AppSize.space16,
                        AppSize.space32,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuyerProductBreadcrumbTrail(
                            categoryLabel: controller.product.category,
                            productName: controller.product.name,
                          ),
                          const SizedBox(height: AppSize.space16),
                          BuyerProductDetailHeader(controller: controller),
                          const SizedBox(height: AppSize.space24),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _splitPanes(controller, narrow: narrow),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Two [Expanded] columns — left [flex] 2, right 1 (2∶1 width share).
  Widget _splitPanes(BuyerProductDetailCon controller, {required bool narrow}) {
    const leftFlex = 2;
    const rightFlex = 1;
    final leftPad = EdgeInsets.fromLTRB(
      AppSize.space32,
      AppSize.space16,
      narrow ? AppSize.space8 : AppSize.space16,
      AppSize.space32,
    );
    final rightPad = EdgeInsets.fromLTRB(
      narrow ? AppSize.space8 : AppSize.space16,
      AppSize.space16,
      AppSize.space32,
      AppSize.space32,
    );

    // One vertical scroll: both columns move together (no nested column scrolls).
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: leftFlex,
            child: ColoredBox(
              color: AppColors.backgroundProductDetailLeft,
              child: Padding(
                padding: leftPad,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuyerProductDetailGallerySection(controller: controller),
                    const SizedBox(height: AppSize.space24),
                    BuyerProductDetailSpecsTable(controller: controller),
                    const SizedBox(height: AppSize.space24),
                    const BuyerProductDetailMoreListings(),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: rightFlex,
            child: ColoredBox(
              color: AppColors.backgroundProductDetailRight,
              child: Padding(
                padding: rightPad,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BuyerProductDetailOrderCard(controller: controller),
                    const SizedBox(height: AppSize.space16),
                    const BuyerProductDetailPaymentSection(),
                    const SizedBox(height: AppSize.space16),
                    const BuyerProductDetailAboutSellerCard(),
                    const SizedBox(height: AppSize.space16),
                    const BuyerProductDetailRecentOrdersCard(),
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
