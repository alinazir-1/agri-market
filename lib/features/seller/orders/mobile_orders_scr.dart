// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/order_model.dart';
// import 'package:agri_market/features/seller/orders/orders_con.dart';
//
// class MobileOrdersScr extends StatelessWidget {
//   const MobileOrdersScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<OrdersCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _StatsBar(c: c),
//           _MainTabs(c: c),
//           Expanded(child: Obx(() => c.mainTabIndex.value == 0
//               ? _OrdersTab(c: c)
//               : _SamplesTab(c: c))),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Stats ──────────────────────────────────────────────────────────────────
//
// class _StatsBar extends StatelessWidget {
//   final OrdersCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           child: Row(
//             children: [
//               _stat(context, '${c.totalOrders}', 'Total',
//                   const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
//               const SizedBox(width: 8),
//               _stat(context, '${c.pendingOrders}', 'Pending',
//                   CColors.backGroundOrange, const Color(0xFFFFF7ED)),
//               const SizedBox(width: 8),
//               _stat(context, '${c.processingOrders}', 'Processing',
//                   const Color(0xFF1D4ED8), const Color(0xFFDBEAFE)),
//               const SizedBox(width: 8),
//               _stat(context, '\$${(c.monthRevenue / 1000).toStringAsFixed(1)}k',
//                   'Revenue', CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
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
// // ── Main Tabs ──────────────────────────────────────────────────────────────
//
// class _MainTabs extends StatelessWidget {
//   final OrdersCon c;
//   const _MainTabs({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           child: Row(
//             children: [
//               _tab(context, 'Orders', 0, c),
//               _tab(context, 'Sample Requests', 1, c),
//             ],
//           ),
//         ));
//   }
//
//   Widget _tab(BuildContext context, String label, int idx, OrdersCon c) {
//     final isActive = c.mainTabIndex.value == idx;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => c.setMainTab(idx),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: isActive ? CColors.borderEmeraldGreen : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//           ),
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
//               color: isActive ? CColors.textEmeraldGreen : context.txtSecondary,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Orders Tab ─────────────────────────────────────────────────────────────
//
// class _OrdersTab extends StatelessWidget {
//   final OrdersCon c;
//   const _OrdersTab({required this.c});
//
//   static const _tabs = ['All', 'Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Status filter chips
//         SizedBox(
//           height: 44,
//           child: Obx(() {
//             final selectedTab = c.selectedTab.value;
//             return ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 itemCount: _tabs.length,
//                 separatorBuilder: (_, __) => const SizedBox(width: 6),
//                 itemBuilder: (_, i) {
//                   final active = selectedTab == i;
//                   return GestureDetector(
//                     onTap: () => c.selectTab(i),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 150),
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: active ? CColors.backGroundEmeraldGreen : context.cardBg,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: active ? CColors.borderEmeraldGreen : context.borderClr,
//                         ),
//                       ),
//                       child: Text(
//                         _tabs[i],
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: active ? CColors.textWhite : context.txtSecondary,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//           }),
//         ),
//         // Order list
//         Expanded(
//           child: Obx(() {
//             final list = c.filteredOrders;
//             if (list.isEmpty) {
//               return Center(
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.shopping_bag_outlined, size: 48, color: context.txtSecondary),
//                   const SizedBox(height: 12),
//                   Text('No orders found',
//                       style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//                 ]),
//               );
//             }
//             return ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: list.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 10),
//               itemBuilder: (_, i) => _OrderCard(order: list[i], c: c),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
//
// class _OrderCard extends StatelessWidget {
//   final OrderModel order;
//   final OrdersCon c;
//   const _OrderCard({required this.order, required this.c});
//
//   Color _statusColor(OrderStatus s) {
//     switch (s) {
//       case OrderStatus.pending: return CColors.backGroundOrange;
//       case OrderStatus.confirmed: return const Color(0xFF1D4ED8);
//       case OrderStatus.processing: return const Color(0xFF7C3AED);
//       case OrderStatus.shipped: return const Color(0xFF0369A1);
//       case OrderStatus.delivered: return CColors.iconEmeraldGreen;
//       case OrderStatus.cancelled: return CColors.iconError;
//     }
//   }
//
//   String _statusLabel(OrderStatus s) => s.name[0].toUpperCase() + s.name.substring(1);
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
//           // Header row
//           Row(
//             children: [
//               Expanded(
//                 child: Text(order.orderId,
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: context.txtPrimary)),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: _statusColor(order.orderStatus).withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   _statusLabel(order.orderStatus),
//                   style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       color: _statusColor(order.orderStatus)),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Product info
//           Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   order.productImage,
//                   width: 44,
//                   height: 44,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     width: 44,
//                     height: 44,
//                     color: CColors.backgroundEmerald100,
//                     child: const Icon(Icons.image_outlined,
//                         size: 18, color: CColors.iconEmeraldGreen),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(order.productName,
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: context.txtPrimary),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis),
//                     const SizedBox(height: 2),
//                     Text('${order.quantity} ${order.unit} · ${order.buyerName}',
//                         style: TextStyle(
//                             fontSize: 11, color: context.txtSecondary)),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text('\$${order.totalAmount.toStringAsFixed(0)}',
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w800,
//                           color: context.txtPrimary)),
//                   Text(order.buyerLocation,
//                       style: TextStyle(
//                           fontSize: 10, color: context.txtSecondary)),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Payment status + date
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: order.orderPaymentStatus == OrderPaymentStatus.paid
//                       ? CColors.backgroundEmerald100
//                       : order.orderPaymentStatus == OrderPaymentStatus.partial
//                           ? const Color(0xFFFFF7ED)
//                           : const Color(0xFFFEE2E2),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   order.orderPaymentStatus.name[0].toUpperCase() +
//                       order.orderPaymentStatus.name.substring(1),
//                   style: TextStyle(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                     color: order.orderPaymentStatus == OrderPaymentStatus.paid
//                         ? CColors.textEmeraldGreen
//                         : order.orderPaymentStatus == OrderPaymentStatus.partial
//                             ? CColors.textOrange
//                             : CColors.textError,
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
//                 style: TextStyle(fontSize: 10, color: context.txtSecondary),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Samples Tab ────────────────────────────────────────────────────────────
//
// class _SamplesTab extends StatelessWidget {
//   final OrdersCon c;
//   const _SamplesTab({required this.c});
//
//   Color _sampleStatusColor(SampleStatus s) {
//     switch (s) {
//       case SampleStatus.newRequest: return const Color(0xFF1D4ED8);
//       case SampleStatus.accepted: return CColors.iconEmeraldGreen;
//       case SampleStatus.dispatched: return const Color(0xFF0369A1);
//       case SampleStatus.delivered: return CColors.iconEmeraldGreen;
//       case SampleStatus.rejected: return CColors.iconError;
//       case SampleStatus.cancelled: return const Color(0xFF6B7280);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.sampleRequests;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.science_outlined, size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No sample requests',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, i) {
//           final s = list[i];
//           return Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: context.cardBg,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: context.borderClr),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset(
//                     s.productImage,
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
//                       Text(s.productName,
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: context.txtPrimary),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis),
//                       const SizedBox(height: 2),
//                       Text('${s.buyerName} · ${s.sampleQty} ${s.sampleUnit}',
//                           style: TextStyle(
//                               fontSize: 11, color: context.txtSecondary)),
//                       Text(s.sampleId,
//                           style: TextStyle(
//                               fontSize: 10, color: context.txtSecondary)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: _sampleStatusColor(s.status).withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     s.status.name[0].toUpperCase() + s.status.name.substring(1),
//                     style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700,
//                         color: _sampleStatusColor(s.status)),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }
