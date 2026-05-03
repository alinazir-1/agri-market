// // lib/features/seller/dashboard/mobile_dashboard_scr.dart
// // ✅ Reused: AppColors, AppSize, AppText, AppContainer, ThemeColors,
// //            DashboardCon, DashStat, DashOrder, DashActivity
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/constants/sizes.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/features/seller/dashboard/dashboard_con.dart';
//
// import '../../../shared/widgets/common/app_container.dart';
// import '../../../shared/widgets/common/app_text.dart';
//
// class MobileDashboardScr extends StatelessWidget {
//   const MobileDashboardScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<DashboardCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(AppSize.space16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _GreetingCard(),
//             const SizedBox(height: AppSize.space16),
//             _RevenueCard(c: c),
//             const SizedBox(height: AppSize.space16),
//             _StatsGrid(c: c),
//             const SizedBox(height: AppSize.space16),
//             _RecentOrdersList(c: c),
//             const SizedBox(height: AppSize.space16),
//             _ActivityList(c: c),
//             const SizedBox(height: AppSize.space24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  GREETING CARD
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _GreetingCard extends StatelessWidget {
//   _GreetingCard();
//
//   final String greeting = () {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Good Morning';
//     if (hour < 17) return 'Good Afternoon';
//     return 'Good Evening';
//   }();
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppSize.space16),
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       gradient: const LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [AppColors.emeraldGreen, Color(0xFF065F46)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText(
//             text: '$greeting, Ahmed!',
//             fontSize: AppSize.font18Large2,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textWhite,
//           ),
//           const SizedBox(height: AppSize.space4),
//           AppText(
//             text: "Here's your business overview for today",
//             fontSize: AppSize.font13Small,
//             color: AppColors.textWhite,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  REVENUE CARD
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _RevenueCard extends StatelessWidget {
//   final DashboardCon c;
//   const _RevenueCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       padding: const EdgeInsets.all(AppSize.space16),
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(color: context.borderClr),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText(
//             text: 'Revenue Overview',
//             fontSize: AppSize.font14Medium2,
//             fontWeight: FontWeight.w600,
//             color: context.txtPrimary,
//           ),
//           const SizedBox(height: AppSize.space12),
//           Row(
//             children: [
//               Expanded(
//                 child: _RevenueMetric(
//                   label: 'This Month',
//                   value: '\$24,580',
//                   trend: '+12.5%',
//                   isPositive: true,
//                 ),
//               ),
//               AppContainer(
//                 width: 1,
//                 height: 48,
//                 backgroundColor: context.borderClr,
//               ),
//               Expanded(
//                 child: _RevenueMetric(
//                   label: 'Last Month',
//                   value: '\$20,100',
//                   trend: '+5.8%',
//                   isPositive: true,
//                 ),
//               ),
//               AppContainer(
//                 width: 1,
//                 height: 48,
//                 backgroundColor: context.borderClr,
//               ),
//               Expanded(
//                 child: _RevenueMetric(
//                   label: 'Total',
//                   value: '\$126K',
//                   trend: '+22.3%',
//                   isPositive: true,
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
// class _RevenueMetric extends StatelessWidget {
//   final String label;
//   final String value;
//   final String trend;
//   final bool isPositive;
//
//   const _RevenueMetric({
//     required this.label,
//     required this.value,
//     required this.trend,
//     required this.isPositive,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppSize.space8),
//       child: Column(
//         children: [
//           AppText(
//             text: value,
//             fontSize: AppSize.font16Medium,
//             fontWeight: FontWeight.w700,
//             color: context.txtPrimary,
//           ),
//           const SizedBox(height: AppSize.space2),
//           AppText(
//             text: label,
//             fontSize: AppSize.font10XSmall,
//             color: context.txtSecondary,
//           ),
//           const SizedBox(height: AppSize.space2),
//           AppText(
//             text: trend,
//             fontSize: AppSize.font10XSmall,
//             fontWeight: FontWeight.w600,
//             color: isPositive
//                 ? AppColors.backGroundEmeraldGreen
//                 : AppColors.textError,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  STATS GRID
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _StatsGrid extends StatelessWidget {
//   final DashboardCon c;
//   const _StatsGrid({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: AppSize.space12,
//         mainAxisSpacing: AppSize.space12,
//         childAspectRatio: 1.5,
//       ),
//       itemCount: c.stats.length,
//       itemBuilder: (context, i) => _MobileStatCard(stat: c.stats[i]),
//     );
//   }
// }
//
// class _MobileStatCard extends StatelessWidget {
//   final DashStat stat;
//   const _MobileStatCard({required this.stat});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       padding: const EdgeInsets.all(AppSize.space12),
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(color: context.borderClr),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AppContainer(
//                 width: AppSize.space32,
//                 height: AppSize.space32,
//                 backgroundColor: stat.iconBg,
//                 borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//                 child: Icon(stat.icon,
//                     size: AppSize.icon16Small, color: stat.iconColor),
//               ),
//               AppText(
//                 text: stat.trend.split(' ').first,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//                 color: stat.isPositive
//                     ? AppColors.backGroundEmeraldGreen
//                     : AppColors.textError,
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 text: stat.value,
//                 fontSize: AppSize.font18Large2,
//                 fontWeight: FontWeight.w700,
//                 color: context.txtPrimary,
//               ),
//               AppText(
//                 text: stat.label,
//                 fontSize: AppSize.font10XSmall,
//                 color: context.txtSecondary,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  RECENT ORDERS LIST
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _RecentOrdersList extends StatelessWidget {
//   final DashboardCon c;
//   const _RecentOrdersList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AppText(
//               text: 'Recent Orders',
//               fontSize: AppSize.font16Medium - 1,
//               fontWeight: FontWeight.w700,
//               color: context.txtPrimary,
//             ),
//             TextButton(
//               onPressed: () {},
//               style: TextButton.styleFrom(
//                 foregroundColor: AppColors.backGroundEmeraldGreen,
//                 padding: EdgeInsets.zero,
//                 minimumSize: Size.zero,
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//               child: const AppText(
//                 text: 'View All',
//                 fontSize: AppSize.font12Small2,
//                 color: AppColors.backGroundEmeraldGreen,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: AppSize.space8),
//         AppContainer(
//           backgroundColor: context.cardBg,
//           borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//           border: Border.all(color: context.borderClr),
//           child: Column(
//             children: c.recentOrders.asMap().entries.map((e) {
//               final isLast = e.key == c.recentOrders.length - 1;
//               return Column(
//                 children: [
//                   _MobileOrderItem(order: e.value),
//                   if (!isLast) Divider(height: 1, color: context.borderClr),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _MobileOrderItem extends StatelessWidget {
//   final DashOrder order;
//   const _MobileOrderItem({required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppSize.space14,
//         vertical: AppSize.space10,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   text: order.id,
//                   fontSize: AppSize.font12Small2,
//                   fontWeight: FontWeight.w600,
//                   color: context.txtPrimary,
//                 ),
//                 const SizedBox(height: AppSize.space2),
//                 AppText(
//                   text: order.buyer,
//                   fontSize: AppSize.font12Small2,
//                   color: context.txtSecondary,
//                 ),
//                 AppText(
//                   text: order.product,
//                   fontSize: 11,
//                   color: context.txtSecondary,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               AppText(
//                 text: order.amount,
//                 fontSize: AppSize.font13Small,
//                 fontWeight: FontWeight.w600,
//                 color: context.txtPrimary,
//               ),
//               const SizedBox(height: AppSize.space4),
//               AppContainer(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSize.space8,
//                   vertical: AppSize.space2,
//                 ),
//                 backgroundColor: order.statusBg,
//                 borderRadius: BorderRadius.circular(AppSize.radius20Large),
//                 child: AppText(
//                   text: order.status,
//                   fontSize: AppSize.font10XSmall,
//                   fontWeight: FontWeight.w600,
//                   color: order.statusColor,
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
// // ─────────────────────────────────────────────────────────────────────────────
// //  ACTIVITY LIST
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _ActivityList extends StatelessWidget {
//   final DashboardCon c;
//   const _ActivityList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText(
//           text: 'Recent Activity',
//           fontSize: AppSize.font16Medium - 1,
//           fontWeight: FontWeight.w700,
//           color: context.txtPrimary,
//         ),
//         const SizedBox(height: AppSize.space8),
//         AppContainer(
//           backgroundColor: context.cardBg,
//           borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//           border: Border.all(color: context.borderClr),
//           child: Column(
//             children: c.activities.asMap().entries.map((e) {
//               final isLast = e.key == c.activities.length - 1;
//               return Column(
//                 children: [
//                   _MobileActivityItem(activity: e.value),
//                   if (!isLast) Divider(height: 1, color: context.borderClr),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _MobileActivityItem extends StatelessWidget {
//   final DashActivity activity;
//   const _MobileActivityItem({required this.activity});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppSize.space14,
//         vertical: AppSize.space10,
//       ),
//       child: Row(
//         children: [
//           AppContainer(
//             width: AppSize.space36,
//             height: AppSize.space36,
//             backgroundColor: activity.iconBg,
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             child: Icon(
//               activity.icon,
//               size: AppSize.icon16Small,
//               color: activity.iconColor,
//             ),
//           ),
//           const SizedBox(width: AppSize.space10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   text: activity.title,
//                   fontSize: AppSize.font13Small,
//                   fontWeight: FontWeight.w600,
//                   color: context.txtPrimary,
//                 ),
//                 AppText(
//                   text: activity.subtitle,
//                   fontSize: 11,
//                   color: context.txtSecondary,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: AppSize.space8),
//           AppText(
//             text: activity.time,
//             fontSize: AppSize.font10XSmall,
//             color: context.txtSecondary,
//           ),
//         ],
//       ),
//     );
//   }
// }
