// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/features/seller/help_support/help_support_con.dart';
//
// class MobileHelpSupportScr extends StatelessWidget {
//   const MobileHelpSupportScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<HelpSupportCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _HeroBanner(c: c),
//             const SizedBox(height: 16),
//             _ContactSection(),
//             const SizedBox(height: 14),
//             _ResourcesSection(),
//             const SizedBox(height: 14),
//             _FaqSection(c: c),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Hero Banner ────────────────────────────────────────────────────────────
//
// class _HeroBanner extends StatelessWidget {
//   final HelpSupportCon c;
//   const _HeroBanner({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF0E7C66), Color(0xFF1AA37A)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: const Icon(Icons.support_agent_rounded,
//                 size: 24, color: Colors.white),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'How can we help you?',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             'Search our knowledge base or browse FAQs',
//             style: TextStyle(fontSize: 12, color: Colors.white70),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           Container(
//             height: 44,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(22),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.10),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: c.searchController,
//               onChanged: c.onSearch,
//               style: const TextStyle(
//                   fontSize: 13, color: CColors.textPrimary),
//               decoration: const InputDecoration(
//                 hintText: 'Search FAQs, topics...',
//                 hintStyle: TextStyle(
//                     fontSize: 13, color: CColors.textSecondary),
//                 prefixIcon: Icon(Icons.search_rounded,
//                     color: CColors.iconEmeraldGreen, size: 20),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(vertical: 13),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Contact Section ────────────────────────────────────────────────────────
//
// class _ContactSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: context.borderClr),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//             child: Text(
//               'Contact Support',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: context.txtPrimary,
//               ),
//             ),
//           ),
//           Divider(height: 1, color: context.borderClr),
//           _ContactTile(
//             icon: Icons.chat_bubble_outline_rounded,
//             bg: const Color(0xFFDBEAFE),
//             fg: const Color(0xFF1D4ED8),
//             title: 'Live Chat',
//             subtitle: 'Avg. response: 2 min',
//           ),
//           Divider(height: 1, color: context.dividerClr),
//           _ContactTile(
//             icon: Icons.email_outlined,
//             bg: const Color(0xFFF3E8FF),
//             fg: const Color(0xFF7C3AED),
//             title: 'Email Us',
//             subtitle: 'support@agrimarket.com',
//           ),
//           Divider(height: 1, color: context.dividerClr),
//           _ContactTile(
//             icon: Icons.phone_outlined,
//             bg: const Color(0xFFD1FAE5),
//             fg: CColors.textEmeraldGreen,
//             title: 'Call Support',
//             subtitle: '+92 51 111-AGRI',
//             last: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ContactTile extends StatelessWidget {
//   const _ContactTile({
//     required this.icon,
//     required this.bg,
//     required this.fg,
//     required this.title,
//     required this.subtitle,
//     this.last = false,
//   });
//   final IconData icon;
//   final Color bg, fg;
//   final String title, subtitle;
//   final bool last;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: bg,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 18, color: fg),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: context.txtPrimary)),
//                 Text(subtitle,
//                     style: TextStyle(
//                         fontSize: 11, color: context.txtSecondary)),
//               ],
//             ),
//           ),
//           Icon(Icons.arrow_forward_ios_rounded,
//               size: 12, color: context.txtSecondary),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Resources Section ──────────────────────────────────────────────────────
//
// class _ResourcesSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: context.borderClr),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//             child: Text(
//               'Quick Resources',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: context.txtPrimary,
//               ),
//             ),
//           ),
//           Divider(height: 1, color: context.borderClr),
//           _ResourceTile(
//               icon: Icons.menu_book_outlined, label: 'Documentation'),
//           Divider(height: 1, color: context.dividerClr),
//           _ResourceTile(
//               icon: Icons.play_circle_outline_rounded,
//               label: 'Video Tutorials'),
//           Divider(height: 1, color: context.dividerClr),
//           _ResourceTile(
//               icon: Icons.bug_report_outlined, label: 'Report a Problem'),
//           Divider(height: 1, color: context.dividerClr),
//           _ResourceTile(
//               icon: Icons.lightbulb_outline_rounded,
//               label: 'Feature Requests',
//               last: true),
//         ],
//       ),
//     );
//   }
// }
//
// class _ResourceTile extends StatelessWidget {
//   const _ResourceTile({
//     required this.icon,
//     required this.label,
//     this.last = false,
//   });
//   final IconData icon;
//   final String label;
//   final bool last;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: CColors.iconEmeraldGreen),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(label,
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: context.txtPrimary)),
//           ),
//           Icon(Icons.arrow_forward_ios_rounded,
//               size: 11, color: context.txtSecondary),
//         ],
//       ),
//     );
//   }
// }
//
// // ── FAQ Section ────────────────────────────────────────────────────────────
//
// class _FaqSection extends StatelessWidget {
//   final HelpSupportCon c;
//   const _FaqSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: context.borderClr),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
//             child: Row(
//               children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: CColors.backgroundEmerald100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(Icons.quiz_outlined,
//                       size: 15, color: CColors.iconEmeraldGreen),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'Frequently Asked Questions',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: context.txtPrimary,
//                     ),
//                   ),
//                 ),
//                 Obx(() => Text(
//                       '${c.filteredFaqs.length} articles',
//                       style: TextStyle(
//                           fontSize: 11, color: context.txtSecondary),
//                     )),
//               ],
//             ),
//           ),
//           Divider(height: 1, color: context.borderClr),
//           Obx(() {
//             final faqs = c.filteredFaqs;
//             if (faqs.isEmpty) {
//               return Padding(
//                 padding: const EdgeInsets.all(32),
//                 child: Column(
//                   children: [
//                     Icon(Icons.search_off_rounded,
//                         size: 32, color: context.txtSecondary),
//                     const SizedBox(height: 10),
//                     Text('No results found',
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: context.txtPrimary)),
//                     const SizedBox(height: 4),
//                     Text('Try different keywords',
//                         style: TextStyle(
//                             fontSize: 11, color: context.txtSecondary)),
//                   ],
//                 ),
//               );
//             }
//             return Column(
//               children: List.generate(faqs.length, (i) {
//                 return _FaqTile(
//                   faq: faqs[i],
//                   index: i,
//                   c: c,
//                   last: i == faqs.length - 1,
//                 );
//               }),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// class _FaqTile extends StatelessWidget {
//   const _FaqTile({
//     required this.faq,
//     required this.index,
//     required this.c,
//     required this.last,
//   });
//   final FaqItem faq;
//   final int index;
//   final HelpSupportCon c;
//   final bool last;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final expanded = c.expandedIndex.value == index;
//       return Column(
//         children: [
//           GestureDetector(
//             onTap: () => c.toggleFaq(index),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 150),
//               color: expanded
//                   ? CColors.fillColor.withOpacity(
//                       context.isDark ? 0.05 : 1.0)
//                   : Colors.transparent,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 7, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: CColors.backgroundEmerald100,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             faq.category,
//                             style: const TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w700,
//                                 color: CColors.textEmeraldGreen),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           faq.question,
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: expanded
//                                 ? CColors.textEmeraldGreen
//                                 : context.txtPrimary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   AnimatedRotation(
//                     turns: expanded ? 0.5 : 0,
//                     duration: const Duration(milliseconds: 200),
//                     child: Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       size: 20,
//                       color: expanded
//                           ? CColors.iconEmeraldGreen
//                           : context.txtSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           AnimatedCrossFade(
//             firstChild: const SizedBox(width: double.infinity),
//             secondChild: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
//               color: CColors.fillColor.withOpacity(
//                   context.isDark ? 0.05 : 1.0),
//               child: Text(
//                 faq.answer,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: context.txtSecondary,
//                   height: 1.6,
//                 ),
//               ),
//             ),
//             crossFadeState: expanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 200),
//           ),
//           if (!last) Divider(height: 1, color: context.dividerClr),
//         ],
//       );
//     });
//   }
// }
