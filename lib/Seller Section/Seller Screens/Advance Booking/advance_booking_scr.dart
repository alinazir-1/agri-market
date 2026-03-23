// import 'package:agri/Seller%20Section/Seller%20Screens/Advance%20Booking/advance_booking_con.dart';
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
// class AdvanceBookingScr extends StatelessWidget {
//   final MarketplaceCon marketPlaceController = Get.find();
//   final AdvanceBookingCon advanceBookingController = Get.put(
//     AdvanceBookingCon(),
//   );
//
//   AdvanceBookingScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CColors.backGroundWhite,
//       body: SafeArea(
//         child: Column(
//           children: [
//             TopBar(title: "Advance Booking"),
//
//             const SizedBox(height: CSize.space8),
//
//             // CategorySection(marketPlaceController: marketPlaceController),
//             Expanded(
//               flex: 7,
//               child: Obx(
//                 () => GridView.builder(
//                   itemCount: advanceBookingController.products.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 5,
//                     crossAxisSpacing: CSize.space10,
//                     mainAxisSpacing: CSize.space10,
//                     childAspectRatio: 0.80,
//                   ),
//                   itemBuilder: (context, index) {
//                     final product = advanceBookingController.products[index];
//
//                     // ── Progress calculation ──
//                     final double bookedQty =
//                         150; // replace with product.bookedQty
//                     final double totalStock = (product.stock ?? 1).toDouble();
//                     final double progressValue = (bookedQty / totalStock).clamp(
//                       0.0,
//                       1.0,
//                     );
//                     final bool isAlmostFull = progressValue >= 0.8;
//
//                     // ── Harvest date format ──
//                     final String harvestDate =
//                         product.harvestDate; // already a String
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
//                           //  HARVEST DATE HEADER BAR
//                           // ══════════════════════════════════════
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: CSize.space12,
//                               vertical: CSize.space5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isAlmostFull
//                                   ? const Color(0xFFB45309)
//                                   : CColors.backGroundEmeraldGreen,
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(CSize.radius20Large),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Left: Calendar icon + label
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(
//                                       Icons.calendar_today_outlined,
//                                       size: CSize.icon16Small,
//                                       color: CColors.iconWhite,
//                                     ),
//                                     const SizedBox(width: CSize.space4),
//                                     CText(
//                                       text: "Harvest Date",
//                                       color: CColors.textWhite,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ],
//                                 ),
//
//                                 // Right: Date pill
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: CSize.space8,
//                                     vertical: CSize.space2,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.18),
//                                     borderRadius: BorderRadius.circular(
//                                       CSize.radius20Large,
//                                     ),
//                                   ),
//                                   child: CText(
//                                     text: harvestDate,
//                                     color: CColors.textWhite,
//                                     fontSize: CSize.font10XSmall,
//                                     fontWeight: FontWeight.w700,
//                                   ),
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
//                                           size: CSize.icon36XLarge,
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
//                                           Colors.black.withOpacity(0.65),
//                                           Colors.transparent,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 // ── TOP LEFT: Status Badge (pill shape) ──
//                                 if (product.status != null)
//                                   Positioned(
//                                     top: CSize.space8,
//                                     left: CSize.space8,
//                                     child: CContainer(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: CSize.space8,
//                                         vertical: CSize.space4,
//                                       ),
//                                       borderRadius: BorderRadius.circular(
//                                         CSize.radius5Small,
//                                       ),
//                                       backgroundColor:
//                                           product.status == ProductStatus.active
//                                           ? CColors.backgroundEmerald100
//                                           : CColors.backGroundOrange,
//                                       child: CText(
//                                         text: product.status?.name ?? "",
//                                         color:
//                                             product.status ==
//                                                 ProductStatus.active
//                                             ? CColors.textEmeraldGreen
//                                             : CColors.textWhite,
//                                         fontSize: CSize.font10XSmall,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
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
//                           //  INFO SECTION
//                           Padding(
//                             padding: const EdgeInsets.all(CSize.space10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // ── Booking Price ──
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     CText(
//                                       text: "BOOKING PRICE",
//                                       color: CColors.textPrimary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         CText(
//                                           text: "\$${product.bookingPrice}",
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
//                                 // ── MOQ ──
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     CText(
//                                       text: "MOQ",
//                                       color: CColors.textPrimary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                     CText(
//                                       text:
//                                           "${product.minOrderQty} ${product.unit}",
//                                       color: CColors.textSecondary,
//                                       fontSize: CSize.font10XSmall,
//                                       fontWeight: FontWeight.w600,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: CSize.space4),
//
//                                 // // ── Thin Divider ──
//                                 // const Divider(
//                                 //   height: CSize.space16,
//                                 //   thickness: CSize.borderWidth05,
//                                 //   color: CColors.borderGray,
//                                 // ),
//
//                                 // ── Booking Progress ──
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Label + booked qty row
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         CText(
//                                           text: "BOOKED",
//                                           color: CColors.textPrimary,
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w900,
//                                         ),
//                                         CText(
//                                           text:
//                                               "${bookedQty.toInt()} / ${product.stock} ${product.unit}",
//                                           color: isAlmostFull
//                                               ? CColors.textOrange
//                                               : CColors.textEmeraldGreen,
//                                           fontSize: CSize.font10XSmall,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ],
//                                     ),
//
//                                     const SizedBox(height: CSize.space5),
//
//                                     // Progress bar
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(
//                                         CSize.radius24XLarge,
//                                       ),
//                                       child: LinearProgressIndicator(
//                                         value: progressValue,
//                                         minHeight: CSize.space8 - CSize.space2,
//                                         backgroundColor: CColors.borderGray
//                                             .withOpacity(0.3),
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               isAlmostFull
//                                                   ? CColors.backGroundOrange
//                                                   : CColors
//                                                         .backGroundEmeraldGreen,
//                                             ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: CSize.space5),
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
//                                           width: CSize.borderWidth1,
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
//                                       height: CSize.space32,
//                                       width: CSize.space32,
//                                       icon: Icons.delete_outline_outlined,
//                                       iconSize: CSize.icon20Medium,
//                                       iconColor: CColors.iconError,
//                                       border: BorderSide(
//                                         width: CSize.borderWidth1,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Data/Models/advance_booking_product_model.dart';
import '../../../Data/Models/product_type_enums.dart';
import 'advance_booking_con.dart';

class AdvanceBookingScr extends StatelessWidget {
  final AdvanceBookingCon c = Get.put(AdvanceBookingCon());

  AdvanceBookingScr({super.key});

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
                "Advance Booking",
                style: TextStyle(
                  fontSize: CSize.font24Large,
                  fontWeight: FontWeight.w900,
                  color: CColors.textPrimary,
                ),
              ),
              SizedBox(height: CSize.space2),
              Text(
                "Manage your advance booking listings",
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
              controller: c.searchController,
              onChanged: c.onSearch,
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

          // Message
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
          const CircleAvatar(
            radius: 17,
            backgroundColor: CColors.backGroundEmeraldGreen,
            child: Text(
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

          // Category scroll
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

          // Forward arrow
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

            _filterChip("All", AdvanceBookingFilter.all),
            const SizedBox(width: CSize.space5),
            _filterChip("Active", AdvanceBookingFilter.active),
            const SizedBox(width: CSize.space5),
            _filterChip("Inactive", AdvanceBookingFilter.inactive),

            // Divider
            Container(
              width: 1,
              height: 16,
              color: const Color(0xFFE2E8F0),
              margin: const EdgeInsets.symmetric(horizontal: CSize.space10),
            ),

            // Booking label
            const Text(
              "Booking:",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(width: CSize.space8),

            _filterChipWarn("Almost Full", AdvanceBookingFilter.almostFull),

            const Spacer(),

            // Count
            Obx(
              () => Text(
                "${c.filteredProducts.length} products",
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
                child: DropdownButton<AdvanceBookingSortOption>(
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
                      value: AdvanceBookingSortOption.latest,
                      child: Text("Sort: Latest"),
                    ),
                    DropdownMenuItem(
                      value: AdvanceBookingSortOption.oldest,
                      child: Text("Sort: Oldest"),
                    ),
                    DropdownMenuItem(
                      value: AdvanceBookingSortOption.harvestSoon,
                      child: Text("Harvest: Soonest"),
                    ),
                    DropdownMenuItem(
                      value: AdvanceBookingSortOption.highestStock,
                      child: Text("Highest Stock"),
                    ),
                  ],
                  onChanged: (val) =>
                      c.setSort(val ?? AdvanceBookingSortOption.latest),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, AdvanceBookingFilter filter) {
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

  Widget _filterChipWarn(String label, AdvanceBookingFilter filter) {
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

  // ════════════════════════════════════════════════════════════════════════════
  //  PRODUCT GRID
  // ════════════════════════════════════════════════════════════════════════════

  Widget _productGrid() {
    return Obx(() {
      final products = c.filteredProducts;
      if (products.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

  Widget _productCard(AdvanceBookingProductModel product) {
    final double prog = c.progress(product);
    final bool almostFull = c.isAlmostFull(product);
    final double booked = c.bookedQty(product.id);

    return Container(
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: almostFull ? const Color(0xFFFED7AA) : const Color(0xFFE2E8F0),
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── HARVEST DATE HEADER BAR ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space12,
              vertical: CSize.space5,
            ),
            decoration: BoxDecoration(
              color: almostFull
                  ? const Color(0xFFB45309)
                  : CColors.backGroundEmeraldGreen,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(CSize.radius20Large),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Calendar icon + label
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: CSize.icon16Small,
                      color: CColors.iconWhite,
                    ),
                    SizedBox(width: CSize.space4),
                    Text(
                      "Harvest Date",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w500,
                        color: CColors.textWhite,
                      ),
                    ),
                  ],
                ),

                // Right: Date pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space8,
                    vertical: CSize.space2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                  ),
                  child: Text(
                    product.harvestDate,
                    style: const TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w700,
                      color: CColors.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── IMAGE SECTION ──────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 1.7,
            child: Stack(
              children: [
                // Product image
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

                // Gradient
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
                if (product.status != null)
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

                // BOTTOM: Name + Location + Grade
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
                // Booking Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Booking Price",
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
                          "\$${product.bookingPrice}",
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

                // MOQ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "MOQ",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w900,
                        color: CColors.textPrimary,
                      ),
                    ),
                    Text(
                      "${product.minOrderQty?.toInt()} ${product.unit}",
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

                const SizedBox(height: CSize.space2),

                // Booked Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Booked",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w900,
                        color: CColors.textPrimary,
                      ),
                    ),
                    Text(
                      "${booked.toInt()} / ${product.stock} ${product.unit}",
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w700,
                        color: almostFull
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
                    minHeight: CSize.space8 - CSize.space2,
                    backgroundColor: CColors.borderGray.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      almostFull
                          ? CColors.backGroundOrange
                          : CColors.backGroundEmeraldGreen,
                    ),
                  ),
                ),

                const SizedBox(height: CSize.space4),

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
                            width: CSize.borderWidth1,
                            color: CColors.borderDarkGray,
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
                            width: CSize.borderWidth1,
                            color: CColors.borderError,
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
