// import 'package:agri/Seller%20Section/Seller%20Screens/Live%20Auctions/live_auctions_con.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
//
// import '../../../Core/Constant/colors.dart';
// import '../../../Core/Constant/sizes.dart';
// import '../../../Data/Models/product_type_enums.dart';
// import '../../../Shared/Common Widgets/c_container.dart';
// import '../../../Shared/Common Widgets/c_outlined_button.dart';
// import '../../../Shared/Common Widgets/c_text.dart';
// import '../../../Shared/Screens Common Widgets/category_section.dart';
// import '../../../Shared/Screens Common Widgets/top_bar.dart';
// import '../Marketplace/marketplace_con.dart';
//
// class LiveAuctionsScr extends StatelessWidget {
//   final MarketplaceCon marketPlaceController = Get.find();
//   final LiveAuctionsCon liveAuctionsController = Get.put(LiveAuctionsCon());
//   LiveAuctionsScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CColors.backGroundWhite,
//       body: SafeArea(
//         child: Column(
//           children: [
//             TopBar(title: "Live Auctions"),
//
//             const SizedBox(height: CSize.space8),
//
//             Expanded(
//               flex: 7,
//               child: Obx(
//                 () => GridView.builder(
//                   itemCount: liveAuctionsController.products.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 5,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 0.80,
//                   ),
//                   itemBuilder: (context, index) {
//                     final product = liveAuctionsController.products[index];
//
//                     // ── Countdown string from auctionEndTime ──────────────────────────
//                     final Duration remaining = product.auctionEndTime
//                         .difference(DateTime.now());
//                     final String timerText = remaining.isNegative
//                         ? "Ended"
//                         : "${remaining.inHours.toString().padLeft(2, '0')}:"
//                               "${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:"
//                               "${(remaining.inSeconds % 60).toString().padLeft(2, '0')}";
//
//                     return CContainer(
//                       borderRadius: BorderRadius.circular(CSize.radius20Large),
//                       backgroundColor: CColors.backGroundWhite,
//                       border: Border.all(
//                         width: CSize.borderWidth1,
//                         color: CColors.borderGray,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // ══════════════════════════════════════
//                           //  TIMER HEADER BAR  (image se bilkul upar)
//                           // ══════════════════════════════════════
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: CSize.space10,
//                               vertical: CSize.space5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: remaining.isNegative
//                                   ? CColors.backGroundOrange
//                                   : CColors.backGroundEmeraldGreen,
//                               borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(CSize.radius20Large),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Left: Clock icon + label
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(
//                                       Icons.access_time_rounded,
//                                       size: CSize.icon16Small,
//                                       color: CColors.iconWhite,
//                                     ),
//                                     const SizedBox(width: CSize.space4),
//                                     CText(
//                                       text: "Time Left",
//                                       color: CColors.textWhite,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ],
//                                 ),
//
//                                 // Right: Blinking dot + countdown
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     // Blinking dot (only when active)
//                                     if (!remaining.isNegative)
//                                       TweenAnimationBuilder<double>(
//                                         tween: Tween(begin: 1.0, end: 0.15),
//                                         duration: const Duration(
//                                           milliseconds: 900,
//                                         ),
//                                         builder: (context, value, child) {
//                                           return Opacity(
//                                             opacity: value,
//                                             child: child,
//                                           );
//                                         },
//                                         onEnd: () {},
//                                         child: Container(
//                                           width: 6,
//                                           height: 6,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                       ),
//
//                                     if (!remaining.isNegative)
//                                       const SizedBox(width: CSize.space5),
//
//                                     CText(
//                                       text: timerText,
//                                       color: CColors.textWhite,
//                                       fontSize: CSize.font13Small,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // ══════════════════════════════════════
//                           //  IMAGE SECTION
//                           // ══════════════════════════════════════
//                           AspectRatio(
//                             aspectRatio: 1.7,
//                             child: Stack(
//                               children: [
//                                 // ── Product Image ──
//                                 ClipRRect(
//                                   child: Image.network(
//                                     product.images.first,
//                                     fit: BoxFit.cover,
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     loadingBuilder:
//                                         (context, child, loadingProgress) {
//                                           if (loadingProgress == null)
//                                             return child;
//                                           return const Center(
//                                             child: CircularProgressIndicator(),
//                                           );
//                                         },
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return const Center(
//                                         child: Icon(
//                                           Icons.broken_image,
//                                           size: 40,
//                                           color: Colors.grey,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//
//                                 // ── Bottom Gradient Overlay ──
//                                 Positioned.fill(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.bottomCenter,
//                                         end: Alignment.center,
//                                         colors: [
//                                           Colors.black.withOpacity(0.62),
//                                           Colors.transparent,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 // ── TOP LEFT: Status Badge ──
//                                 Positioned(
//                                   top: 8,
//                                   left: 8,
//                                   child: CContainer(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4,
//                                     ),
//                                     borderRadius: BorderRadius.circular(6),
//                                     backgroundColor:
//                                         product.status == ProductStatus.active
//                                         ? CColors.backgroundEmerald100
//                                         : CColors.backGroundOrange,
//                                     child: CText(
//                                       text: "product.status",
//                                       color:
//                                           product.status == ProductStatus.active
//                                           ? CColors.textEmeraldGreen
//                                           : CColors.textWhite,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ),
//
//                                 // ── BOTTOM LEFT: Product Name + Location ──
//                                 Positioned(
//                                   left: CSize.space10,
//                                   bottom: CSize.space8,
//                                   right: CSize.space10,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       CText(
//                                         text: product.name,
//                                         color: CColors.textWhite,
//                                         fontSize: CSize.font16Medium,
//                                         fontWeight: FontWeight.w700,
//                                         maxLines: 2,
//                                       ),
//                                       const SizedBox(height: CSize.space2),
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.location_on_outlined,
//                                             size: CSize.icon16Small,
//                                             color: CColors.iconWhite,
//                                           ),
//                                           const SizedBox(width: CSize.space2),
//                                           Expanded(
//                                             child: CText(
//                                               text:
//                                                   "${product.origin} ${product.location}",
//                                               color: CColors.textWhite,
//                                               fontSize: CSize.font10XSmall,
//                                               fontWeight: FontWeight.w400,
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           const SizedBox(width: CSize.space4),
//                                           CContainer(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: CSize.space5,
//                                               vertical: CSize.space2,
//                                             ),
//
//                                             backgroundColor:
//                                                 CColors.backGroundAmber,
//                                             borderRadius: BorderRadius.circular(
//                                               CSize.radius5Small,
//                                             ),
//                                             child: CText(
//                                               text: "GRADE ${product.grade}",
//                                               color: CColors.textPrimary,
//                                               fontSize: CSize.font10XSmall,
//                                               fontWeight: FontWeight.w800,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // ══════════════════════════════════════
//                           //  INFO SECTION
//                           // ══════════════════════════════════════
//                           Padding(
//                             padding: const EdgeInsets.all(CSize.space8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // ── Starting Price ──
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     CText(
//                                       text: "STARTING PRICE",
//                                       color: CColors.textPrimary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         CText(
//                                           text: "\$${product.startingBid}",
//                                           color: CColors.textEmeraldGreen,
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w700,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         CText(
//                                           text: "/${product.unit}",
//                                           color: CColors.textSecondary,
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: CSize.space2),
//
//                                 // ── Current Bid ──
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     CText(
//                                       text: "CURRENT BID",
//                                       color: CColors.textPrimary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         CText(
//                                           text: "\$${product.currentBid}",
//                                           color: CColors.textEmeraldGreen,
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w700,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         CText(
//                                           text: "/${product.unit}",
//                                           color: CColors.textSecondary,
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: CSize.space2),
//
//                                 // ── Thin Divider ──
//                                 const Divider(
//                                   height: 6,
//                                   thickness: 0.5,
//                                   color: CColors.borderGray,
//                                 ),
//
//                                 const SizedBox(height: CSize.space2),
//
//                                 // ── Total Bids ──
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     CText(
//                                       text: "TOTAL BIDS",
//                                       color: CColors.textPrimary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                     CText(
//                                       text: "${product.totalBids}",
//                                       color: CColors.textSecondary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w600,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: CSize.space8),
//
//                                 // ── Buttons ──
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: COutlineButton(
//                                         text: "Edit",
//                                         textColor: CColors.textEmeraldGreen,
//                                         fontSize: CSize.font16Medium,
//                                         fontWeight: FontWeight.w500,
//                                         icon: Icons.edit_outlined,
//                                         iconSize: CSize.icon20Medium,
//                                         iconColor: CColors.iconEmeraldGreen,
//                                         border: BorderSide(
//                                           color: CColors.borderDarkGray,
//                                         ),
//                                         hoverBorderColor:
//                                             CColors.borderEmeraldGreen,
//                                         hoverBackgroundColor:
//                                             CColors.backgroundEmerald100,
//                                         borderRadius: CSize.radius10Medium,
//                                         onPressed: () {},
//                                       ),
//                                     ),
//                                     const SizedBox(width: CSize.space8),
//                                     COutlineButton(
//                                       height: 30,
//                                       width: 30,
//                                       icon: Icons.delete_outline_outlined,
//                                       iconSize: CSize.icon20Medium,
//                                       iconColor: CColors.iconError,
//                                       border: BorderSide(
//                                         color: CColors.borderError,
//                                       ),
//                                       hoverBorderColor: CColors.borderError,
//                                       hoverBackgroundColor:
//                                           CColors.backgroundErrorLight,
//                                       borderRadius: CSize.radius10Medium,
//                                       onPressed: () {},
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:agri_market/Shared/Screens%20Common%20Widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Data/Models/live_auction_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';
import '../Customers/customers_con.dart';
import 'live_auctions_con.dart';

class LiveAuctionsScr extends StatelessWidget {
  final LiveAuctionsCon c = Get.put(LiveAuctionsCon());

  LiveAuctionsScr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _categoryBar(),
            _filterBar(),
            Expanded(child: _productGrid()),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ════════════════════════════════════════════════════════════════════════════

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space20,
        vertical: CSize.space12,
      ),
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Live Auctions",
                style: TextStyle(
                  fontSize: CSize.font24Large,
                  fontWeight: FontWeight.w900,
                  color: CColors.textPrimary,
                ),
              ),
              SizedBox(height: CSize.space2),
              Text(
                "Manage your live auction listings",
                style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(width: CSize.space20),

          SizedBox(
            width: 300,
            height: 36,
            child: TextField(
              controller: c.searchController,
              onChanged: c.onSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: "Search auctions...",
                hintStyle: const TextStyle(
                  fontSize: 11,
                  color: CColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: CSize.icon16Small,
                  color: CColors.iconEmeraldGreen,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: CSize.space10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(
                    color: CColors.borderEmeraldGreen,
                    width: CSize.borderWidth1,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Notification
          Stack(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: CColors.backGroundWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: CSize.icon16Small,
                  color: CColors.iconEmeraldGreen,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: CColors.notificationDot,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CColors.backGroundWhite,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: CSize.space8),

          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: CColors.backGroundWhite,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(
              Icons.messenger_outline_rounded,
              size: CSize.icon16Small,
              color: CColors.iconEmeraldGreen,
            ),
          ),

          const SizedBox(width: CSize.space8),

          CircleAvatar(
            radius: 17,
            backgroundColor: CColors.backGroundEmeraldGreen,
            child: const Text(
              "AS",
              style: TextStyle(
                fontSize: CSize.font10XSmall,
                fontWeight: FontWeight.w800,
                color: CColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  CATEGORY BAR
  // ════════════════════════════════════════════════════════════════════════════

  Widget _categoryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space20,
        vertical: CSize.space10,
      ),
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Obx(
            () => GestureDetector(
              onTap: c.selectedCategoryIndex.value > 0
                  ? c.scrollCategoryPrev
                  : null,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: CSize.font10XSmall,
                  color: c.selectedCategoryIndex.value > 0
                      ? CColors.iconEmeraldGreen
                      : CColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: CSize.space8),
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                controller: c.categoryScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: c.categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: CSize.space8),
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isActive = c.selectedCategoryIndex.value == index;
                    return GestureDetector(
                      onTap: () => c.selectCategory(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space14,
                          vertical: CSize.space7,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? CColors.backGroundEmeraldGreen
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(
                            CSize.radius20Large,
                          ),
                          border: Border.all(
                            color: isActive
                                ? CColors.borderEmeraldGreen
                                : const Color(0xFFE2E8F0),
                            width: CSize.borderWidth1,
                          ),
                        ),
                        child: Text(
                          c.categories[index].name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? CColors.textWhite
                                : CColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: CSize.space8),
          Obx(
            () => GestureDetector(
              onTap: c.selectedCategoryIndex.value < c.categories.length - 1
                  ? c.scrollCategoryNext
                  : null,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: CSize.font10XSmall,
                  color: c.selectedCategoryIndex.value < c.categories.length - 1
                      ? CColors.iconEmeraldGreen
                      : CColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  FILTER BAR
  // ════════════════════════════════════════════════════════════════════════════

  Widget _filterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space20,
        vertical: CSize.space8,
      ),
      decoration: const BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Obx(
        () => Row(
          children: [
            const Text(
              "Status:",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(width: CSize.space8),
            _filterChip("All", AuctionFilter.all),
            const SizedBox(width: CSize.space5),
            _filterChip("Active", AuctionFilter.active),
            const SizedBox(width: CSize.space5),
            _filterChipRed("Ended", AuctionFilter.ended),
            Container(
              width: 1,
              height: 16,
              color: const Color(0xFFE2E8F0),
              margin: const EdgeInsets.symmetric(horizontal: CSize.space10),
            ),
            const Text(
              "Bids:",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(width: CSize.space8),
            _filterChipAmber("High Bids (20+)", AuctionFilter.highBids),
            const Spacer(),
            Obx(
              () => Text(
                "${c.filteredProducts.length} auctions",
                style: const TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: CSize.space8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CSize.space12,
                vertical: CSize.space5,
              ),
              decoration: BoxDecoration(
                color: CColors.backGroundWhite,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AuctionSortOption>(
                  value: c.selectedSort.value,
                  isDense: true,
                  style: const TextStyle(
                    fontSize: CSize.font10XSmall,
                    fontWeight: FontWeight.w600,
                    color: CColors.textPrimary,
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: CSize.icon16Small,
                    color: CColors.iconEmeraldGreen,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: AuctionSortOption.latest,
                      child: Text("Sort: Latest"),
                    ),
                    DropdownMenuItem(
                      value: AuctionSortOption.oldest,
                      child: Text("Sort: Oldest"),
                    ),
                    DropdownMenuItem(
                      value: AuctionSortOption.endingSoon,
                      child: Text("Ending Soon"),
                    ),
                    DropdownMenuItem(
                      value: AuctionSortOption.highestBid,
                      child: Text("Highest Bid"),
                    ),
                    DropdownMenuItem(
                      value: AuctionSortOption.mostBids,
                      child: Text("Most Bids"),
                    ),
                  ],
                  onChanged: (val) =>
                      c.setSort(val ?? AuctionSortOption.latest),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, AuctionFilter filter) {
    return Obx(() {
      final isActive = c.selectedFilter.value == filter;
      return GestureDetector(
        onTap: () => c.setFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space4,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? CColors.backGroundEmeraldGreen
                : CColors.backGroundWhite,
            borderRadius: BorderRadius.circular(CSize.radius20Large),
            border: Border.all(
              color: isActive
                  ? CColors.borderEmeraldGreen
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: CSize.font10XSmall,
              fontWeight: FontWeight.w600,
              color: isActive ? CColors.textWhite : CColors.textSecondary,
            ),
          ),
        ),
      );
    });
  }

  Widget _filterChipRed(String label, AuctionFilter filter) {
    return Obx(() {
      final isActive = c.selectedFilter.value == filter;
      return GestureDetector(
        onTap: () => c.setFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space4,
          ),
          decoration: BoxDecoration(
            color: isActive ? CColors.borderError : CColors.backGroundWhite,
            borderRadius: BorderRadius.circular(CSize.radius20Large),
            border: Border.all(
              color: isActive ? CColors.borderError : const Color(0xFFFCA5A5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: CSize.font10XSmall,
              fontWeight: FontWeight.w600,
              color: isActive ? CColors.textWhite : CColors.textRichRed,
            ),
          ),
        ),
      );
    });
  }

  Widget _filterChipAmber(String label, AuctionFilter filter) {
    return Obx(() {
      final isActive = c.selectedFilter.value == filter;
      return GestureDetector(
        onTap: () => c.setFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space4,
          ),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFBBF24) : CColors.backGroundWhite,
            borderRadius: BorderRadius.circular(CSize.radius20Large),
            border: Border.all(
              color:
                  isActive ? const Color(0xFFFBBF24) : const Color(0xFFFDE68A),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: CSize.font10XSmall,
              fontWeight: FontWeight.w600,
              color:
                  isActive ? const Color(0xFF78350F) : const Color(0xFF92400E),
            ),
          ),
        ),
      );
    });
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  PRODUCT GRID
  // ════════════════════════════════════════════════════════════════════════════

  Widget _productGrid() {
    return Obx(() {
      final products = c.filteredProducts;
      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.gavel_outlined,
                size: CSize.icon36XLarge,
                color: CColors.textSecondary,
              ),
              SizedBox(height: CSize.space12),
              Text(
                "No auctions found",
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.all(CSize.space16),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: CSize.space12,
          mainAxisSpacing: CSize.space12,
          childAspectRatio: 0.80,
        ),
        itemBuilder: (context, index) => _productCard(products[index]),
      );
    });
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  PRODUCT CARD
  // ════════════════════════════════════════════════════════════════════════════

  Widget _productCard(LiveAuctionProductModel product) {
    final bool ended = c.isEnded(product);
    final bool endingSoon = c.isEndingSoon(product);
    final String timer = c.timerText(product);

    // Header color logic
    final Color headerColor = ended
        ? CColors.backGroundOrange
        : endingSoon
            ? const Color(0xFFB45309)
            : CColors.backGroundEmeraldGreen;

    return Container(
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: endingSoon && !ended
              ? const Color(0xFFFED7AA)
              : const Color(0xFFE2E8F0),
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── TIMER HEADER BAR ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space10,
              vertical: CSize.space5,
            ),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(CSize.radius20Large),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Clock + label
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.access_time_rounded,
                      size: CSize.icon16Small,
                      color: CColors.iconWhite,
                    ),
                    SizedBox(width: CSize.space4),
                    Text(
                      "Time Left",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w500,
                        color: CColors.textWhite,
                      ),
                    ),
                  ],
                ),

                // Right: Blinking dot + timer
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!ended)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 0.15),
                        duration: const Duration(milliseconds: 900),
                        builder: (context, value, child) =>
                            Opacity(opacity: value, child: child),
                        onEnd: () {},
                        child: Container(
                          width: CSize.space8,
                          height: CSize.space8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    if (!ended) const SizedBox(width: CSize.space5),
                    Text(
                      timer,
                      style: const TextStyle(
                        fontSize: CSize.font13Small,
                        fontWeight: FontWeight.w700,
                        color: CColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── IMAGE SECTION ──────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 1.7,
            child: Stack(
              children: [
                ClipRRect(
                  child: Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, _) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: CSize.icon36XLarge,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(0.62),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // TOP LEFT: Status badge
                Positioned(
                  top: CSize.space8,
                  left: CSize.space8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space8,
                      vertical: CSize.space4,
                    ),
                    decoration: BoxDecoration(
                      color: product.status == ProductStatus.active
                          ? CColors.backgroundEmerald100.withOpacity(0.95)
                          : CColors.backGroundOrange.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(CSize.radius5Small),
                    ),
                    child: Text(
                      product.status?.name ?? "",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w700,
                        color: product.status == ProductStatus.active
                            ? CColors.textEmeraldGreen
                            : CColors.textWhite,
                      ),
                    ),
                  ),
                ),

                // BOTTOM: Name + location + grade
                Positioned(
                  left: CSize.space10,
                  bottom: CSize.space8,
                  right: CSize.space10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: CSize.font16Medium,
                          fontWeight: FontWeight.w700,
                          color: CColors.textWhite,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: CSize.space2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: CSize.icon16Small,
                            color: CColors.iconWhite,
                          ),
                          const SizedBox(width: CSize.space2),
                          Expanded(
                            child: Text(
                              "${product.origin} ${product.location}",
                              style: TextStyle(
                                fontSize: CSize.font10XSmall,
                                color: CColors.textWhite.withOpacity(0.78),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: CSize.space4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: CSize.space5,
                              vertical: CSize.space2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius: BorderRadius.circular(
                                CSize.radius5Small,
                              ),
                            ),
                            child: Text(
                              "GRADE ${product.grade}",
                              style: const TextStyle(
                                fontSize: CSize.font10XSmall,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF78350F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── INFO SECTION ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(CSize.space8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Starting Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "STARTING PRICE",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w900,
                        color: CColors.textPrimary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${product.startingBid}",
                          style: const TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w700,
                            color: CColors.textEmeraldGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "/${product.unit}",
                          style: const TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w600,
                            color: CColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space2),

                // Current Bid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "CURRENT BID",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w900,
                        color: CColors.textPrimary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${product.currentBid}",
                          style: const TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w700,
                            color: CColors.textEmeraldGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "/${product.unit}",
                          style: const TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w600,
                            color: CColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space2),

                // Divider
                const Divider(
                  height: CSize.space8,
                  thickness: CSize.borderWidth05,
                  color: CColors.borderGray,
                ),

                const SizedBox(height: CSize.space2),

                // Total Bids
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL BIDS",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w900,
                        color: CColors.textPrimary,
                      ),
                    ),
                    Text(
                      "${product.totalBids}",
                      style: const TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w600,
                        color: CColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space5),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => c.editProduct(product),
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: CSize.icon16Small,
                          color: CColors.iconEmeraldGreen,
                        ),
                        label: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w500,
                            color: CColors.textEmeraldGreen,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: CColors.borderDarkGray,
                            width: CSize.borderWidth1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              CSize.radius10Medium,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: CSize.space4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: CSize.space8),
                    SizedBox(
                      height: CSize.space32,
                      width: CSize.space32,
                      child: OutlinedButton(
                        onPressed: () => c.deleteProduct(product.id),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(
                            color: CColors.borderError,
                            width: CSize.borderWidth1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              CSize.radius10Medium,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline_outlined,
                          size: CSize.icon20Medium,
                          color: CColors.iconError,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
