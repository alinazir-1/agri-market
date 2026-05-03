// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/features/seller/business_profile/business_profile_con.dart';
//
// class MobileProfileScr extends StatelessWidget {
//   const MobileProfileScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<BusinessProfileCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _ProfileHeader(context: context),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: _InfoSection(c: c, context: context),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: _StatsSection(context: context),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: _EditButton(),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Profile Header ────────────────────────────────────────────────────────────
//
// class _ProfileHeader extends StatelessWidget {
//   final BuildContext context;
//   const _ProfileHeader({required this.context});
//
//   @override
//   Widget build(BuildContext ctx) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF0E7C66), Color(0xFF065F46)],
//         ),
//       ),
//       child: Column(
//         children: [
//           // Avatar
//           Container(
//             width: 72,
//             height: 72,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.2),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2.5),
//             ),
//             child: const Center(
//               child: Text(
//                 'AS',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'Ahmed Seller',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'ahmed@agrimarket.com',
//             style: TextStyle(color: Colors.white70, fontSize: 13),
//           ),
//           const SizedBox(height: 10),
//           // Verified badge
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                   color: Colors.white.withValues(alpha: 0.4), width: 1),
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.verified_rounded,
//                     color: Colors.amber, size: 14),
//                 SizedBox(width: 5),
//                 Text(
//                   'Verified Seller',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
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
// // ── Info Section ──────────────────────────────────────────────────────────────
//
// class _InfoSection extends StatelessWidget {
//   final BusinessProfileCon c;
//   final BuildContext context;
//   const _InfoSection({required this.c, required this.context});
//
//   @override
//   Widget build(BuildContext ctx) {
//     return Obx(() => Container(
//           decoration: BoxDecoration(
//             color: ctx.cardBg,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: ctx.borderClr),
//           ),
//           child: Column(
//             children: [
//               _InfoTile(
//                 icon: Icons.storefront_outlined,
//                 label: 'Business Name',
//                 value: c.businessName.text.isNotEmpty
//                     ? c.businessName.text
//                     : 'Green Valley Farms',
//                 context: ctx,
//               ),
//               Divider(height: 1, color: ctx.borderClr),
//               _InfoTile(
//                 icon: Icons.phone_outlined,
//                 label: 'Phone',
//                 value: c.phone.text.isNotEmpty
//                     ? c.phone.text
//                     : '+92 300 1234567',
//                 context: ctx,
//               ),
//               Divider(height: 1, color: ctx.borderClr),
//               _InfoTile(
//                 icon: Icons.location_on_outlined,
//                 label: 'Location',
//                 value: c.city.text.isNotEmpty
//                     ? '${c.city.text}, ${c.country.text}'
//                     : 'Lahore, Pakistan',
//                 context: ctx,
//               ),
//               Divider(height: 1, color: ctx.borderClr),
//               _InfoTile(
//                 icon: Icons.category_outlined,
//                 label: 'Category',
//                 value: c.selectedCategory.value.isNotEmpty
//                     ? c.selectedCategory.value
//                     : 'Grains & Cereals',
//                 context: ctx,
//                 isLast: true,
//               ),
//             ],
//           ),
//         ));
//   }
// }
//
// class _InfoTile extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final BuildContext context;
//   final bool isLast;
//
//   const _InfoTile({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.context,
//     this.isLast = false,
//   });
//
//   @override
//   Widget build(BuildContext ctx) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: const Color(0xFFD1FAE5),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon,
//                 size: 18, color: CColors.backGroundEmeraldGreen),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                       fontSize: 11, color: ctx.txtSecondary),
//                 ),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: ctx.txtPrimary,
//                   ),
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
// // ── Stats Section ─────────────────────────────────────────────────────────────
//
// class _StatsSection extends StatelessWidget {
//   final BuildContext context;
//   const _StatsSection({required this.context});
//
//   @override
//   Widget build(BuildContext ctx) {
//     return Row(
//       children: [
//         Expanded(
//           child: _StatTile(
//             label: 'Products',
//             value: '89',
//             icon: Icons.inventory_2_outlined,
//             context: ctx,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _StatTile(
//             label: 'Orders',
//             value: '1,247',
//             icon: Icons.shopping_bag_outlined,
//             context: ctx,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _StatTile(
//             label: 'Rating',
//             value: '4.8',
//             icon: Icons.star_outline_rounded,
//             context: ctx,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _StatTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final BuildContext context;
//
//   const _StatTile({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.context,
//   });
//
//   @override
//   Widget build(BuildContext ctx) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//       decoration: BoxDecoration(
//         color: ctx.cardBg,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ctx.borderClr),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 20, color: CColors.backGroundEmeraldGreen),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: ctx.txtPrimary,
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(fontSize: 11, color: ctx.txtSecondary),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Edit Button ───────────────────────────────────────────────────────────────
//
// class _EditButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: () {},
//         icon: const Icon(Icons.edit_outlined, size: 18),
//         label: const Text('Edit Profile',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: CColors.backGroundEmeraldGreen,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 13),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           elevation: 0,
//         ),
//       ),
//     );
//   }
// }
