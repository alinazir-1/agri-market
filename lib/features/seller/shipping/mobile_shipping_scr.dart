// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/shipping_model.dart';
// import 'package:agri_market/features/seller/shipping/widgets/shipping_widgets.dart';
//
// class MobileShippingScr extends StatelessWidget {
//   const MobileShippingScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ShippingCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _TabBar(c: c),
//           Expanded(
//             child: Obx(() => c.activeTab.value == ShippingTab.shipments
//                 ? _ShipmentsTab(c: c)
//                 : _PartnersTab(c: c)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Tab Bar ────────────────────────────────────────────────────────────────
//
// class _TabBar extends StatelessWidget {
//   final ShippingCon c;
//   const _TabBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           child: Row(
//             children: [
//               _tab(context, '📦  Shipments', ShippingTab.shipments, c),
//               _tab(context, '🚚  Partners', ShippingTab.deliveryPartners, c),
//             ],
//           ),
//         ));
//   }
//
//   Widget _tab(BuildContext context, String label, ShippingTab tab, ShippingCon c) {
//     final isActive = c.activeTab.value == tab;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => c.setTab(tab),
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
// // ── Shipments Tab ──────────────────────────────────────────────────────────
//
// class _ShipmentsTab extends StatelessWidget {
//   final ShippingCon c;
//   const _ShipmentsTab({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _StatsBar(c: c),
//         _FilterChips(c: c),
//         Expanded(child: _ShipmentList(c: c)),
//       ],
//     );
//   }
// }
//
// class _StatsBar extends StatelessWidget {
//   final ShippingCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           child: Row(
//             children: [
//               _stat(context, '${c.totalShipments}', 'Total',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const SizedBox(width: 6),
//               _stat(context, '${c.inTransitCount}', 'Transit',
//                   const Color(0xFF0369A1), const Color(0xFFE0F2FE)),
//               const SizedBox(width: 6),
//               _stat(context, '${c.deliveredCount}', 'Delivered',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const SizedBox(width: 6),
//               _stat(context, '${c.delayedCount}', 'Delayed',
//                   CColors.backGroundOrange, const Color(0xFFFFF7ED)),
//             ],
//           ),
//         ));
//   }
//
//   Widget _stat(BuildContext context, String value, String label, Color fg, Color bg) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             Text(value,
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                     color: fg)),
//             const SizedBox(height: 2),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 9,
//                     color: context.txtSecondary,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _FilterChips extends StatelessWidget {
//   final ShippingCon c;
//   const _FilterChips({required this.c});
//
//   static const _filters = [
//     (ShippingFilter.all, 'All', CColors.backGroundEmeraldGreen),
//     (ShippingFilter.pending, 'Pending', CColors.backGroundOrange),
//     (ShippingFilter.inTransit, 'In Transit', Color(0xFF0369A1)),
//     (ShippingFilter.delivered, 'Delivered', CColors.backGroundEmeraldGreen),
//     (ShippingFilter.cancelled, 'Cancelled', CColors.borderError),
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
//               final (filter, label, activeColor) = _filters[i];
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
//                       color: active ? activeColor : context.borderClr,
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
// class _ShipmentList extends StatelessWidget {
//   final ShippingCon c;
//   const _ShipmentList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.filteredShipments;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.local_shipping_outlined,
//                 size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No shipments found',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, i) => _ShipmentCard(shipment: list[i], c: c),
//       );
//     });
//   }
// }
//
// class _ShipmentCard extends StatelessWidget {
//   final ShipmentModel shipment;
//   final ShippingCon c;
//   const _ShipmentCard({required this.shipment, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final s = shipment;
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
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('#${s.orderId}',
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: context.txtPrimary)),
//                     Text(c.formatDate(s.orderDate),
//                         style: TextStyle(
//                             fontSize: 10, color: context.txtSecondary)),
//                   ],
//                 ),
//               ),
//               ShipStatusPill(status: s.status),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Product + buyer
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(s.productName,
//                         style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: context.txtPrimary),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis),
//                     Text('${s.quantity} ${s.unit}',
//                         style: TextStyle(
//                             fontSize: 10, color: context.txtSecondary)),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(s.buyerName,
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: context.txtPrimary)),
//                   Text(s.buyerLocation,
//                       style: TextStyle(
//                           fontSize: 10, color: context.txtSecondary)),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Progress bar
//           ShipmentProgressBar(currentStep: s.progressStep),
//           const SizedBox(height: 10),
//           // Tracking + partner
//           Row(
//             children: [
//               if (s.partnerName != null) ...[
//                 Icon(Icons.local_shipping_outlined,
//                     size: 12, color: CColors.iconEmeraldGreen),
//                 const SizedBox(width: 4),
//                 Text(s.partnerName!,
//                     style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: CColors.textEmeraldGreen)),
//                 const SizedBox(width: 10),
//               ],
//               if (s.trackingNumber != null) ...[
//                 Icon(Icons.pin_drop_outlined,
//                     size: 12, color: context.txtSecondary),
//                 const SizedBox(width: 4),
//                 Text(s.trackingNumber!,
//                     style: TextStyle(
//                         fontSize: 10, color: context.txtSecondary)),
//               ],
//               const Spacer(),
//               if (s.estimatedDelivery != null)
//                 Text(
//                   'Est: ${c.formatDate(s.estimatedDelivery!)}',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: s.isDelayed
//                         ? CColors.backGroundOrange
//                         : context.txtSecondary,
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (s.status == ShipmentStatus.pending)
//                 _actionBtn('Dispatch', CColors.textEmeraldGreen,
//                     const Color(0xFFBBF7D0), () => c.markAsDispatched(s.id)),
//               if (s.status != ShipmentStatus.cancelled &&
//                   s.status != ShipmentStatus.pending) ...[
//                 const SizedBox(width: 8),
//                 _actionBtn('Track', CColors.textEmeraldGreen,
//                     const Color(0xFFBBF7D0), () => c.trackShipment(s)),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _actionBtn(
//       String label, Color textColor, Color borderColor, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: borderColor.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: borderColor),
//         ),
//         child: Text(label,
//             style: TextStyle(
//                 fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
//       ),
//     );
//   }
// }
//
// // ── Partners Tab ───────────────────────────────────────────────────────────
//
// class _PartnersTab extends StatelessWidget {
//   final ShippingCon c;
//   const _PartnersTab({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: c.partners.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 10),
//           itemBuilder: (_, i) {
//             final p = c.partners[i];
//             return DeliveryPartnerCard(
//               partner: p,
//               onAssign: () => c.assignPartnerToOrder(p),
//               onViewDetails: () => c.viewPartnerDetails(p),
//               onToggleStatus: () => c.togglePartnerStatus(p.id),
//             );
//           },
//         ));
//   }
// }
