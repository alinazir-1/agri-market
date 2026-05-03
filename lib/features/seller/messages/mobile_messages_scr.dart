// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/message_model.dart';
// import 'package:agri_market/features/seller/messages/message_con.dart';
//
// class MobileMessagesScr extends StatelessWidget {
//   const MobileMessagesScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<MessagesCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           // Search bar
//           _SearchBar(c: c),
//           // Filter chips
//           Obx(() => _FilterChips(c: c, activeTab: c.activeTab.value)),
//           // Conversation list
//           Expanded(
//             child: Obx(() => _ConversationList(
//               c: c,
//               activeTab: c.activeTab.value,
//               searchQuery: c.convSearch.value,
//             )),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Search Bar ───────────────────────────────────────────────────────────────
//
// class _SearchBar extends StatelessWidget {
//   final MessagesCon c;
//   const _SearchBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: context.cardBg,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//       child: TextField(
//         controller: c.convSearchController,
//         onChanged: (v) => c.convSearch.value = v,
//         decoration: InputDecoration(
//           hintText: 'Search conversations...',
//           hintStyle: TextStyle(fontSize: 13, color: context.txtSecondary),
//           prefixIcon: Icon(Icons.search_rounded,
//               size: 18, color: context.txtSecondary),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           filled: true,
//           fillColor: context.appBg,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: context.borderClr),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: context.borderClr),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(
//                 color: CColors.backGroundEmeraldGreen, width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Filter Chips ─────────────────────────────────────────────────────────────
//
// class _FilterChips extends StatelessWidget {
//   final MessagesCon c;
//   final ConversationTab activeTab;
//   const _FilterChips({required this.c, required this.activeTab});
//
//   @override
//   Widget build(BuildContext context) {
//     final tabs = [ConversationTab.all, ConversationTab.unread, ConversationTab.orders];
//     final labels = ['All', 'Unread', 'Orders'];
//
//     return Container(
//       color: context.cardBg,
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//       child: Row(
//         children: List.generate(tabs.length, (i) {
//           final isActive = activeTab == tabs[i];
//           return Padding(
//             padding: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
//             child: GestureDetector(
//               onTap: () => c.activeTab.value = tabs[i],
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: isActive
//                       ? CColors.backGroundEmeraldGreen
//                       : context.appBg,
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
//                     color:
//                         isActive ? Colors.white : context.txtSecondary,
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
// // ── Conversation List ────────────────────────────────────────────────────────
//
// class _ConversationList extends StatelessWidget {
//   final MessagesCon c;
//   final ConversationTab activeTab;
//   final String searchQuery;
//   const _ConversationList({
//     required this.c,
//     required this.activeTab,
//     required this.searchQuery,
//   });
//
//   List<ConversationModel> get _filtered {
//     List<ConversationModel> list = List.from(c.conversations);
//     switch (activeTab) {
//       case ConversationTab.unread:
//         list = list.where((conv) => conv.unreadCount > 0).toList();
//         break;
//       case ConversationTab.orders:
//         list = list.where((conv) => conv.recentOrders.isNotEmpty).toList();
//         break;
//       default:
//         break;
//     }
//     final q = searchQuery.toLowerCase();
//     if (q.isNotEmpty) {
//       list = list
//           .where((conv) => conv.buyerName.toLowerCase().contains(q))
//           .toList();
//     }
//     return list;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final convs = _filtered;
//     if (convs.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.chat_bubble_outline_rounded,
//                 size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No conversations',
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: context.txtPrimary)),
//           ],
//         ),
//       );
//     }
//     return ListView.separated(
//       itemCount: convs.length,
//       separatorBuilder: (_, __) =>
//           Divider(height: 1, color: context.borderClr),
//       itemBuilder: (ctx, i) => _ConversationItem(conv: convs[i]),
//     );
//   }
// }
//
// class _ConversationItem extends StatelessWidget {
//   final ConversationModel conv;
//   const _ConversationItem({required this.conv});
//
//   String _timeText(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m';
//     if (diff.inHours < 24) return '${diff.inHours}h';
//     return '${diff.inDays}d';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             // Avatar with online dot
//             Stack(
//               children: [
//                 Container(
//                   width: 46,
//                   height: 46,
//                   decoration: BoxDecoration(
//                     color: conv.avatarColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       conv.buyerName.substring(0, 1),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (conv.isOnline)
//                   Positioned(
//                     bottom: 1,
//                     right: 1,
//                     child: Container(
//                       width: 11,
//                       height: 11,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF22C55E),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 1.5),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             conv.buyerName,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: conv.unreadCount > 0
//                                   ? FontWeight.w700
//                                   : FontWeight.w500,
//                               color: context.txtPrimary,
//                             ),
//                           ),
//                           if (conv.isVip) ...[
//                             const SizedBox(width: 4),
//                             const Icon(Icons.star_rounded,
//                                 size: 12, color: Colors.amber),
//                           ],
//                         ],
//                       ),
//                       Text(
//                         _timeText(conv.lastMessageTime),
//                         style: TextStyle(
//                             fontSize: 11, color: context.txtSecondary),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 3),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           conv.lastMessage,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: conv.unreadCount > 0
//                                 ? context.txtPrimary
//                                 : context.txtSecondary,
//                             fontWeight: conv.unreadCount > 0
//                                 ? FontWeight.w500
//                                 : FontWeight.w400,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       if (conv.unreadCount > 0) ...[
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: CColors.backGroundEmeraldGreen,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '${conv.unreadCount}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
