// // lib/features/seller/products/mobile_products_scr.dart
// // ✅ Reused: AppColors, AppSize, AppText, AppContainer, ThemeColors,
// //            MyProductsCon, ProductStatus
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/constants/sizes.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/advance_booking_product_model.dart';
// import 'package:agri_market/data/models/live_auction_product_model.dart';
// import 'package:agri_market/data/models/marketplace_product_model.dart';
// import 'package:agri_market/data/models/product_type_enums.dart';
// import 'package:agri_market/features/seller/products/my_products_con.dart';
//
// import '../../../shared/widgets/common/app_container.dart';
// import '../../../shared/widgets/common/app_text.dart';
//
// class MobileProductsScr extends StatelessWidget {
//   const MobileProductsScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<MyProductsCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _SearchBar(c: c),
//           Obx(() => _TabBar(c: c, activeTab: c.activeTab.value)),
//           Expanded(
//             child: Obx(() => _ProductList(
//                   c: c,
//                   activeTab: c.activeTab.value,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  SEARCH BAR
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _SearchBar extends StatelessWidget {
//   final MyProductsCon c;
//   const _SearchBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       backgroundColor: context.cardBg,
//       padding: const EdgeInsets.fromLTRB(
//         AppSize.space16,
//         AppSize.space12,
//         AppSize.space16,
//         0,
//       ),
//       child: TextField(
//         controller: c.searchController,
//         onChanged: c.onSearch,
//         style: TextStyle(
//           fontSize: AppSize.font13Small,
//           color: context.txtPrimary,
//         ),
//         decoration: InputDecoration(
//           hintText: 'Search products...',
//           hintStyle: TextStyle(
//             fontSize: AppSize.font13Small,
//             color: context.txtSecondary,
//           ),
//           prefixIcon: Icon(
//             Icons.search_rounded,
//             size: AppSize.icon20Medium - 2,
//             color: context.txtSecondary,
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: AppSize.space14,
//             vertical: AppSize.space10,
//           ),
//           filled: true,
//           fillColor: context.appBg,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             borderSide: BorderSide(color: context.borderClr),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             borderSide: BorderSide(color: context.borderClr),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             borderSide: const BorderSide(
//               color: AppColors.backGroundEmeraldGreen,
//               width: AppSize.borderWidth1 + 0.5,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  TAB BAR
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _TabBar extends StatelessWidget {
//   final MyProductsCon c;
//   final MyProductsTab activeTab;
//   const _TabBar({required this.c, required this.activeTab});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       backgroundColor: context.cardBg,
//       child: Column(
//         children: [
//           const SizedBox(height: AppSize.space12),
//           Row(
//             children: [
//               _TabItem(
//                 label: 'Marketplace',
//                 isActive: activeTab == MyProductsTab.marketplace,
//                 onTap: () => c.setTab(MyProductsTab.marketplace),
//               ),
//               _TabItem(
//                 label: 'Adv. Booking',
//                 isActive: activeTab == MyProductsTab.advanceBooking,
//                 onTap: () => c.setTab(MyProductsTab.advanceBooking),
//               ),
//               _TabItem(
//                 label: 'Auctions',
//                 isActive: activeTab == MyProductsTab.liveAuctions,
//                 onTap: () => c.setTab(MyProductsTab.liveAuctions),
//               ),
//             ],
//           ),
//           // Active indicator strip
//           Row(
//             children: [
//               _TabIndicator(
//                 isActive: activeTab == MyProductsTab.marketplace,
//               ),
//               _TabIndicator(
//                 isActive: activeTab == MyProductsTab.advanceBooking,
//               ),
//               _TabIndicator(
//                 isActive: activeTab == MyProductsTab.liveAuctions,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TabItem extends StatelessWidget {
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;
//   const _TabItem({
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         behavior: HitTestBehavior.opaque,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
//           child: AppText(
//             text: label,
//             fontSize: AppSize.font13Small,
//             fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
//             color: isActive
//                 ? AppColors.backGroundEmeraldGreen
//                 : context.txtSecondary,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _TabIndicator extends StatelessWidget {
//   final bool isActive;
//   const _TabIndicator({required this.isActive});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         height: AppSize.borderWidth2,
//         color: isActive ? AppColors.backGroundEmeraldGreen : Colors.transparent,
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PRODUCT LIST
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _ProductList extends StatelessWidget {
//   final MyProductsCon c;
//   final MyProductsTab activeTab;
//   const _ProductList({required this.c, required this.activeTab});
//
//   @override
//   Widget build(BuildContext context) {
//     switch (activeTab) {
//       case MyProductsTab.marketplace:
//         final products = c.filteredMp;
//         if (products.isEmpty) return _EmptyState(message: 'No products found');
//         return ListView.separated(
//           padding: const EdgeInsets.all(AppSize.space12),
//           itemCount: products.length,
//           separatorBuilder: (_, __) => const SizedBox(height: AppSize.space8),
//           itemBuilder: (_, i) => _MpProductCard(product: products[i], c: c),
//         );
//
//       case MyProductsTab.advanceBooking:
//         final products = c.filteredAb;
//         if (products.isEmpty) return _EmptyState(message: 'No products found');
//         return ListView.separated(
//           padding: const EdgeInsets.all(AppSize.space12),
//           itemCount: products.length,
//           separatorBuilder: (_, __) => const SizedBox(height: AppSize.space8),
//           itemBuilder: (_, i) => _AbProductCard(product: products[i], c: c),
//         );
//
//       case MyProductsTab.liveAuctions:
//         final products = c.filteredLa;
//         if (products.isEmpty) return _EmptyState(message: 'No auctions found');
//         return ListView.separated(
//           padding: const EdgeInsets.all(AppSize.space12),
//           itemCount: products.length,
//           separatorBuilder: (_, __) => const SizedBox(height: AppSize.space8),
//           itemBuilder: (_, i) => _LaProductCard(product: products[i], c: c),
//         );
//     }
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  EMPTY STATE
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _EmptyState extends StatelessWidget {
//   final String message;
//   const _EmptyState({required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.inventory_2_outlined,
//             size: AppSize.icon36XLarge + 12,
//             color: context.txtSecondary,
//           ),
//           const SizedBox(height: AppSize.space12),
//           AppText(
//             text: message,
//             fontSize: AppSize.font16Medium - 1,
//             fontWeight: FontWeight.w600,
//             color: context.txtPrimary,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MARKETPLACE CARD
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _MpProductCard extends StatelessWidget {
//   final MarketplaceProductModel product;
//   final MyProductsCon c;
//   const _MpProductCard({required this.product, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final progress = c.mpProgress(product);
//     final isActive = product.status == ProductStatus.active;
//     final isLow = c.mpIsLow(product);
//
//     return AppContainer(
//       padding: const EdgeInsets.all(AppSize.space12),
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(color: context.borderClr),
//       child: Row(
//         children: [
//           // Product image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//             child: Image.asset(
//               product.images.first,
//               width: 56,
//               height: 56,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => AppContainer(
//                 width: 56,
//                 height: 56,
//                 backgroundColor: AppColors.backgroundEmerald100,
//                 child: const Icon(
//                   Icons.eco_rounded,
//                   color: AppColors.backGroundEmeraldGreen,
//                   size: 24,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: AppSize.space12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: AppText(
//                         text: product.name,
//                         fontSize: AppSize.font13Small,
//                         fontWeight: FontWeight.w600,
//                         color: context.txtPrimary,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     AppContainer(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.space6,
//                         vertical: AppSize.space2,
//                       ),
//                       backgroundColor: isActive
//                           ? AppColors.backgroundEmerald100
//                           : AppColors.badgeButterYellow,
//                       borderRadius:
//                           BorderRadius.circular(AppSize.radius20Large),
//                       child: AppText(
//                         text: isActive ? 'Active' : 'Pending',
//                         fontSize: AppSize.font10XSmall,
//                         fontWeight: FontWeight.w600,
//                         color: isActive
//                             ? AppColors.backGroundEmeraldGreen
//                             : AppColors.textYellow700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppSize.space2),
//                 AppText(
//                   text:
//                       '\$${product.price} / ${product.unit}  •  ${product.category}',
//                   fontSize: 11,
//                   color: context.txtSecondary,
//                 ),
//                 const SizedBox(height: AppSize.space6),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(AppSize.space4),
//                         child: LinearProgressIndicator(
//                           value: progress,
//                           minHeight: 5,
//                           backgroundColor: context.borderClr,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             isLow
//                                 ? AppColors.borderError
//                                 : AppColors.backGroundEmeraldGreen,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: AppSize.space8),
//                     AppText(
//                       text: '${product.stock} left',
//                       fontSize: AppSize.font10XSmall,
//                       color: context.txtSecondary,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ADVANCE BOOKING CARD
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _AbProductCard extends StatelessWidget {
//   final AdvanceBookingProductModel product;
//   final MyProductsCon c;
//   const _AbProductCard({required this.product, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final progress = c.abProgress(product);
//     final isActive = product.status == ProductStatus.active;
//     final almostFull = c.abIsAlmostFull(product);
//
//     return AppContainer(
//       padding: const EdgeInsets.all(AppSize.space12),
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(color: context.borderClr),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//             child: Image.asset(
//               product.images.first,
//               width: 56,
//               height: 56,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => AppContainer(
//                 width: 56,
//                 height: 56,
//                 backgroundColor: AppColors.backgroundEmerald100,
//                 child: const Icon(
//                   Icons.eco_rounded,
//                   color: AppColors.backGroundEmeraldGreen,
//                   size: 24,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: AppSize.space12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: AppText(
//                         text: product.name,
//                         fontSize: AppSize.font13Small,
//                         fontWeight: FontWeight.w600,
//                         color: context.txtPrimary,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     AppContainer(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.space6,
//                         vertical: AppSize.space2,
//                       ),
//                       backgroundColor: isActive
//                           ? AppColors.backgroundEmerald100
//                           : AppColors.badgeLightRed,
//                       borderRadius:
//                           BorderRadius.circular(AppSize.radius20Large),
//                       child: AppText(
//                         text: isActive ? 'Active' : 'Inactive',
//                         fontSize: AppSize.font10XSmall,
//                         fontWeight: FontWeight.w600,
//                         color: isActive
//                             ? AppColors.backGroundEmeraldGreen
//                             : AppColors.textRichRed,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppSize.space2),
//                 AppText(
//                   text:
//                       '\$${product.bookingPrice} booking  •  Harvest: ${product.harvestDate}',
//                   fontSize: 11,
//                   color: context.txtSecondary,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: AppSize.space6),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(AppSize.space4),
//                         child: LinearProgressIndicator(
//                           value: progress,
//                           minHeight: 5,
//                           backgroundColor: context.borderClr,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             almostFull
//                                 ? AppColors.borderError
//                                 : AppColors.textBlue700,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: AppSize.space8),
//                     AppText(
//                       text: '${(progress * 100).toStringAsFixed(0)}% booked',
//                       fontSize: AppSize.font10XSmall,
//                       color: context.txtSecondary,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  LIVE AUCTION CARD
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _LaProductCard extends StatelessWidget {
//   final LiveAuctionProductModel product;
//   final MyProductsCon c;
//   const _LaProductCard({required this.product, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final isEnded = c.laIsEnded(product);
//     final isEndingSoon = c.laIsEndingSoon(product);
//
//     return AppContainer(
//       padding: const EdgeInsets.all(AppSize.space12),
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(
//         color: isEndingSoon && !isEnded
//             ? AppColors.badgeLightRed
//             : context.borderClr,
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//             child: Image.asset(
//               product.images.first,
//               width: 56,
//               height: 56,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => AppContainer(
//                 width: 56,
//                 height: 56,
//                 backgroundColor: AppColors.backgroundEmerald100,
//                 child: const Icon(
//                   Icons.eco_rounded,
//                   color: AppColors.backGroundEmeraldGreen,
//                   size: 24,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: AppSize.space12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: AppText(
//                         text: product.name,
//                         fontSize: AppSize.font13Small,
//                         fontWeight: FontWeight.w600,
//                         color: context.txtPrimary,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     AppContainer(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.space6,
//                         vertical: AppSize.space2,
//                       ),
//                       backgroundColor: isEnded
//                           ? context.borderClr
//                           : AppColors.backgroundEmerald100,
//                       borderRadius:
//                           BorderRadius.circular(AppSize.radius20Large),
//                       child: AppText(
//                         text: isEnded ? 'Ended' : 'Live',
//                         fontSize: AppSize.font10XSmall,
//                         fontWeight: FontWeight.w600,
//                         color: isEnded
//                             ? context.txtSecondary
//                             : AppColors.backGroundEmeraldGreen,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppSize.space2),
//                 AppText(
//                   text:
//                       'Current: \$${product.currentBid}  •  ${product.totalBids} bids',
//                   fontSize: 11,
//                   color: context.txtSecondary,
//                 ),
//                 const SizedBox(height: AppSize.space4),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.timer_outlined,
//                       size: AppSize.font12Small2,
//                       color: isEndingSoon && !isEnded
//                           ? AppColors.borderError
//                           : context.txtSecondary,
//                     ),
//                     const SizedBox(width: 3),
//                     AppText(
//                       text: c.laTimerText(product),
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: isEndingSoon && !isEnded
//                           ? AppColors.borderError
//                           : context.txtSecondary,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
