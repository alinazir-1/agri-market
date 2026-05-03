// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/customer_model.dart';
// import 'package:agri_market/features/seller/customers/customers_con.dart';
//
// class MobileCustomersScr extends StatelessWidget {
//   const MobileCustomersScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<CustomersCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _StatsBar(c: c),
//           _FilterChips(c: c),
//           Expanded(child: _CustomerList(c: c)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Stats ──────────────────────────────────────────────────────────────────
//
// class _StatsBar extends StatelessWidget {
//   final CustomersCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           child: Row(
//             children: [
//               _stat(context, '${c.totalCustomers}', 'Total',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const SizedBox(width: 8),
//               _stat(context, '${c.activeCount}', 'Active',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const SizedBox(width: 8),
//               _stat(context, '${c.vipCount}', 'VIP',
//                   const Color(0xFF7C3AED), const Color(0xFFF3E8FF)),
//               const SizedBox(width: 8),
//               _stat(
//                   context,
//                   '\$${(c.totalRevenue / 1000).toStringAsFixed(1)}k',
//                   'Revenue',
//                   const Color(0xFF1D4ED8),
//                   const Color(0xFFEFF6FF)),
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
//   final CustomersCon c;
//   const _FilterChips({required this.c});
//
//   static const _filters = [
//     (CustomerFilter.all, 'All'),
//     (CustomerFilter.active, 'Active'),
//     (CustomerFilter.vip, 'VIP'),
//     (CustomerFilter.inactive, 'Inactive'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: Obx(() {
//         final activeFilter = c.filter.value;
//         return ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: _filters.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 6),
//             itemBuilder: (_, i) {
//               final (filter, label) = _filters[i];
//               final active = activeFilter == filter;
//               return GestureDetector(
//                 onTap: () => c.setFilter(filter),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 150),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: active ? CColors.backGroundEmeraldGreen : context.cardBg,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: active ? CColors.borderEmeraldGreen : context.borderClr,
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
// // ── Customer List ────────────────────────────────────────────────────────
//
// class _CustomerList extends StatelessWidget {
//   final CustomersCon c;
//   const _CustomerList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.filteredCustomers;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.people_alt_outlined, size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No customers found',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, i) => _CustomerCard(customer: list[i], c: c),
//       );
//     });
//   }
// }
//
// class _CustomerCard extends StatelessWidget {
//   final CustomerModel customer;
//   final CustomersCon c;
//   const _CustomerCard({required this.customer, required this.c});
//
//   Color _statusColor(CustomerStatus s) {
//     switch (s) {
//       case CustomerStatus.active: return CColors.iconEmeraldGreen;
//       case CustomerStatus.vip: return const Color(0xFF7C3AED);
//       case CustomerStatus.inactive: return const Color(0xFF6B7280);
//     }
//   }
//
//   Color _statusBg(CustomerStatus s) {
//     switch (s) {
//       case CustomerStatus.active: return CColors.backgroundEmerald100;
//       case CustomerStatus.vip: return const Color(0xFFF3E8FF);
//       case CustomerStatus.inactive: return const Color(0xFFF3F4F6);
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
//                   color: customer.avatarColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     customer.name.substring(0, 2).toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
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
//                     Text(customer.name,
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: context.txtPrimary)),
//                     Text('${customer.email} · ${customer.location}',
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
//                   color: _statusBg(customer.status),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   customer.status.name[0].toUpperCase() +
//                       customer.status.name.substring(1),
//                   style: TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.w700,
//                       color: _statusColor(customer.status)),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Stats + actions
//           Row(
//             children: [
//               _chip(context, Icons.shopping_bag_outlined,
//                   '${customer.totalOrders} orders',
//                   CColors.backgroundEmerald100, CColors.iconEmeraldGreen),
//               const SizedBox(width: 8),
//               _chip(context, Icons.attach_money_rounded,
//                   '\$${customer.totalSpent.toStringAsFixed(0)}',
//                   const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () => c.messageCustomer(customer),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: CColors.backgroundEmerald100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.chat_bubble_outline_rounded,
//                           size: 13, color: CColors.iconEmeraldGreen),
//                       SizedBox(width: 4),
//                       Text('Message',
//                           style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: CColors.textEmeraldGreen)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Last order: ${customer.lastOrderDate.day}/${customer.lastOrderDate.month}/${customer.lastOrderDate.year}',
//             style: TextStyle(fontSize: 10, color: context.txtSecondary),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _chip(BuildContext context, IconData icon, String label,
//       Color bg, Color fg) {
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
