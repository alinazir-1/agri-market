// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/notification_model.dart';
// import 'package:agri_market/features/seller/notifications/notifications_con.dart';
//
// class MobileNotificationsScr extends StatelessWidget {
//   const MobileNotificationsScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<NotificationsCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _StatsBar(c: c),
//           _FilterChips(c: c),
//           Expanded(child: _NotifList(c: c)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Stats ──────────────────────────────────────────────────────────────────
//
// class _StatsBar extends StatelessWidget {
//   final NotificationsCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           child: Row(
//             children: [
//               _stat(context, '${c.totalCount}', 'Total',
//                   const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
//               const SizedBox(width: 8),
//               _stat(context, '${c.unreadCount}', 'Unread',
//                   CColors.textError, const Color(0xFFFEE2E2)),
//               const SizedBox(width: 8),
//               _stat(context, '${c.todayCount}', 'Today',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               const Spacer(),
//               if (c.unreadCount > 0)
//                 GestureDetector(
//                   onTap: c.markAllRead,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: context.cardBg,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: context.borderClr),
//                     ),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.done_all_rounded,
//                             size: 13, color: CColors.iconEmeraldGreen),
//                         SizedBox(width: 4),
//                         Text('Mark all read',
//                             style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: CColors.textEmeraldGreen)),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ));
//   }
//
//   Widget _stat(BuildContext context, String value, String label, Color fg, Color bg) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Text(value,
//               style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w800,
//                   color: fg)),
//           const SizedBox(height: 2),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 10,
//                   color: context.txtSecondary,
//                   fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Filter Chips ───────────────────────────────────────────────────────────
//
// class _FilterChips extends StatelessWidget {
//   final NotificationsCon c;
//   const _FilterChips({required this.c});
//
//   static const _filters = [
//     (NotificationFilter.all, 'All'),
//     (NotificationFilter.unread, 'Unread'),
//     (NotificationFilter.orders, 'Orders'),
//     (NotificationFilter.payments, 'Payments'),
//     (NotificationFilter.system, 'System'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: Obx(() {
//         final activeFilter = c.activeFilter.value;
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
// // ── Notification List ──────────────────────────────────────────────────────
//
// class _NotifList extends StatelessWidget {
//   final NotificationsCon c;
//   const _NotifList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.filteredNotifications;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.notifications_off_outlined,
//                 size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No notifications',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//             const SizedBox(height: 4),
//             Text("You're all caught up!",
//                 style: TextStyle(
//                     fontSize: 12, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 8),
//         itemBuilder: (_, i) => _NotifCard(notification: list[i], c: c),
//       );
//     });
//   }
// }
//
// class _NotifCard extends StatelessWidget {
//   final NotificationModel notification;
//   final NotificationsCon c;
//   const _NotifCard({required this.notification, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final n = notification;
//     return GestureDetector(
//       onTap: () => c.selectNotification(n),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 120),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: n.isRead ? context.cardBg : const Color(0xFFF0FDF4),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: n.isRead ? context.borderClr : CColors.borderEmeraldGreen.withOpacity(0.3),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icon
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: n.iconBg,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(n.icon, size: 18, color: n.iconColor),
//             ),
//             const SizedBox(width: 10),
//             // Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: n.iconBg,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           n.typeLabel,
//                           style: TextStyle(
//                               fontSize: 9,
//                               fontWeight: FontWeight.w700,
//                               color: n.iconColor),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           n.title,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: n.isRead
//                                 ? FontWeight.w500
//                                 : FontWeight.w700,
//                             color: context.txtPrimary,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     n.body,
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: context.txtSecondary,
//                       height: 1.4,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             // Time + dot
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   c.formatTime(n.time),
//                   style: TextStyle(fontSize: 9, color: context.txtSecondary),
//                 ),
//                 if (!n.isRead) ...[
//                   const SizedBox(height: 6),
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       color: CColors.notificationDot,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
