// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/features/seller/inventory/inventory_con.dart';
// import 'package:agri_market/features/seller/inventory/add_stock_batch_scr.dart';
//
// class MobileInventoryScr extends StatelessWidget {
//   const MobileInventoryScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<InventoryCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _StatsBar(c: c),
//           _FilterChips(c: c),
//           Expanded(child: _ItemList(c: c)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Stats ──────────────────────────────────────────────────────────────────
//
// class _StatsBar extends StatelessWidget {
//   final InventoryCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           child: Row(
//             children: [
//               _stat(context, '${c.totalProducts}', 'Total',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const SizedBox(width: 8),
//               _stat(context, '${c.inStockCount}', 'In Stock',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const SizedBox(width: 8),
//               _stat(context, '${c.lowStockCount}', 'Low Stock',
//                   CColors.backGroundOrange, const Color(0xFFFFF7ED)),
//               const SizedBox(width: 8),
//               _stat(context, '${c.outOfStockCount}', 'Out',
//                   CColors.iconError, const Color(0xFFFEE2E2)),
//             ],
//           ),
//         ));
//   }
//
//   Widget _stat(BuildContext context, String value, String label, Color fg, Color bg) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Text(value,
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w800,
//                     color: fg)),
//             const SizedBox(height: 2),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 10,
//                     color: context.txtSecondary,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Filter Chips ───────────────────────────────────────────────────────────
//
// class _FilterChips extends StatelessWidget {
//   final InventoryCon c;
//   const _FilterChips({required this.c});
//
//   static const _filters = [
//     (InventoryFilter.all, 'All', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (InventoryFilter.marketplace, 'Marketplace', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (InventoryFilter.liveAuction, 'Auction', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (InventoryFilter.lowStock, 'Low Stock', CColors.backGroundOrange, CColors.backGroundOrange),
//     (InventoryFilter.outOfStock, 'Out of Stock', CColors.borderError, CColors.borderError),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: Obx(() {
//         final activeFilter = c.selectedFilter.value;
//         return ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: _filters.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 6),
//             itemBuilder: (_, i) {
//               final (filter, label, activeColor, activeBorder) = _filters[i];
//               final active = activeFilter == filter;
//               return GestureDetector(
//                 onTap: () => c.setFilter(filter),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 150),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: active ? activeColor : context.cardBg,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: active ? activeBorder : context.borderClr,
//                     ),
//                   ),
//                   child: Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: active ? CColors.textWhite : context.txtSecondary,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//       }),
//     );
//   }
// }
//
// // ── Item List ──────────────────────────────────────────────────────────────
//
// class _ItemList extends StatelessWidget {
//   final InventoryCon c;
//   const _ItemList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.filteredItems;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.inventory_2_outlined, size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No products found',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, i) => _InventoryCard(item: list[i], c: c),
//       );
//     });
//   }
// }
//
// class _InventoryCard extends StatelessWidget {
//   final InventoryItem item;
//   final InventoryCon c;
//   const _InventoryCard({required this.item, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isOut = item.isOutOfStock;
//       final isLow = item.isLowStock;
//       final statusColor = isOut
//           ? CColors.textError
//           : isLow
//               ? CColors.textOrange
//               : CColors.textEmeraldGreen;
//       final statusBg = isOut
//           ? const Color(0xFFFEE2E2)
//           : isLow
//               ? const Color(0xFFFFF7ED)
//               : CColors.backgroundEmerald100;
//       final statusLabel = isOut ? 'Out of Stock' : isLow ? 'Low Stock' : 'In Stock';
//
//       return Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: context.cardBg,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: context.borderClr),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset(
//                     item.image,
//                     width: 44,
//                     height: 44,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 44,
//                       height: 44,
//                       color: CColors.backgroundEmerald100,
//                       child: const Icon(Icons.image_outlined,
//                           size: 18, color: CColors.iconEmeraldGreen),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(item.name,
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w700,
//                               color: context.txtPrimary),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis),
//                       Text('${item.category} · \$${item.sellingPrice.value.toStringAsFixed(0)}/${item.unit}',
//                           style: TextStyle(
//                               fontSize: 11, color: context.txtSecondary)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: statusBg,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(statusLabel,
//                       style: TextStyle(
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700,
//                           color: statusColor)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Stock bar
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${item.currentStock.toStringAsFixed(0)} / ${item.totalInitialStock.toStringAsFixed(0)} ${item.unit}',
//                       style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: statusColor),
//                     ),
//                     Text(
//                       '${(item.progressValue * 100).toStringAsFixed(0)}% sold',
//                       style: TextStyle(
//                           fontSize: 10, color: context.txtSecondary),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                     value: item.progressValue,
//                     backgroundColor: context.borderClr,
//                     valueColor: AlwaysStoppedAnimation<Color>(statusColor),
//                     minHeight: 6,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Actions
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 if (isOut || isLow)
//                   GestureDetector(
//                     onTap: () => Get.to(
//                       () => AddStockBatchScr(item: item),
//                       transition: Transition.rightToLeft,
//                     ),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: isOut
//                             ? const Color(0xFFFEE2E2)
//                             : const Color(0xFFFFF7ED),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: isOut ? CColors.borderError : CColors.backGroundOrange,
//                         ),
//                       ),
//                       child: Text(
//                         'Add Stock',
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w700,
//                           color: isOut ? CColors.textError : CColors.textOrange,
//                         ),
//                       ),
//                     ),
//                   ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: () => Get.to(
//                     () => AddStockBatchScr(item: item),
//                     transition: Transition.rightToLeft,
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: CColors.backgroundEmerald100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       'Edit',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: CColors.textEmeraldGreen,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
