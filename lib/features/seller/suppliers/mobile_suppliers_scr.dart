// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/supplier_model.dart';
// import 'package:agri_market/features/seller/suppliers/suppliers_con.dart';
//
// class MobileSuppliersScr extends StatelessWidget {
//   const MobileSuppliersScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<SuppliersCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _StatsBar(c: c),
//           _FilterChips(c: c),
//           Expanded(child: _SupplierList(c: c)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Stats ──────────────────────────────────────────────────────────────────
//
// class _StatsBar extends StatelessWidget {
//   final SuppliersCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final total = c.suppliers.length;
//       final active =
//           c.suppliers.where((s) => s.status == SupplierStatus.active).length;
//       final pending =
//           c.suppliers.where((s) => s.status == SupplierStatus.pending).length;
//       final topRating = c.suppliers.isEmpty
//           ? 0.0
//           : c.suppliers.map((s) => s.rating).reduce((a, b) => a > b ? a : b);
//
//       return Container(
//         color: context.cardBg,
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//         child: Row(
//           children: [
//             _stat(context, '$total', 'Total', CColors.iconEmeraldGreen,
//                 CColors.backgroundEmerald100),
//             const SizedBox(width: 8),
//             _stat(context, '$active', 'Active', CColors.iconEmeraldGreen,
//                 CColors.backgroundEmerald100),
//             const SizedBox(width: 8),
//             _stat(context, '$pending', 'Pending', CColors.backGroundOrange,
//                 const Color(0xFFFFF7ED)),
//             const SizedBox(width: 8),
//             _stat(context, topRating.toStringAsFixed(1), 'Top ★',
//                 const Color(0xFFCA8A04), const Color(0xFFFEF9C3)),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _stat(
//       BuildContext context, String value, String label, Color fg, Color bg) {
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
//                     fontSize: 15, fontWeight: FontWeight.w800, color: fg)),
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
//   final SuppliersCon c;
//   const _FilterChips({required this.c});
//
//   static const _filters = [
//     (SupplierFilter.all, 'All'),
//     (SupplierFilter.active, 'Active'),
//     (SupplierFilter.pending, 'Pending'),
//     (SupplierFilter.inactive, 'Inactive'),
//     (SupplierFilter.blocked, 'Blocked'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: Obx(() {
//         final activeFilter = c.activeFilter.value;
//         return ListView.separated(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           itemCount: _filters.length,
//           separatorBuilder: (_, __) => const SizedBox(width: 6),
//           itemBuilder: (_, i) {
//             final (filter, label) = _filters[i];
//             final active = activeFilter == filter;
//             return GestureDetector(
//               onTap: () => c.setFilter(filter),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 150),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color:
//                       active ? CColors.backGroundEmeraldGreen : context.cardBg,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color:
//                         active ? CColors.borderEmeraldGreen : context.borderClr,
//                   ),
//                 ),
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: active ? CColors.textWhite : context.txtSecondary,
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
//
// // ── Supplier List ──────────────────────────────────────────────────────────
//
// class _SupplierList extends StatelessWidget {
//   final SuppliersCon c;
//   const _SupplierList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.filteredSuppliers;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.store_outlined, size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No suppliers found',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, i) => _SupplierCard(supplier: list[i]),
//       );
//     });
//   }
// }
//
// class _SupplierCard extends StatelessWidget {
//   final SupplierModel supplier;
//   const _SupplierCard({required this.supplier});
//
//   Color _statusColor(SupplierStatus s) {
//     switch (s) {
//       case SupplierStatus.active:
//         return CColors.iconEmeraldGreen;
//       case SupplierStatus.pending:
//         return CColors.backGroundOrange;
//       case SupplierStatus.inactive:
//         return const Color(0xFF6B7280);
//       case SupplierStatus.blocked:
//         return CColors.iconError;
//     }
//   }
//
//   Color _statusBg(SupplierStatus s) {
//     switch (s) {
//       case SupplierStatus.active:
//         return CColors.backgroundEmerald100;
//       case SupplierStatus.pending:
//         return const Color(0xFFFFF7ED);
//       case SupplierStatus.inactive:
//         return const Color(0xFFF3F4F6);
//       case SupplierStatus.blocked:
//         return const Color(0xFFFEE2E2);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: context.cardBg,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: context.borderClr),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: supplier.avatarColor.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     supplier.name.substring(0, 2).toUpperCase(),
//                     style: TextStyle(
//                       color: supplier.avatarColor,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(supplier.name,
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: context.txtPrimary),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis),
//                     Text('${supplier.contactPerson} · ${supplier.location}',
//                         style: TextStyle(
//                             fontSize: 11, color: context.txtSecondary),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: _statusBg(supplier.status),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   supplier.status.name[0].toUpperCase() +
//                       supplier.status.name.substring(1),
//                   style: TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.w700,
//                       color: _statusColor(supplier.status)),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Stats row
//           Row(
//             children: [
//               _infoChip(context, Icons.star_rounded, '${supplier.rating}',
//                   const Color(0xFFFEF9C3), const Color(0xFFCA8A04)),
//               const SizedBox(width: 8),
//               _infoChip(
//                   context,
//                   Icons.shopping_cart_outlined,
//                   '${supplier.totalOrders} orders',
//                   CColors.backgroundEmerald100,
//                   CColors.iconEmeraldGreen),
//               const SizedBox(width: 8),
//               _infoChip(
//                   context,
//                   Icons.scale_outlined,
//                   '${supplier.totalSupplied.toStringAsFixed(0)} T',
//                   const Color(0xFFEFF6FF),
//                   const Color(0xFF1D4ED8)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Contact
//           Row(
//             children: [
//               Icon(Icons.email_outlined, size: 12, color: context.txtSecondary),
//               const SizedBox(width: 4),
//               Expanded(
//                 child: Text(supplier.email,
//                     style: TextStyle(fontSize: 11, color: context.txtSecondary),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis),
//               ),
//               Icon(Icons.phone_outlined, size: 12, color: context.txtSecondary),
//               const SizedBox(width: 4),
//               Text(supplier.phone,
//                   style: TextStyle(fontSize: 11, color: context.txtSecondary)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _infoChip(
//       BuildContext context, IconData icon, String label, Color bg, Color fg) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 11, color: fg),
//           const SizedBox(width: 3),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
//         ],
//       ),
//     );
//   }
// }
