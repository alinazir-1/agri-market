// import 'package:agri/Core/Constant/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Core/Constant/colors.dart';
// import '../../../Data/Models/product_type_enums.dart';
// import '../../../Shared/Screens Common Widgets/category_section.dart';
// import '../../../Shared/Screens Common Widgets/top_bar.dart';
// import 'marketplace_con.dart';
//
// class MarketplaceScr extends StatelessWidget {
//   final MarketplaceCon marketPlaceController = Get.find();
//
//   MarketplaceScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CColors.backGroundWhite,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(CSize.space12),
//           child: Column(
//             children: [
//               // ── Top Bar ──
//               TopBar(title: "MarketPlace"),
//
//               const SizedBox(height: CSize.space8),
//
//               // ── Category Section ──
//               CategorySection(marketPlaceController: marketPlaceController),
//
//               // ── Product Grid ──
//               Expanded(
//                 flex: 7,
//                 child: Obx(
//                   () => GridView.builder(
//                     itemCount: marketPlaceController.products.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 5,
//                           crossAxisSpacing: CSize.space10,
//                           mainAxisSpacing: CSize.space10,
//                           childAspectRatio: 0.80,
//                         ),
//                     itemBuilder: (context, index) {
//                       final product = marketPlaceController.products[index];
//
//                       // ── Progress calculation ──
//                       final double soldQty =
//                           150; // replace with product.soldQty
//                       final double totalStock = (product.stock ?? 1).toDouble();
//                       final double progress = (soldQty / totalStock).clamp(
//                         0.0,
//                         1.0,
//                       );
//                       final bool isLowStock = progress >= 0.8;
//
//                       return Container(
//                         decoration: BoxDecoration(
//                           color: CColors.backGroundWhite,
//                           borderRadius: BorderRadius.circular(
//                             CSize.radius20Large,
//                           ),
//                           border: Border.all(
//                             width: CSize.borderWidth1,
//                             color: CColors.borderGray,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // ════════════════════════════════════
//                             //  IMAGE SECTION
//                             // ════════════════════════════════════
//                             AspectRatio(
//                               aspectRatio: 1.7,
//                               child: Stack(
//                                 children: [
//                                   // ── Product Image ──
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.vertical(
//                                       top: Radius.circular(CSize.radius20Large),
//                                     ),
//                                     child: Image.network(
//                                       product.images.first,
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                       height: double.infinity,
//                                       loadingBuilder:
//                                           (context, child, loadingProgress) {
//                                             if (loadingProgress == null)
//                                               return child;
//                                             return const Center(
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             );
//                                           },
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                             return const Center(
//                                               child: Icon(
//                                                 Icons.broken_image,
//                                                 size: CSize.icon36XLarge,
//                                                 color: Colors.grey,
//                                               ),
//                                             );
//                                           },
//                                     ),
//                                   ),
//
//                                   // ── Bottom Gradient Overlay ──
//                                   Positioned.fill(
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           begin: Alignment.bottomCenter,
//                                           end: Alignment.center,
//                                           colors: [
//                                             Colors.black.withOpacity(0.65),
//                                             Colors.transparent,
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   // ── TOP LEFT: Status Badge ──
//                                   Positioned(
//                                     top: CSize.space8,
//                                     left: CSize.space8,
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: CSize.space8,
//                                         vertical: CSize.space4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color:
//                                             product.status ==
//                                                 ProductStatus.active
//                                             ? CColors.backgroundEmerald100
//                                             : CColors.backgroundErrorLight,
//                                         borderRadius: BorderRadius.circular(
//                                           CSize.radius5Small,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         product.status == ProductStatus.active
//                                             ? "Active"
//                                             : "Pending",
//                                         style: TextStyle(
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w700,
//                                           color:
//                                               product.status ==
//                                                   ProductStatus.active
//                                               ? CColors.textEmeraldGreen
//                                               : CColors.textRichRed,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   // ── BOTTOM: Product Name + Location + Grade Pill ──
//                                   Positioned(
//                                     left: CSize.space10,
//                                     bottom: CSize.space8,
//                                     right: CSize.space10,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           product.name,
//                                           style: const TextStyle(
//                                             fontSize: CSize.font16Medium,
//                                             fontWeight: FontWeight.w700,
//                                             color: CColors.textWhite,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         const SizedBox(height: CSize.space2),
//                                         Row(
//                                           children: [
//                                             const Icon(
//                                               Icons.location_on_outlined,
//                                               size: CSize.icon16Small,
//                                               color: CColors.iconWhite,
//                                             ),
//                                             const SizedBox(width: CSize.space2),
//                                             Expanded(
//                                               child: Text(
//                                                 "${product.origin} ${product.location}",
//                                                 style: const TextStyle(
//                                                   fontSize: CSize.font10XSmall,
//                                                   fontWeight: FontWeight.w400,
//                                                   color: CColors.textWhite,
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             const SizedBox(width: CSize.space4),
//
//                                             // Amber Grade Pill
//                                             Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: CSize.space5,
//                                                     vertical: CSize.space2,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: const Color(0xFFFBBF24),
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                       CSize.radius5Small,
//                                                     ),
//                                               ),
//                                               child: Text(
//                                                 "GRADE ${product.grade}",
//                                                 style: const TextStyle(
//                                                   fontSize: CSize.font10XSmall,
//                                                   fontWeight: FontWeight.w800,
//                                                   color: Color(0xFF78350F),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             // ════════════════════════════════════
//                             //  INFO SECTION
//                             // ════════════════════════════════════
//                             Padding(
//                               padding: const EdgeInsets.all(CSize.space8),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   // ── Price ──
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         "PRICE",
//                                         style: TextStyle(
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w900,
//                                           color: CColors.textPrimary,
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             "\$${product.price}",
//                                             style: const TextStyle(
//                                               fontSize: CSize.font10XSmall,
//                                               fontWeight: FontWeight.w700,
//                                               color: CColors.textEmeraldGreen,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           Text(
//                                             "/${product.unit}",
//                                             style: const TextStyle(
//                                               fontSize: CSize.font10XSmall,
//                                               fontWeight: FontWeight.w600,
//                                               color: CColors.textSecondary,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//
//                                   const SizedBox(height: CSize.space2),
//
//                                   // ── Total Stock ──
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         "TOTAL STOCK",
//                                         style: TextStyle(
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w900,
//                                           color: CColors.textPrimary,
//                                         ),
//                                       ),
//                                       Text(
//                                         "${product.stock} ${product.unit}",
//                                         style: const TextStyle(
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w600,
//                                           color: CColors.textSecondary,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//
//                                   const SizedBox(height: CSize.space2),
//
//                                   // ── MOQ ──
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         "MOQ",
//                                         style: TextStyle(
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w900,
//                                           color: CColors.textPrimary,
//                                         ),
//                                       ),
//                                       Text(
//                                         "${product.minOrderQty} ${product.unit}",
//                                         style: const TextStyle(
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w600,
//                                           color: CColors.textSecondary,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//
//                                   // ── Divider ──
//                                   const Divider(
//                                     height: CSize.space16,
//                                     thickness: CSize.borderWidth05,
//                                     color: CColors.borderGray,
//                                   ),
//
//                                   const SizedBox(height: CSize.space4),
//
//                                   // ── Stock Sold Progress ──
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const Text(
//                                             "STOCK SOLD",
//                                             style: TextStyle(
//                                               fontSize: CSize.font10XSmall,
//                                               fontWeight: FontWeight.w900,
//                                               color: CColors.textPrimary,
//                                             ),
//                                           ),
//                                           Text(
//                                             "${soldQty.toInt()} / ${product.stock} ${product.unit}",
//                                             style: TextStyle(
//                                               fontSize: CSize.font10XSmall,
//                                               fontWeight: FontWeight.w700,
//                                               color: isLowStock
//                                                   ? CColors.textOrange
//                                                   : CColors.textEmeraldGreen,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: CSize.space2),
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(
//                                           CSize.radius24XLarge,
//                                         ),
//                                         child: LinearProgressIndicator(
//                                           value: progress,
//                                           minHeight:
//                                               CSize.space5 + CSize.space2,
//                                           backgroundColor: CColors.borderGray
//                                               .withOpacity(0.3),
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                 isLowStock
//                                                     ? CColors.backGroundOrange
//                                                     : CColors
//                                                           .backGroundEmeraldGreen,
//                                               ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//
//                                   const SizedBox(height: CSize.space4),
//
//                                   // ── Buttons ──
//                                   Row(
//                                     children: [
//                                       // Edit Button
//                                       Expanded(
//                                         child: OutlinedButton.icon(
//                                           onPressed: () {},
//                                           icon: const Icon(
//                                             Icons.edit_outlined,
//                                             size: CSize.icon20Medium,
//                                             color: CColors.iconEmeraldGreen,
//                                           ),
//                                           label: const Text(
//                                             "Edit",
//                                             style: TextStyle(
//                                               fontSize: CSize.font13Small,
//                                               fontWeight: FontWeight.w500,
//                                               color: CColors.textEmeraldGreen,
//                                             ),
//                                           ),
//                                           style: OutlinedButton.styleFrom(
//                                             side: const BorderSide(
//                                               width: CSize.borderWidth1,
//                                               color: CColors.borderDarkGray,
//                                             ),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                     CSize.radius10Medium,
//                                                   ),
//                                             ),
//                                             padding: const EdgeInsets.symmetric(
//                                               vertical: CSize.space4,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//
//                                       const SizedBox(width: CSize.space8),
//
//                                       // Delete Button
//                                       SizedBox(
//                                         height: CSize.space32,
//                                         width: CSize.space32,
//                                         child: OutlinedButton(
//                                           onPressed: () {},
//                                           style: OutlinedButton.styleFrom(
//                                             padding: EdgeInsets.zero,
//                                             side: const BorderSide(
//                                               width: CSize.borderWidth1,
//                                               color: CColors.borderError,
//                                             ),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                     CSize.radius10Medium,
//                                                   ),
//                                             ),
//                                           ),
//                                           child: const Icon(
//                                             Icons.delete_outline_outlined,
//                                             size: CSize.icon20Medium,
//                                             color: CColors.iconError,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Data/Models/marketplace_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';
import 'marketplace_con.dart';

class MarketplaceScr extends StatelessWidget {
  final MarketplaceCon marketplaceController = Get.find();

  MarketplaceScr({super.key});

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
          // Title + subtitle
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Marketplace",
                style: TextStyle(
                  fontSize: CSize.font24Large,
                  fontWeight: FontWeight.w900,
                  color: CColors.textPrimary,
                ),
              ),
              SizedBox(height: CSize.space2),
              Text(
                "Manage your product listings",
                style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(width: CSize.space20),

          // Search bar
          SizedBox(
            width: 300,
            height: 36,
            child: TextField(
              controller: marketplaceController.searchController,
              onChanged: marketplaceController.onSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: "Search products...",
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

          // Notification button
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

          // Message button
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

          // Avatar
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
          // Back arrow
          Obx(
            () => GestureDetector(
              onTap: marketplaceController.selectedCategoryIndex.value > 0
                  ? marketplaceController.scrollCategoryPrev
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
                  color: marketplaceController.selectedCategoryIndex.value > 0
                      ? CColors.iconEmeraldGreen
                      : CColors.textSecondary,
                ),
              ),
            ),
          ),

          const SizedBox(width: CSize.space8),

          // Category scroll
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                controller: marketplaceController.categoryScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: marketplaceController.categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: CSize.space8),
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isActive =
                        marketplaceController.selectedCategoryIndex.value ==
                            index;
                    return GestureDetector(
                      onTap: () => marketplaceController.selectCategory(index),
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
                          marketplaceController.categories[index].name,
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

          // Forward arrow
          Obx(
            () => GestureDetector(
              onTap: marketplaceController.selectedCategoryIndex.value <
                      marketplaceController.categories.length - 1
                  ? marketplaceController.scrollCategoryNext
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
                  color: marketplaceController.selectedCategoryIndex.value <
                          marketplaceController.categories.length - 1
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
            // Status label
            const Text(
              "Status:",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(width: CSize.space8),

            _filterChip("All", StockFilter.all),
            const SizedBox(width: CSize.space5),
            _filterChip("Active", StockFilter.active),
            const SizedBox(width: CSize.space5),
            _filterChip("Pending", StockFilter.pending),

            // Divider
            Container(
              width: 1,
              height: 16,
              color: const Color(0xFFE2E8F0),
              margin: const EdgeInsets.symmetric(horizontal: CSize.space10),
            ),

            // Stock label
            const Text(
              "Stock:",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(width: CSize.space8),

            _filterChipWarn("Low Stock", StockFilter.lowStock),
            const SizedBox(width: CSize.space5),
            _filterChipRed("Out of Stock", StockFilter.outOfStock),

            const Spacer(),

            // Product count
            Obx(
              () => Text(
                "${marketplaceController.filteredProducts.length} products",
                style: const TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: CSize.space8),

            // Sort dropdown
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
                child: DropdownButton<SortOption>(
                  value: marketplaceController.selectedSort.value,
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
                      value: SortOption.latest,
                      child: Text("Sort: Latest"),
                    ),
                    DropdownMenuItem(
                      value: SortOption.oldest,
                      child: Text("Sort: Oldest"),
                    ),
                    DropdownMenuItem(
                      value: SortOption.highestStock,
                      child: Text("Highest Stock"),
                    ),
                    DropdownMenuItem(
                      value: SortOption.lowestStock,
                      child: Text("Lowest Stock"),
                    ),
                  ],
                  onChanged: (val) =>
                      marketplaceController.setSort(val ?? SortOption.latest),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, StockFilter filter) {
    return Obx(() {
      final isActive = marketplaceController.selectedFilter.value == filter;
      return GestureDetector(
        onTap: () => marketplaceController.setFilter(filter),
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

  Widget _filterChipWarn(String label, StockFilter filter) {
    return Obx(() {
      final isActive = marketplaceController.selectedFilter.value == filter;
      return GestureDetector(
        onTap: () => marketplaceController.setFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space4,
          ),
          decoration: BoxDecoration(
            color:
                isActive ? CColors.backGroundOrange : CColors.backGroundWhite,
            borderRadius: BorderRadius.circular(CSize.radius20Large),
            border: Border.all(
              color:
                  isActive ? CColors.backGroundOrange : const Color(0xFFFED7AA),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: CSize.font10XSmall,
              fontWeight: FontWeight.w600,
              color: isActive ? CColors.textWhite : CColors.textOrange,
            ),
          ),
        ),
      );
    });
  }

  Widget _filterChipRed(String label, StockFilter filter) {
    return Obx(() {
      final isActive = marketplaceController.selectedFilter.value == filter;
      return GestureDetector(
        onTap: () => marketplaceController.setFilter(filter),
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

  // ════════════════════════════════════════════════════════════════════════════
  //  PRODUCT GRID
  // ════════════════════════════════════════════════════════════════════════════

  Widget _productGrid() {
    return Obx(() {
      final products = marketplaceController.filteredProducts;
      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.inventory_2_outlined,
                size: CSize.icon36XLarge,
                color: CColors.textSecondary,
              ),
              SizedBox(height: CSize.space12),
              Text(
                "No products found",
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

  Widget _productCard(MarketplaceProductModel product) {
    final double prog = marketplaceController.progress(product);
    final bool lowStock = marketplaceController.isLowStock(product);
    final bool outOfStock = marketplaceController.isOutOfStock(product);

    return Container(
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: lowStock ? const Color(0xFFFED7AA) : const Color(0xFFE2E8F0),
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── IMAGE SECTION ──────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 1.65,
            child: Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(CSize.radius20Large),
                  ),
                  child: Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
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

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(0.65),
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
                      vertical: CSize.space2,
                    ),
                    decoration: BoxDecoration(
                      color: product.status == ProductStatus.active
                          ? CColors.backgroundEmerald100.withOpacity(0.95)
                          : const Color(0xFFFEE2E2).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                    ),
                    child: Text(
                      product.status == ProductStatus.active
                          ? "Active"
                          : "Pending",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w700,
                        color: product.status == ProductStatus.active
                            ? CColors.textEmeraldGreen
                            : CColors.textRichRed,
                      ),
                    ),
                  ),
                ),

                // BOTTOM: Name + location + grade
                Positioned(
                  left: CSize.space8,
                  bottom: CSize.space8,
                  right: CSize.space8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: CSize.font13Small,
                          fontWeight: FontWeight.w800,
                          color: CColors.textWhite,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: CSize.space2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: CSize.font10XSmall,
                            color: CColors.iconWhite,
                          ),
                          const SizedBox(width: CSize.space2),
                          Expanded(
                            child: Text(
                              "${product.origin}, ${product.location}",
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
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius: BorderRadius.circular(
                                CSize.radius20Large,
                              ),
                            ),
                            child: Text(
                              "GRADE ${product.grade}",
                              style: const TextStyle(
                                fontSize: 8,
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
            padding: const EdgeInsets.all(CSize.space10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Price ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: CColors.textSecondary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${product.price}",
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
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: CColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Total Stock
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Stock",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: CColors.textSecondary,
                      ),
                    ),
                    Text(
                      "${product.stock} ${product.unit}",
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: CColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space2),

                // MOQ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "MOQ",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: CColors.textSecondary,
                      ),
                    ),
                    Text(
                      "${product.minOrderQty?.toInt()} ${product.unit}",
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: CColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                // Divider
                const Divider(
                  height: CSize.space12,
                  thickness: CSize.borderWidth05,
                  color: Color(0xFFF1F5F9),
                ),

                // Stock Sold label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "STOCK SOLD",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: CColors.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      "${marketplaceController.soldQty(product.id).toInt()} / ${product.stock} ${product.unit}",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: lowStock
                            ? CColors.textOrange
                            : CColors.textEmeraldGreen,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space4),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  child: LinearProgressIndicator(
                    value: prog,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      lowStock
                          ? CColors.backGroundOrange
                          : CColors.backGroundEmeraldGreen,
                    ),
                  ),
                ),

                const SizedBox(height: CSize.space8),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            marketplaceController.editProduct(product),
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: CSize.font10XSmall,
                          color: CColors.iconEmeraldGreen,
                        ),
                        label: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w600,
                            color: CColors.textEmeraldGreen,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: CSize.space4,
                          ),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              CSize.radius10Medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: CSize.space8),
                    SizedBox(
                      width: CSize.space32,
                      height: CSize.space32,
                      child: OutlinedButton(
                        onPressed: () =>
                            marketplaceController.deleteProduct(product.id),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: Color(0xFFFCA5A5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              CSize.radius10Medium,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: CSize.icon16Small,
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
