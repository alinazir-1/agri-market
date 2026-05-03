// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/payment_model.dart';
// import 'package:agri_market/data/models/product_type_enums.dart';
// import 'package:agri_market/features/seller/payments/payment_con.dart';
//
// class MobilePaymentsScr extends StatelessWidget {
//   const MobilePaymentsScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<PaymentsCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Obx(() {
//         final selectedFilter = c.selectedFilter.value;
//         final txList = c.filteredPayments;
//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Balance summary card
//               _BalanceCard(c: c),
//               const SizedBox(height: 16),
//               // Filter chips
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: _FilterChips(c: c, selectedFilter: selectedFilter),
//               ),
//               const SizedBox(height: 12),
//               // Transaction list
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: _TransactionList(c: c, payments: txList),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ── Balance Card ─────────────────────────────────────────────────────────────
//
// class _BalanceCard extends StatelessWidget {
//   final PaymentsCon c;
//   const _BalanceCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF0E7C66), Color(0xFF065F46)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Total Revenue',
//             style: TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '\$${c.totalRevenue.toStringAsFixed(0)}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _MetricTile(
//                   label: 'This Month',
//                   value: '\$${c.thisMonthRevenue.toStringAsFixed(0)}',
//                   icon: Icons.trending_up_rounded,
//                   color: const Color(0xFF86EFAC),
//                 ),
//               ),
//               Container(
//                   width: 1,
//                   height: 36,
//                   color: Colors.white.withValues(alpha: 0.2)),
//               Expanded(
//                 child: _MetricTile(
//                   label: 'Pending',
//                   value: '\$${c.pendingAmount.toStringAsFixed(0)}',
//                   icon: Icons.hourglass_empty_rounded,
//                   color: const Color(0xFFFDE68A),
//                 ),
//               ),
//               Container(
//                   width: 1,
//                   height: 36,
//                   color: Colors.white.withValues(alpha: 0.2)),
//               Expanded(
//                 child: _MetricTile(
//                   label: 'Failed',
//                   value: '\$${c.failedAmount.toStringAsFixed(0)}',
//                   icon: Icons.error_outline_rounded,
//                   color: const Color(0xFFFCA5A5),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MetricTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;
//
//   const _MetricTile({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: Column(
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(height: 3),
//           Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Text(
//             label,
//             style:
//                 const TextStyle(color: Colors.white60, fontSize: 10),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Filter Chips ─────────────────────────────────────────────────────────────
//
// class _FilterChips extends StatelessWidget {
//   final PaymentsCon c;
//   final PaymentFilter selectedFilter;
//   const _FilterChips({required this.c, required this.selectedFilter});
//
//   @override
//   Widget build(BuildContext context) {
//     final filters = PaymentFilter.values;
//     final labels = ['All', 'Paid', 'Pending', 'Partial', 'Failed'];
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(filters.length, (i) {
//           final isActive = selectedFilter == filters[i];
//           return Padding(
//             padding: EdgeInsets.only(right: i < filters.length - 1 ? 8 : 0),
//             child: GestureDetector(
//               onTap: () => c.selectedFilter.value = filters[i],
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: isActive
//                       ? CColors.backGroundEmeraldGreen
//                       : context.cardBg,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isActive
//                         ? CColors.backGroundEmeraldGreen
//                         : context.borderClr,
//                   ),
//                 ),
//                 child: Text(
//                   labels[i],
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: isActive ? Colors.white : context.txtSecondary,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// // ── Transaction List ─────────────────────────────────────────────────────────
//
// class _TransactionList extends StatelessWidget {
//   final PaymentsCon c;
//   final List<PaymentModel> payments;
//   const _TransactionList({required this.c, required this.payments});
//
//   @override
//   Widget build(BuildContext context) {
//     final list = payments;
//     if (list.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.payments_outlined,
//                   size: 48, color: context.txtSecondary),
//               const SizedBox(height: 12),
//               Text('No transactions found',
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: context.txtPrimary)),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Column(
//       children: list.asMap().entries.map((e) {
//         return _TransactionItem(payment: e.value, context: context);
//       }).toList(),
//     );
//   }
// }
//
// class _TransactionItem extends StatelessWidget {
//   final PaymentModel payment;
//   final BuildContext context;
//
//   const _TransactionItem(
//       {required this.payment, required this.context});
//
//   Color get _statusBg {
//     switch (payment.status) {
//       case PaymentStatus.paid:
//         return const Color(0xFFD1FAE5);
//       case PaymentStatus.pending:
//         return const Color(0xFFFEF9C3);
//       case PaymentStatus.partial:
//         return const Color(0xFFDBEAFE);
//       case PaymentStatus.failed:
//         return const Color(0xFFFEE2E2);
//     }
//   }
//
//   Color get _statusColor {
//     switch (payment.status) {
//       case PaymentStatus.paid:
//         return const Color(0xFF0E7C66);
//       case PaymentStatus.pending:
//         return const Color(0xFFA16207);
//       case PaymentStatus.partial:
//         return const Color(0xFF1D4ED8);
//       case PaymentStatus.failed:
//         return const Color(0xFFB91C1C);
//     }
//   }
//
//   String get _statusLabel {
//     switch (payment.status) {
//       case PaymentStatus.paid:
//         return 'Paid';
//       case PaymentStatus.pending:
//         return 'Pending';
//       case PaymentStatus.partial:
//         return 'Partial';
//       case PaymentStatus.failed:
//         return 'Failed';
//     }
//   }
//
//   String get _typeLabel {
//     switch (payment.productType) {
//       case ProductType.marketplace:
//         return 'Marketplace';
//       case ProductType.advanceBooking:
//       case ProductType.booking:
//         return 'Adv. Booking';
//       case ProductType.liveAuction:
//       case ProductType.auction:
//         return 'Auction';
//     }
//   }
//
//   String _formatDate(DateTime dt) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
//   }
//
//   @override
//   Widget build(BuildContext ctx) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: ctx.cardBg,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ctx.borderClr),
//       ),
//       child: Row(
//         children: [
//           // Avatar
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: payment.avatarColor,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 payment.buyerName.substring(0, 1),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   payment.buyerName,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: ctx.txtPrimary,
//                   ),
//                 ),
//                 Text(
//                   '${payment.productName}  •  ${_typeLabel}',
//                   style: TextStyle(fontSize: 11, color: ctx.txtSecondary),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   _formatDate(payment.date),
//                   style: TextStyle(fontSize: 11, color: ctx.txtSecondary),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '\$${payment.amount.toStringAsFixed(0)}',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: ctx.txtPrimary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: _statusBg,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _statusLabel,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: _statusColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
